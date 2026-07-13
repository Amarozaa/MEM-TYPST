# -*- coding: utf-8 -*-
"""
Aplica la prueba de Mann-Whitney U para comparar Control vs Adaptativo,
en todas las variables de interes (SUS, dimensiones GEQ, metricas objetivas).

Como usarla en Python (lo que hace este script, explicado):

    from scipy import stats
    resultado = stats.mannwhitneyu(datos_control, datos_adaptativo)
    # resultado.statistic -> el valor U
    # resultado.pvalue    -> el p-valor

Eso es literalmente todo lo que hay que escribir para "usar" Mann-Whitney U --
la funcion ya hace el ordenamiento y la suma de puestos por dentro, no hay
que calcularlo a mano. Este script simplemente lo aplica de forma ordenada
a todas las variables del estudio y arma una tabla con los resultados.

Para correr: python pruebas_mann_whitney.py
"""

from pathlib import Path
import pandas as pd
from scipy import stats

from analisis_simple import armar_tabla

BASE = Path(__file__).parent

VARIABLES = [
    ("sus", "SUS"),
    ("afecto_positivo", "Afecto positivo"),
    ("afecto_negativo", "Afecto negativo"),
    ("desafio", "Desafio"),
    ("tension", "Tension"),
    ("inmersion", "Inmersion"),
    ("distancia_promedio_al_jefe", "Distancia al jefe"),
    ("ratio_ataques_melee", "Ratio ataques melee"),
    ("esquivas_totales", "Esquivas totales"),
    ("esquivas_exitosas", "Esquivas exitosas"),
    ("duracion_combate_seg", "Duracion combate"),
]


def interpretar_efecto(rb):
    """Regla de dedo estandar para el tamano de efecto rank-biserial."""
    a = abs(rb)
    if a < 0.10:
        return "insignificante"
    if a < 0.30:
        return "pequeno"
    if a < 0.50:
        return "mediano"
    return "grande"


def main():
    df = armar_tabla()
    control = df[df.condicion == "control"]
    adaptive = df[df.condicion == "adaptive"]

    filas = []
    for columna, etiqueta in VARIABLES:
        c = control[columna].dropna()
        a = adaptive[columna].dropna()

        resultado = stats.mannwhitneyu(c, a, alternative="two-sided")
        u = resultado.statistic
        p = resultado.pvalue

        # tamano de efecto rank-biserial: mide que tan grande es la diferencia,
        # independiente del n (a diferencia del p-valor, que si depende del n)
        n1, n2 = len(c), len(a)
        rb = 1 - (2 * u) / (n1 * n2)

        filas.append({
            "Variable": etiqueta,
            "Mediana Control": round(c.median(), 2),
            "Mediana Adaptativo": round(a.median(), 2),
            "U": round(u, 1),
            "p": round(p, 3),
            "Significativo (p<.05)": "SI" if p < 0.05 else "no",
            "Efecto (rank-biserial)": round(rb, 2),
            "Tamano del efecto": interpretar_efecto(rb),
        })

    tabla = pd.DataFrame(filas)

    print("=" * 100)
    print("RESULTADOS MANN-WHITNEY U: Control vs Adaptativo")
    print("=" * 100)
    print(tabla.to_string(index=False))

    salida = BASE / "resultados_mann_whitney.csv"
    tabla.to_csv(salida, index=False, encoding="utf-8-sig")
    print(f"\nGuardado en: {salida}")


if __name__ == "__main__":
    main()
