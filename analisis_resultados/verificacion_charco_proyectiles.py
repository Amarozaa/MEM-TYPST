# -*- coding: utf-8 -*-
"""
Verifica, ataque por ataque, si las menciones de "charco" (BA_Poddle) o
"proyectiles/bolas" (BA_ProjectilAttack, BA_HomingAttack) en las respuestas
abiertas se condicen con lo que realmente paso en el arbol de esa persona
(peso antes del combate vs. peso final).

Para correr: python verificacion_charco_proyectiles.py
"""

import csv
import json
import re
from pathlib import Path

from analisis_arbol_comportamiento import cargar_pesos_finales, cargar_pesos_precombate
from analisis_simple import armar_tabla

BASE = Path(__file__).parent
GEQ_CSV = BASE / "Cuestionario Experiencia de Juego.csv"

ATAQUES_A_REVISAR = {
    "BA_Poddle": ["charco", "aplana", "aplanada", "aplanó", "se agacha", "agachaba", "se esconde"],
    "BA_ProjectilAttack": ["proyectil", "bola de fuego", "bolas", "esfera", "esferaz"],
    "BA_HomingAttack": ["homing", "siguen", "trayectoria no lineal", "te sigue", "te siguen"],
}


def cargar_respuestas():
    respuestas = {}
    with open(GEQ_CSV, encoding="utf-8-sig", newline="") as f:
        lector = csv.reader(f)
        next(lector)
        for fila in lector:
            codigo_crudo = fila[1].strip()
            if not codigo_crudo or codigo_crudo in {"TEST", "P03", "P05", "P09"}:
                continue
            codigo = codigo_crudo if codigo_crudo.startswith("P") else "P" + codigo_crudo
            respuestas[codigo] = {
                "predecible": fila[32],
                "interesante_frustrante": fila[33],
                "aprendia": fila[34],
                "justo": fila[35],
            }
    return respuestas


def buscar_menciones(texto_completo, alias):
    texto = texto_completo.lower()
    return [a for a in alias if a in texto]


def main():
    pesos_finales = cargar_pesos_finales()
    pesos_precombate = cargar_pesos_precombate()
    respuestas = cargar_respuestas()

    df = armar_tabla()
    condicion_real = dict(zip(df["codigo"], df["condicion"]))

    print("Buscando menciones de 'charco' / 'proyectiles' / 'bolas' en las 4 respuestas abiertas...\n")

    for codigo, resp in sorted(respuestas.items()):
        texto_completo = " ".join(resp.values())

        for ataque, alias in ATAQUES_A_REVISAR.items():
            encontrados = buscar_menciones(texto_completo, alias)
            if not encontrados:
                continue

            # encuentra en que pregunta especifica aparecio, para citarla
            pregunta_con_mencion = next(
                (nombre for nombre, txt in resp.items()
                 if any(a in txt.lower() for a in encontrados)),
                None,
            )
            cita = resp[pregunta_con_mencion]

            es_adaptativo = condicion_real.get(codigo) == "adaptive"

            if es_adaptativo and codigo in pesos_precombate and codigo in pesos_finales:
                base = 50.0
                pre = pesos_precombate[codigo].get(ataque, 50)
                fin = pesos_finales[codigo].get(ataque, 50)
                condicion = "ADAPTATIVO"

                # etapa 1: base(50) -> pre-combate (subio ANTES de que empezara la pelea?)
                if pre > base:
                    etapa_precombate = f"SUBIO en la pre-adaptacion ({base:.0f}->{pre:.0f})"
                elif pre < base:
                    etapa_precombate = f"BAJO en la pre-adaptacion ({base:.0f}->{pre:.0f})"
                else:
                    etapa_precombate = f"sin cambio en la pre-adaptacion ({base:.0f}->{pre:.0f})"

                # etapa 2: pre-combate -> final (que paso durante la pelea misma)
                if fin > pre:
                    etapa_combate = f"SUBIO durante el combate ({pre:.0f}->{fin:.0f})"
                elif fin < pre:
                    etapa_combate = f"BAJO durante el combate ({pre:.0f}->{fin:.0f})"
                else:
                    etapa_combate = f"sin cambio durante el combate ({pre:.0f}->{fin:.0f})"

                if fin > base:
                    veredicto = "NETO: TERMINO MAS ALTO que el default (coincide con la molestia percibida)"
                elif fin < base:
                    veredicto = "NETO: TERMINO MAS BAJO que el default (contrario a la molestia percibida)"
                else:
                    veredicto = "NETO: TERMINO IGUAL AL DEFAULT (la molestia percibida no se refleja en el arbol)"
            else:
                condicion = "CONTROL (el arbol nunca cambia, queda fijo en 50)"
                etapa_precombate = "sin cambio (50->50)"
                etapa_combate = "sin cambio (50->50)"
                veredicto = "NETO: SIN CAMBIO POSIBLE (jefe fijo, cualquier percepcion es atribucion)"

            print(f"[{codigo:6s}] menciona '{ataque}' (via: {encontrados}) -- {condicion}")
            print(f"          etapa pre-adaptacion: {etapa_precombate}")
            print(f"          etapa durante combate: {etapa_combate}")
            print(f"          {veredicto}")
            print(f"          cita ({pregunta_con_mencion}): \"{cita.strip()[:200]}\"")
            print()


if __name__ == "__main__":
    main()
