# -*- coding: utf-8 -*-
"""
Genera diagramas de caja (boxplot) comparando Control vs Adaptativo
para las variables mas relevantes del estudio.

Requiere que 'analisis_simple.py' este en la misma carpeta.

Para correr: python graficos_boxplot.py
Genera archivos .png en la carpeta 'graficos/'.
"""

from pathlib import Path
import matplotlib.pyplot as plt

from analisis_simple import armar_tabla

BASE = Path(__file__).parent
CARPETA_SALIDA = BASE / "graficos"
CARPETA_SALIDA.mkdir(exist_ok=True)

COLOR_CONTROL = "#4C72B0"
COLOR_ADAPTATIVO = "#DD8452"


def boxplot_simple(df, columna, titulo, ylabel, nombre_archivo, figsize=(5, 5)):
    """Un boxplot: Control vs Adaptativo, para una sola variable."""
    datos_control = df[df.condicion == "control"][columna].dropna()
    datos_adaptativo = df[df.condicion == "adaptive"][columna].dropna()

    fig, ax = plt.subplots(figsize=figsize)
    caja = ax.boxplot(
        [datos_control, datos_adaptativo],
        tick_labels=["Control", "Adaptativo"],
        patch_artist=True,
        widths=0.5,
    )
    for parche, color in zip(caja["boxes"], [COLOR_CONTROL, COLOR_ADAPTATIVO]):
        parche.set_facecolor(color)
        parche.set_alpha(0.6)

    # se dibujan tambien los puntos individuales encima, para ver cada participante
    for i, datos in enumerate([datos_control, datos_adaptativo], start=1):
        x = [i] * len(datos)
        ax.scatter(x, datos, color="black", alpha=0.5, zorder=3, s=20)

    ax.set_title(titulo)
    ax.set_ylabel(ylabel)
    ax.grid(axis="y", alpha=0.3)
    fig.tight_layout()
    fig.savefig(CARPETA_SALIDA / nombre_archivo, dpi=150)
    plt.close(fig)


def panel_geq(df):
    """Un solo panel con las 5 dimensiones del GEQ + SUS, lado a lado."""
    variables = [
        ("sus", "SUS (0-100)"),
        ("afecto_positivo", "Afecto positivo (1-5)"),
        ("afecto_negativo", "Afecto negativo (1-5)"),
        ("desafio", "Desafio (1-5)"),
        ("tension", "Tension (1-5)"),
        ("inmersion", "Inmersion (1-5)"),
    ]

    fig, axes = plt.subplots(2, 3, figsize=(13, 8))
    axes = axes.flatten()

    for ax, (columna, etiqueta) in zip(axes, variables):
        datos_control = df[df.condicion == "control"][columna].dropna()
        datos_adaptativo = df[df.condicion == "adaptive"][columna].dropna()

        caja = ax.boxplot(
            [datos_control, datos_adaptativo],
            tick_labels=["Control", "Adaptativo"],
            patch_artist=True,
            widths=0.5,
        )
        for parche, color in zip(caja["boxes"], [COLOR_CONTROL, COLOR_ADAPTATIVO]):
            parche.set_facecolor(color)
            parche.set_alpha(0.6)

        for i, datos in enumerate([datos_control, datos_adaptativo], start=1):
            x = [i] * len(datos)
            ax.scatter(x, datos, color="black", alpha=0.5, zorder=3, s=15)

        ax.set_title(etiqueta)
        ax.grid(axis="y", alpha=0.3)

    fig.suptitle("SUS y dimensiones GEQ: Control vs Adaptativo", fontsize=14)
    fig.tight_layout()
    fig.savefig(CARPETA_SALIDA / "panel_geq_sus.png", dpi=150)
    plt.close(fig)


def panel_metricas_objetivas(df):
    """Panel con las metricas objetivas de juego."""
    variables = [
        ("distancia_promedio_al_jefe", "Distancia promedio al jefe"),
        ("ratio_ataques_melee", "Ratio ataques melee"),
        ("esquivas_totales", "Esquivas totales"),
        ("duracion_combate_seg", "Duracion combate (seg)"),
    ]

    fig, axes = plt.subplots(1, 4, figsize=(15, 5))

    for ax, (columna, etiqueta) in zip(axes, variables):
        datos_control = df[df.condicion == "control"][columna].dropna()
        datos_adaptativo = df[df.condicion == "adaptive"][columna].dropna()

        caja = ax.boxplot(
            [datos_control, datos_adaptativo],
            tick_labels=["Control", "Adaptativo"],
            patch_artist=True,
            widths=0.5,
        )
        for parche, color in zip(caja["boxes"], [COLOR_CONTROL, COLOR_ADAPTATIVO]):
            parche.set_facecolor(color)
            parche.set_alpha(0.6)

        for i, datos in enumerate([datos_control, datos_adaptativo], start=1):
            x = [i] * len(datos)
            ax.scatter(x, datos, color="black", alpha=0.5, zorder=3, s=15)

        ax.set_title(etiqueta, fontsize=10)
        ax.grid(axis="y", alpha=0.3)

    fig.suptitle("Metricas objetivas de juego: Control vs Adaptativo", fontsize=14)
    fig.tight_layout()
    fig.savefig(CARPETA_SALIDA / "panel_metricas_objetivas.png", dpi=150)
    plt.close(fig)


def violinplot_simple(df, columna, titulo, ylabel, nombre_archivo):
    """
    Un diagrama de violin: Control vs Adaptativo, para una sola variable.
    A diferencia del boxplot (que solo muestra cuartiles), el violin dibuja
    la forma completa de la distribucion -- se ve donde se "amontonan" mas
    respuestas, no solo los percentiles.
    """
    datos_control = df[df.condicion == "control"][columna].dropna()
    datos_adaptativo = df[df.condicion == "adaptive"][columna].dropna()

    fig, ax = plt.subplots(figsize=(5, 5))
    violin = ax.violinplot(
        [datos_control, datos_adaptativo],
        showmedians=True,
        showextrema=True,
    )

    for cuerpo, color in zip(violin["bodies"], [COLOR_CONTROL, COLOR_ADAPTATIVO]):
        cuerpo.set_facecolor(color)
        cuerpo.set_alpha(0.6)
        cuerpo.set_edgecolor("black")

    # la mediana (linea horizontal que dibuja matplotlib dentro del violin)
    violin["cmedians"].set_color("black")
    violin["cmedians"].set_linewidth(2)

    # se dibujan tambien los puntos individuales, para ver cada participante
    for i, datos in enumerate([datos_control, datos_adaptativo], start=1):
        x = [i] * len(datos)
        ax.scatter(x, datos, color="black", alpha=0.5, zorder=3, s=20)

    ax.set_xticks([1, 2])
    ax.set_xticklabels(["Control", "Adaptativo"])
    ax.set_title(titulo)
    ax.set_ylabel(ylabel)
    ax.grid(axis="y", alpha=0.3)
    fig.tight_layout()
    fig.savefig(CARPETA_SALIDA / nombre_archivo, dpi=150)
    plt.close(fig)


def boxplots_geq_individuales(df):
    """Un boxplot por cada dimension del GEQ, en archivos separados.

    Pensado para acomodarlos manualmente en una grilla (ej. 3 + 2) dentro
    de la memoria, en lugar de un unico panel combinado.
    """
    variables = [
        ("afecto_positivo", "Afecto positivo (GEQ)", "boxplot_geq_afecto_positivo.png"),
        ("afecto_negativo", "Afecto negativo (GEQ)", "boxplot_geq_afecto_negativo.png"),
        ("desafio", "Desafio (GEQ)", "boxplot_geq_desafio.png"),
        ("tension", "Tension (GEQ)", "boxplot_geq_tension.png"),
        ("inmersion", "Inmersion (GEQ)", "boxplot_geq_inmersion.png"),
    ]
    # figsize mas ancho que alto: al acomodarlos en grilla (3 + 2) ocupan menos
    # alto de pagina, conservando el ancho con que se muestran en la memoria.
    for columna, titulo, nombre_archivo in variables:
        boxplot_simple(df, columna, titulo, "Puntaje (1-5)", nombre_archivo, figsize=(5, 3.4))


def main():
    df = armar_tabla()

    panel_geq(df)
    panel_metricas_objetivas(df)
    boxplots_geq_individuales(df)

    # Tambien se guardan un par de graficos individuales grandes, por si se
    # necesitan sueltos para la memoria (ej. solo desafio, o solo tension)
    boxplot_simple(df, "desafio", "Desafio (GEQ)", "Puntaje (1-5)", "boxplot_desafio.png")
    boxplot_simple(df, "tension", "Tension (GEQ)", "Puntaje (1-5)", "boxplot_tension.png")
    boxplot_simple(df, "sus", "SUS", "Puntaje (0-100)", "boxplot_sus.png")

    violinplot_simple(df, "sus", "SUS", "Puntaje (0-100)", "violin_sus.png")

    print(f"Graficos guardados en: {CARPETA_SALIDA}")
    for archivo in sorted(CARPETA_SALIDA.glob("*.png")):
        print(" -", archivo.name)


if __name__ == "__main__":
    main()
