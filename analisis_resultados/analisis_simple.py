# -*- coding: utf-8 -*-
"""
Analisis simple del estudio Memorials (control vs adaptativo).
Solo calcula promedios y medianas por grupo, sin pruebas estadisticas.
Para correr: python analisis_simple.py
"""

import csv
import json
import re
import datetime
from pathlib import Path

import pandas as pd

BASE = Path(__file__).parent
GEQ_CSV = BASE / "Cuestionario Experiencia de Juego.csv"
INIT_CSV = BASE / "Cuestionario inicial de la sesión.csv"
LOGS = BASE / "LOGS_Jugadores" / "LOGS_FINALES"

# Participantes de pilotaje / prueba que se excluyen siempre (ver contexto_memorials.md)
EXCLUIR_PILOTAJE = {"TEST", "P03", "P05", "P09"}
# (P17 ya tiene sus logs completos desde 2026-07-07, se incluye en el analisis)
EXCLUIR_SIN_LOGS = set()


# ---------------------------------------------------------------------------
# PASO 1: leer la condicion (control/adaptativo) de cada participante
# desde los archivos *_metrics.json, que es la fuente mas confiable
# ---------------------------------------------------------------------------
def leer_condiciones_y_metricas():
    condicion = {}
    metricas = {}
    duracion = {}

    def parsear_fecha(s):
        # formato "2026.06.19-12.15.34"
        fecha, hora = s.split("-")
        y, mo, d = fecha.split(".")
        h, mi, se = hora.split(".")
        return datetime.datetime(int(y), int(mo), int(d), int(h), int(mi), int(se))

    for carpeta in sorted(LOGS.iterdir()):
        if not carpeta.is_dir():
            continue
        archivos_metrics = list(carpeta.glob("*_metrics.json"))
        if not archivos_metrics:
            continue

        datos = json.loads(archivos_metrics[0].read_text(encoding="utf-8"))
        nombre = carpeta.name

        # el nombre de la carpeta trae el codigo de participante, con algunos casos especiales
        if nombre.startswith("P26-REAL"):
            codigo = "P26-2"
        elif nombre.startswith("P26_"):
            codigo = "P26"
        elif nombre.startswith("P3_ISAIAS"):
            codigo = "P03"  # participante de pilotaje, se excluye despues
        elif nombre.startswith("Pedro_Esc_Logs"):
            continue  # log de prueba, no es un participante con codigo P
        else:
            m = re.match(r"(P\d+)", nombre)
            codigo = m.group(1) if m else None
        if codigo is None:
            continue

        condicion[codigo] = datos.get("condition")
        metricas[codigo] = datos

        archivos_win = list(carpeta.glob("*_win.json"))
        if archivos_win:
            datos_win = json.loads(archivos_win[0].read_text(encoding="utf-8"))
            t_inicio = parsear_fecha(datos["written_at"])
            t_fin = parsear_fecha(datos_win["written_at"])
            duracion[codigo] = (t_fin - t_inicio).total_seconds()

    return condicion, metricas, duracion


# ---------------------------------------------------------------------------
# PASO 2: calcular el puntaje de experiencia (0-9) del cuestionario inicial
# ---------------------------------------------------------------------------
HORAS = {"Menos de 2 horas": 0, "2 a 5 horas": 1, "6 a 10 horas": 2, "Más de 10 horas": 3}
TIEMPO = {"Menos de 1 año": 0, "1 a 3 años": 1, "4 a 6 años": 2, "Más de 6 años": 3}
SOULS = {
    "Ninguno": 0,
    "1 o 2, pero no los terminé": 1,
    "1 o 2 terminados, o 3 o más jugados": 2,
    "3 o más terminados": 3,
}


def leer_experiencia():
    experiencia = {}
    with open(INIT_CSV, encoding="utf-8-sig", newline="") as f:
        lector = csv.reader(f)
        next(lector)  # saltar encabezado
        for fila in lector:
            codigo_crudo = fila[1].strip()
            if not codigo_crudo:
                continue
            codigo = codigo_crudo if codigo_crudo.startswith("P") else "P" + codigo_crudo

            h = HORAS.get(fila[2].strip())
            t = TIEMPO.get(fila[3].strip())
            s = SOULS.get(fila[4].strip())
            if h is None or t is None or s is None:
                continue  # respuesta no reconocida, se ignora

            experiencia[codigo] = h + t + s
    return experiencia


# ---------------------------------------------------------------------------
# PASO 3: calcular SUS y las 5 dimensiones del GEQ
# ---------------------------------------------------------------------------
def calcular_sus(valores_10_items):
    """
    valores_10_items: lista con las 10 respuestas (1-5), en orden (pregunta 1 a 10).
    Regla estandar del SUS:
      - preguntas impares (1,3,5,7,9): se resta 1 al valor
      - preguntas pares   (2,4,6,8,10): se resta el valor de 5
      - se suman los 10 resultados y se multiplica por 2.5 -> puntaje 0-100
    """
    total = 0
    for i, valor in enumerate(valores_10_items):
        if i % 2 == 0:  # posiciones 0,2,4,6,8 = preguntas 1,3,5,7,9 (impares)
            total += valor - 1
        else:  # posiciones 1,3,5,7,9 = preguntas 2,4,6,8,10 (pares)
            total += 5 - valor
    return total * 2.5


def leer_geq():
    """
    Devuelve un diccionario por participante con:
      - sus: puntaje 0-100
      - afecto_positivo, afecto_negativo, desafio, tension, inmersion: promedio 1-5 de sus 4 items
      - las 4 respuestas abiertas
    """
    resultados = {}
    with open(GEQ_CSV, encoding="utf-8-sig", newline="") as f:
        lector = csv.reader(f)
        next(lector)
        for fila in lector:
            codigo_crudo = fila[1].strip()
            if not codigo_crudo or codigo_crudo in EXCLUIR_PILOTAJE:
                continue
            codigo = codigo_crudo if codigo_crudo.startswith("P") else "P" + codigo_crudo

            sus_items = [int(x) for x in fila[2:12]]        # columnas 2-11: SUS
            geq_items = [int(x) for x in fila[12:32]]       # columnas 12-31: GEQ

            resultados[codigo] = {
                "sus": calcular_sus(sus_items),
                "afecto_positivo": sum(geq_items[0:4]) / 4,   # cols 12-15
                "afecto_negativo": sum(geq_items[4:8]) / 4,   # cols 16-19
                "desafio": sum(geq_items[8:12]) / 4,          # cols 20-23
                "tension": sum(geq_items[12:16]) / 4,         # cols 24-27
                "inmersion": sum(geq_items[16:20]) / 4,       # cols 28-31
                "resp_predecible": fila[32],
                "resp_interesante_frustrante": fila[33],
                "resp_aprendia": fila[34],
                "resp_justo": fila[35],
            }
    return resultados


# ---------------------------------------------------------------------------
# PASO 4: armar la tabla final, uniendo todo por codigo de participante
# ---------------------------------------------------------------------------
def armar_tabla():
    condicion, metricas, duracion = leer_condiciones_y_metricas()
    experiencia = leer_experiencia()
    geq = leer_geq()

    filas = []
    for codigo in sorted(geq.keys()):
        if codigo in EXCLUIR_SIN_LOGS or codigo not in condicion:
            continue  # sin condicion conocida -> no se puede clasificar

        m = metricas.get(codigo, {})
        melee = m.get("MeleeAttacks", 0) or 0
        distancia_ataques = m.get("RangedAttacks", 0) or 0

        fila = {
            "codigo": codigo,
            "condicion": condicion[codigo],
            "puntaje_experiencia": experiencia.get(codigo),
            **geq[codigo],
            "distancia_promedio_al_jefe": m.get("AverageDistance"),
            "ratio_ataques_melee": melee / (melee + distancia_ataques) if (melee + distancia_ataques) > 0 else None,
            "esquivas_totales": m.get("TotalDodges"),
            "esquivas_exitosas": m.get("SuccessfulDodges"),
            "duracion_combate_seg": duracion.get(codigo),
        }
        filas.append(fila)

    return pd.DataFrame(filas)


# ---------------------------------------------------------------------------
# PASO 5: imprimir tablas simples (promedio y mediana por grupo)
# ---------------------------------------------------------------------------
def imprimir_tabla_resumen(df, columnas, titulo):
    print(f"\n=== {titulo} ===")
    resumen = df.groupby("condicion")[columnas].agg(["mean", "median"]).round(2)
    print(resumen)


def main():
    df = armar_tabla()
    df.to_csv(BASE / "tabla_datos_completa.csv", index=False, encoding="utf-8-sig")

    n_control = (df.condicion == "control").sum()
    n_adaptativo = (df.condicion == "adaptive").sum()
    print(f"Participantes analizados: {len(df)}  (control={n_control}, adaptativo={n_adaptativo})")

    imprimir_tabla_resumen(
        df,
        ["sus", "afecto_positivo", "afecto_negativo", "desafio", "tension", "inmersion"],
        "SUS y dimensiones GEQ por grupo",
    )

    imprimir_tabla_resumen(
        df,
        ["distancia_promedio_al_jefe", "ratio_ataques_melee", "esquivas_totales",
         "esquivas_exitosas", "duracion_combate_seg"],
        "Metricas objetivas de juego por grupo",
    )

    print("\n=== Puntaje de experiencia: minimo, maximo y cuantos por valor ===")
    print(df["puntaje_experiencia"].value_counts().sort_index())

    print("\nTabla completa guardada en: tabla_datos_completa.csv")


if __name__ == "__main__":
    main()
