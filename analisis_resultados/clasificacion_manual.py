# -*- coding: utf-8 -*-
"""
Analisis de las 4 preguntas abiertas del GEQ a partir de una clasificacion
manual hecha por el investigador.

============================================================================
IMPORTANTE - COMO FUNCIONA (leer antes de usar):

  Las clasificaciones NO estan en este script. Viven en el archivo:

        clasificacion_editable.csv

  Ese archivo es la UNICA fuente de verdad. Editalo a mano (en Excel o donde
  quieras) para cambiar las categorias de cada participante en las columnas
  'predictibilidad', 'aprendizaje' y 'justicia'. Las columnas 'resp_*' traen
  el texto original de cada respuesta al lado, solo como referencia para
  clasificar; no es necesario tocarlas.

  Este script SOLO LEE ese archivo, NUNCA lo sobrescribe. Correrlo es seguro:
  no puede pisar tus ediciones. Solo genera, aparte, un grafico y unos
  conteos en pantalla.
============================================================================

Nota metodologica (pregunta de "aprendizaje"): varias respuestas afirmativas
en realidad describen el comportamiento por diseno del jefe segun la distancia
(ej. "de cerca ataca cuerpo a cuerpo, de lejos a distancia"), sin distinguir
si eso es adaptacion real al historial de acciones. El conteo de "Si" puede
sobreestimar cuanta gente percibio adaptacion real. Tener presente al reportar.

Para correr: python clasificacion_manual.py
"""

from pathlib import Path
import sys

import pandas as pd
import matplotlib.pyplot as plt

BASE = Path(__file__).parent
CARPETA_GRAFICOS = BASE / "graficos"
CARPETA_GRAFICOS.mkdir(exist_ok=True)

# Fuente de verdad de las clasificaciones. Este script solo la LEE.
ARCHIVO_EDITABLE = BASE / "clasificacion_editable.csv"

# ---------------------------------------------------------------------------
# PREGUNTA 2: aspectos interesantes o frustrantes (temas recurrentes).
# No es una categoria por persona, sino una lista de temas que se repiten
# (una respuesta puede tocar mas de un tema), por lo que se mantiene aca y no
# en el CSV editable. Editar esta lista a mano si se desea ajustar los temas.
# ---------------------------------------------------------------------------
TEMAS_Q2 = {
    "No poder cancelar animaciones / falta 'animation cancel'":
        ["P17", "P19", "P21", "P26-2", "P30"],
    "Combos dejan expuesto / prefieren atacar de a uno":
        ["P13", "P18", "P28"],
    "Buffering de ataques (clicks repetidos se acumulan)":
        ["P40", "P41"],
    "Camara / sistema de fijar objetivo (lock-on)":
        ["P14", "P33"],
    "Variedad de ataques del jefe fue lo mas interesante":
        ["P12", "P24", "P39", "P16", "P19"],
    "Problemas de hitbox / puntería (bolas magicas, mago)":
        ["P15", "P35"],
    "Tener que comprometer movilidad para usar magia":
        ["P31", "P32"],
    "Zona/sala especifica frustrante (ej. mazmorra, tres magos)":
        ["P16", "P39"],
}


def cargar_clasificacion():
    """Lee las clasificaciones desde el CSV editable. Nunca lo escribe."""
    if not ARCHIVO_EDITABLE.exists():
        sys.exit(
            f"No se encontro {ARCHIVO_EDITABLE.name}. Ese archivo contiene las\n"
            "clasificaciones y debe existir para correr este analisis."
        )
    tabla = pd.read_csv(ARCHIVO_EDITABLE, encoding="utf-8-sig")
    # se normalizan celdas vacias a texto vacio para los conteos
    for col in ["predictibilidad", "aprendizaje", "justicia"]:
        tabla[col] = tabla[col].fillna("(sin clasificar)").astype(str).str.strip()
    return tabla


def imprimir_conteos(tabla):
    for columna, titulo in [
        ("predictibilidad", "PREGUNTA 1: Predictibilidad"),
        ("aprendizaje", "PREGUNTA 3: Percepcion de aprendizaje/adaptacion"),
        ("justicia", "PREGUNTA 4: Justicia"),
    ]:
        print(f"\n=== {titulo} ===")
        conteo = tabla.groupby(["condicion", columna]).size().unstack(fill_value=0)
        conteo = conteo.rename(index={"control": "Control", "adaptive": "Adaptativo"})
        print(conteo)


def imprimir_temas_q2():
    print("\n=== PREGUNTA 2: Temas recurrentes (interesante/frustrante) ===")
    for tema, participantes in sorted(TEMAS_Q2.items(), key=lambda kv: -len(kv[1])):
        print(f"  ({len(participantes)}) {tema}")
        print(f"       {', '.join(participantes)}")


def graficar(tabla):
    fig, axes = plt.subplots(1, 3, figsize=(16, 5))

    especificaciones = [
        ("predictibilidad", "Predictibilidad", axes[0]),
        ("aprendizaje", "Percepcion de aprendizaje", axes[1]),
        ("justicia", "Justicia", axes[2]),
    ]

    for columna, titulo, ax in especificaciones:
        conteo = tabla.groupby(["condicion", columna]).size().unstack(fill_value=0)
        conteo = conteo.rename(index={"control": "Control", "adaptive": "Adaptativo"})
        conteo.plot(kind="bar", ax=ax, colormap="Set2")
        ax.set_title(titulo)
        ax.set_ylabel("Cantidad de participantes")
        ax.set_xlabel("")
        ax.tick_params(axis="x", rotation=0)
        ax.legend(fontsize=7)

    fig.suptitle("Clasificacion de preguntas abiertas", fontsize=13)
    fig.tight_layout()
    salida = CARPETA_GRAFICOS / "clasificacion_preguntas_abiertas.png"
    fig.savefig(salida, dpi=150)
    plt.close(fig)
    print(f"\nGrafico guardado en: {salida}")


def main():
    tabla = cargar_clasificacion()
    print(f"Clasificaciones leidas desde: {ARCHIVO_EDITABLE.name} "
          f"({len(tabla)} participantes)")
    imprimir_conteos(tabla)
    imprimir_temas_q2()
    graficar(tabla)


if __name__ == "__main__":
    main()
