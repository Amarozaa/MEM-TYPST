# Contexto del estudio — Trabajo de título: Memorials
> Archivo de contexto para análisis de datos. Leer completo antes de cualquier análisis.

---

## 1. Descripción general del estudio

**Título:** Diseño e Implementación de Enemigos Adaptativos en Videojuegos  
**Investigador responsable:** Prof. Francisco J. Gutiérrez (frgutier@dcc.uchile.cl)  
**Memorista:** Amaro Andrés Zurita Alvarado — Ingeniería Civil en Computación, Universidad de Chile  
**Tipo de estudio:** Prueba de concepto, diseño entre sujetos (between-subjects)

**Hipótesis central:** La incorporación de un sistema de IA adaptativo en el enemigo jefe genera experiencias de juego más desafiantes y personalizadas, en comparación con un jefe de comportamiento fijo (control).

---

## 2. Diseño experimental

### Versiones del juego
- **Control:** jefe con comportamiento predefinido y fijo
- **Adaptativa:** jefe que ajusta sus ataques según métricas del jugador recolectadas en la fase de exploración previa al combate

Cada participante juega **una sola versión** (between-subjects). No saben qué versión están jugando.

### Grupos de experiencia
Los participantes se clasifican en dos niveles según el **cuestionario previo** (puntaje 0–9):
- **Poca o nula experiencia:** puntaje 0–3
- **Con experiencia:** puntaje 4–9

La asignación a versión se hace por **asignación por bloques** alternando dentro de cada nivel de experiencia.

### Participantes piloto (EXCLUIR del análisis)
Los siguientes participantes jugaron la versión adaptativa antes de que se realizaran cambios al sistema. Sus datos se reportan como pilotaje y **NO deben incluirse en el análisis principal**:
- **P03** (Isaías) — Adaptativo
- **P09** (Benjamín Araya Neira) — Adaptativo  
- **P05** (Samuel Condore) — Adaptativo
- Cualquier entrada con código **TEST**

---

## 3. Estructura de datos

### Archivos CSV disponibles

#### `Inscripción — prueba de videojuego para trabajo de titulo.csv`
Formulario de inscripción. Contiene nombre, contacto, autopercepción de experiencia (Sí/No) y disponibilidad horaria. **No usar para clasificar experiencia en el análisis** — es solo para reclutamiento.

#### `Cuestionario inicial de la sesión.csv`
Aplicado al inicio de cada sesión. Contiene:
- Col 1: Código de participante (ej. P01, P22)
- Col 2: Horas semanales de juego → puntaje 0-3
- Col 3: Tiempo jugando acción → puntaje 0-3
- Col 4: Cantidad de soulslikes jugados → puntaje 0-3
- Col 5-7: Comodidad con mecánicas (escala 1-5): esquiva, distancia, alternar
- Col 8: Consentimiento informado

**Cálculo del puntaje de experiencia (0–9):**
```
Horas:   Menos de 2h=0, 2-5h=1, 6-10h=2, Más de 10h=3
Tiempo:  Menos de 1 año=0, 1-3 años=1, 4-6 años=2, Más de 6 años=3
Souls:   Ninguno=0, 1-2 sin terminar=1, 1-2 terminados o 3+ jugados=2, 3+ terminados=3
Total = suma de los tres (0-9). Corte: ≥4 = Con experiencia, ≤3 = Poca o nula
```

#### `Cuestionario Experiencia de Juego.csv`
Aplicado al finalizar la sesión. Contiene:
- Col 1: Marca temporal
- Col 2: Código de participante
- **Cols 2-11: SUS** (10 ítems, escala 1-5)
- **Cols 12-31: GEQ** (20 ítems, escala 1-5)
- **Cols 32-35: Preguntas abiertas** (4 preguntas cualitativas)

**Cálculo del puntaje SUS (0–100):**
```python
# Ítems impares (índice 0,2,4,6,8 → preguntas 1,3,5,7,9): valor - 1
# Ítems pares (índice 1,3,5,7,9 → preguntas 2,4,6,8,10): 5 - valor
# SUS = suma * 2.5
# Benchmark típico: 68 (promedio industria). Sobre 80.3 = Excelente.
```

**Dimensiones del GEQ (cols dentro del CSV, base 0):**
```
Afecto positivo: cols 12-15  (Me sentí satisfecho/a, feliz, divertido, lo disfruté)
Afecto negativo: cols 16-19  (aburrido/a, cansador/a, mal humor, pensé en otras cosas)
Desafío:         cols 20-23  (desafiado/a, difícil, esforzarme mucho, presión de tiempo)
Tensión:         cols 24-27  (frustrado/a, molesto/a, irritable, presionado/a)
Inmersión:       cols 28-31  (olvidé el entorno, impresionante, experiencia rica, perdí conexión)
```
Nota: el GEQ originalmente usa escala 0-4. En este estudio se aplicó en 1-5. Al interpretar, considerar que 1=mínimo y 5=máximo. Para comparar con benchmarks publicados del GEQ, restar 1 a cada valor para convertir a escala 0-4.

---

## 4. Mapeo de participantes

### Versión asignada por código
```
CONTROL:    P01, P10, P13, P14, P15, P22, P26, P27, P31, P32, P33, P39
ADAPTATIVO: P11, P12, P16, P18, P19, P21, P23, P24, P26-2, P28, P30, P34, P35
PILOTAJE (excluir): P03, P05, P09
```

### Estado actual del balance (al cierre del reclutamiento)
- Control: 12 participantes válidos, promedio puntaje experiencia ≈ 5.92
- Adaptativo: 13 participantes válidos, promedio puntaje experiencia ≈ 6.62
- Nota: el grupo adaptativo quedó con jugadores levemente más experimentados. Reportar como limitación menor.
- Todos los participantes válidos cayeron en "Con experiencia" (puntaje ≥4). No hubo participantes de poca/nula experiencia en la muestra final. Reportar como limitación del estudio.

---

## 5. Resultados preliminares obtenidos

### SUS (excluyendo pilotaje y TEST, n=22)
- Promedio general: 79.3 / 100
- Mediana: 77.5
- Rango: 65.0 – 92.5
- Distribución: 9 Excelente (≥80.3), 10 Bueno (68-80), 3 Aceptable (51-68), 0 Pobre
- Control promedio: 79.79 | Adaptativo promedio: 77.31

### GEQ por dimensión (escala 1-5)
|Dimensión|Control|Adaptativo|
|---|---|---|
|Afecto positivo|4.71|4.44|
|Afecto negativo|1.40|1.33|
|Desafío|2.42|2.56|
|Tensión|1.38|1.46|
|Inmersión|3.56|3.42|

---

## 6. Consideraciones metodológicas importantes

- **Escala GEQ adaptada:** se aplicó en 1-5 en vez de 0-4 original. Al analizar, restar 1 para comparar con literatura.
- **SUS adaptado a videojuegos:** los ítems originales fueron reformulados al contexto de juego. No es el SUS validado textualmente, sino una adaptación.
- **Todos son "Con experiencia":** el reclutamiento en foros universitarios atrajo solo jugadores con experiencia, eliminando la posibilidad de analizar el subgrupo de poca/nula experiencia. Limitación del estudio.
- **Desbalance leve de experiencia entre grupos:** el grupo adaptativo quedó con un promedio de puntaje de experiencia 0.7 puntos mayor. Diferencia pequeña pero a reportar.
- **Sin ciego:** los participantes no saben qué versión juegan, pero el investigador sí. Limitación menor.
- **n pequeño:** con ~12-13 por grupo, las diferencias observadas son descriptivas. Evitar afirmar significancia estadística sin pruebas formales (Mann-Whitney U o similar recomendado dado el n y la distribución).

---

## 7. Análisis pendientes sugeridos

1. Comparación Control vs. Adaptativo en SUS y cada dimensión GEQ (con prueba estadística no paramétrica, ej. Mann-Whitney U)
2. Correlación entre puntaje de experiencia y dimensiones GEQ (¿los más experimentados sintieron menos desafío?)
3. Correlación entre comodidad con mecánicas (bloque 2 cuestionario previo) y métricas objetivas de juego
4. Análisis cualitativo de preguntas abiertas (predictibilidad, justicia, percepción de adaptación del jefe)
5. Comparación de métricas objetivas de juego (daño recibido, esquivas, duración del combate) entre versiones
6. Verificar si quienes percibieron que el jefe "aprendía" corresponden principalmente al grupo adaptativo

---

## 8. Notas adicionales

- El código P26 corresponde a Martín Pinochet (Control) y P26-2 corresponde a Martín Garrido Gamboa (Adaptativo). El segundo recibió ese código provisional por duplicado en la planilla; tratar como participante independiente válido.
- Las métricas de juego se guardan en archivos .txt nombrados con el código de participante (ej. P01.txt) o con timestamp que fue renombrado al terminar la sesión.
- El juego fue desarrollado en Unreal Engine 5.6 con Blueprints y C++. El jefe adaptativo es BP_Slime.
