// =============================================================
// Defensa de memoria de Amaro Zurita Alvarado
// Compilar desde la raíz del repositorio (MEMORIA_TYPST):
//     typst compile --root . presentacion/defensa.typ
// =============================================================

#import "@preview/touying:0.7.3": *
#import themes.metropolis: *

#let img = "../template-informe-memoria-fcfm-main/imagenes/"

// Paleta navy + ámbar
#let azul = rgb("#0d2340")      // navy: titulos, bandas, portada
#let azul-claro = rgb("#1d4b7a")
#let ambar = rgb("#e0a44a")     // acento cálido
#let ambar-osc = rgb("#a9741f") // ámbar legible sobre fondo claro
#let rojo = ambar-osc           // el acento cálido reemplaza al rojo
#let tinta = rgb("#26303a")     // texto, en vez de negro puro
#let fondo = rgb("#fbfaf7")     // fondo de página, apenas cálido
#let gris = rgb("#ecedf0")      // cajas neutras
#let borde = rgb("#cdd3da")     // filetes de tabla

// --- Tipografía -----------------------------------------------
// Segoe UI se lee mucho mejor proyectada que una serif.
#set text(lang: "es", font: ("Segoe UI", "Calibri", "Arial"), size: 20pt, hyphenate: false)
#set strong(delta: 200)
#show link: set text(fill: azul-claro)

// Imágenes con marco tenue y esquinas redondeadas
#show image: it => block(radius: 4pt, clip: true, stroke: 0.6pt + borde, it)

// Títulos de diapositiva con más presencia
#show heading.where(level: 2): set text(fill: azul, weight: "semibold")

// Secciones divisorias más grandes
#show heading.where(level: 1): set text(fill: azul, weight: "bold", size: 1.15em)

// --- Helpers ---------------------------------------------------
#let dato(valor, etiqueta) = block(
  fill: gris, radius: 8pt, inset: (x: 10pt, y: 14pt), width: 100%,
  align(center)[
    #text(size: 30pt, weight: "bold", fill: azul)[#valor]
    #v(2pt)
    #text(size: 12pt, fill: tinta.lighten(20%), tracking: 0.4pt)[#upper(etiqueta)]
  ],
)

#let destaca(cnt) = block(
  fill: rojo.lighten(92%),
  stroke: (left: 3pt + rojo),
  inset: (left: 14pt, rest: 11pt), radius: (right: 4pt),
  width: 100%,
  text(size: 17pt)[#cnt],
)

// Tabla estilo booktabs: filetes horizontales tenues, sin caja ni verticales
#let tabla(..args) = table(
  stroke: (x: none, y: 0.4pt + borde.lighten(45%)),
  inset: (x: 9pt, y: 8pt),
  fill: none,
  table.hline(stroke: 1pt + azul),
  ..args,
  table.hline(stroke: 1pt + azul),
)

// --- Portada propia -------------------------------------------
#let portada() = touying-slide-wrapper(self => {
  self = utils.merge-dicts(
    self,
    config-common(freeze-slide-counter: true),
    config-page(fill: azul, margin: 0em),
  )
  touying-slide(self: self, {
    set align(left + horizon)
    block(width: 100%, inset: (x: 3em, y: 2em))[
      #block(width: 4.5em, height: 5pt, fill: ambar)
      #v(14pt)
      #text(size: 30pt, weight: "bold", fill: ambar)[
        Diseño e implementación de enemigos adaptativos en videojuegos
      ]
      #v(8pt)
      #text(size: 17pt, fill: ambar.lighten(25%))[
        Memoria para optar al título de Ingeniero Civil en Computación
      ]
      #v(20pt)
      #line(length: 100%, stroke: 0.6pt + ambar.transparentize(60%))
      #v(12pt)
      #text(size: 19pt, weight: "semibold", fill: white)[Amaro Zurita Alvarado]
      #v(10pt)
      #text(size: 13pt, fill: white.transparentize(25%))[
        Universidad de Chile, Facultad de Ciencias Físicas y Matemáticas
        #v(6pt)
        Profesor guía: Francisco Gutiérrez Figueroa#h(1.2em)·#h(1.2em)Co-guía: Elías Zelada Baeza \
        Comisión: Valentín Muñoz Apablaza#h(1.2em)·#h(1.2em)Cristián Llull Torres
      ]
    ]
  })
})

// --- Divisoria de sección propia ------------------------------
#let seccion(config: (:), level: 1, numbered: false, body) = touying-slide-wrapper(self => {
  self = utils.merge-dicts(self, config-page(fill: ambar), config)
  touying-slide(self: self, {
    set align(left + horizon)
    block(inset: (x: 1.5em))[
      #block(width: 3em, height: 4pt, fill: azul.transparentize(40%))
      #v(14pt)
      #text(size: 34pt, weight: "bold", fill: azul)[
        #utils.display-current-heading(level: level, numbered: numbered)
      ]
    ]
    body
  })
})

// --- Diapositiva de cierre ------------------------------------
#let cierre() = touying-slide-wrapper(self => {
  self = utils.merge-dicts(self, config-page(fill: azul))
  touying-slide(self: self, {
    set align(center + horizon)
    block[
      #block(width: 3em, height: 4pt, fill: ambar)
      #v(18pt)
      #text(size: 36pt, weight: "bold", fill: ambar)[Gracias por su atención]
      #v(22pt)
      #text(size: 20pt, fill: white)[Amaro Zurita Alvarado]
      #v(8pt)
      #text(size: 15pt, fill: white.transparentize(30%))[
        Diseño e implementación de enemigos adaptativos en videojuegos
      ]
    ]
  })
})

#show: metropolis-theme.with(
  aspect-ratio: "16-9",
  align: horizon,
  config-info(
    title: [Diseño e implementación de enemigos adaptativos en videojuegos],
    short-title: [Enemigos adaptativos en videojuegos],
    subtitle: [Memoria para optar al título de Ingeniero Civil en Computación],
    author: [Amaro Zurita Alvarado],
    date: datetime.today().display("[day]/[month]/[year]"),
    institution: [Universidad de Chile, Facultad de Ciencias Físicas y Matemáticas],
    contact: [
      Profesor guía: Francisco Gutiérrez Figueroa \
      Profesor co-guía: Elías Zelada Baeza \
      Comisión: Valentín Muñoz Apablaza y Cristián Llull Torres
    ],
  ),
  config-colors(
    primary: azul,
    primary-light: azul.lighten(65%),
    secondary: azul,        // banda de título
    tertiary: azul-claro,
    neutral-lightest: fondo,
    neutral-dark: tinta,
    neutral-darkest: tinta,
  ),
  config-common(new-section-slide-fn: seccion),
)

#portada()

// =============================================================
= Introducción
// =============================================================

== El problema: enemigos que se memorizan

#grid(
  columns: (1fr, 1fr),
  column-gutter: 20pt,
  [
    #set text(size: 18pt)
    En los juegos de acción con combates exigentes, los jefes siguen patrones
    de ataque *fijos*. Tras varios intentos, el jugador los memoriza.

    #v(6pt)
    La dificultad deja de ser un desafío dinámico y pasa a ser un ejercicio de
    *memorización*.

    #v(6pt)
    #destaca[
      La gran mayoría de los enfoques de dificultad dinámica existentes
      ajustan *números* (vida, daño, velocidad), no el *comportamiento*
      del enemigo.
    ]
  ],
  [
    #image(img + "cap1/elden.jpg", width: 100%)
    #v(4pt)
    #set text(size: 13pt)
    #align(center)[Patrones memorizables en _Elden Ring_]
  ],
)

== La excepción, y la pregunta

#grid(
  columns: (1fr, 1.1fr),
  column-gutter: 20pt,
  [
    #image(img + "cap1/alien.jpg", width: 100%)
    #v(4pt)
    #set text(size: 13pt)
    #align(center)[_Alien: Isolation_: el antagonista aprende dónde se esconde
      el jugador y ajusta sus rutas.]
  ],
  [
    #set text(size: 18pt)
    Son pocos los títulos donde el enemigo se adapta a las *acciones
    específicas* de cada jugador.

    #v(10pt)
    #block(fill: azul.lighten(90%), inset: 12pt, radius: 6pt, width: 100%)[
      *¿Y si un jefe identificara el estilo de juego de cada persona y ajustara
      su propia estrategia en consecuencia?*
    ]
  ],
)

== Agenda

#set text(size: 19pt)
#grid(
  columns: (auto, 1fr),
  column-gutter: 14pt,
  row-gutter: 12pt,

  text(fill: azul, weight: "bold")[1.], [*Objetivos* del trabajo],
  text(fill: azul, weight: "bold")[2.], [El *juego* construido y el *sistema adaptativo*: qué mide y qué ajusta],
  text(fill: azul, weight: "bold")[3.], [*Metodología* de evaluación: prueba A/B con 30 participantes],
  text(fill: azul, weight: "bold")[4.], [*Resultados*: verificación técnica, usabilidad, experiencia de juego],
  text(fill: azul, weight: "bold")[5.], [El *hallazgo principal*: el efecto depende del estilo de juego],
  text(fill: azul, weight: "bold")[6.], [*Conclusiones*, limitaciones y trabajo futuro],
)

== Objetivos

#block(fill: azul.lighten(90%), inset: 12pt, radius: 6pt, width: 100%)[
  #set text(size: 17pt)
  *Objetivo general.* Diseñar e implementar un sistema de adaptación para un
  enemigo jefe, capaz de ajustar su comportamiento de combate a
  partir de un perfil construido sobre las acciones previas del jugador, con el
  fin de reducir la previsibilidad del enfrentamiento y evaluar su efecto sobre
  la experiencia de juego.
]

#v(8pt)
#set text(size: 15.5pt)
*Objetivos específicos*
#grid(
  columns: (1fr, 1fr),
  column-gutter: 18pt,
  row-gutter: 6pt,
  [+ Revisar enfoques existentes de IA adaptativa.
   + Construir una versión base con jefe fijo (control).
   + Diseñar enemigos regulares que expongan el estilo de juego.],
  [4. Ajustar los pesos de ataque del jefe según ese perfil.
   5. Validar mediante pruebas de jugabilidad.
   6. Comparar versión adaptativa contra control.],
)

// =============================================================
= El sistema desarrollado
// =============================================================

== El juego construido para el estudio

#grid(
  columns: (1.15fr, 1fr),
  column-gutter: 18pt,
  [
    #set text(size: 17pt)
    - Unreal Engine 5.6, *Blueprints + C++*, con las herramientas nativas de IA
      del motor (_Behaviour Tree_ y _Blackboard_).
    - Mecánicas clásicas de juegos de acción: melee, hechizos a distancia,
      esquiva con _i-frames_, _stamina_, pociones, fijado de objetivo.
    - Un *nivel previo* con tres arquetipos de enemigo regular, y luego el
      combate contra el *jefe*.
    #v(4pt)
    #destaca[
      El nivel previo es donde el sistema observa al jugador. Cada arquetipo
      expone una dimensión distinta de su estilo de juego.
    ]
  ],
  [
    #image(img + "cap3/enemies_comparative.png", width: 100%)
    #v(2pt)
    #set text(size: 13pt)
    #align(center)[Los tres arquetipos de enemigo regular]
  ],
)

== El repertorio del jefe

#set text(size: 15.5pt)
*Nueve ataques* repartidos en tres rangos de distancia. Dentro de cada rango, un
*selector aleatorio ponderado* implementado en C++ elige cuál se ejecuta, y todos
parten con el mismo peso base.

#v(8pt)

#let caja(cnt, fill: gris) = block(
  fill: fill, stroke: 0.7pt + borde, radius: 5pt,
  inset: (x: 7pt, y: 5pt), width: 100%, align(center, cnt),
)
#let baja = align(center, text(fill: azul, size: 12pt)[#sym.arrow.b])
#let rama(titulo, rango, ataques) = [
  #caja(fill: azul.lighten(88%))[
    #text(size: 13.5pt, weight: "bold", fill: azul)[#titulo] \
    #text(size: 11pt, fill: tinta.lighten(20%))[#rango]
  ]
  #baja
  #caja(text(size: 12pt)[Selector ponderado])
  #baja
  #caja(text(size: 13pt)[#ataques], fill: white)
]

#align(center, block(width: 94%)[
  #caja(fill: azul.lighten(90%))[
    #text(size: 14pt, weight: "bold", fill: azul)[Selector principal según la distancia al jugador]
  ]
  #v(3pt)
  #grid(
    columns: (1fr, 1fr, 1fr),
    column-gutter: 10pt,
    align: top,
    rama[Rango lejano][mayor a `FarRange`][Proyectil dirigido \ Proyectil \ Persecución \ Charco],
    rama[Rango medio][entre ambos rangos][Básico \ Pesado \ Látigo],
    rama[Rango cercano][menor a `CloseRange`][Básico \ Área \ Muro],
  )
])


== La decisión de diseño central

#let panel(titulo, color, items) = block(
  fill: color.lighten(92%),
  stroke: (left: 5pt + color),
  inset: (left: 18pt, rest: 16pt), radius: (right: 5pt),
  width: 100%, height: 100%,
)[
  #text(size: 22pt, weight: "bold", fill: color.darken(15%))[#titulo]
  #v(10pt)
  #text(size: 17.5pt)[#items]
]

#grid(
  rows: (7cm,),
  columns: (1fr, 1fr),
  column-gutter: 20pt,
  align: top,
  panel("Parámetros fijos", rojo)[
    El daño, la velocidad y la vida del jefe se mantienen iguales en las dos
    versiones.
    #v(8pt)
    - Daño de cada ataque
    - Velocidad de ejecución
    - Vida del jefe
  ],
  panel("Comportamiento adaptativo", azul)[
    Lo que el perfil del jugador modifica es cómo el jefe usa ese mismo
    repertorio.
    #v(8pt)
    - Qué tan seguido elige cada ataque
    - En qué rangos de distancia los usa
    - Cuánto persigue al jugador
  ],
)

#v(6pt)
#align(center, text(size: 17pt, fill: tinta.lighten(15%))[
  El jefe sigue siendo igual de fuerte, lo que cambia es su estrategia
])

== El perfil de juego: cuatro dimensiones

#set text(size: 16pt)
#tabla(
  columns: (auto, 1fr, 1.2fr),
  table.header([*Dimensión*], [*Qué observa*], [*Hacia dónde empuja al jefe*]),
      table.hline(stroke: 0.6pt + borde),
  [Distancia],
  [Distancia promedio frente al esqueleto normal y al caballero],
  [Achica el rango cercano o alarga la persecución],
  [Melee vs. rango],
  [Proporción de ataques a distancia sobre el total],
  [Refuerza ataques que cierran distancia, o los que castigan de cerca],
  [Esquiva],
  [Proporción de esquivas exitosas contra el ataque telegrafiado],
  [Refuerza el ataque difícil de leer, o los de preparación larga],
  [Zona de tanque],
  [Hacia qué lado esquiva y con qué éxito frente al caballero],
  [Refuerza Giro o Salto, replicando su patrón de reacción],
)

#v(6pt)
#text(size: 14pt)[
  Cada regla que se activa suma *+10 o +15 al peso* de ciertos ataques, sobre un
  *peso base de 50*, sin eliminar ninguno. Se registra además el *porcentaje de
  vida al que suele curarse*, usado durante el combate.
]

== De perfil a comportamiento

#grid(
  columns: (1.3fr, 1fr),
  column-gutter: 18pt,
  [
    #set text(size: 16pt)
    Ejemplo de un jugador que juega *a distancia*, esquiva bien lo telegrafiado
    y tiende a esquivar de lado:

    #v(6pt)
    #tabla(
      columns: (auto, auto),
      table.header([*Ataque*], [*Peso final*]),
      table.hline(stroke: 0.6pt + borde),
      [Charco], [50 + 15 + 10 = *75*],
      [Salto], [50 + 15 + 10 = *75*],
      [Giro], [50 + 10 + 10 = *70*],
      [Básico], [50 + 15 = *65*],
      [Persecución], [50 + 15 = *65*],
      [Espinas, Muro, Proyectiles], [50 (sin cambios)],
    )
  ],
  [
    #set text(size: 16pt)
    *Una restricción independiente del perfil:*

    #destaca[
      Ningún ataque puede elegirse *tres veces seguidas*, por mucho que haya
      subido su peso.
    ]

    #v(6pt)
    #text(size: 15pt)[
      Así el jefe no termina repitiendo el mismo ataque una y otra vez, algo que se vería poco natural.
    ]
  ],
)

== Dos ajustes adicionales durante el combate

#set text(size: 17pt)
#text(size: 16pt)[
  La adaptación principal se calcula *una sola vez, al iniciar el combate*, con
  el perfil del nivel previo. Durante el combate solo hay dos ajustes acotados.
]
#v(8pt)
#grid(
  rows: (7cm,),
  align: top,
  columns: (1fr, 1fr),
  column-gutter: 16pt,
  block(fill: gris, inset: 12pt, radius: 6pt, width: 100%, height: 100%)[
    *1. Por tasa de acierto* \
    #v(4pt)
    #text(size: 15.5pt)[
      Cada 15 ataques del jefe, se revisa qué proporción de cada tipo conectó:
      #v(4pt)
      - acierto \> 60% #sym.arrow ese ataque *+15*
      - acierto \< 30% #sym.arrow ese ataque *−15*
      #v(4pt)
      El jefe deja de insistir en lo que el jugador ya domina.
    ]
  ],
  block(fill: gris, inset: 12pt, radius: 6pt, width: 100%, height: 100%)[
    *2. Por ventana de curación* \
    #v(4pt)
    #text(size: 15.5pt)[
      Usa el % de vida al que el jugador se curaba en el *nivel previo*.
      Cuando entra a ese rango (±10 pp):
      #v(4pt)
      - Básico, Salto, Charco y Homing *+15*
      #v(4pt)
      Al salir del rango, se revierte. Reduce la ventana para tomar la poción.
    ]
  ],
)

// =============================================================
= Evaluación
// =============================================================

== Diseño experimental

#grid(
  columns: (1fr, 1fr),
  column-gutter: 18pt,
  [
    #set text(size: 16.5pt)
    *Prueba A/B, diseño entre sujetos.* Cada persona juega una sola condición,
    nunca ambas.

    #v(6pt)
    *Control:* mismo jefe, mismos nueve ataques, pesos parejos toda la partida.

    #v(6pt)
    *Cegamiento:* el participante no sabe qué versión juega.

    #v(6pt)
    *Perfil:* *todos* lo generan, solo cambia si se aplica.
  ],
  [
    #set text(size: 16.5pt)
    #dato[30][participantes válidos]
    #v(6pt)
    #grid(columns: (1fr, 1fr), column-gutter: 8pt,
      dato[15][control],
      dato[15][adaptativo],
    )
    #v(8pt)
    #text(size: 15pt)[
      Sesiones de 25 a 40 minutos, con asignación alternada dentro de cada perfil
      de experiencia previa para no desbalancear la experiencia entre grupos.
    ]
  ],
)

== Qué se midió

#set text(size: 17pt)
#grid(
  rows: (6.4cm,),
  align: top,
  columns: (1fr, 1.4fr),
  column-gutter: 14pt,
  block(fill: gris, inset: 11pt, radius: 6pt, width: 100%, height: 100%)[
    *1. Durante la partida* \
    #text(size: 14.5pt)[
      *Registro interno del juego:* distancia, ratio melee/rango, esquivas, curaciones, aciertos del jefe y los
      *pesos de ataque reales* que usó el jefe en cada partida.
    ]
  ],
  block(fill: gris, inset: 11pt, radius: 6pt, width: 100%, height: 100%)[
    *2. Después de jugar* \
    #text(size: 14.5pt)[
      *Cuestionario:*
      - *SUS* (System Usability Scale) adaptado a videojuegos: usabilidad.
      - *GEQ* (Game Experience Questionnaire): afecto positivo y negativo, desafío, tensión e inmersión.
      - *Preguntas abiertas*: predictibilidad, aprendizaje, justicia, y lo más
        interesante o frustrante del combate.
    ]
  ],
)

#v(10pt)
#destaca[
  El registro interno permite contrastar *lo que el jugador dijo* contra *lo que
  el sistema efectivamente hizo* en esa partida.
]

// =============================================================
= Resultados
// =============================================================

== Primero: ¿el sistema hace lo que dice hacer?

#v(10pt)
#grid(
  columns: (1fr, 1fr),
  column-gutter: 20pt,
  dato[15 / 15][sesiones donde el ajuste *pre-combate* coincidió exactamente con
    lo predicho por las reglas],
  dato[14 / 15][sesiones donde los pesos cambiaron *durante la pelea*],
)

#v(14pt)
#set text(size: 17pt)
Se aplicaron las reglas *a mano* sobre las métricas de exploración de cada
participante del grupo adaptativo, y se compararon contra el archivo de pesos
que el juego dejó registrado al iniciar el combate.

== Usabilidad (SUS)

#grid(
  columns: (1.1fr, 1fr),
  column-gutter: 18pt,
  [
    #set text(size: 16pt)
    #tabla(
      columns: (auto, auto, auto, auto, auto),
      table.header([*Grupo*], [*N*], [*Prom.*], [*Mediana*], [*DE*]),
      table.hline(stroke: 0.6pt + borde),
      [Control], [15], [77.83], [80.00], [8.44],
      [Adaptativo], [15], [78.00], [77.50], [7.39],
      [General], [30], [77.92], [77.50], [7.80],
    )
    #v(8pt)
    #text(size: 15.5pt)[
      Sin diferencias entre condiciones \
      ($t(27.5) = -0.06$, $p = 0.955$, $d = -0.02$).
    ]
  ],
  [
    #set text(size: 16pt)
    #dato[77.9][puntaje SUS promedio]
    #v(8pt)
    #text(size: 15.5pt)[
      Por sobre el referente de industria (68)#super[1] y cerca del umbral
      «Excelente» (80.3)#super[2].

      #v(6pt)
      Es lo esperable: la adaptación cambia el *comportamiento del jefe*, no la
      interfaz ni los controles.
    ]
  ],
)

#place(bottom + left, dy: 1.2em)[
  #text(size: 11pt, fill: tinta.lighten(30%))[
    #super[1] Sauro y Lewis (2016), _Quantifying the User Experience_.#h(1.2em)
    #super[2] Bangor et al. (2009), _Determining What Individual SUS Scores Mean_.
  ]
]

== Experiencia de juego (GEQ)

#grid(
  columns: (1.25fr, 1fr),
  column-gutter: 16pt,
  [
    #set text(size: 15pt)
    #tabla(
      columns: (auto, auto, auto, auto, auto, auto),
      table.header([*Dimensión*], [*Md. Ctrl*], [*Md. Adap*], [*U*], [*p*], [$r$]),
      table.hline(stroke: 0.6pt + borde),
      [Afecto positivo], [4.75], [4.50], [125.0], [0.602], [−0.11],
      [Afecto negativo], [1.25], [1.25], [137.0], [0.301], [−0.22],
      [Desafío], [2.25], [2.50], [96.5], [0.517], [+0.14],
      [Tensión], [1.25], [1.00], [125.0], [0.592], [−0.11],
      [Inmersión], [3.25], [3.50], [106.0], [0.802], [+0.06],
    )
    #v(6pt)
    #text(size: 14.5pt)[
      Ninguna dimensión alcanza significancia ($p > 0.05$) y todos los tamaños
      de efecto son pequeños.
    ]
  ],
  [
    #image(img + "cap6/boxplot_geq_desafio.png", width: 100%)
    #v(2pt)
    #text(size: 14pt)[
      Medianas parecidas, pero el *rango intercuartílico* del grupo adaptativo
      es más compacto: *0.50 vs. 0.88*.
    ]
  ],
)

== El efecto según el estilo de juego

#grid(
  columns: (1fr, 1.15fr),
  column-gutter: 16pt,
  [
    #set text(size: 16pt)
    Al observar las sesiones surgió una hipótesis: el sistema *no se percibe
    igual* en todos los jugadores.

    #v(6pt)
    Se dividió el grupo adaptativo por la mediana de distancia de exploración
    (300.65): perfil *rango* ($n = 8$) y perfil *cuerpo a cuerpo* ($n = 7$).

    #v(6pt)
    #block(fill: azul.lighten(90%), inset: 10pt, radius: 5pt, width: 100%)[
      #text(size: 15pt)[
        *Tensión reportada (media)* \
        Rango: *1.69* \
        Cuerpo a cuerpo: *1.07* \
        $U = 43.5$, $p = 0.050$, $r = 0.55$ (efecto grande)
      ]
    ]
    #v(6pt)
    #text(size: 15pt)[
      En el grupo *control*, ambos perfiles reportan tensión prácticamente
      igual (medianas de 1.25 y 1.12).
    ]
  ],
  [
    #image(img + "cap6/tension_por_perfil.png", width: 100%)
  ],
)

== La misma señal, medida de forma continua

#set text(size: 17pt)
Correlación entre la distancia mantenida en la exploración y la tensión reportada:

#v(10pt)
#grid(
  rows: (4.6cm,),
  align: top,
  columns: (1fr, 1fr),
  column-gutter: 20pt,
  block(fill: rojo.lighten(90%), inset: 14pt, radius: 6pt, width: 100%, height: 100%)[
    #align(center)[
      *Grupo adaptativo* \
      #v(4pt)
      #text(size: 24pt, weight: "bold", fill: rojo)[$r_s = 0.517$] \
      #text(size: 15pt)[$p = 0.048$ (positiva y significativa)]
    ]
  ],
  block(fill: gris, inset: 14pt, radius: 6pt, width: 100%, height: 100%)[
    #align(center)[
      *Grupo control* \
      #v(4pt)
      #text(size: 24pt, weight: "bold")[$r_s = -0.075$] \
      #text(size: 15pt)[$p = 0.790$ (prácticamente nula)]
    ]
  ],
)

#v(12pt)
#destaca[
  Que la asociación aparezca *solo cuando el jefe se adapta* es la evidencia más
  directa de que el sistema generó una experiencia diferenciada.
]

== ¿Y si fuera solo habilidad, y no estilo de juego?

#set text(size: 16.5pt)
Los jugadores agresivos y cercanos solían ser también los más experimentados.
Tres revisiones para descartar esa explicación alternativa:

#v(10pt)
#grid(
  rows: (5.2cm,),
  align: top,
  columns: (1fr, 1fr, 1fr),
  column-gutter: 12pt,
  block(fill: gris, inset: 11pt, radius: 6pt, width: 100%, height: 100%)[
    #text(size: 14.5pt)[
      *1. ¿Distancia y experiencia están relacionadas?* \
      #v(4pt)
      Relación débil y no significativa \
      ($r_s = -0.313$, $p = 0.256$).
    ]
  ],
  block(fill: gris, inset: 11pt, radius: 6pt, width: 100%, height: 100%)[
    #text(size: 14.5pt)[
      *2. ¿Difiere la experiencia entre perfiles?* \
      #v(4pt)
      Casi idéntica: 6.25 (rango) frente a 6.71 (cuerpo a cuerpo).
    ]
  ],
  block(fill: rojo.lighten(90%), inset: 11pt, radius: 6pt, width: 100%, height: 100%)[
    #text(size: 14.5pt)[
      *3. Correlación parcial, descontando experiencia* \
      #v(4pt)
      La relación *se mantiene*: $r_s = 0.537$, $p = 0.039$.
    ]
  ],
)

#v(10pt)
#text(size: 16pt)[
  Si la tensión se debiera a la habilidad, la relación debería debilitarse al
  descontarla. No lo hizo.
]

== Lo que los jugadores dijeron

#grid(
  columns: (1fr, 1.1fr),
  column-gutter: 18pt,
  [
    #set text(size: 15.5pt)
    *«¿El jefe se sintió predecible?»*
    #v(4pt)
    #tabla(
      columns: (auto, auto),
      table.header([*Condición*], [*Lo llamó predecible*]),
      table.hline(stroke: 0.6pt + borde),
      [Control], [11 / 15 (73%)],
      [Adaptativo], [7 / 15 (47%)],
    )
    #v(10pt)
    *«¿Notaste que aprendía?»*
    #v(4pt)
    #tabla(
      columns: (auto, auto, auto),
      table.header([*Condición*], [*Sí*], [*No*]),
      table.hline(stroke: 0.6pt + borde),
      [Adaptativo], [10], [5],
      [Control], [7], [8],
    )
    #v(4pt)
    #text(size: 14pt)[Fisher, $p = 0.462$ (no significativo).]
  ],
  [
    #set text(size: 16pt)
    #destaca[
      *7 de 15 del grupo control*, que enfrentaron un jefe completamente fijo,
      también afirmaron percibir aprendizaje, y describieron con detalle cambios
      que nunca ocurrieron.
    ]
    #v(8pt)
    #text(size: 15.5pt)[
      Como los pesos reales quedan registrados, se pudo cruzar lo reportado
      contra lo que efectivamente pasó. *La correspondencia es baja.*

      #v(6pt)
      Probable *sesgo de expectativa*: el estudio trata sobre enemigos
      adaptativos, y muchos llegaron esperando encontrar uno.

      #v(6pt)
      Por eso el análisis se apoya en las *métricas objetivas*, no en lo declarado.
    ]
  ],
)

// =============================================================
= Discusión y conclusiones
// =============================================================

== Lecciones para quien diseñe un sistema así

#set text(size: 16.5pt)
#grid(
  rows: (3.7cm, 3.7cm),
  align: top,
  columns: (1fr, 1fr),
  column-gutter: 14pt,
  row-gutter: 10pt,

  block(fill: gris, inset: 11pt, radius: 6pt, width: 100%, height: 100%)[
    #text(size: 15pt)[
      *Adaptar comportamiento, no números.* Subir daño o velocidad se siente
      como un juego más difícil para todos; cambiar de estrategia se siente como
      un enemigo que responde.
    ]
  ],
  block(fill: gris, inset: 11pt, radius: 6pt, width: 100%, height: 100%)[
    #text(size: 15pt)[
      *Que la adaptación sea visible.* Lo único que los jugadores identificaron
      bien fue un cambio llamativo (la forma de charco), no un ataque repetido
      un poco más seguido.
    ]
  ],
  block(fill: gris, inset: 11pt, radius: 6pt, width: 100%, height: 100%)[
    #text(size: 15pt)[
      *Respuestas específicas por comportamiento*, en lugar de un solo ajuste
      genérico que lo endurece todo por igual.
    ]
  ],
  block(fill: azul.lighten(90%), inset: 11pt, radius: 6pt, width: 100%, height: 100%)[
    #text(size: 15pt)[
      *No hace falta subir la dificultad promedio.* La meta puede ser que
      distintos jugadores sientan un desafío *más parejo entre ellos*, lo que
      sugiere el rango intercuartílico más compacto.
    ]
  ],
)

#v(6pt)
#text(size: 15pt)[
  Y una precisión: el jugador *no necesita darse cuenta* de la adaptación para
  que esta cumpla su función. La tensión del perfil de rango subió igual.
]

== Conclusiones

#set text(size: 17.5pt)
#grid(
  columns: (auto, 1fr),
  column-gutter: 14pt,
  row-gutter: 12pt,

  text(fill: azul, weight: "bold", size: 22pt)[1],
  [El sistema *funciona como se especificó*: las reglas predicen exactamente los
   pesos registrados en las 15 sesiones adaptativas.],

  text(fill: azul, weight: "bold", size: 22pt)[2],
  [Comparando *los grupos completos*, las diferencias fueron pequeñas y no
   significativas. Con esta muestra, eso no descarta un efecto real: indica que
   no llegó a hacerse visible.],

  text(fill: azul, weight: "bold", size: 22pt)[3],
  [Al mirar el *estilo de juego*, el efecto sí aparece: los jugadores de perfil
   a distancia reportaron una tensión notablemente mayor en la versión
   adaptativa, y esa diferencia no existe en el control.],
)

#v(10pt)
#destaca[
  *Contribución principal:* un sistema capaz de adaptar el comportamiento del
  jefe al estilo de cada jugador, que en la práctica funcionó mejor contra
  quienes se mantienen a distancia que contra quienes pelean cuerpo a cuerpo.
]

== Limitaciones

#set text(size: 16pt)
#grid(
  columns: (1fr, 1fr),
  column-gutter: 16pt,
  row-gutter: 8pt,
  [
    - *Tamaño de muestra.* 30 participantes (15 por condición) implica bajo poder
      estadístico. Los resultados son descriptivos, no generalizables.

    - *Medir la experiencia es difícil.* El puntaje refleja cuánto ha jugado la
      persona, no su habilidad real. Además, el corte resultó permisivo: todos
      quedaron sobre el umbral.

    - *Desbalance entre grupos.* El grupo adaptativo quedó levemente más
      experimentado (6.47 vs. 6.07) y algo más lejano en su estilo.
  ],
  [
    - *Lo que el jugador reporta es poco confiable*, y el encuadre del estudio
      probablemente infló la percepción de adaptación.

    - *Alcance de la adaptación.* El efecto observado corresponde sobre todo a la
      adaptación *pre-combate*; el ajuste en tiempo real es acotado.

    - *Instrumentos adaptados.* El SUS se adaptó al contexto de videojuegos y el
      GEQ se aplicó traducido; ninguno es el instrumento validado en su forma
      original.
  ],
)

== Trabajo futuro

#set text(size: 17pt)
#grid(
  rows: (4.1cm, 4.1cm),
  align: top,
  columns: (1fr, 1fr),
  column-gutter: 16pt,
  row-gutter: 10pt,

  block(fill: gris, inset: 11pt, radius: 6pt, width: 100%, height: 100%)[
    #text(size: 15.5pt)[
      *Repetir con más participantes.* El efecto real combinando ambos perfiles
      es probablemente menor a $r = 0.55$; detectarlo con confianza requeriría
      del orden de *40 por condición* (80 en total).
    ]
  ],
  block(fill: gris, inset: 11pt, radius: 6pt, width: 100%, height: 100%)[
    #text(size: 15.5pt)[
      *Reforzar la adaptación contra el perfil cuerpo a cuerpo*, que fue donde el
      sistema tuvo menos efecto. ¿Alcanzan las reglas y los ataques disponibles
      para presionar a quien pelea de cerca?
    ]
  ],
  block(fill: gris, inset: 11pt, radius: 6pt, width: 100%, height: 100%)[
    #text(size: 15.5pt)[
      *Extender la adaptación al combate mismo*, más allá del ajuste acotado
      actual.
    ]
  ],
  block(fill: gris, inset: 11pt, radius: 6pt, width: 100%, height: 100%)[
    #text(size: 15.5pt)[
      *Medidas menos dependientes de la opinión*: telemetría más fina del
      combate o señales fisiológicas. Y pulir la jugabilidad: cancelar
      animaciones fue la queja más repetida.
    ]
  ],
)

#cierre()
