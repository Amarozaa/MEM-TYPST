# -*- coding: utf-8 -*-
"""
Cruza los pesos finales del arbol de comportamiento (_tree.json) con las
metricas objetivas y las respuestas abiertas de cada participante.

Se apoya en las reglas de adaptacion pre-combate documentadas en el capitulo
5 de la memoria (example_final.typ, seccion "Adaptacion pre-combate"):

  - Melee vs distancia (requiere MeleeAttacks+RangedAttacks >= 5):
      RangedRatio > 0.5  -> +15 a BA_Poddle, BA_BossChase, BA_HeavyAttack
      RangedRatio < 0.35 -> +15 a BA_AOEAttack, BA_WhipAttack
      (adicional) si MeleeAttacksInRangedZone+RangedAttacksInRangedZone>=3:
          predomino melee en zona de rango -> +10 a BA_AOEAttack
          predomino distancia en zona de rango -> +10 a BA_Poddle

  - Esquiva (requiere TotalDodges >= 5):
      DodgeRatio > 0.6 -> +15 a BA_BasicAttack
      DodgeRatio < 0.4 -> +15 a BA_AOEAttack, BA_WallAttack, BA_HeavyAttack
      (DodgeRatio = DodgesFromDelayAttack / TotalDodges)

  - Zona de tanque:
      Sub-regla A (si LateralDodgesFromDash+BackwardDodgesFromDash >= 2):
          predomino lateral -> +10 a BA_WhipAttack
          predomino atras   -> +10 a BA_HeavyAttack
      Sub-regla B (si TotalDodgesTankZone >= 3):
          DodgesFromDelayAttack_TankZone*2 >= TotalDodgesTankZone
              -> +10 a BA_BasicAttack
          si no -> +10 a BA_HeavyAttack y BA_WhipAttack

Nota: la regla de "Distancia" (AverageDistance) ajusta variables de Blackboard
(CloseRange, FarRange, BossChaseDur), NO pesos de ataque directamente, por lo
que no se puede verificar contra el tree.json -- se deja fuera de esta
verificacion.

Los ajustes DURANTE el combate (aciertos por tipo de ataque, curacion) no se
pueden reconstruir con los datos agregados de metrics.json (se necesitaria el
detalle ataque por ataque), asi que la diferencia entre lo predicho por las
reglas pre-combate y el tree.json final se interpreta como "ajuste adicional
ocurrido durante el combate".

Para correr: python analisis_arbol_comportamiento.py
"""

import json
from pathlib import Path

import pandas as pd
import matplotlib.pyplot as plt

from analisis_simple import armar_tabla, LOGS

BASE = Path(__file__).parent
CARPETA_GRAFICOS = BASE / "graficos"
CARPETA_GRAFICOS.mkdir(exist_ok=True)

ATAQUES = [
    "BA_BasicAttack", "BA_AOEAttack", "BA_HeavyAttack", "BA_ProjectilAttack",
    "BA_BossChase", "BA_Poddle", "BA_HomingAttack", "BA_WhipAttack", "BA_WallAttack",
]

# nombres en español que la gente usa en las respuestas abiertas para cada ataque,
# para poder buscar menciones directas en el texto
ALIAS_ATAQUES = {
    "BA_BasicAttack": ["ataque basico", "espada basico"],
    "BA_AOEAttack": ["espinas", "area", "aoe"],
    "BA_HeavyAttack": ["salto", "pesado", "knockback"],
    "BA_ProjectilAttack": ["proyectil", "bola de fuego", "bolas", "esfera"],
    "BA_BossChase": ["persecucion", "se acerca", "corre hacia", "chase"],
    "BA_Poddle": ["charco", "aplana", "aplanада", "aplanado", "se aplana"],
    "BA_HomingAttack": ["homing", "siguen", "trayectoria no lineal", "te siguen"],
    "BA_WhipAttack": ["latigo", "espada", "sword"],
    "BA_WallAttack": ["muro", "pared", "wall"],
}


def cargar_pesos_finales():
    """
    Lee el arbol de pesos VERDADERAMENTE final de cada participante.

    OJO: el archivo suelto "_tree.json" es en realidad una foto de los pesos
    justo DESPUES del ajuste pre-combate, pero ANTES de que empiece la pelea
    (por eso antes salia que el ajuste "durante combate" siempre daba 0 -- se
    estaba comparando la foto de pre-combate contra si misma).

    El estado real de cuando termina la pelea esta en el campo "final_tree"
    dentro de "_win.json" (viene como un string JSON anidado, hay que
    parsearlo dos veces).
    """
    import re
    pesos = {}
    for carpeta in sorted(LOGS.iterdir()):
        if not carpeta.is_dir():
            continue
        archivos = list(carpeta.glob("*_win.json"))
        if not archivos:
            continue
        nombre = carpeta.name
        if nombre.startswith("P26-REAL"):
            codigo = "P26-2"
        elif nombre.startswith("P26_"):
            codigo = "P26"
        elif nombre.startswith("P3_ISAIAS"):
            codigo = "P03"
        elif nombre.startswith("Pedro_Esc_Logs"):
            continue
        else:
            m = re.match(r"(P\d+)", nombre)
            codigo = m.group(1) if m else None
        if codigo is None:
            continue
        win_data = json.loads(archivos[0].read_text(encoding="utf-8"))
        final_tree_str = win_data.get("final_tree")
        if not final_tree_str:
            continue
        pesos[codigo] = json.loads(final_tree_str)
    return pesos


def cargar_pesos_precombate():
    """
    Lee el _tree.json suelto de cada participante -- esta es la foto de los
    pesos justo despues del ajuste pre-combate, ANTES de que empiece la pelea.
    Sirve para separar "cuanto ajusto el pre-combate" de "cuanto ajusto la
    pelea misma" (ver cargar_pesos_finales para la explicacion completa).
    """
    import re
    pesos = {}
    for carpeta in sorted(LOGS.iterdir()):
        if not carpeta.is_dir():
            continue
        archivos = list(carpeta.glob("*_tree.json"))
        if not archivos:
            continue
        nombre = carpeta.name
        if nombre.startswith("P26-REAL"):
            codigo = "P26-2"
        elif nombre.startswith("P26_"):
            codigo = "P26"
        elif nombre.startswith("P3_ISAIAS"):
            codigo = "P03"
        elif nombre.startswith("Pedro_Esc_Logs"):
            continue
        else:
            m = re.match(r"(P\d+)", nombre)
            codigo = m.group(1) if m else None
        if codigo is None:
            continue
        pesos[codigo] = json.loads(archivos[0].read_text(encoding="utf-8"))
    return pesos


def cargar_metricas_crudas():
    """Lee el _metrics.json completo de cada participante (para aplicar las reglas)."""
    import re
    metricas = {}
    for carpeta in sorted(LOGS.iterdir()):
        if not carpeta.is_dir():
            continue
        archivos = list(carpeta.glob("*_metrics.json"))
        if not archivos:
            continue
        nombre = carpeta.name
        if nombre.startswith("P26-REAL"):
            codigo = "P26-2"
        elif nombre.startswith("P26_"):
            codigo = "P26"
        elif nombre.startswith("P3_ISAIAS"):
            codigo = "P03"
        elif nombre.startswith("Pedro_Esc_Logs"):
            continue
        else:
            m = re.match(r"(P\d+)", nombre)
            codigo = m.group(1) if m else None
        if codigo is None:
            continue
        metricas[codigo] = json.loads(archivos[0].read_text(encoding="utf-8"))
    return metricas


def predecir_ajustes_pre_combate(m):
    """
    Aplica las reglas de ApplyPreCombatMeleeVsRanged, ApplyPreCombatDodges y
    ApplyPreCombatTankZone (documentadas en example_final.typ) sobre las
    metricas crudas de un participante. Devuelve un dict {ataque: ajuste_predicho}.
    """
    ajuste = {a: 0 for a in ATAQUES}

    melee = m.get("MeleeAttacks", 0) or 0
    ranged = m.get("RangedAttacks", 0) or 0
    if melee + ranged >= 5:
        ranged_ratio = ranged / (melee + ranged)
        if ranged_ratio > 0.5:
            ajuste["BA_Poddle"] += 15
            ajuste["BA_BossChase"] += 15
            ajuste["BA_HeavyAttack"] += 15
        elif ranged_ratio < 0.35:
            ajuste["BA_AOEAttack"] += 15
            ajuste["BA_WhipAttack"] += 15

        melee_rz = m.get("MeleeAttacksInRangedZone", 0) or 0
        ranged_rz = m.get("RangedAttacksInRangedZone", 0) or 0
        if melee_rz + ranged_rz >= 3:
            if melee_rz > ranged_rz:
                ajuste["BA_AOEAttack"] += 10
            else:
                ajuste["BA_Poddle"] += 10

    total_dodges = m.get("TotalDodges", 0) or 0
    if total_dodges >= 5:
        dodge_ratio = (m.get("DodgesFromDelayAttack", 0) or 0) / total_dodges
        if dodge_ratio > 0.6:
            ajuste["BA_BasicAttack"] += 15
        elif dodge_ratio < 0.4:
            ajuste["BA_AOEAttack"] += 15
            ajuste["BA_WallAttack"] += 15
            ajuste["BA_HeavyAttack"] += 15

    lateral = m.get("LateralDodgesFromDash", 0) or 0
    atras = m.get("BackwardDodgesFromDash", 0) or 0
    if lateral + atras >= 2:
        if lateral >= atras:
            ajuste["BA_WhipAttack"] += 10
        else:
            ajuste["BA_HeavyAttack"] += 10

    total_tank = m.get("TotalDodgesTankZone", 0) or 0
    if total_tank >= 3:
        delay_tank = m.get("DodgesFromDelayAttack_TankZone", 0) or 0
        if delay_tank * 2 >= total_tank:
            ajuste["BA_BasicAttack"] += 10
        else:
            ajuste["BA_HeavyAttack"] += 10
            ajuste["BA_WhipAttack"] += 10

    return ajuste


def main():
    df = armar_tabla()
    pesos_finales = cargar_pesos_finales()          # real, desde win.json -> final_tree
    pesos_precombate = cargar_pesos_precombate()      # real, desde el _tree.json suelto
    metricas_crudas = cargar_metricas_crudas()

    filas = []
    for _, fila in df.iterrows():
        codigo = fila["codigo"]
        if fila["condicion"] != "adaptive":
            continue
        if codigo not in pesos_finales or codigo not in pesos_precombate or codigo not in metricas_crudas:
            continue

        final = pesos_finales[codigo]
        precombate = pesos_precombate[codigo]
        m = metricas_crudas[codigo]

        # chequeo de validacion: compara la prediccion por reglas contra el
        # pre-combate REAL registrado (no contra el final) -- si coinciden,
        # confirma que las reglas documentadas estan bien implementadas aqui
        predicho_precombate = predecir_ajustes_pre_combate(m)
        magnitud_predicha = sum(predicho_precombate.values())
        magnitud_precombate_real = sum(precombate.get(a, 50) - 50 for a in ATAQUES)
        reglas_ok = (magnitud_predicha == magnitud_precombate_real)

        magnitud_final = sum(final.get(a, 50) - 50 for a in ATAQUES)
        magnitud_en_combate = magnitud_final - magnitud_precombate_real

        ataques_modificados_en_combate = [
            a for a in ATAQUES if final.get(a, 50) != precombate.get(a, 50)
        ]

        filas.append({
            "codigo": codigo,
            "tension": fila["tension"],
            "desafio": fila["desafio"],
            "magnitud_precombate_real": magnitud_precombate_real,
            "magnitud_final_real": magnitud_final,
            "magnitud_atribuible_a_combate": magnitud_en_combate,
            "reglas_precombate_ok": reglas_ok,
            "ataques_cambiados_durante_combate": ", ".join(
                a.replace("BA_", "") for a in ataques_modificados_en_combate
            ),
        })

    tabla = pd.DataFrame(filas).sort_values("magnitud_atribuible_a_combate", ascending=False, key=abs)

    salida = BASE / "adaptacion_por_participante.csv"
    tabla.to_csv(salida, index=False, encoding="utf-8-sig")

    print("=== Adaptacion por participante (solo Adaptativo, n={}) ===".format(len(tabla)))
    print(tabla.to_string(index=False))
    print(f"\nGuardado en: {salida}")

    n_reglas_ok = tabla["reglas_precombate_ok"].sum()
    print(f"\nValidacion de reglas pre-combate: coinciden en {n_reglas_ok}/{len(tabla)} participantes")

    from scipy import stats
    print("\n=== Correlacion: magnitud atribuible a COMBATE vs percepcion subjetiva ===")
    rho, p = stats.spearmanr(tabla["magnitud_atribuible_a_combate"], tabla["tension"])
    print(f"magnitud_atribuible_a_combate vs tension: rho={rho:.3f} p={p:.3f}")
    rho, p = stats.spearmanr(tabla["magnitud_atribuible_a_combate"], tabla["desafio"])
    print(f"magnitud_atribuible_a_combate vs desafio: rho={rho:.3f} p={p:.3f}")

    print("\n=== Correlacion: magnitud FINAL total vs percepcion subjetiva ===")
    rho, p = stats.spearmanr(tabla["magnitud_final_real"], tabla["tension"])
    print(f"magnitud_final_real vs tension: rho={rho:.3f} p={p:.3f}")
    rho, p = stats.spearmanr(tabla["magnitud_final_real"], tabla["desafio"])
    print(f"magnitud_final_real vs desafio: rho={rho:.3f} p={p:.3f}")

    # grafico de dispersion
    fig, axes = plt.subplots(1, 2, figsize=(11, 5))
    for ax, col, titulo in [
        (axes[0], "tension", "Magnitud atribuible a combate vs Tension"),
        (axes[1], "desafio", "Magnitud atribuible a combate vs Desafio"),
    ]:
        ax.scatter(tabla["magnitud_atribuible_a_combate"], tabla[col], color="#DD8452", s=50)
        for _, r in tabla.iterrows():
            ax.annotate(r["codigo"], (r["magnitud_atribuible_a_combate"], r[col]),
                        fontsize=7, xytext=(3, 3), textcoords="offset points")
        ax.set_xlabel("Magnitud atribuible a combate (final real - precombate real)")
        ax.set_ylabel(titulo.split(" vs ")[1])
        ax.set_title(titulo)
        ax.grid(alpha=0.3)
    fig.tight_layout()
    salida_fig = CARPETA_GRAFICOS / "adaptacion_vs_percepcion.png"
    fig.savefig(salida_fig, dpi=150)
    plt.close(fig)
    print(f"Grafico guardado en: {salida_fig}")


if __name__ == "__main__":
    main()
