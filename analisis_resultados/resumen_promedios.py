# -*- coding: utf-8 -*-
"""
Resumen de promedios: Control / Adaptativo / General.
Pensado para mostrarle una tabla simple al profesor guia.

Requiere que 'analisis_simple.py' este en la misma carpeta (usa su
funcion armar_tabla() para no repetir la logica de lectura de datos).

Para correr: python resumen_promedios.py
"""

from pathlib import Path
import pandas as pd
import matplotlib.pyplot as plt

from analisis_simple import armar_tabla

BASE = Path(__file__).parent

# Nombres bonitos para mostrar en la tabla final (columna interna -> nombre a mostrar)
# Se separan en dos grupos para que las tablas/imagenes no queden demasiado anchas
COLUMNAS_SUS_GEQ = {
    "sus": "SUS (0-100)",
    "afecto_positivo": "Afecto positivo",
    "afecto_negativo": "Afecto negativo",
    "desafio": "Desafio",
    "tension": "Tension",
    "inmersion": "Inmersion",
}

COLUMNAS_OBJETIVAS = {
    # se usa "\n" para partir los titulos largos en 2 lineas: asi la columna
    # se dimensiona por la linea mas larga, no por el titulo completo
    "distancia_promedio_al_jefe": "Distancia\nprom. al jefe",
    "ratio_ataques_melee": "Ratio ataques\nmelee",
    "esquivas_totales": "Esquivas\ntotales",
    "esquivas_exitosas": "Esquivas\nexitosas",
    "duracion_combate_seg": "Duracion\ncombate (seg)",
    "puntaje_experiencia": "Experiencia\nprevia (0-9)",
}

COLUMNAS_A_MOSTRAR = {**COLUMNAS_SUS_GEQ, **COLUMNAS_OBJETIVAS}

COLOR_ENCABEZADO = "#4C72B0"
COLOR_FILA_CONTROL = "#EAF0F8"
COLOR_FILA_ADAPTATIVO = "#FCEEE3"
COLOR_FILA_GENERAL = "#E8E8E8"


def guardar_tabla_como_imagen(tabla, titulo, nombre_archivo):
    """Dibuja el DataFrame como una imagen de tabla (con colores), no como texto plano."""
    filas = tabla.reset_index().rename(columns={"index": "Grupo"})

    # colores de fondo por fila, segun el grupo
    colores_fila = []
    for grupo in filas["Grupo"]:
        if grupo == "Control":
            colores_fila.append(COLOR_FILA_CONTROL)
        elif grupo == "Adaptativo":
            colores_fila.append(COLOR_FILA_ADAPTATIVO)
        else:
            colores_fila.append(COLOR_FILA_GENERAL)

    n_filas, n_columnas = filas.shape

    def largo_linea_mas_larga(texto):
        """Si el texto tiene '\\n', el ancho que importa es el de la linea mas larga, no el total."""
        return max(len(linea) for linea in str(texto).split("\n"))

    # ancho de cada columna calculado a mano, segun la linea de texto mas larga que
    # contiene (encabezado o cualquier valor de esa columna), con un margen chico (padding)
    PADDING = 2  # caracteres de aire extra
    anchos_caracteres = []
    for col in range(n_columnas):
        largo_encabezado = largo_linea_mas_larga(filas.columns[col])
        largo_max_valores = max(largo_linea_mas_larga(v) for v in filas.iloc[:, col])
        anchos_caracteres.append(max(largo_encabezado, largo_max_valores) + PADDING)

    ancho_total_caracteres = sum(anchos_caracteres)
    anchos_relativos = [a / ancho_total_caracteres for a in anchos_caracteres]

    # si algun encabezado tiene 2 lineas (por el "\n"), la fila de encabezado
    # necesita mas alto que las filas de datos (que tienen solo 1 linea)
    max_lineas_encabezado = max(str(c).count("\n") + 1 for c in filas.columns)
    alto_extra_encabezado = 0.35 * (max_lineas_encabezado - 1)  # pulgadas extra si son 2 lineas

    fig, ax = plt.subplots(
        figsize=(0.11 * ancho_total_caracteres, 0.55 * n_filas + 1.1 + alto_extra_encabezado)
    )
    ax.axis("off")
    ax.set_title(titulo, fontsize=13, pad=15)

    tabla_mpl = ax.table(
        cellText=filas.values,
        colLabels=filas.columns,
        cellLoc="center",
        loc="center",
        colWidths=anchos_relativos,
    )
    tabla_mpl.auto_set_font_size(False)
    tabla_mpl.set_fontsize(9)
    tabla_mpl.scale(1, 1.6)

    # a la fila de encabezado se le da altura extra si su texto ocupa 2 lineas,
    # para que no se salga del recuadro de la celda
    if max_lineas_encabezado > 1:
        for col in range(n_columnas):
            celda = tabla_mpl[0, col]
            celda.set_height(celda.get_height() * 1.8)

    # pintar encabezado
    for col in range(n_columnas):
        celda = tabla_mpl[0, col]
        celda.set_facecolor(COLOR_ENCABEZADO)
        celda.get_text().set_color("white")
        celda.get_text().set_fontweight("bold")

    # pintar filas de datos segun el grupo, y dejar la columna "Grupo" en negrita
    for fila_idx in range(1, n_filas + 1):
        for col in range(n_columnas):
            celda = tabla_mpl[fila_idx, col]
            celda.set_facecolor(colores_fila[fila_idx - 1])
            if col == 0:
                celda.get_text().set_fontweight("bold")

    fig.tight_layout()
    fig.savefig(BASE / nombre_archivo, dpi=180, bbox_inches="tight")
    plt.close(fig)


def main():
    df = armar_tabla()

    columnas = list(COLUMNAS_A_MOSTRAR.keys())

    # Promedio por grupo (Control / Adaptativo)
    promedio_por_grupo = df.groupby("condicion")[columnas].mean().round(2)
    promedio_por_grupo = promedio_por_grupo.rename(index={"control": "Control", "adaptive": "Adaptativo"})

    # Promedio general (todos juntos, sin separar por grupo)
    promedio_general = df[columnas].mean().round(2)
    promedio_general.name = "General (ambos grupos)"

    # Se arma una sola tabla con 3 filas: Control, Adaptativo, General
    tabla_final = pd.concat([promedio_por_grupo, promedio_general.to_frame().T])
    tabla_final = tabla_final.rename(columns=COLUMNAS_A_MOSTRAR)

    # Se agrega una columna con el numero de participantes de cada fila
    # (se usa el nombre de cada fila para no depender del orden en que pandas las entregue)
    n_por_grupo = df["condicion"].value_counts().rename(index={"control": "Control", "adaptive": "Adaptativo"})
    n_por_grupo["General (ambos grupos)"] = len(df)
    tabla_final.insert(0, "n", n_por_grupo.reindex(tabla_final.index))

    # version "limpia" de los encabezados (sin el "\n" que se usa solo para las imagenes)
    # para que la consola y el CSV se vean bien
    tabla_para_texto = tabla_final.rename(columns=lambda c: c.replace("\n", " "))

    print("=" * 100)
    print("TABLA RESUMEN: PROMEDIOS POR GRUPO")
    print("=" * 100)
    print(tabla_para_texto.to_string())

    # Se guarda tambien como CSV, facil de abrir en Excel para mostrarle al profesor
    salida_csv = BASE / "resumen_promedios.csv"
    tabla_para_texto.to_csv(salida_csv, encoding="utf-8-sig")
    print(f"\nGuardado CSV en: {salida_csv}")

    # Se generan dos imagenes de tabla (mas faciles de ver/mostrar que un CSV)
    tabla_sus_geq = tabla_final[["n"] + list(COLUMNAS_SUS_GEQ.values())]
    tabla_objetivas = tabla_final[["n"] + list(COLUMNAS_OBJETIVAS.values())]

    guardar_tabla_como_imagen(
        tabla_sus_geq, "SUS y dimensiones GEQ - promedios por grupo", "resumen_sus_geq.png"
    )
    guardar_tabla_como_imagen(
        tabla_objetivas, "Metricas objetivas de juego - promedios por grupo", "resumen_metricas_objetivas.png"
    )
    print("Guardadas imagenes: resumen_sus_geq.png, resumen_metricas_objetivas.png")


if __name__ == "__main__":
    main()
