#set page(paper: "a4", margin: (x: 1.6cm, y: 1.5cm),
  numbering: "1 / 1", number-align: center + bottom)
#set text(lang: "es", font: ("Segoe UI", "Calibri", "Arial"),
  size: 10pt, hyphenate: false)
#set par(justify: false, leading: 0.62em)
#show heading: set text(fill: rgb("#0d2340"))

#align(center)[
  #text(size: 17pt, weight: "bold", fill: rgb("#0d2340"))[Guion de defensa]
  #linebreak()
  #text(size: 10pt, fill: rgb("#555"))[Amaro Zurita Alvarado -- 20 minutos]
]
#v(10pt)

#table(columns: 4, stroke: 0.4pt + rgb("#cdd3da"), inset: 5pt, align: left,
  [Bloque], [Diapositivas], [Tiempo], [%],
  [Inicio], [1–4], [0:00 – 1:55], [10%],
  [Antecedentes y diseño], [5–18], [1:55 – 8:45], [34%],
  [Aporte propio (resultados y discusión)], [19–28], [8:45 – 16:40], [40%],
  [Cierre], [29–32], [16:40 – 19:20], [13%],
  [*Colchón*], [—], [19:20 – 20:00], [3%],
)
#v(6pt)
#v(10pt)

#block(breakable: false, width: 100%)[
  #text(size: 11pt, weight: "bold", fill: rgb("#0d2340"))[1. Portada]
  #h(6pt)
  #text(size: 9pt, fill: rgb("#777"))[0:00 – 0:20]
  #v(4pt)
  #grid(columns: (5.4cm, 1fr), column-gutter: 10pt, align: top,
    image("miniaturas/d01.png", width: 100%),
    [
    #par[Buenas tardes, profesores. Mi nombre es Amaro Zurita y hoy les voy a presentar mi memoria para optar al título de Ingeniero Civil en Computación, titulada "Diseño e implementación de enemigos adaptativos en videojuegos", desarrollada bajo la guía del profesor Francisco Gutiérrez y la co-guía del profesor Elías Zelada.]
    #v(3pt)
    ],
  )
]
#v(9pt)

#block(breakable: false, width: 100%)[
  #text(size: 11pt, weight: "bold", fill: rgb("#0d2340"))[2. El problema]
  #h(6pt)
  #text(size: 9pt, fill: rgb("#777"))[0:20 – 0:55]
  #v(4pt)
  #grid(columns: (5.4cm, 1fr), column-gutter: 10pt, align: top,
    image("miniaturas/d02.png", width: 100%),
    [
    #par[#underline[Quiero partir por el problema concreto]. En juegos de acción exigentes, #underline[como Elden Ring], los jefes siguen patrones de ataque fijos. Eso significa que #underline[después de varios intentos] el jugador se los aprende de memoria, y a partir de ahí la dificultad deja de ser un desafío y pasa a ser un ejercicio de memorización.]
    #v(3pt)
    #par[Ahora, sí #underline[existen] técnicas para ajustar la dificultad de forma dinámica. Pero la gran mayoría ajusta #underline[números]: la vida del enemigo, su daño, su velocidad. Ninguna cambia #underline[cómo se comporta].]
    #v(3pt)
    ],
  )
]
#v(9pt)

#block(breakable: false, width: 100%)[
  #text(size: 11pt, weight: "bold", fill: rgb("#0d2340"))[3. La pregunta de este trabajo]
  #h(6pt)
  #text(size: 9pt, fill: rgb("#777"))[0:55 – 1:35]
  #v(4pt)
  #grid(columns: (5.4cm, 1fr), column-gutter: 10pt, align: top,
    image("miniaturas/d03.png", width: 100%),
    [
    #par[#underline[Hay un caso especial], el ejemplo que más se repite cuando se habla de enemigos adaptativos. En _Alien: Isolation_ el alien #underline[aprende dónde sueles esconderte y cambia sus *rutas de patrullaje*, así que el escondite que te salvó una vez deja de servirte].]
    #v(3pt)
    #block(inset: (left: 6pt), stroke: (left: 2pt + rgb("#cdd3da")))[
      #text(size: 8.5pt, style: "italic", fill: rgb("#555"))[Acá baja el ritmo y mira a la comisión, no a la pantalla. Es la pregunta central de toda la defensa: dila, pero no la leas palabra por palabra.]
    ]
    #v(3pt)
    #par[Y de ahí sale la pregunta de este trabajo: ¿y si el jefe reconociera cómo juega cada persona y cambiara su estrategia según eso? #underline[Un mismo jefe podría ser distinto para todos].]
    #v(3pt)
    ],
  )
]
#v(9pt)

#block(breakable: false, width: 100%)[
  #text(size: 11pt, weight: "bold", fill: rgb("#0d2340"))[4. Agenda]
  #h(6pt)
  #text(size: 9pt, fill: rgb("#777"))[1:35 – 1:55]
  #v(4pt)
  #grid(columns: (5.4cm, 1fr), column-gutter: 10pt, align: top,
    image("miniaturas/d04.png", width: 100%),
    [
    #block(inset: (left: 6pt), stroke: (left: 2pt + rgb("#cdd3da")))[
      #text(size: 8.5pt, style: "italic", fill: rgb("#555"))[No leas los seis puntos, ya están en pantalla. Agrúpalos.]
    ]
    #v(3pt)
    #par[#underline[Para responder eso], la presentación va así. #underline[Primero] los objetivos. #underline[Después], cómo se construyeron el juego y el sistema que adapta al jefe. #underline[Luego], cómo se puso a prueba. #underline[Y al final], los resultados.]
    #v(3pt)
    #block(inset: (left: 6pt), stroke: (left: 2pt + rgb("#cdd3da")))[
      #text(size: 8.5pt, style: "italic", fill: rgb("#555"))[\#\# ANTECEDENTES Y DISEÑO — 1:55 a 8:45]
    ]
    #v(3pt)
    ],
  )
]
#v(9pt)

#block(breakable: false, width: 100%)[
  #text(size: 11pt, weight: "bold", fill: rgb("#0d2340"))[5. Objetivos]
  #h(6pt)
  #text(size: 9pt, fill: rgb("#777"))[1:55 – 2:40]
  #v(4pt)
  #grid(columns: (5.4cm, 1fr), column-gutter: 10pt, align: top,
    image("miniaturas/d05.png", width: 100%),
    [
    #block(inset: (left: 6pt), stroke: (left: 2pt + rgb("#cdd3da")))[
      #text(size: 8.5pt, style: "italic", fill: rgb("#555"))[Lee el objetivo general tal cual está en pantalla. Es casi el mismo que está en el escrito, así que conviene no improvisarlo.]
    ]
    #v(3pt)
    #par[El objetivo general fue diseñar e implementar un sistema de adaptación para un enemigo jefe, capaz de #underline[ajustar su comportamiento] de combate a partir de un #underline[perfil construido sobre las acciones previas del jugador], para reducir la previsibilidad del enfrentamiento y evaluar su efecto sobre la experiencia de juego.]
    #v(3pt)
    #par[*\[clic × 6 — uno por objetivo específico\]*]
    #v(3pt)
    #par[Los específicos van desde #underline[revisar el estado del arte] hasta #underline[comparar la versión adaptativa contra una de control]. Quiero destacar dos: el número dos, construir una versión base con jefe fijo que sirva de control, y el número tres, #underline[diseñar enemigos regulares que expongan el estilo de juego]. Esos dos son los que hacen posible todo el resto.]
    #v(3pt)
    ],
  )
]
#v(9pt)

#block(breakable: false, width: 100%)[
  #text(size: 11pt, weight: "bold", fill: rgb("#0d2340"))[7. El juego]
  #h(6pt)
  #text(size: 9pt, fill: rgb("#777"))[2:40 – 3:05]
  #v(4pt)
  #grid(columns: (5.4cm, 1fr), column-gutter: 10pt, align: top,
    image("miniaturas/d07.png", width: 100%),
    [
    #par[#underline[No había un juego base donde probar esto], así que se construyó uno. Es un juego de acción _soulslike_, en Unreal Engine 5.6, hecho con Blueprints y C++, usando las #underline[herramientas nativas] de inteligencia artificial del motor: Behaviour Tree y Blackboard.]
    #v(3pt)
    #par[Tiene las #underline[mecánicas clásicas] del género: combate melee, hechizos a distancia, esquiva con frames de invulnerabilidad, stamina, pociones y fijado de objetivo.]
    #v(3pt)
    ],
  )
]
#v(9pt)

#block(breakable: false, width: 100%)[
  #text(size: 11pt, weight: "bold", fill: rgb("#0d2340"))[8. Los tres niveles: el tutorial]
  #h(6pt)
  #text(size: 9pt, fill: rgb("#777"))[3:05 – 3:12]
  #v(4pt)
  #grid(columns: (5.4cm, 1fr), column-gutter: 10pt, align: top,
    image("miniaturas/d08.png", width: 100%),
    [
    #block(inset: (left: 6pt), stroke: (left: 2pt + rgb("#cdd3da")))[
      #text(size: 8.5pt, style: "italic", fill: rgb("#555"))[Las tres diapositivas que vienen son solo fotos. El texto va hablado.]
    ]
    #v(3pt)
    #par[El juego son tres niveles. Primero un #underline[tutorial], donde el jugador aprende los controles contra un maniquí, sin riesgo.]
    #v(3pt)
    ],
  )
]
#v(9pt)

#block(breakable: false, width: 100%)[
  #text(size: 11pt, weight: "bold", fill: rgb("#0d2340"))[9. Los tres niveles: el nivel previo]
  #h(6pt)
  #text(size: 9pt, fill: rgb("#777"))[3:12 – 3:20]
  #v(4pt)
  #grid(columns: (5.4cm, 1fr), column-gutter: 10pt, align: top,
    image("miniaturas/d09.png", width: 100%),
    [
    #par[Después un #underline[nivel previo], que reúne a los tres arquetipos de enemigo regular. Mientras el jugador lo recorre, el sistema #underline[observa] cómo juega, y cada arquetipo está diseñado para #underline[exponer] una dimensión distinta de su estilo de juego.]
    #v(3pt)
    ],
  )
]
#v(9pt)

#block(breakable: false, width: 100%)[
  #text(size: 11pt, weight: "bold", fill: rgb("#0d2340"))[10. Los tres niveles: el jefe]
  #h(6pt)
  #text(size: 9pt, fill: rgb("#777"))[3:20 – 3:25]
  #v(4pt)
  #grid(columns: (5.4cm, 1fr), column-gutter: 10pt, align: top,
    image("miniaturas/d10.png", width: 100%),
    [
    #par[Y al final, el #underline[combate contra el jefe], que es donde se aplica todo lo que el sistema aprendió.]
    #v(3pt)
    ],
  )
]
#v(9pt)

#block(breakable: false, width: 100%)[
  #text(size: 11pt, weight: "bold", fill: rgb("#0d2340"))[11. El repertorio del jefe]
  #h(6pt)
  #text(size: 9pt, fill: rgb("#777"))[3:25 – 3:40]
  #v(4pt)
  #grid(columns: (5.4cm, 1fr), column-gutter: 10pt, align: top,
    image("miniaturas/d11.png", width: 100%),
    [
    #par[El jefe tiene nueve ataques, agrupados en rangos de distancia. Dentro de cada rango elige mediante un selector aleatorio ponderado implementado en C++, y todos los ataques parten con el mismo peso base: cincuenta.]
    #v(3pt)
    ],
  )
]
#v(9pt)

#block(breakable: false, width: 100%)[
  #text(size: 11pt, weight: "bold", fill: rgb("#0d2340"))[12. La decisión de diseño central]
  #h(6pt)
  #text(size: 9pt, fill: rgb("#777"))[3:40 – 4:05]
  #v(4pt)
  #grid(columns: (5.4cm, 1fr), column-gutter: 10pt, align: top,
    image("miniaturas/d12.png", width: 100%),
    [
    #block(inset: (left: 6pt), stroke: (left: 2pt + rgb("#cdd3da")))[
      #text(size: 8.5pt, style: "italic", fill: rgb("#555"))[Las dos columnas se leen solas: no las enumeres. Tú aporta el porqué, que es lo único que no está en pantalla.]
    ]
    #v(3pt)
    #par[Lo primero es lo que #underline[no cambia]. Estos tres parámetros son idénticos en las dos versiones, y es deliberado: es lo que permite atribuir cualquier diferencia al #underline[comportamiento] del jefe, y no a que sea más fuerte.]
    #v(3pt)
    #block(inset: (y: 2pt))[
      #text(size: 9pt, weight: "bold", fill: rgb("#a9741f"))[> clic]
    ]
    #par[Lo que sí cambia es #underline[cómo usa ese mismo repertorio]: la frecuencia de cada ataque, las distancias a las que los usa y cuánto persigue.]
    #v(3pt)
    #par[La distinción importa. Subir los números #underline[endurece el juego para todos por igual]; cambiar el comportamiento produce un jefe #underline[distinto para cada persona].]
    #v(3pt)
    ],
  )
]
#v(9pt)

#block(breakable: false, width: 100%)[
  #text(size: 11pt, weight: "bold", fill: rgb("#0d2340"))[13. El perfil de cuatro dimensiones]
  #h(6pt)
  #text(size: 9pt, fill: rgb("#777"))[4:05 – 5:40]
  #v(4pt)
  #grid(columns: (5.4cm, 1fr), column-gutter: 10pt, align: top,
    image("miniaturas/d13.png", width: 100%),
    [
    #block(inset: (left: 6pt), stroke: (left: 2pt + rgb("#cdd3da")))[
      #text(size: 8.5pt, style: "italic", fill: rgb("#555"))[Esta es la diapositiva más densa. No leas la tabla completa: recórrela.]
    ]
    #v(3pt)
    #par[El perfil tiene cuatro dimensiones, y cada una se mide contra un enemigo distinto del nivel previo.]
    #v(3pt)
    #par[La primera es la distancia promedio que el jugador mantiene. Si juega pegado, se achica el rango cercano del jefe, obligándolo a recurrir antes a ataques de rango medio.]
    #v(3pt)
    #block(inset: (y: 2pt))[
      #text(size: 9pt, weight: "bold", fill: rgb("#a9741f"))[> clic]
    ]
    #par[La segunda es qué tipo de ataque usa: si predominan los ataques a distancia, suben los pesos de los ataques que cierran distancia rápido.]
    #v(3pt)
    #block(inset: (y: 2pt))[
      #text(size: 9pt, weight: "bold", fill: rgb("#a9741f"))[> clic]
    ]
    #par[La tercera es la esquiva: qué proporción de sus esquivas fueron exitosas contra el ataque telegrafiado del caballero. Si esquiva muy bien lo que se anuncia con anticipación, sube el peso del ataque básico, que es el que apenas se telegrafía. Si esquiva mal, suben los de preparación larga, que igual le conectan.]
    #v(3pt)
    #block(inset: (y: 2pt))[
      #text(size: 9pt, weight: "bold", fill: rgb("#a9741f"))[> clic]
    ]
    #par[Y la cuarta observa hacia qué lado esquiva cuando el caballero se le viene encima: si esquiva de lado sube el peso del #underline[giro], que barre alrededor; si esquiva hacia atrás sube el del #underline[salto], que cierra la distancia.]
    #v(3pt)
    #block(inset: (y: 2pt))[
      #text(size: 9pt, weight: "bold", fill: rgb("#a9741f"))[> clic]
    ]
    #par[Cada regla que se activa suma diez o quince puntos al peso de ciertos ataques, sobre una base pareja de cincuenta, sin eliminar nunca un ataque del repertorio. No es que el ataque haga más daño: pesa más a la hora de elegirlo.]
    #v(3pt)
    #par[En este mismo nivel se registra además a qué porcentaje de vida suele curarse el jugador, pero eso no ajusta los pesos antes del combate sino durante él, como voy a mostrar en un momento.]
    #v(3pt)
    ],
  )
]
#v(9pt)

#block(breakable: false, width: 100%)[
  #text(size: 11pt, weight: "bold", fill: rgb("#0d2340"))[14. Un ejemplo concreto]
  #h(6pt)
  #text(size: 9pt, fill: rgb("#777"))[5:40 – 6:20]
  #v(4pt)
  #grid(columns: (5.4cm, 1fr), column-gutter: 10pt, align: top,
    image("miniaturas/d14.png", width: 100%),
    [
    #par[Este es un ejemplo concreto. Un jugador que juega a distancia, esquiva bien lo telegrafiado y tiende a esquivar de lado, termina enfrentando un jefe donde Charco y Salto pesan setenta y cinco, Giro setenta, Básico y Persecución sesenta y cinco, y los demás quedan en su valor base.]
    #v(3pt)
    #par[Y no son solo los pesos. Como este jugador se mantiene lejos, el jefe también achica su rango lejano en setenta y cinco unidades, con lo que entra antes a su repertorio de larga distancia, y alarga su persecución en dos segundos, así que pasa más tiempo cerrando el espacio. Es el mismo jefe, con el mismo repertorio, pero jugando distinto.]
    #v(3pt)
    #par[Y al margen del perfil, una regla fija: ningún ataque puede salir #underline[tres veces seguidas], por mucho que haya subido su peso.]
    #v(3pt)
    ],
  )
]
#v(9pt)

#block(breakable: false, width: 100%)[
  #text(size: 11pt, weight: "bold", fill: rgb("#0d2340"))[15. Ajustes durante el combate]
  #h(6pt)
  #text(size: 9pt, fill: rgb("#777"))[6:20 – 7:10]
  #v(4pt)
  #grid(columns: (5.4cm, 1fr), column-gutter: 10pt, align: top,
    image("miniaturas/d15.png", width: 100%),
    [
    #par[Esos pesos se calculan una sola vez, al empezar el combate, y son la parte principal de la adaptación. Durante el combate hay además dos ajustes más acotados.]
    #v(3pt)
    #block(inset: (y: 2pt))[
      #text(size: 9pt, weight: "bold", fill: rgb("#a9741f"))[> clic]
    ]
    #par[El primero mira, cada quince ataques del jefe, qué proporción de cada tipo efectivamente conectó. Si conecta mucho, ese ataque sube; si el jugador lo esquiva siempre, baja. Así el jefe deja de insistir en lo que la persona ya domina.]
    #v(3pt)
    #block(inset: (y: 2pt))[
      #text(size: 9pt, weight: "bold", fill: rgb("#a9741f"))[> clic]
    ]
    #par[El segundo usa el dato de curación registrado en el nivel previo. El sistema sabe a qué porcentaje de vida suele curarse el jugador, y cuando entra a ese rango sube los pesos de los ataques más rápidos, reduciéndole la ventana para tomar la poción.]
    #v(3pt)
    ],
  )
]
#v(9pt)

#block(breakable: false, width: 100%)[
  #text(size: 11pt, weight: "bold", fill: rgb("#0d2340"))[17. Diseño experimental]
  #h(6pt)
  #text(size: 9pt, fill: rgb("#777"))[7:10 – 8:15]
  #v(4pt)
  #grid(columns: (5.4cm, 1fr), column-gutter: 10pt, align: top,
    image("miniaturas/d17.png", width: 100%),
    [
    #par[Para evaluarlo se hizo una prueba A/B con diseño entre sujetos: cada persona juega una sola condición, nunca las dos. Así, #underline[lo que alguien aprende jugando una versión no influye en cómo percibe la otra].]
    #v(3pt)
    #par[La condición de control es exactamente el mismo jefe, con los mismos nueve ataques, pero con los pesos parejos durante toda la partida.]
    #v(3pt)
    #par[La condición se fija con un #underline[botón escondido en el menú principal], que se presiona antes de entregarle el control al participante, así que la persona nunca sabe qué versión está jugando.]
    #v(3pt)
    #par[Y hay un detalle importante: la recolección del perfil es independiente de la condición. _Todos_ los participantes generan perfil; lo único que cambia es si ese perfil se aplica o no. #underline[Eso permitió después verificar que ambos grupos partieron jugando parecido].]
    #v(3pt)
    #par[Participaron treinta personas: quince en cada condición. Cada sesión duró entre veinticinco y cuarenta minutos.]
    #v(3pt)
    ],
  )
]
#v(9pt)

#block(breakable: false, width: 100%)[
  #text(size: 11pt, weight: "bold", fill: rgb("#0d2340"))[18. Los datos que se recogieron]
  #h(6pt)
  #text(size: 9pt, fill: rgb("#777"))[8:15 – 8:45]
  #v(4pt)
  #grid(columns: (5.4cm, 1fr), column-gutter: 10pt, align: top,
    image("miniaturas/d18.png", width: 100%),
    [
    #par[La medición tuvo dos partes. Durante la partida, el propio juego lleva un registro interno con las métricas de comportamiento y, lo más importante, los pesos de ataque reales de cada partida.]
    #v(3pt)
    #block(inset: (y: 2pt))[
      #text(size: 9pt, weight: "bold", fill: rgb("#a9741f"))[> clic]
    ]
    #par[Después de jugar, cada participante respondió un cuestionario con tres bloques: el SUS adaptado, una selección de ítems del GEQ y preguntas abiertas.]
    #v(3pt)
    #block(inset: (y: 2pt))[
      #text(size: 9pt, weight: "bold", fill: rgb("#a9741f"))[> clic]
    ]
    #par[#underline[Que los pesos reales queden registrados es lo que después permite contrastar lo que el jugador _dijo_ contra lo que el sistema _efectivamente hizo_].]
    #v(3pt)
    #block(inset: (left: 6pt), stroke: (left: 2pt + rgb("#cdd3da")))[
      #text(size: 8.5pt, style: "italic", fill: rgb("#555"))[\#\# RESULTADOS — 8:45 a 16:40]
    ]
    #v(3pt)
    ],
  )
]
#v(9pt)

#block(breakable: false, width: 100%)[
  #text(size: 11pt, weight: "bold", fill: rgb("#0d2340"))[20. Verificación técnica]
  #h(6pt)
  #text(size: 9pt, fill: rgb("#777"))[8:45 – 9:10]
  #v(4pt)
  #grid(columns: (5.4cm, 1fr), column-gutter: 10pt, align: top,
    image("miniaturas/d20.png", width: 100%),
    [
    #par[Lo primero fue verificar que el sistema efectivamente funcionó: el ajuste previo al combate fue el esperado en las quince sesiones adaptativas,]
    #v(3pt)
    #block(inset: (y: 2pt))[
      #text(size: 9pt, weight: "bold", fill: rgb("#a9741f"))[> clic]
    ]
    #par[y en catorce de quince los pesos además cambiaron durante la pelea.]
    #v(3pt)
    #block(inset: (y: 2pt))[
      #text(size: 9pt, weight: "bold", fill: rgb("#a9741f"))[> clic]
    ]
    #par[Así, cualquier resultado que venga después no se explica por un sistema que no funcionó.]
    #v(3pt)
    ],
  )
]
#v(9pt)

#block(breakable: false, width: 100%)[
  #text(size: 11pt, weight: "bold", fill: rgb("#0d2340"))[21. SUS]
  #h(6pt)
  #text(size: 9pt, fill: rgb("#777"))[9:10 – 9:40]
  #v(4pt)
  #grid(columns: (5.4cm, 1fr), column-gutter: 10pt, align: top,
    image("miniaturas/d21.png", width: 100%),
    [
    #par[En usabilidad, la tabla muestra los puntajes por grupo.]
    #v(3pt)
    #block(inset: (y: 2pt))[
      #text(size: 9pt, weight: "bold", fill: rgb("#a9741f"))[> clic]
    ]
    #par[Entre condiciones no hay ninguna diferencia.]
    #v(3pt)
    #block(inset: (y: 2pt))[
      #text(size: 9pt, weight: "bold", fill: rgb("#a9741f"))[> clic]
    ]
    #par[El promedio general fue 77.9. El puntaje más bajo fue 62.5, que igual se considera aceptable: bajo 50 recién se habla de un sistema con problemas serios de usabilidad.]
    #v(3pt)
    #block(inset: (y: 2pt))[
      #text(size: 9pt, weight: "bold", fill: rgb("#a9741f"))[> clic]
    ]
    #par[Está por sobre el referente de industria, que son 68 puntos, y cerca del umbral de "Excelente". Y que no haya diferencia entre condiciones es exactamente lo esperado: la adaptación cambia el comportamiento del jefe, no la interfaz ni los controles.]
    #v(3pt)
    ],
  )
]
#v(9pt)

#block(breakable: false, width: 100%)[
  #text(size: 11pt, weight: "bold", fill: rgb("#0d2340"))[22. GEQ global]
  #h(6pt)
  #text(size: 9pt, fill: rgb("#777"))[9:40 – 10:25]
  #v(4pt)
  #grid(columns: (5.4cm, 1fr), column-gutter: 10pt, align: top,
    image("miniaturas/d22.png", width: 100%),
    [
    #par[En el GEQ, mirando los grupos completos, ninguna de las cinco dimensiones alcanzó significancia estadística, y todos los tamaños de efecto son pequeños. *\[clic\]*]
    #v(3pt)
    #par[Desafío e inmersión van en la dirección esperada, pero no se distinguen del azar con esta muestra.]
    #v(3pt)
    #block(inset: (y: 2pt))[
      #text(size: 9pt, weight: "bold", fill: rgb("#a9741f"))[> clic]
    ]
    #par[Hay una observación descriptiva que sí vale la pena. En desafío, las medianas son parecidas, pero el rango intercuartílico del grupo adaptativo es visiblemente más compacto: 0.50 contra 0.88. Es decir, el cincuenta por ciento central de las respuestas se concentra en un intervalo más estrecho. Eso sugiere que el sistema pudo haber regulado el desafío hacia un rango más parejo entre jugadores, en vez de simplemente subirlo.]
    #v(3pt)
    #block(inset: (left: 6pt), stroke: (left: 2pt + rgb("#cdd3da")))[
      #text(size: 8.5pt, style: "italic", fill: rgb("#555"))[Marca el tono: acá reconoces que el resultado global es negativo. No lo escondas, pero no te quedes ahí — la frase siguiente es el giro.]
    ]
    #v(3pt)
    ],
  )
]
#v(9pt)

#block(breakable: false, width: 100%)[
  #text(size: 11pt, weight: "bold", fill: rgb("#0d2340"))[23. El hallazgo]
  #h(6pt)
  #text(size: 9pt, fill: rgb("#777"))[10:25 – 12:10]
  #v(4pt)
  #grid(columns: (5.4cm, 1fr), column-gutter: 10pt, align: top,
    image("miniaturas/d23.png", width: 100%),
    [
    #par[Al observar a los participantes jugar durante las sesiones surgió una hipótesis: el sistema no se percibe igual en todos. Daba la impresión de que quienes peleaban cuerpo a cuerpo acusaban menos la adaptación que quienes preferían mantenerse a distancia, y había que ver si los datos lo respaldaban.]
    #v(3pt)
    #par[A quien juega a distancia, el jefe adaptado lo persigue y le cierra la distancia; es un cambio de comportamiento muy visible. En cambio, a quien ya pelea de cerca, la adaptación le refuerza ataques de corto alcance para los que de todas formas está preparado.]
    #v(3pt)
    #par[A eso se suma que quienes pelean cuerpo a cuerpo solían ser también los más familiarizados con este tipo de juegos, así que parte del efecto podría venir de que al sistema le cuesta más presionar a un jugador experimentado. Es una explicación alternativa que reviso en un par de diapositivas más.]
    #v(3pt)
    #block(inset: (y: 2pt))[
      #text(size: 9pt, weight: "bold", fill: rgb("#a9741f"))[> clic]
    ]
    #par[Para comprobarlo se decidió dividir el grupo adaptativo por la mediana de distancia de exploración: quedaron ocho jugadores de perfil rango y siete de cuerpo a cuerpo.]
    #v(3pt)
    #block(inset: (y: 2pt))[
      #text(size: 9pt, weight: "bold", fill: rgb("#a9741f"))[> clic]
    ]
    #par[Los de perfil rango reportaron una tensión media de 1.69, contra 1.07 en los de cuerpo a cuerpo. La diferencia queda justo en el límite de la significancia, y con un tamaño de efecto grande, a pesar de lo chicos que son los subgrupos.]
    #v(3pt)
    #block(inset: (y: 2pt))[
      #text(size: 9pt, weight: "bold", fill: rgb("#a9741f"))[> clic]
    ]
    #par[Y lo decisivo: al aplicar exactamente la misma división al grupo de control, ambos perfiles reportan una tensión prácticamente igual. La diferencia aparece solo cuando el jefe se adapta.]
    #v(3pt)
    ],
  )
]
#v(9pt)

#block(breakable: false, width: 100%)[
  #text(size: 11pt, weight: "bold", fill: rgb("#0d2340"))[24. La correlación]
  #h(6pt)
  #text(size: 9pt, fill: rgb("#777"))[12:10 – 12:40]
  #v(4pt)
  #grid(columns: (5.4cm, 1fr), column-gutter: 10pt, align: top,
    image("miniaturas/d24.png", width: 100%),
    [
    #par[Lo mismo se ve midiéndolo de forma continua, sin cortar por la mediana. La correlación entre la distancia que la persona mantuvo en la exploración y la tensión que reportó después es positiva y significativa en el grupo adaptativo,]
    #v(3pt)
    #block(inset: (y: 2pt))[
      #text(size: 9pt, weight: "bold", fill: rgb("#a9741f"))[> clic]
    ]
    #par[y prácticamente nula en el control.]
    #v(3pt)
    #block(inset: (y: 2pt))[
      #text(size: 9pt, weight: "bold", fill: rgb("#a9741f"))[> clic]
    ]
    #par[Que la asociación exista solo cuando el jefe se adapta es la evidencia más directa de este estudio de que el sistema generó una experiencia diferenciada.]
    #v(3pt)
    ],
  )
]
#v(9pt)

#block(breakable: false, width: 100%)[
  #text(size: 11pt, weight: "bold", fill: rgb("#0d2340"))[25. Descartando la habilidad]
  #h(6pt)
  #text(size: 9pt, fill: rgb("#777"))[12:40 – 13:30]
  #v(4pt)
  #grid(columns: (5.4cm, 1fr), column-gutter: 10pt, align: top,
    image("miniaturas/d25.png", width: 100%),
    [
    #par[Acá vuelvo a la explicación alternativa que mencioné hace un momento: los jugadores agresivos y cercanos solían ser también los más experimentados. Si eso fuera cierto, su menor tensión no sería por su estilo(y por el sistema), sino porque simplemente son mejores.]
    #v(3pt)
    #par[Se hicieron tres revisiones. Primero, se midió si distancia y experiencia están relacionadas dentro del grupo adaptativo: la relación resultó débil y no significativa.]
    #v(3pt)
    #block(inset: (y: 2pt))[
      #text(size: 9pt, weight: "bold", fill: rgb("#a9741f"))[> clic]
    ]
    #par[Segundo, se comparó la experiencia promedio de ambos perfiles, y resultó casi idéntica.]
    #v(3pt)
    #block(inset: (y: 2pt))[
      #text(size: 9pt, weight: "bold", fill: rgb("#a9741f"))[> clic]
    ]
    #par[Y tercero, la más importante: se volvió a medir la relación entre distancia y tensión, pero descontando el efecto de la experiencia mediante correlación parcial. Si la tensión se debiera a la habilidad, esa relación debería debilitarse.]
    #v(3pt)
    #block(inset: (y: 2pt))[
      #text(size: 9pt, weight: "bold", fill: rgb("#a9741f"))[> clic]
    ]
    #par[No solo se mantuvo, sino que siguió siendo significativa.]
    #v(3pt)
    ],
  )
]
#v(9pt)

#block(breakable: false, width: 100%)[
  #text(size: 11pt, weight: "bold", fill: rgb("#0d2340"))[26. Lo que los jugadores dijeron]
  #h(6pt)
  #text(size: 9pt, fill: rgb("#777"))[13:30 – 14:50]
  #v(4pt)
  #grid(columns: (5.4cm, 1fr), column-gutter: 10pt, align: top,
    image("miniaturas/d26.png", width: 100%),
    [
    #par[En las preguntas abiertas hay dos resultados y un hallazgo que obliga a leerlos con cuidado.]
    #v(3pt)
    #par[El primero: en el grupo control, once de quince describieron al jefe como predecible; en el adaptativo, solo siete. Va en la dirección esperada.]
    #v(3pt)
    #par[El segundo: diez de quince del grupo adaptativo dijeron percibir que el jefe aprendía, contra siete de quince en el control. La dirección es la correcta, pero no alcanza significancia.]
    #v(3pt)
    #par[Y acá viene el tercero, que es uno de los resultados más interesantes del trabajo: siete personas del grupo de control, que enfrentaron un jefe completamente fijo, también afirmaron percibir aprendizaje, y describieron con detalle cambios que nunca ocurrieron.]
    #v(3pt)
    #par[Como el sistema guarda los pesos reales, se pudo cruzar lo que cada persona reportó contra lo que efectivamente pasó en su partida, y la correspondencia es baja. Probablemente hay un sesgo de expectativa: el estudio trata sobre enemigos adaptativos y mucha gente llegó esperando encontrar uno.]
    #v(3pt)
    #par[Por eso el análisis de este trabajo se apoya principalmente en las métricas objetivas y no en lo que el jugador declara.]
    #v(3pt)
    ],
  )
]
#v(9pt)

#block(breakable: false, width: 100%)[
  #text(size: 11pt, weight: "bold", fill: rgb("#0d2340"))[28. Implicancias de diseño]
  #h(6pt)
  #text(size: 9pt, fill: rgb("#777"))[14:50 – 16:40]
  #v(4pt)
  #grid(columns: (5.4cm, 1fr), column-gutter: 10pt, align: top,
    image("miniaturas/d28.png", width: 100%),
    [
    #block(inset: (left: 6pt), stroke: (left: 2pt + rgb("#cdd3da")))[
      #text(size: 8.5pt, style: "italic", fill: rgb("#555"))[Esta diapositiva es tu aporte más transferible. Habla con soltura, no leas.]
    ]
    #v(3pt)
    #par[Más allá de este jefe en particular, el trabajo deja tres lecciones para quien quiera diseñar sistemas así.]
    #v(3pt)
    #par[La primera es qué conviene cambiar: el comportamiento del enemigo, y no sus números fijos, como el daño o la velocidad. Subir los números el jugador lo siente como que el juego se puso más difícil para todos por igual, no como que el enemigo cambió su forma de jugar.]
    #v(3pt)
    #block(inset: (y: 2pt))[
      #text(size: 9pt, weight: "bold", fill: rgb("#a9741f"))[> clic]
    ]
    #par[La segunda es cómo lograr que se note, si es que el propósito es ese. Por un lado, conviene que la adaptación se traduzca en algo llamativo: el único caso donde alguien identificó correctamente lo que pasó fue cuando el jefe empezó a usar mucho su forma de charco, que es visualmente muy distinta; cuando el cambio era solo que un ataque se repitiera un poco más, nadie lo notó. Y por otro, que cada comportamiento del jugador tenga una respuesta propia y reconocible, en vez de un solo ajuste genérico, porque así es más fácil que la persona relacione lo que hizo con lo que el enemigo hizo después.]
    #v(3pt)
    #block(inset: (y: 2pt))[
      #text(size: 9pt, weight: "bold", fill: rgb("#a9741f"))[> clic]
    ]
    #par[Y la tercera, quizás la más interesante, es cuál puede ser la meta: un sistema así no necesita hacer el juego más difícil en promedio para cumplir su propósito. Puede apuntar a que distintos jugadores sientan un desafío más parejo entre ellos, que es justamente lo que sugiere ese rango intercuartílico más compacto.]
    #v(3pt)
    #block(inset: (y: 2pt))[
      #text(size: 9pt, weight: "bold", fill: rgb("#a9741f"))[> clic]
    ]
    #par[Un matiz importante: el jugador no necesita darse cuenta de la adaptación para que esta funcione. La tensión de los jugadores de rango subió igual, aunque muchos no supieran explicar por qué.]
    #v(3pt)
    #block(inset: (left: 6pt), stroke: (left: 2pt + rgb("#cdd3da")))[
      #text(size: 8.5pt, style: "italic", fill: rgb("#555"))[\#\# CIERRE — 16:40 a 19:20]
    ]
    #v(3pt)
    ],
  )
]
#v(9pt)

#block(breakable: false, width: 100%)[
  #text(size: 11pt, weight: "bold", fill: rgb("#0d2340"))[29. Limitaciones]
  #h(6pt)
  #text(size: 9pt, fill: rgb("#777"))[16:40 – 17:55]
  #v(4pt)
  #grid(columns: (5.4cm, 1fr), column-gutter: 10pt, align: top,
    image("miniaturas/d29.png", width: 100%),
    [
    #block(inset: (left: 6pt), stroke: (left: 2pt + rgb("#cdd3da")))[
      #text(size: 8.5pt, style: "italic", fill: rgb("#555"))[Rápido. No te disculpes, enúncialas con seguridad: reconocerlas te da credibilidad.]
    ]
    #v(3pt)
    #par[Estas conclusiones hay que leerlas con varias limitaciones. La principal es el tamaño de muestra: treinta participantes implica poco poder estadístico, así que los resultados son indicios de una prueba de concepto y no algo generalizable.]
    #v(3pt)
    #block(inset: (y: 2pt))[
      #text(size: 9pt, weight: "bold", fill: rgb("#a9741f"))[> clic]
    ]
    #par[A eso se suma que medir la experiencia previa resultó difícil: el puntaje del cuestionario inicial refleja cuánto ha jugado la persona, pero no su habilidad real, y eso limita los análisis que dependen de la experiencia, como el que mostré hace un rato.]
    #v(3pt)
    #block(inset: (y: 2pt))[
      #text(size: 9pt, weight: "bold", fill: rgb("#a9741f"))[> clic]
    ]
    #par[En la misma línea, y pese a la asignación alternada, el grupo adaptativo quedó levemente más experimentado que el de control.]
    #v(3pt)
    #block(inset: (y: 2pt))[
      #text(size: 9pt, weight: "bold", fill: rgb("#a9741f"))[> clic]
    ]
    #par[Lo que el jugador reporta resultó poco confiable, y el encuadre del estudio probablemente infló la percepción de adaptación.]
    #v(3pt)
    #block(inset: (y: 2pt))[
      #text(size: 9pt, weight: "bold", fill: rgb("#a9741f"))[> clic]
    ]
    #par[El efecto observado, además, corresponde sobre todo a la adaptación previa al combate, ya que el ajuste durante el combate es acotado.]
    #v(3pt)
    #block(inset: (y: 2pt))[
      #text(size: 9pt, weight: "bold", fill: rgb("#a9741f"))[> clic]
    ]
    #par[Y por último, el SUS y el GEQ se aplicaron adaptados, uno cambiando las referencias al sistema por el juego y el otro traducido, así que no son los instrumentos validados en su forma original.]
    #v(3pt)
    ],
  )
]
#v(9pt)

#block(breakable: false, width: 100%)[
  #text(size: 11pt, weight: "bold", fill: rgb("#0d2340"))[30. Conclusiones]
  #h(6pt)
  #text(size: 9pt, fill: rgb("#777"))[17:55 – 18:50]
  #v(4pt)
  #grid(columns: (5.4cm, 1fr), column-gutter: 10pt, align: top,
    image("miniaturas/d30.png", width: 100%),
    [
    #par[Primero, el sistema funciona como se especificó: las reglas predicen exactamente los pesos registrados en las quince sesiones.]
    #v(3pt)
    #block(inset: (y: 2pt))[
      #text(size: 9pt, weight: "bold", fill: rgb("#a9741f"))[> clic]
    ]
    #par[Segundo, comparando los grupos completos las diferencias fueron pequeñas y no significativas. Con una muestra de este tamaño, eso no descarta que exista un efecto real; solo indica que no llegó a hacerse visible.]
    #v(3pt)
    #block(inset: (y: 2pt))[
      #text(size: 9pt, weight: "bold", fill: rgb("#a9741f"))[> clic]
    ]
    #par[Y tercero, al mirar el estilo de juego el efecto sí aparece: los jugadores de perfil a distancia reportaron una tensión notablemente mayor en la versión adaptativa, y esa diferencia no existe en el control.]
    #v(3pt)
    #block(inset: (y: 2pt))[
      #text(size: 9pt, weight: "bold", fill: rgb("#a9741f"))[> clic]
    ]
    #par[La contribución principal, entonces, es un sistema capaz de adaptar el comportamiento del jefe al estilo de cada jugador, que en la práctica funcionó mejor contra quienes se mantienen a distancia que contra quienes pelean cuerpo a cuerpo. Con esto el objetivo general se cumplió.]
    #v(3pt)
    ],
  )
]
#v(9pt)

#block(breakable: false, width: 100%)[
  #text(size: 11pt, weight: "bold", fill: rgb("#0d2340"))[31. Trabajo futuro]
  #h(6pt)
  #text(size: 9pt, fill: rgb("#777"))[18:50 – 19:15]
  #v(4pt)
  #grid(columns: (5.4cm, 1fr), column-gutter: 10pt, align: top,
    image("miniaturas/d31.png", width: 100%),
    [
    #par[Las líneas más directas: repetir la evaluación con más participantes, del orden de cuarenta por condición; reforzar la adaptación contra el perfil cuerpo a cuerpo, que es donde el sistema tuvo menos efecto; extender la adaptación al combate mismo; y complementar lo que el jugador declara con medidas menos dependientes de su opinión.]
    #v(3pt)
    ],
  )
]
#v(9pt)

#block(breakable: false, width: 100%)[
  #text(size: 11pt, weight: "bold", fill: rgb("#0d2340"))[32. Cierre]
  #h(6pt)
  #text(size: 9pt, fill: rgb("#777"))[19:15 – 19:20]
  #v(4pt)
  #grid(columns: (5.4cm, 1fr), column-gutter: 10pt, align: top,
    image("miniaturas/d32.png", width: 100%),
    [
    #par[Eso es todo. Muchas gracias por su atención, y quedo atento a sus preguntas.]
    #v(3pt)
    #block(inset: (left: 6pt), stroke: (left: 2pt + rgb("#cdd3da")))[
      #text(size: 8.5pt, style: "italic", fill: rgb("#555"))[No digas "eso sería" ni "no sé si me expliqué". Cierra firme y calla.]
    ]
    #v(3pt)
    #block(inset: (left: 6pt), stroke: (left: 2pt + rgb("#cdd3da")))[
      #text(size: 8.5pt, style: "italic", fill: rgb("#555"))[\#\# Notas de ensayo]
    ]
    #v(3pt)
    #block(inset: (left: 6pt), stroke: (left: 2pt + rgb("#cdd3da")))[
      #text(size: 8.5pt, style: "italic", fill: rgb("#555"))[- *Cronometra dos pasadas completas antes de la defensa.* Si la primera te da más de 19 minutos, el recorte va en la diapositiva 11 (perfil): describe dos dimensiones en detalle y menciona las otras dos. - *Las tres frases que no pueden faltar*, aunque se te olvide todo lo demás: 1. "La adaptación cambia qué tan seguido elige cada ataque, no cuánto daño hace." 2. "La diferencia entre perfiles aparece solo en el grupo adaptativo." 3. "Siete personas del grupo de control también creyeron ver adaptación." - *Evita decir "no funcionó"* al hablar del resultado global. Di "no alcanzó significancia con esta muestra": es lo correcto estadísticamente y es lo que dice tu escrito. - *Si te trabas*, vuelve a la diapositiva en pantalla y describe lo que se ve. Siempre hay un dato o una figura de donde retomar.]
    ]
    #v(3pt)
    ],
  )
]
#v(9pt)

