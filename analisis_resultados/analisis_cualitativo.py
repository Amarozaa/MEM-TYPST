# -*- coding: utf-8 -*-
"""
Ayuda para el analisis de las preguntas abiertas del cuestionario GEQ.

Las 4 preguntas abiertas son:
  1. Que tan predecible te parecio el jefe? Por que?
  2. Que aspectos te parecieron mas interesantes o frustrantes del combate? Por que?
  3. Sentiste que el jefe aprendia o cambiaba segun tus acciones? Por que?
  4. Que tan justo o injusto te parecio su comportamiento? Por que?

IMPORTANTE: el analisis cualitativo de texto libre no se puede automatizar del
todo, necesita que tu leas las respuestas y decidas en que categoria cae cada
una (esto se llama "codificacion tematica"). Este script hace 2 cosas:

  1. Exporta las respuestas ordenadas por grupo a un CSV facil de leer,
     con una columna vacia "categoria_manual" para que la vayas llenando
     a mano mientras lees.
  2. Da una clasificacion automatica BORRADOR (Si/No/Revisar) para la
     pregunta 3 (aprendizaje), basada en palabras clave. Esto es solo un
     punto de partida rapido -- hay que revisarla a mano, no es fiable
     al 100% (una respuesta puede decir "no" al principio y "si" despues,
     por ejemplo).

Para correr: python analisis_cualitativo.py
"""

import re
from pathlib import Path

import pandas as pd
import matplotlib.pyplot as plt

from analisis_simple import armar_tabla

BASE = Path(__file__).parent
CARPETA_GRAFICOS = BASE / "graficos"
CARPETA_GRAFICOS.mkdir(exist_ok=True)

PREGUNTAS = {
    "resp_predecible": "1. Que tan predecible parecio el jefe",
    "resp_interesante_frustrante": "2. Aspectos interesantes o frustrantes",
    "resp_aprendia": "3. Sintio que el jefe aprendia o cambiaba",
    "resp_justo": "4. Que tan justo o injusto parecio",
}


# ---------------------------------------------------------------------------
# PASO 1: exportar las respuestas ordenadas, listas para leer y codificar a mano
# ---------------------------------------------------------------------------
def exportar_respuestas_para_codificar(df):
    columnas = ["codigo", "condicion"] + list(PREGUNTAS.keys())
    tabla = df[columnas].rename(columns=PREGUNTAS)
    tabla = tabla.sort_values(["condicion", "codigo"])

    # se agrega una columna vacia para que la llenes tu mismo mientras lees
    tabla["categoria_manual"] = ""

    salida = BASE / "respuestas_abiertas_para_codificar.csv"
    tabla.to_csv(salida, index=False, encoding="utf-8-sig")
    print(f"Guardado: {salida}")
    print("Abrelo en Excel/Sheets, ordena por la pregunta que te interese,")
    print("y ve llenando la columna 'categoria_manual' con tus propias etiquetas")
    print("(ej: 'Si', 'No', 'Ambiguo', o categorias mas especificas que tu definas).")


# ---------------------------------------------------------------------------
# PASO 2: clasificacion automatica BORRADOR para la pregunta de aprendizaje
# ---------------------------------------------------------------------------
def clasificar_aprendizaje_borrador(texto):
    """
    Heuristica simple basada en palabras clave, SOLO como punto de partida.
    Hay que revisar cada caso a mano despues -- esto se equivoca con
    respuestas complejas (ej: "no al principio, pero despues si").
    """
    texto = texto.lower().strip()

    empieza_con_no = bool(re.match(r"^no[\s,\.]", texto)) or texto.startswith("no,")
    empieza_con_si = bool(re.match(r"^s[ií][\s,\.]", texto))

    if empieza_con_si:
        return "Si (borrador)"
    if empieza_con_no:
        return "No (borrador)"
    return "Revisar a mano"


def graficar_clasificacion_borrador(df):
    df = df.copy()
    df["clasificacion"] = df["resp_aprendia"].apply(clasificar_aprendizaje_borrador)

    conteo = (
        df.groupby(["condicion", "clasificacion"]).size().unstack(fill_value=0)
    )
    conteo = conteo.rename(index={"control": "Control", "adaptive": "Adaptativo"})
    print("\n=== Clasificacion BORRADOR de 'sintio que el jefe aprendia' ===")
    print(conteo)
    print("\n(Recuerda: esto es un borrador automatico, revisa 'Revisar a mano'")
    print("y corrige a ojo los que el script haya clasificado mal)")

    fig, ax = plt.subplots(figsize=(7, 5))
    conteo.plot(kind="bar", ax=ax, color=["#55A868", "#C44E52", "#8172B2"])
    ax.set_title("Percepcion de aprendizaje del jefe (clasificacion borrador)")
    ax.set_ylabel("Cantidad de participantes")
    ax.set_xlabel("")
    ax.legend(title="Respuesta")
    plt.xticks(rotation=0)
    fig.tight_layout()
    fig.savefig(CARPETA_GRAFICOS / "borrador_percepcion_aprendizaje.png", dpi=150)
    plt.close(fig)
    print(f"\nGrafico guardado en: {CARPETA_GRAFICOS / 'borrador_percepcion_aprendizaje.png'}")


def main():
    df = armar_tabla()
    exportar_respuestas_para_codificar(df)
    graficar_clasificacion_borrador(df)


if __name__ == "__main__":
    main()
