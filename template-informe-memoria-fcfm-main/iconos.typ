#set page(width: auto, height: auto, margin: 12pt)

#let icono-punto(color, borde: none) = circle(radius: 4pt, fill: color, stroke: borde)
#let icono-triangulo(color, borde: none) = polygon(
  fill: color, stroke: borde,
  (0pt, 0pt), (9pt, 4.5pt), (0pt, 9pt),
)
#let icono-barra(color, w, h) = rect(width: w, height: h, fill: color)
#let icono-puerta-salida = box(width: 16pt, height: 16pt)[
  #place(top + left, rect(width: 12pt, height: 16pt, stroke: 0.7pt, fill: none))
  #place(top + left, dx: 3pt, dy: 4pt, polygon(
    stroke: 0.7pt, fill: none,
    (0pt, 0pt), (6pt, 4pt), (0pt, 8pt),
  ))
]
#let icono-palanca = box(width: 18pt, height: 18pt)[
  #place(top + left, dx: 1pt, dy: 2pt, rect(width: 12pt, height: 16pt, stroke: red + 0.7pt, fill: none))
  #place(top + left, dx: 15pt, dy: -2pt, line(end: (-8pt, 10pt), stroke: red + 2pt))
]

// === Tutorial ===
*Tutorial*
#v(4pt)
#grid(
  columns: (52pt, 52pt, 52pt, 52pt, 52pt, 52pt, 52pt),
  row-gutter: 4pt,
  align: center + horizon,
  icono-triangulo(red), icono-barra(yellow, 4pt, 16pt), icono-punto(yellow),
  icono-punto(white, borde: 0.5pt), icono-triangulo(white, borde: 0.5pt), icono-barra(rgb("#ff00ff"), 16pt, 4pt),
  icono-puerta-salida,
  text(size: 9pt)[Inicio], text(size: 9pt)[Puerta], text(size: 9pt)[Maniquí],
  text(size: 9pt)[Esqueleto], text(size: 9pt)[Espinas], text(size: 9pt)[Puente],
  text(size: 9pt)[Salida],
)

#v(16pt)

// === Dungeon ===
*Dungeon*
#v(4pt)
#grid(
  columns: (46pt, 46pt, 46pt, 46pt, 46pt, 46pt, 46pt, 46pt),
  row-gutter: 4pt,
  align: center + horizon,
  icono-triangulo(red), icono-punto(white, borde: 0.5pt), icono-punto(blue),
  icono-punto(red), icono-barra(yellow, 16pt, 4pt),
  text(size: 16pt, fill: rgb("#5500cc"))[↑], icono-puerta-salida, icono-palanca,
  text(size: 9pt)[Inicio], text(size: 9pt)[Esqueleto], text(size: 9pt)[Mago],
  text(size: 9pt)[Caballero], text(size: 9pt)[Puerta], text(size: 9pt)[Escaleras],
  text(size: 9pt)[Salida], text(size: 9pt)[Palanca],
)
