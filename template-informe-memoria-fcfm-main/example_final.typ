#import "final.typ": conf, resumen, dedicatoria, agradecimientos, declaracion-ia, start-doc, end-doc, capitulo, apendice
#import "metadata.typ": example-metadata

#show: conf.with(metadata: example-metadata)

// Las tablas llevan el caption arriba (convencion habitual); las figuras/imagenes
// mantienen el caption abajo (comportamiento por defecto de Typst).
#show figure.where(kind: table): set figure.caption(position: top)

#resumen(metadata: example-metadata)[
    En muchos videojuegos, los enemigos de comportamiento fijo se vuelven predecibles una vez
    que el jugador aprende su patrón de ataque, lo que puede hacer que el enfrentamiento pierda
    interés. Este trabajo aborda ese problema mediante un enemigo jefe capaz de adaptar su
    comportamiento de combate al estilo de cada jugador. La adaptación no cambia la fuerza del
    jefe, sino qué tan seguido elige cada uno de sus ataques, a partir de un perfil construido
    con la forma en que la persona jugó antes del enfrentamiento, considerando señales como su
    preferencia por el combate cuerpo a cuerpo o a distancia, su uso de la esquiva y sus hábitos
    de curación.

    El sistema se diseñó e implementó íntegramente con las herramientas nativas de Unreal
    Engine, sobre un juego del género _souls-like_ construido especialmente para este trabajo.
    Para evaluar su efecto se desarrolló también una versión de control, idéntica salvo en que
    los pesos de ataque del jefe permanecen fijos, y se comparó ambas versiones mediante una
    prueba de concepto con 30 participantes, siguiendo un diseño entre sujetos. La experiencia
    de juego se midió con el Game Experience Questionnaire y una escala de usabilidad,
    complementados con preguntas abiertas y con el registro interno del sistema.

    Los resultados muestran, en primer lugar, que el mecanismo de adaptación funciona como se
    especificó: los ajustes de pesos predichos por las reglas coincidieron con los registrados
    en las quince sesiones del grupo adaptativo. Al comparar ambos grupos completos, las
    diferencias observadas en la experiencia reportada fueron pequeñas y no alcanzaron a ser
    significativas; sin embargo, al separar a los participantes según su estilo de juego, los de
    perfil a distancia reportaron una
    tensión notablemente mayor en la versión adaptativa, efecto que no aparece en la versión de
    control. Así, la contribución principal es un sistema capaz de adaptar el comportamiento del
    jefe al estilo de cada jugador, que en la práctica funcionó mejor contra quienes se mantienen
    a distancia que contra quienes pelean cuerpo a cuerpo. Estos hallazgos deben leerse como
    indicios de una prueba de concepto, considerando el tamaño reducido de la muestra y los
    límites de lo que el jugador reporta para evaluar sistemas de este tipo.
]

#dedicatoria[
    Una dedicatoria especial para alguien especial.
]

#agradecimientos[
    #lorem(150)

    #lorem(100)

    #lorem(100)
]

#declaracion-ia[
    En la elaboración de esta memoria se utilizaron herramientas de inteligencia artificial
    generativa. Específicamente, se empleó Claude (Anthropic) como asistente durante el
    proceso de redacción y edición del documento escrito, y también como apoyo en la
    planificación y diseño de aspectos de la implementación en Unreal Engine 5.6.

    En cuanto a la redacción, la herramienta se utilizó para mejorar la claridad y
    coherencia de distintas secciones del texto, reformular párrafos y revisar el estilo.
    Los contenidos técnicos, los argumentos y las decisiones de diseño son de autoría
    propia; el uso de IA se limitó a la edición y refinamiento de la expresión escrita,
    no a la generación de ideas o análisis originales. En relación con el desarrollo,
    la herramienta se consultó para planificar la estructura de ciertos sistemas en
    Unreal Engine, discutir enfoques de implementación y resolver dudas puntuales
    durante el proceso de desarrollo del juego.

    Todo el contenido fue revisado y validado por el autor, quien asume plena
    responsabilidad sobre el trabajo presentado.
]

#show: start-doc

// ==========================================
// CAPÍTULO 1: INTRODUCCIÓN
// ==========================================
#capitulo(title: "Introducción")[

    == Problema abordado

    El diseño de la inteligencia artificial en videojuegos ha avanzado notablemente en
    las últimas décadas, evolucionando desde simples máquinas de estados finitos hacia
    árboles de comportamiento y otros sistemas de navegación más sofisticados
    @IAVideogames. Sin embargo, muchos títulos continúan empleando enemigos con rutinas
    predefinidas y comportamientos relativamente previsibles, como ocurre en juegos como
    _Elden Ring_#footnote[
      Elden Ring es un videojuego de rol de acción en mundo abierto desarrollado por
      FromSoftware y publicado por Bandai Namco.
      #link("https://en.bandainamcoent.eu/elden-ring/elden-ring")[Disponible en sitio web].
    ] o _Hollow Knight_#footnote[
      Hollow Knight es un videojuego de acción y aventuras en 2D desarrollado por Team
      Cherry, ambientado en el reino subterráneo de Hallownest.
      #link("https://www.hollowknight.com/")[Disponible en sitio web].
    ], donde ciertos enemigos y jefes siguen patrones de ataque que los jugadores
    terminan memorizando tras varios intentos. En géneros particularmente exigentes en
    este aspecto, como los _souls-like_#footnote[
      Subgénero inspirado en la serie Dark Souls, caracterizado por un combate
      desafiante, penalizaciones por muerte y patrones de ataque memorizables en los
      jefes.
    ] o los _roguelike_#footnote[
      Género de videojuegos caracterizado por mazmorras generadas aleatoriamente,
      _permadeath_ (muerte permanente del personaje) y elementos de rol.
    ], esta previsibilidad puede limitar la rejugabilidad, haciendo que la dificultad se
    perciba más como un ejercicio de memorización que como un desafío dinámico y en
    constante evolución.

    Aunque existen técnicas para ajustar la dificultad, la mayoría de los acercamientos a
    la dificultad dinámica se limitan a modificar parámetros generales del juego, como la
    vida, el daño o la velocidad de los enemigos, en lugar de su comportamiento @Zohaib18.
    Son pocos
    los títulos que implementan sistemas donde los enemigos se adaptan activamente a las
    acciones específicas del jugador; uno de los ejemplos más citados es
    _Alien: Isolation_#footnote[
      Alien: Isolation es un videojuego de sigilo y supervivencia en primera persona
      desarrollado por Creative Assembly y publicado por SEGA, ambientado en el universo
      de la película Alien.
      #link("https://www.sega.com/es/alien-isolation/alien-isolation")[Disponible en sitio web].
    ], donde el antagonista aprende los patrones de escondite del jugador y ajusta sus
    rutas de patrullaje para mantener la tensión en cada encuentro.

    Este problema general, la falta de enemigos que aprenden del estilo de juego de cada
    jugador en lugar de limitarse a ejecutar rutinas fijas o a escalar parámetros
    numéricos, es el que motiva este trabajo. Cuando un jugador logra memorizar los
    patrones de ataque o movimiento de un enemigo, el enfrentamiento pierde buena parte
    de su tensión y su sorpresa; si, en cambio, el enemigo identificara patrones en las
    acciones del jugador y ajustara su propia estrategia en consecuencia, un mismo
    enemigo podría ofrecer combates distintos según el estilo de juego de cada persona,
    generando experiencias más dinámicas, personalizadas y rejugables.

    Este trabajo aborda dicho problema explorando la construcción de un enemigo final (un
    "jefe") adaptativo en Unreal Engine. Se consideró inicialmente la alternativa de Godot
    Engine, pero se optó por Unreal Engine por tres razones principales. Primero, Unreal
    Engine cuenta con un sistema nativo y maduro de inteligencia artificial para
    videojuegos (Behaviour Trees y Blackboard), a diferencia de Godot, que no incorpora una
    solución equivalente en su núcleo, dependiendo en cambio de complementos de la
    comunidad (como LimboAI o Beehave) para lograr algo similar. Segundo, Unreal Engine
    ofrece mejor soporte y documentación para
    tecnologías de inteligencia artificial generativa orientadas a videojuegos, como NVIDIA
    ACE, que se consideraron durante la exploración inicial del trabajo. Tercero, la
    experiencia previa del autor con
    Unreal Engine permitió reducir la curva de aprendizaje asociada a las herramientas del
    motor, dedicando más tiempo al diseño e implementación del sistema de adaptación
    propiamente tal. En conjunto, estas razones convierten a Unreal Engine en una
    plataforma adecuada para experimentar con este tipo de sistemas.

    == Solución propuesta

    La solución desarrollada consiste en un sistema de inteligencia artificial adaptativa
    que permite a un enemigo jefe ajustar su comportamiento de combate en función de cómo
    juega cada jugador, implementado íntegramente con las herramientas nativas de Unreal
    Engine (Behaviour Trees, Blackboard y Blueprints, junto con algunos nodos
    personalizados en C++), sobre un juego del género _souls-like_ construido
    especialmente para este trabajo.

    A diferencia de otros enfoques de dificultad dinámica, que ajustan parámetros
    generales del juego (vida, daño, velocidad), la adaptación aquí propuesta opera sobre
    las probabilidades de selección de los distintos ataques del jefe: el repertorio de
    ataques se mantiene fijo, pero la frecuencia con que cada uno se elige se ajusta según
    un perfil de juego construido a partir del comportamiento del jugador frente a un
    conjunto de enemigos regulares previos al combate (capítulo 3), considerando señales
    como su preferencia por el combate cuerpo a cuerpo o a distancia, su uso de la esquiva
    y sus hábitos de curación.

    Para poder evaluar el efecto de esta adaptación, se construyó también una versión de
    control del juego, idéntica a la versión adaptativa salvo en que los pesos de ataque
    del jefe permanecen fijos en sus valores base, sin incorporar el perfil de juego
    recolectado. La comparación entre ambas versiones (capítulo 6) permite aislar el
    efecto de la adaptación de otros factores del diseño del juego.

    Cabe precisar que, durante la etapa de propuesta, se consideró además la posibilidad
    de extender esta adaptación al combate mismo, ajustando el comportamiento del jefe en
    tiempo real según las acciones del jugador durante el enfrentamiento. Esta línea quedó
    fuera del alcance final de este trabajo, que se concentra en la adaptación previa al
    combate mediante las herramientas nativas del motor; se retoma como trabajo futuro en el
    capítulo 7.

    == Objetivos

    === Objetivo general

    Diseñar e implementar un sistema de adaptación para un enemigo jefe en Unreal Engine,
    capaz de ajustar su comportamiento de combate a partir de un perfil construido sobre
    las acciones previas del jugador, con el fin de reducir la previsibilidad del
    enfrentamiento y evaluar su efecto sobre la experiencia de juego.

    === Objetivos específicos

    + Investigar y analizar enfoques existentes para el diseño de inteligencia artificial
      adaptativa en videojuegos.
    + Construir una versión base del juego con un jefe de comportamiento fijo, sin
      mecanismos adaptativos, que sirva como caso de control en las pruebas.
    + Diseñar e implementar un conjunto de enemigos regulares cuyo comportamiento frente
      al jugador permita construir un perfil de su estilo de juego.
    + Implementar, sobre la base anterior, un mecanismo que ajuste los pesos de selección
      de ataques del jefe a partir de dicho perfil antes del inicio del combate.
    + Validar el sistema mediante pruebas de jugabilidad, midiendo la capacidad de
      adaptación del jefe y la percepción de desafío por parte de los jugadores.
    + Comparar los resultados obtenidos entre la versión adaptativa y la versión de
      control, identificando ventajas, limitaciones y posibles mejoras.

    == Metodología

    El desarrollo del trabajo siguió una metodología experimental de tipo
    control-tratamiento, comúnmente conocida como prueba A/B (_A/B test_) @KohaviTangXie20.
    En este tipo de metodología se comparan dos versiones de un mismo producto o sistema,
    la versión de control (sin la modificación que se quiere evaluar) y la versión de
    tratamiento (con dicha modificación), para determinar si la diferencia entre ambas
    produce un efecto medible. En este trabajo, la versión de control corresponde a un jefe
    de comportamiento fijo y sin mecanismos de adaptación, mientras que la versión de
    tratamiento corresponde a una segunda versión, idéntica en el resto de sus sistemas, en
    la que el jefe ajusta los pesos de selección de sus ataques a partir de un perfil
    construido sobre el comportamiento del jugador frente a los enemigos regulares previos
    al combate (capítulos 3 y 4).

    La evaluación del sistema contempla dos dimensiones. Desde una perspectiva técnica, se
    verifica la corrección del propio mecanismo de adaptación: a partir de los pesos de
    ataque volcados a archivo al iniciar cada combate (capítulo 5), se revisa que el
    perfil construido sobre el comportamiento del jugador se traduzca efectivamente en los
    ajustes esperados sobre dichos pesos. Desde la perspectiva de experiencia de usuario, se
    diseñaron pruebas de jugabilidad mediante un experimento controlado con un diseño
    entre sujetos (_between-subjects_): cada participante juega una sola de las dos
    versiones, nunca ambas. Se optó por este diseño, en lugar de uno intrasujeto en que la
    misma persona jugara ambas versiones, para evitar que el aprendizaje acumulado durante
    una condición contaminara la percepción de la otra. La experiencia de juego se mide
    utilizando el Game Experience Questionnaire @GEQuestionare para las dimensiones de
    desafío, tensión, inmersión y afecto (positivo y negativo), complementado con
    retroalimentación cualitativa sobre la percepción de predictibilidad de cada versión.
    El detalle de esta evaluación y sus resultados se presenta en el capítulo 6.

    En términos generales, los resultados muestran que el sistema de adaptación funciona
    según lo especificado: al comparar las reglas de ajuste con los pesos de ataque
    realmente registrados en cada sesión, se confirma que el jefe sí ajustó su
    comportamiento al perfil de cada jugador. Al comparar la versión de control con la
    adaptativa mirando todo el grupo junto, no aparecen diferencias significativas en la experiencia
    de juego reportada. El hallazgo más importante surge al mirar el estilo de juego de
    cada persona: el sistema logra su efecto con éxito en los jugadores de perfil a
    distancia, quienes reportan una tensión notablemente mayor en la versión adaptativa,
    aunque ese mismo efecto casi no se nota en los jugadores de perfil cuerpo a cuerpo, y
    esta diferencia no aparece en la versión de control. Así, la contribución principal de
    este trabajo es un sistema capaz de adaptar el comportamiento del jefe al estilo de
    cada jugador, que en la práctica funcionó mejor contra quienes se mantienen a distancia
    que contra quienes pelean cuerpo a cuerpo.
    Esta diferencia, eso sí, no se puede atribuir por completo al estilo de juego, ya que
    también podría influir la experiencia previa de cada perfil de jugador. Sumado a esto,
    los resultados muestran que confiar solo en lo que el jugador reporta tiene límites
    para evaluar sistemas de este tipo.

    Estos resultados dejan algunas implicancias para quienes diseñen sistemas similares.
    Por un lado, sugieren que una adaptación se percibe mejor cuando se traduce en
    comportamientos reconocibles y en respuestas específicas a cada tipo de acción del
    jugador, y no en ajustes numéricos genéricos como subir el daño o la velocidad de los
    ataques. Por otro, plantean que un sistema de este tipo no necesita hacer el juego más
    difícil en promedio para cumplir su propósito, sino que puede apuntar a que distintos
    jugadores experimenten un nivel de desafío más parejo entre ellos. Estos resultados y
    sus implicancias se detallan y discuten en profundidad en el capítulo 6.

    El resto de este documento se organiza de la siguiente manera. El capítulo 2 revisa el
    trabajo relacionado, incluyendo enfoques existentes de dificultad dinámica e
    inteligencia artificial adaptativa en videojuegos. El capítulo 3 describe el diseño
    conceptual del videojuego desarrollado, incluyendo su narrativa, mecánicas y enemigos.
    El capítulo 4 detalla el diseño del sistema de adaptación basado en el comportamiento
    del jugador, junto con las reglas que traducen dicho comportamiento en ajustes sobre el
    jefe. El capítulo 5 describe la implementación técnica del videojuego en Unreal Engine.
    El capítulo 6 presenta la prueba de concepto realizada, junto con los resultados
    obtenidos, su discusión y las limitaciones del estudio. Finalmente, el capítulo 7
    concluye el trabajo y propone líneas de trabajo futuro.
]

// ==========================================
// CAPÍTULO 2: TRABAJO RELACIONADO
// ==========================================
#capitulo(title: "Trabajo relacionado")[

    == Técnicas tradicionales de IA en videojuegos

    Actualmente, la mayoría de los videojuegos implementan la inteligencia de los
    enemigos mediante técnicas como los Behaviour Trees o las máquinas de estados finitos
    (FSM) @IOVINO2022104096. Un Behaviour Tree es una estructura jerárquica que organiza
    decisiones y acciones mediante nodos que retornan éxito, fallo o ejecución en curso,
    lo que permite definir comportamientos de forma modular. Una FSM, por su parte, es un
    modelo compuesto por un conjunto de estados discretos (por ejemplo, patrullar,
    perseguir o atacar) y transiciones entre ellos, activadas por condiciones o eventos
    específicos; en cada instante el agente se encuentra en un único estado, el cual
    determina su comportamiento actual.

    Estas metodologías permiten establecer patrones y reglas claras de reacción,
    ofreciendo control sobre el comportamiento de los enemigos. Sin embargo, carecen de
    capacidad de adaptación real: los enemigos suelen repetir las mismas rutinas y no
    aprenden de las acciones del jugador, lo que los hace predecibles tras algunos
    intentos y reduce tanto la rejugabilidad como el desafío.

    == Enfoques de ajuste dinámico de dificultad

    En el ámbito de la investigación se han desarrollado diversos enfoques para el ajuste
    dinámico de dificultad @Zohaib18, incluyendo métodos probabilísticos que optimizan el
    _engagement_ del jugador mediante funciones matemáticas, sistemas basados en redes
    neuronales capaces de predecir estados emocionales del jugador con buena precisión, y
    técnicas de aprendizaje por refuerzo donde controladores adaptativos ajustan el
    comportamiento de los enemigos según el rendimiento del jugador, manteniendo
    experiencias equilibradas sin volverse predecibles. Aun así, estos casos siguen siendo
    excepcionales debido a diversos desafíos técnicos y de recursos, además de la limitada
    adopción por parte de la industria, y no representan una metodología estandarizada
    para lograr adaptación en tiempo real en los videojuegos modernos.

    En esa misma línea, Zohaib @Zohaib18 describe otros enfoques complementarios, como
    sistemas donde grupos de personajes no jugables forman comportamientos adaptativos de
    manera descentralizada, ajustando sus parámetros según la retroalimentación del
    jugador, por ejemplo a partir de sus patrones de movimiento e interacciones, así
    como técnicas de
    _scripting_ dinámico que modifican reglas de comportamiento en tiempo real con base en
    tasas de éxito y fracaso, permitiendo que los enemigos evolucionen sus tácticas durante
    el juego. Investigaciones más recientes, también recopiladas por Zohaib @Zohaib18, han
    combinado algoritmos de búsqueda en árboles con redes neuronales para crear oponentes
    que adaptan su nivel de desafío según los recursos computacionales disponibles,
    demostrando que es posible correlacionar directamente la dificultad percibida con el
    tiempo de procesamiento asignado.

    == Tecnologías emergentes y aplicaciones recientes

    En paralelo, tecnologías emergentes como NVIDIA ACE (_Avatar Cloud Engine_) han
    mostrado posibilidades interesantes de aprendizaje dinámico. Por ejemplo, en el juego
    MIR5#footnote[
      MIR5 es un MMORPG desarrollado por Wemade Next.
      #link("https://www.invenglobal.com/articles/19158/wemade-next-to-develop-an-ai-boss-in-mir5-in-collaboration-with-nvidia")[Disponible en sitio web].
    ], un jefe conocido como _Asterion_ utiliza esta tecnología para evaluar tácticas,
    habilidades y equipo del jugador en tiempo real, adaptando sus estrategias para
    mantener un desafío personalizado y constante. Aunque el enfoque principal de NVIDIA
    ACE ha sido mejorar la interacción con personajes no jugables mediante conversaciones
    naturales, su aplicación en MIR5 evidencia que es posible diseñar enemigos que
    aprenden y modifican su comportamiento según el jugador.

    A pesar de estos avances, no existe una metodología ampliamente adoptada que permita
    implementar enemigos adaptativos de manera general en motores de juego comunes como
    Unreal Engine. La mayoría de las soluciones actuales dependen de tecnologías externas
    o están restringidas a casos específicos, y las técnicas más sofisticadas permanecen
    principalmente en el ámbito de la investigación, sin traducirse en herramientas
    accesibles para desarrolladores. Esto abre un espacio de investigación y desarrollo
    para crear sistemas de inteligencia artificial que no solo reaccionen, sino que
    aprendan y se ajusten al estilo de juego del usuario.

    == Casos destacados de adaptación en la industria

    Más allá de Alien: Isolation y MIR5, existen otros casos notables en la industria que
    han explorado distintas formas de adaptación y personalización de la experiencia de
    juego.

    === Left 4 Dead y el AI Director

    _Left 4 Dead_#footnote[
      Left 4 Dead es un videojuego cooperativo de supervivencia y terror desarrollado por
      Valve Corporation y publicado en 2008. El juego se centra en cuatro supervivientes
      que deben atravesar escenarios infestados de zombis, enfrentándose a hordas
      dinámicas controladas por el sistema AI Director.
      #link("https://www.l4d.com/")[Disponible en sitio web].
    ] introdujo un sistema conocido como "AI Director", diseñado para crear experiencias
    dinámicas de terror y supervivencia cooperativa. A diferencia de los sistemas
    tradicionales, donde los enemigos aparecen en ubicaciones predefinidas, el AI Director
    analiza constantemente el estado del equipo de jugadores, incluyendo salud, munición,
    posición y nivel de estrés, para ajustar la intensidad del juego en tiempo real
    @Booth09.

    El sistema funciona manipulando varios parámetros: la frecuencia y tamaño de las
    hordas de zombis, la aparición de "infectados especiales" (enemigos con habilidades
    únicas), la colocación de recursos como botiquines y munición, e incluso elementos
    ambientales como música y efectos de sonido. Cuando el equipo está funcionando bien,
    el Director incrementa la presión mediante encuentros más desafiantes; cuando los
    jugadores están al borde del colapso, reduce temporalmente la intensidad para permitir
    momentos de respiro y recuperación. Esta aproximación se basa en la teoría del "flow"
    de Csikszentmihalyi @Csikszentmihalyi90, que busca mantener a los jugadores en un estado óptimo entre el
    aburrimiento y la frustración.

    Sin embargo, el AI Director presenta limitaciones importantes para el contexto de un
    combate contra un jefe individual: opera principalmente a nivel macro, ajustando
    parámetros globales del encuentro en lugar de modificar tácticas específicas de
    enemigos individuales. No aprende de las estrategias particulares de cada jugador, por
    ejemplo si prefiere el combate a distancia o cuerpo a cuerpo, ni adapta patrones de
    ataque específicos; su enfoque se centra en el ritmo y la intensidad general de la
    experiencia, no en la creación de adversarios que evolucionen tácticamente según el
    estilo de juego individual.

    === Middle-earth: Shadow of Mordor y el Sistema Nemesis

    El Sistema Nemesis, introducido en _Middle-earth: Shadow of Mordor_#footnote[
      Middle-earth: Shadow of Mordor es un videojuego de acción y aventuras en mundo
      abierto desarrollado por Monolith Productions y publicado por Warner Bros.
      Interactive Entertainment en 2014, ambientado en el universo de El Señor de los
      Anillos. El juego presenta el Sistema Nemesis, que genera enemigos dinámicos con
      memoria persistente de sus encuentros con el jugador.
      #link("https://www.shadowofmordor.com/")[Disponible en sitio web].
    ] (2014) y expandido en su secuela Shadow of War (2017), representa un enfoque
    distinto hacia la personalización de enemigos. El sistema genera una jerarquía
    dinámica de capitanes orcos, cada uno con personalidad, fortalezas, debilidades y
    apariencia generadas proceduralmente.

    Su característica más distintiva es la memoria persistente: cuando el jugador se
    enfrenta a un capitán, el resultado del encuentro tiene consecuencias permanentes. Si
    el jugador es derrotado, el capitán que lo mató asciende en rango, gana confianza y
    puede desarrollar nuevas habilidades o inmunidades; en encuentros posteriores, ese
    mismo capitán recordará la victoria anterior mediante diálogos contextuales y mostrará
    cicatrices o modificaciones físicas resultado del combate previo. Si el jugador logra
    herir pero no matar a un capitán que luego escapa, este puede regresar más tarde con
    vendajes, quemaduras o prótesis mecánicas que reflejan cómo fue herido, y
    potencialmente habiendo desarrollado resistencia a las tácticas que el jugador empleó.

    No obstante, desde la perspectiva de adaptación táctica en combate, el Sistema Nemesis
    opera principalmente en la dimensión narrativa y estratégica más que en la táctica
    inmediata. Las adaptaciones de los capitanes son cambios de configuración entre
    encuentros, como nuevas inmunidades, armas o habilidades, en lugar de ajustes
    dinámicos durante el combate mismo: un capitán no modifica sus patrones de ataque a
    mitad de pelea según observe que el jugador esquiva siempre hacia un mismo lado o
    abusa de cierta habilidad. Son evoluciones preprogramadas que se activan por
    condiciones específicas, en lugar de aprendizaje genuino de patrones de comportamiento
    del jugador.

    === Limitaciones comunes y espacio de oportunidad

    Ambos sistemas, aunque innovadores en sus respectivos dominios, comparten una
    limitación de fondo: ninguno implementa adaptación táctica en tiempo real basada en el
    análisis de patrones específicos del estilo de combate del jugador. Left 4 Dead ajusta
    la experiencia global, pero no personaliza el comportamiento de enemigos individuales;
    Shadow of Mordor genera evolución narrativa y estratégica entre encuentros, pero no
    adaptación táctica durante los combates mismos.

    Esto evidencia un espacio de oportunidad: enemigos, en particular jefes, capaces de
    identificar y responder a las preferencias tácticas del jugador (patrones de ataque,
    _timing_ de esquivas, uso de habilidades específicas, posicionamiento), ajustando su
    comportamiento de forma dinámica antes o durante el combate. Una aproximación así
    complementaría los enfoques existentes al enfocarse en la adaptación a nivel
    micro-táctico, donde cada encuentro individual se vuelve un desafío personalizado
    según las decisiones momento a momento del jugador.

    == Consideraciones de experiencia de usuario

    Más allá de la implementación técnica de los sistemas adaptativos, es necesario
    considerar cómo estos impactan la experiencia del usuario. Pinelle et al. @Pinelle08
    desarrollaron un conjunto de heurísticas para evaluar la usabilidad en videojuegos,
    derivadas del análisis de 108 reseñas profesionales que cubrieron seis géneros
    principales. Su trabajo identificó doce categorías de problemas de usabilidad
    comunes, entre las cuales destacan: respuestas impredecibles a las acciones del
    usuario, falta de información sobre el estado del juego, controles difíciles de
    manejar y representaciones visuales difíciles de interpretar.

    Estas heurísticas son particularmente relevantes para el desarrollo de enemigos
    adaptativos, ya que varias se relacionan directamente con cómo el jugador percibe y
    entiende el comportamiento de la IA. Por ejemplo, la heurística de proporcionar
    respuestas consistentes a las acciones del usuario establece que los enemigos deben
    comportarse de manera predecible y apropiada para la situación, lo que plantea una
    tensión de fondo para este trabajo: ¿cómo lograr que un enemigo sea adaptativo sin
    volverse impredecible o frustrante? Un sistema de este tipo debe equilibrar la
    adaptación dinámica con la consistencia percibida, de manera que el jugador pueda
    entender las "reglas" del comportamiento del enemigo incluso cuando este evolucione.

    Más allá de estas heurísticas generales, existen instrumentos específicos para medir
    la experiencia de juego mediante cuestionarios estandarizados. El Game Experience
    Questionnaire (GEQ) @GEQuestionare organiza la experiencia en dimensiones como afecto
    positivo, afecto negativo, desafío, tensión, inmersión y competencia, cada una medida
    a partir de un conjunto de ítems que el jugador responde según su nivel de acuerdo.
    Otro instrumento relevante es el GAMEFULQUEST @GamefulQuest19, que mide la
    "gamefulness" percibida por el usuario, es decir, cuánto se asemeja una experiencia de
    uso a la de un juego, a través de dimensiones como inmersión, logro, competencia
    social e influencia sobre el sistema. Mientras el GAMEFULQUEST está orientado
    principalmente a evaluar la incorporación de elementos de juego en sistemas que no son
    videojuegos (gamificación), el GEQ está diseñado específicamente para videojuegos y
    cubre dimensiones más directamente relacionadas con el desafío, la tensión y la
    inmersión que interesan evaluar en este trabajo, razón por la cual se adopta como
    instrumento principal en la evaluación descrita en el capítulo 6.

    == Síntesis y brecha identificada

    La revisión de la literatura muestra que, aunque existen enfoques tradicionales y
    avances recientes en IA de videojuegos, ninguno ofrece una solución general ni
    fácilmente integrable para lograr adaptación táctica en tiempo real en enemigos
    individuales dentro de motores como Unreal Engine. Las técnicas clásicas no aprenden
    del jugador, los métodos de investigación suelen requerir recursos elevados o no están
    pensados para su aplicación práctica en juegos comerciales, y los casos industriales
    corresponden a soluciones específicas, difíciles de replicar.

    Esta situación evidencia una brecha concreta: la falta de un mecanismo que permita que
    un enemigo, en particular un jefe, registre el comportamiento del jugador y ajuste sus
    patrones de combate de manera dinámica, implementado con las herramientas nativas de
    un motor de uso común. Sobre esa brecha se construye el sistema descrito en los
    capítulos siguientes.
]

// ==========================================
// CAPÍTULO 3: DISEÑO DEL VIDEOJUEGO
// ==========================================
#capitulo(title: "Diseño del videojuego")[
    Este capítulo describe las decisiones de diseño detrás del videojuego construido para
    este trabajo, dejando los detalles técnicos de su implementación para el capítulo 5.
    Primero se explica el género elegido y las mecánicas principales que sostienen el
    combate; luego, los arquetipos de enemigos diseñados a partir de esas mecánicas; y
    finalmente, los niveles que organizan en qué orden el jugador se enfrenta a cada uno.
    Estas decisiones, tomadas en conjunto, son las que el capítulo 4 retoma para explicar
    cómo se adapta el comportamiento del jefe al estilo de juego de quien lo enfrenta.

    == Marco de diseño

    Las decisiones descritas en este capítulo se organizan siguiendo el modelo MDA
    (_Mechanics, Dynamics, Aesthetics_) @HunickeMDA04, un marco conceptual ampliamente
    utilizado en el diseño de videojuegos que distingue tres niveles de análisis. Las
    mecánicas corresponden a los componentes y reglas básicas del juego: las acciones
    concretas que el jugador puede ejecutar y los recursos que las limitan. Las dinámicas
    corresponden al comportamiento que emerge en tiempo real cuando esas mecánicas
    interactúan entre sí y con las decisiones del jugador durante una partida. Finalmente,
    las estéticas corresponden a las respuestas emocionales que se busca generar en quien
    juega, como el desafío, la tensión o la sensación de dominio progresivo sobre un
    enemigo.

    En este trabajo, las mecánicas corresponden al conjunto de acciones y recursos
    descritos en la siguiente sección (desplazamiento, combate cuerpo a cuerpo, esquiva,
    fijado de objetivo, equipamiento alternable y carrera, junto con los recursos de vida,
    stamina, maná y pociones). Las dinámicas emergen de la interacción entre estas
    mecánicas y el comportamiento del jefe, en particular de su capacidad de ajustar sus
    propios patrones de ataque según el perfil de juego observado, lo que se detalla en el
    capítulo 4. La estética buscada es la propia del género _souls-like_: un desafío que
    recompensa la lectura atenta del enemigo y la adaptación del propio estilo de juego,
    evitando que el combate se reduzca a la memorización de un patrón fijo. El diseño
    conceptual descrito en este capítulo, incluyendo sus mecánicas, arquetipos de enemigos
    y estructura de niveles, fue además revisado y validado por un panel de expertos en
    diseño de videojuegos, compuesto por el profesor guía y el profesor co-guía de este
    trabajo.

    == Género y mecánicas principales

    El juego corresponde a un _action-RPG_ en tercera persona del género _souls-like_,
    mencionado ya en el capítulo 1: se compone de un combate en tiempo real sostenido por
    estadísticas de vida, stamina y maná, y de una dificultad pensada para premiar la
    lectura atenta de cada enemigo por sobre la repetición de un mismo botón. Esta
    elección de género combina un gusto personal con una razón de fondo que sí es
    relevante para este trabajo: es precisamente en este tipo de juegos donde la
    previsibilidad de los enemigos se vuelve más notoria, ya que el jugador aprende a
    memorizar patrones de ataque tras unos pocos intentos, por lo que resulta el escenario
    más
    exigente para poner a prueba un enemigo que efectivamente se adapte a quien lo
    enfrenta.

    Sobre esa base, el juego se construyó alrededor de un pequeño conjunto de mecánicas
    que definen lo que el jugador puede hacer en cada encuentro:

    - *Desplazamiento*: el jugador se mueve libremente en cualquier dirección en tercera
      persona.
    - *Combate cuerpo a cuerpo*: el jugador ataca con una secuencia de golpes
      consecutivos, pudiendo encadenarlos en un combo si continúa atacando a tiempo.
    - *Esquiva*: el jugador puede rodar para evadir un ataque, quedando invulnerable
      durante toda la duración del movimiento; es la principal herramienta defensiva del
      juego.
    - *Fijado de objetivo*: el jugador puede fijar la cámara sobre un enemigo específico,
      orientándose automáticamente hacia él durante el combate, lo que le permite
      desplazarse lateralmente a su alrededor sin perderlo de vista.
    - *Equipamiento alternable*: mediante una misma acción, el jugador puede alternar
      entre un hechizo de proyectil de fuego, ofensivo, a distancia y con costo de maná, y
      una poción de vida, defensiva y de uso limitado, ofreciendo una vía alternativa al
      combate cuerpo a cuerpo puro.
    - *Carrera*: el jugador puede desplazarse más rápido de lo normal, útil para ganar o
      mantener distancia frente a un enemigo.

    Estas acciones se sostienen sobre los recursos que limitan su uso: la vida, que
    termina el encuentro si llega a cero; la stamina, que se consume al esquivar o correr;
    el maná, que se consume al lanzar el hechizo de fuego; y una cantidad limitada de
    pociones de vida, que es lo que efectivamente acota cuándo el jugador puede curarse.
    Esta limitación de recursos obliga al jugador a tomar decisiones constantes: cuándo
    esquivar en lugar de atacar, cuándo curarse en lugar de seguir presionando, cuándo
    alejarse en lugar de arriesgar un golpe, en lugar de simplemente repetir una única
    acción óptima.

    Esta variedad de decisiones es, además, lo que hace posible el resto del diseño
    descrito en este capítulo: si el juego solo permitiera atacar y nada más, todos los
    jugadores jugarían igual y no habría comportamiento que perfilar. No todas las
    mecánicas cumplen ese rol por igual: el fijado de objetivo y la carrera responden más
    bien a la convención del género, ya que se esperan en un juego de este tipo y facilitan
    el manejo de la cámara y el posicionamiento, sin que el sistema observe especialmente
    cómo se usan. Son, en cambio, la preferencia por el cuerpo a cuerpo o el hechizo a
    distancia, el uso más o menos frecuente de la esquiva, y el momento en que se decide
    curar, las mecánicas que los arquetipos de enemigos descritos a continuación están
    pensados para poner a prueba.

    == Diseño y arquetipos de enemigos

    El diseño de los enemigos no buscó únicamente escalar la dificultad de forma
    progresiva, sino representar distintos arquetipos de combate, cada uno pensado para
    poner a prueba una forma distinta de jugar. En lugar de variar solo la vida o el daño
    de un mismo tipo de enemigo, se optó por diferenciar a cada uno por su patrón de
    comportamiento, de manera que el jugador deba ajustar su forma de jugar, y no solo su
    nivel de atención, al enfrentar a cada arquetipo.

    Esta decisión responde a dos objetivos que se buscó conciliar. El primero es
    puramente de diseño de juego: un elenco pequeño de enemigos claramente diferenciados
    resulta más legible para el jugador que uno numeroso pero homogéneo, ya que cada
    encuentro comunica de inmediato qué tipo de respuesta espera de quien lo enfrenta. El
    segundo objetivo, propio de este proyecto, es que esa misma diferenciación permite que
    el comportamiento del jugador frente a cada arquetipo sea informativo: si los enemigos
    fuesen variaciones menores entre sí, la forma en que el jugador los enfrenta no
    distinguiría con claridad un estilo de juego de otro. Por ello, los tres enemigos
    "regulares" del juego se diseñaron para ser, en la práctica, situaciones de prueba
    distintas entre sí, mientras que el jefe se diseñó como un antagonista capaz de
    responder a los resultados de esas pruebas. El detalle de cómo se llega a esa
    progresión a lo largo de los niveles del juego se aborda en la siguiente sección.

    El primer arquetipo, el esqueleto normal#footnote[
      Modelo 3D "Skeleton Character PSX" por vinrax, licenciado bajo
      #link("https://creativecommons.org/licenses/by/4.0/")[CC BY 4.0]. Se modificó el
      modelo original agregando rig y animaciones mediante Mixamo. Este mismo modelo se
      utilizó también para el esqueleto mago, diferenciándose únicamente en el arma
      equipada: la espada proviene del pack "Dungeon Environment / 135+ Assets" de
      PackDev citado en la sección @sec:diseno-niveles, mientras que el báculo del mago
      corresponde al modelo 3D "Khajiiti Moon Staff" por Shriker1, licenciado bajo
      #link("https://creativecommons.org/licenses/by/4.0/")[CC BY 4.0]
      (#link("https://sketchfab.com/3d-models/khajiiti-moon-staff-87cca6fa0b94448b97a3b354843393e1")[disponible en sitio web]).
      #link("https://sketchfab.com/3d-models/skeleton-character-psx-ece576bbed4b4364911c7596d828a558")[Disponible en sitio web].
    ], corresponde al enemigo más básico del
    juego: un enemigo cuerpo a cuerpo que persigue al jugador y cuyo único ataque es un
    golpe directo de espada, sin variaciones ni segundas intenciones. Su rol es introducir
    el ciclo de combate fundamental: acercarse, esquivar y golpear, sin agregar elementos
    adicionales que
    puedan confundir al jugador mientras aún está aprendiendo los controles. Por este
    motivo es el único enemigo presente durante el tutorial. Sus apariciones siguientes,
    ya en el nivel previo al combate y junto a los demás arquetipos, no buscan representar
    un desafío en sí mismas, sino servir de punto de comparación: al ser un enemigo
    "neutro", la forma en
    que el jugador lo enfrenta funciona como una referencia base respecto a la cual
    contrastar su comportamiento frente a los dos arquetipos siguientes, ambos más
    especializados.

    El segundo arquetipo, el esqueleto mago, se diseñó como contraparte directa del
    anterior: en lugar de perseguir al jugador, permanece en su posición y ataca a
    distancia una vez lo detecta, recurriendo al cuerpo a cuerpo con su báculo únicamente
    cuando es el propio jugador quien decide acortar el espacio entre ambos. Su
    propósito es introducir una decisión táctica explícita que el esqueleto normal no
    plantea: acercarse para forzar el combate cuerpo a cuerpo contra un enemigo que de otro
    modo se mantiene a distancia, o permanecer lejos y lidiar con sus ataques a rango. Esto
    expone una primera diferencia de fondo entre estilos de juego: quienes
    prefieren resolver los encuentros de forma agresiva y cercana, frente a quienes
    prefieren un acercamiento más cauteloso y a distancia. Esta es, de los tres arquetipos
    regulares, la diferencia de comportamiento más directa de observar. Concretamente, el
    mago alterna entre dos ataques:

    - *Ataque a distancia*: lanza un proyectil hacia el jugador desde lejos, sin
      necesidad de acercarse.
    - *Ataque cuerpo a cuerpo*: golpea con su báculo cuando el jugador se encuentra a
      corta distancia, recurriendo a él solo en ese caso.

    El tercer arquetipo, el esqueleto caballero#footnote[
      Modelo 3D "Skeleton Lord" por DJMaesen (bumstrum), licenciado bajo
      #link("https://creativecommons.org/licenses/by/4.0/")[CC BY 4.0]. Se modificó el
      modelo original agregando rig y animaciones mediante Mixamo. El arma equipada
      proviene del pack "Dungeon Environment / 135+ Assets" de PackDev citado en la
      sección @sec:diseno-niveles.
      #link("https://sketchfab.com/3d-models/skeleton-lord-a3f7b44275cf4c489ad62c535268ac16")[Disponible en sitio web].
    ], se diseñó con un propósito distinto a los
    dos anteriores: a diferencia del esqueleto normal y del mago, cuyos ataques se
    resuelven con relativamente poca preparación visible, los dos ataques del caballero
    están marcadamente telegrafiados, es decir, tienen una preparación larga y claramente
    reconocible antes de conectar:

    - *Avance (dash)*: el caballero cubre distancia rápidamente para golpear, obligando al
      jugador a decidir hacia qué lado o dirección esquivar.
    - *Golpe de área*: de preparación aún más larga que el avance, castiga con especial
      fuerza a quien no logra esquivarlo a tiempo.

    Su rol no es presionar al jugador con
    velocidad o
    cantidad de golpes, sino enseñarle a identificar una señal de ataque evidente y a
    esquivarla con el timing correcto, en lugar de reaccionar de forma genérica ante
    cualquier ataque. Pero ese rol no es solo pedagógico: junto con enseñarle al jugador a
    leer este tipo de señales, el caballero es también el arquetipo a través del cual el
    juego observa cómo responde efectivamente el jugador frente a ellas: si esquiva el
    dash hacia un lado o hacia atrás, y si logra o no esquivar el ataque telegrafiado a
    tiempo. Ese comportamiento pasa a formar parte del
    perfil de juego utilizado más adelante para adaptar al jefe (capítulo 4). Al ser el
    primer enemigo del juego que exige este tipo de lectura, su rol dentro de la
    progresión es cerrar la preparación del jugador justo antes del enfrentamiento contra
    el jefe, cuyos ataques son considerablemente más numerosos y
    variados.

    #figure(
      image("imagenes/cap3/enemies_comparative.png", width: 80%),
      caption: [Los arquetipos de enemigo regulares del juego.],
    ) <fig:arquetipos-regulares>

    Tomados en conjunto (@fig:arquetipos-regulares), estos tres arquetipos no se diseñaron
    para ser superados de forma aislada, sino como un pequeño catálogo de situaciones de
    combate: ritmo básico, gestión
    de distancia y lectura de ataques telegrafiados, que sumadas dan una imagen
    razonablemente completa de cómo juega quien los enfrenta. Por eso, antes que pensarlos
    como tres enemigos sueltos, conviene entenderlos como las tres "preguntas" que el juego
    le hace al jugador antes de llegar al jefe.

    El jefe, en cambio, no es una prueba más que se suma a las tres anteriores: es el
    primer enemigo que responde a las respuestas que el jugador ya dio sobre ritmo,
    distancia y lectura de ataques. Por eso se optó por un jefe de comportamiento
    variable en lugar de uno con patrones fijos, donde la dificultad sería la misma para
    todos los jugadores independientemente de su desempeño. Aquí es un único antagonista
    el que cambia, en función de cómo jugó quien lo enfrenta.

    A diferencia de los demás enemigos, que reutilizan assets existentes, el jefe se
    construyó como un personaje propio (@fig:jefe-modelo). Esto permitió darle distintas
    formas y diseñar cada ataque a la medida del combate, en lugar de adaptarse a un
    modelo externo: puede presionar la distancia, multiplicar los ataques telegrafiados
    o variar su agresividad según el perfil construido a partir de los arquetipos
    anteriores, lo que hace posible el sistema adaptativo del capítulo 4.

    #figure(
      image("imagenes/cap3/slime_nivel.png", width: 60%),
      caption: [El jefe en su forma normal.],
    ) <fig:jefe-modelo>

    Concretamente, el jefe dispone de nueve ataques distintos, agrupados en tres
    secuencias según el rango al que se encuentre el jugador en el momento de atacar. La
    @tbl:ataques-jefe resume esta relación.

    #figure(
      align(center, table(
        columns: 2,
        align: (left, left),
        table.header([*Rango*], [*Ataques disponibles*]),
        [Lejano], [Charco, Persecución, Proyectil en línea recta, Proyectil homing],
        [Medio], [Básico, Salto, Giro],
        [Cercano], [Básico, Espinas, Muro],
      )),
      caption: [Ataques del jefe agrupados según el rango respecto al jugador.],
    ) <tbl:ataques-jefe>

    A grandes rasgos, cada uno de estos ataques se comporta de la siguiente forma:

    - *Básico*: un ataque cuerpo a cuerpo en el que el jefe deforma su cuerpo hacia
      adelante para golpear.
    - *Espinas*: el jefe saca espinas alrededor de sí mismo, golpeando en área a quien se
      encuentre cerca.
    - *Muro*: el jefe se transforma en un muro rectangular, se estira hacia arriba y cae
      hacia adelante, aplastando al jugador frente a él.
    - *Salto*: el jefe salta acercándose a la posición del jugador y golpea en área al
      aterrizar.
    - *Giro*: el jefe se contrae brevemente y luego extiende su cuerpo como un látigo,
      describiendo un barrido lateral frente a él.
    - *Charco*: el jefe se transforma en un charco líquido y avanza hacia el jugador, para
      luego, tras un tiempo, resurgir desde el suelo golpeando y repeliendo al jugador si
      este se encuentra cerca.
    - *Persecución*: el jefe se desplaza hacia el jugador durante un máximo de algunos
      segundos o hasta entrar en un rango de ataque determinado; no causa daño por sí
      misma, sino que sirve para cerrar distancia desde un rango medio-lejano.
    - *Proyectil en línea recta*: el jefe dispara un abanico de proyectiles que avanzan en
      línea recta, sin seguir al jugador.
    - *Proyectil homing*: el jefe dispara una cantidad menor de proyectiles, pero que
      persiguen activamente al jugador.

    Cada uno de estos ataques se diseñó, además, pensando en un perfil de jugador
    distinto al cual poner a prueba, tal como resume la @tbl:perfiles-castigados.

    #figure(
      align(center, table(
        columns: 2,
        align: (left, left),
        table.header([*Ataque*], [*Perfil de jugador que pone a prueba*]),
        [Básico], [Jugador estático, que permanece quieto frente al jefe.],
        [Espinas], [Jugador agresivo, que se mantiene cerca del jefe.],
        [Muro], [Ninguno en particular; aporta variedad táctica a corta distancia.],
        [Giro], [Jugador que se desplaza lateralmente en rango medio.],
        [Salto], [Jugador que mantiene distancia media o esquiva hacia atrás.],
        [Charco], [Jugador que huye constantemente o abusa del _kiteo_.],
        [Persecución], [Ninguno en particular; es solo movilidad hacia el jugador.],
        [Proyectil en línea recta], [Jugador que permanece quieto a distancia lejana.],
        [Proyectil homing], [Jugador que se mueve mucho estando a distancia lejana.],
      )),
      caption: [Perfil de jugador al que apunta cada ataque del jefe.],
    ) <tbl:perfiles-castigados>

    Dentro de cada rango, el ataque concreto se elige mediante un sorteo aleatorio
    ponderado, y son justamente esos pesos, no la elección del rango, que depende solo de
    la distancia, los que el sistema adaptativo del capítulo 4 ajusta según el
    comportamiento previo del jugador. Cabe mencionar que todos los ataques parten con el
    mismo peso, es decir, la misma probabilidad de ser elegidos dentro de su rango, antes
    de que el sistema adaptativo introduzca cualquier ajuste. El detalle de cada ataque y
    del mecanismo de selección se documenta en el capítulo 5.

    El detalle técnico de la implementación de cada uno de estos enemigos (estructura,
    comportamiento e inteligencia artificial) se documenta en el capítulo 5.

    == Diseño de niveles <sec:diseno-niveles>

    Los niveles se diseñaron como una progresión de encuentros: primero se introduce al jugador en
    un entorno de bajo riesgo, luego se le enfrenta a los tres arquetipos regulares en
    conjunto, y finalmente se le lleva al combate contra el jefe. La ambientación de
    mazmorra que comparten los tres niveles responde a una decisión de producción,
    aprovechar assets disponibles de Fab (Unreal Engine Marketplace)#footnote[
      Asset "Dungeon Environment / 135+ Assets" por PackDev, obtenido de Fab bajo la Fab
      Standard License.
      #link("https://www.fab.com/listings/bb39bae4-7f7a-4127-b07e-151cf52db0f6")[Disponible en sitio web].
    ], y no condiciona las
    decisiones de diseño que se describen a continuación.

    === Nivel de tutorial

    El primer nivel se diseñó como un entorno de bajo riesgo, cuyo objetivo es que el
    jugador aprenda los controles y mecánicas básicas (desplazamiento, esquiva, fijado de
    objetivo, ataque) antes de que estas decisiones tengan consecuencias relevantes, de
    modo que la dificultad real del combate se introduce de forma gradual.

    El nivel se organiza en una secuencia de salas, cada una dedicada a introducir una
    mecánica nueva mediante un mensaje emergente, seguida de inmediato por una oportunidad
    de practicarla antes de poder continuar. La @fig:minimapa-tutorial muestra la
    distribución de estas salas, con la simbología detallada en la @tbl:simbologia-tutorial.

    #figure(
      image("imagenes/cap3/minimap_tutorial.png", width: 80%),
      caption: [Distribución de salas del nivel de tutorial.],
    ) <fig:minimapa-tutorial>

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

    #figure(
      align(center, grid(
        columns: (52pt, 52pt, 52pt, 52pt, 52pt, 52pt, 52pt),
        row-gutter: 4pt,
        align: center + horizon,
        icono-triangulo(red), icono-barra(yellow, 4pt, 16pt), icono-punto(yellow),
        icono-punto(white, borde: 0.5pt), icono-triangulo(white, borde: 0.5pt), icono-barra(rgb("#ff00ff"), 16pt, 4pt),
        icono-puerta-salida,
        text(size: 9pt)[Inicio], text(size: 9pt)[Puerta], text(size: 9pt)[Maniquí],
        text(size: 9pt)[Esqueleto], text(size: 9pt)[Espinas], text(size: 9pt)[Puente],
        text(size: 9pt)[Salida],
      )),
      caption: [Simbología utilizada en el minimapa del nivel de tutorial.],
    ) <tbl:simbologia-tutorial>

    La sala inicial, donde aparece el jugador, enseña el desplazamiento y presenta al
    maniquí: al acercarse, un mensaje indica que el clic izquierdo ataca, y que
    presionarlo varias veces seguidas encadena los golpes en un combo. Recién cuando el
    jugador logra bajarle la vida al maniquí se abre la puerta de salida.

    #figure(
      image("imagenes/cap3/priemerasalatutoria.png", width: 90%),
      caption: [La primera sala del tutorial, con el maniquí y la puerta de salida.],
    ) <fig:primera-sala-tutorial>

    La segunda sala es notablemente más larga que la primera. En su recorrido se enseña a
    correr y, ya cerca del primer esqueleto normal que el jugador encuentra, a esquivar,
    aclarando que la esquiva otorga invulnerabilidad. Derrotar a este enemigo abre la
    puerta hacia la tercera sala.

    #figure(
      grid(
        columns: (1fr, 1fr),
        column-gutter: 8pt,
        image("imagenes/cap3/pasillo-2nd-room.png", width: 100%),
        image("imagenes/cap3/exitwithenemy-2nd-room.png", width: 100%),
      ),
      caption: [La segunda sala del tutorial: el pasillo principal (izquierda) y el esqueleto junto a la puerta de salida (derecha).],
    ) <fig:segunda-sala-tutorial>

    La tercera sala está dividida por un abismo con espinas en el fondo, cruzado por un
    puente que comienza levantado, con un maniquí ubicado al otro lado. Al entrar, se
    enseña a fijar el objetivo y a lanzar una bola de fuego; la intención es que el
    jugador fije al maniquí del otro lado del abismo y le baje la vida a distancia, ya
    que el puente permanece levantado y el abismo impide cruzar de otra forma. Al
    lograrlo, el puente baja y habilita el paso.

    #figure(
      image("imagenes/cap3/espinas-y-puente.png", width: 90%),
      caption: [El abismo con espinas y el puente levantado en la tercera sala del tutorial.],
    ) <fig:espinas-puente>

    Al otro lado, unas flechas señalan un agujero en el suelo por el que el jugador debe
    dejarse caer para continuar. Tras la caída, el jugador aterriza sobre un campo de
    espinas en la sala siguiente, donde se enseña a alternar entre el hechizo de fuego y
    la poción de vida, pidiéndole específicamente cambiar a la poción y curarse.

    #figure(
      grid(
        columns: (1fr, 1fr),
        column-gutter: 8pt,
        image("imagenes/cap3/espinas de la cuarta sala.png", width: 100%),
        image("imagenes/cap3/salida del tutorial.png", width: 100%),
      ),
      caption: [La cuarta sala del tutorial: el campo de espinas (izquierda) y el pasillo final (derecha).],
    ) <fig:cuarta-sala-tutorial>

    El nivel termina poco después, en un pasillo final sin más obstáculos.

    === Nivel previo al jefe

    El segundo nivel reúne, por primera y única vez, a los tres arquetipos de enemigo
    regulares (esqueleto normal, mago y caballero) descritos en la sección anterior. A
    diferencia del tutorial, aquí el jugador debe lidiar con los tres ejes de
    comportamiento (ritmo básico, gestión de distancia y lectura de ataques
    telegrafiados) de forma simultánea y bajo la presión de varios enemigos a la vez, lo
    que lo convierte en el último peldaño de dificultad antes del jefe.

    El nivel se organiza en torno a una sala amplia central, desde la cual se accede a dos
    zonas dedicadas, una por cada uno de los arquetipos especializados, antes de poder
    llegar a la puerta del jefe.

    #figure(
      grid(
        columns: (1fr, 1fr),
        column-gutter: 12pt,
        image("imagenes/cap3/dungeon_minimap_1.png", width: 100%),
        image("imagenes/cap3/dungeon_minimap_2.png", width: 100%),
      ),
      caption: [Distribución de salas del nivel previo al jefe: piso 1 (izquierda) y piso 2 (derecha).],
    ) <fig:minimapa-dungeon>

    #figure(
      align(center, grid(
        columns: (46pt, 46pt, 46pt, 46pt, 46pt, 46pt, 46pt, 46pt),
        row-gutter: 4pt,
        align: center + horizon,
        icono-triangulo(red), icono-punto(white, borde: 0.5pt), icono-punto(blue),
        icono-punto(red), icono-barra(yellow, 16pt, 4pt),
        text(size: 16pt, fill: rgb("#5500cc"))[↑], icono-puerta-salida, icono-palanca,
        text(size: 9pt)[Inicio], text(size: 9pt)[Esqueleto], text(size: 9pt)[Mago],
        text(size: 9pt)[Caballero], text(size: 9pt)[Puerta], text(size: 9pt)[Escaleras],
        text(size: 9pt)[Salida], text(size: 9pt)[Palanca],
      )),
      caption: [Simbología utilizada en los minimapas del nivel previo al jefe.],
    ) <tbl:simbologia-dungeon>

    El jugador comienza en una sala vacía y, al avanzar por un primer tramo de pasillos, se
    encuentra de inmediato con el primer esqueleto normal, que patrulla la zona. Al final de
    estos pasillos se abre la sala amplia mencionada, donde patrullan dos esqueletos
    normales adicionales.

    #figure(
      grid(
        columns: (1fr, 1fr),
        column-gutter: 8pt,
        image("imagenes/cap3/sala-inicio-nivelprevio.png", width: 100%),
        image("imagenes/cap3/sala-central-nivelprevio.png", width: 100%),
      ),
      caption: [La sala inicial del nivel previo al jefe (izquierda) y la sala amplia central (derecha).],
    ) <fig:salas-inicio-central>

    Al frente de esta sala, en el extremo opuesto a la entrada, se encuentra la puerta de
    acceso al jefe, bloqueada por dos puertas metálicas dispuestas una tras otra. Abrir
    ambas es la condición para avanzar, y cada una se desbloquea completando una de las dos
    zonas laterales que se describen a continuación. Además de la entrada por los pasillos y
    de esta puerta bloqueada, la sala amplia tiene otras dos salidas, una hacia cada zona,
    junto con dos puertas metálicas adicionales que funcionan únicamente como atajos de
    regreso.

    #figure(
      image("imagenes/cap3/gates-zona-principal.png", width: 80%),
      caption: [Las dos puertas metálicas que bloquean el acceso al jefe.],
    ) <fig:gates-principal>

    #figure(
      grid(
        columns: (1fr, 1fr),
        column-gutter: 8pt,
        image("imagenes/cap3/salida-izq-hacia-zonatanquel-nivelprevio.png", width: 100%),
        image("imagenes/cap3/salida-der-hacia-zonaenemigosrango-nivelprevio.png", width: 100%),
      ),
      caption: [Salida izquierda hacia la zona tanque (izquierda) y salida derecha hacia la zona de rango (derecha).],
    ) <fig:salidas-zonas>

    La salida izquierda lleva, mediante una escalera, a un segundo piso que corresponde a la
    zona de enemigos de tipo tanque (enemigos lentos pero de gran resistencia y daño elevado),
    es decir, a los esqueletos caballero. Tras avanzar un poco se
    encuentra el primer caballero y, más adelante en la misma sala, el segundo. Al final de
    la zona, una palanca abre a la vez una de las dos puertas metálicas que bloquean el
    acceso al jefe y una puerta de atajo, por la que el jugador puede bajar una escalera y
    volver directamente a la sala amplia sin repetir el recorrido.

    #figure(
      grid(
        columns: (1fr, 1fr),
        column-gutter: 8pt,
        image("imagenes/cap3/primer-enemigo-zonatanque.png", width: 100%),
        image("imagenes/cap3/segundo-enemigo-zonatanque.png", width: 100%),
      ),
      caption: [El primer y segundo esqueleto caballero en la zona tanque.],
    ) <fig:caballeros-zonatanque>

    #figure(
      image("imagenes/cap3/palanca-zona-tanque.png", width: 70%),
      caption: [La palanca al final de la zona tanque.],
    ) <fig:palanca-zonatanque>

    La salida derecha conduce a la zona de rango. Tras cambiar de sala, el jugador encuentra
    al primer esqueleto mago; pasado este, una escalera sube a un segundo piso de la misma
    zona, donde esperan tres esqueletos mago dispuestos sobre plataformas, cada una con una
    rampa en su parte posterior que permite subir y atacarlos cuerpo a cuerpo, sin perjuicio
    de poder seguir atacándolos a distancia con la bola de fuego. Al final de esta sala, otra
    palanca abre la segunda puerta metálica de acceso al jefe junto con su propia puerta de
    atajo, que de igual forma permite bajar y regresar a la sala amplia.

    #figure(
      grid(
        columns: (1fr, 1fr),
        column-gutter: 8pt,
        image("imagenes/cap3/primer-enemigo-zonarango.png", width: 100%),
        image("imagenes/cap3/sala-con-3magos-zonarango.png", width: 100%),
      ),
      caption: [El primer esqueleto mago (izquierda) y los tres magos del segundo piso de la zona de rango (derecha).],
    ) <fig:magos-zonarango>

    #figure(
      image("imagenes/cap3/palanca-zona-rango.png", width: 80%),
      caption: [La palanca al final de la zona de rango.],
    ) <fig:palanca-zonarango>

    Una vez abiertas ambas puertas metálicas, una desde cada zona, el jugador puede
    finalmente acceder a la sala del jefe.

    Todo lo que el jugador hace en este nivel, cómo enfrenta a cada arquetipo, cómo
    esquiva, etc., queda registrado y se utiliza más adelante para ajustar el
    comportamiento del jefe; el mecanismo concreto de ese ajuste se explica en el
    capítulo 4. Por ahora basta con entender este nivel como el último punto de referencia
    sobre el jugador antes de que comience el combate final.

    === Arena del jefe

    A diferencia de los dos niveles anteriores, la arena del jefe (@fig:arena-jefe) se
    diseñó como un espacio simple: un pasillo corto conecta la sala del nivel previo con
    una sala de gran tamaño donde ocurre el combate. Al entrar a esta sala, una puerta
    metálica se cierra detrás del jugador, cortando la posibilidad de retirada, y se
    activa el jefe. No hay aquí una progresión de salas ni elementos adicionales que
    aprender, ese rol ya lo cumplieron los niveles anteriores, sino un único espacio
    amplio que le da al jefe, versátil y con ataques de distinto alcance, el lugar
    necesario para desplegar todo su repertorio.

    #figure(
      image("imagenes/cap3/boss_arena.png", width: 80%),
      caption: [Vista general de la arena del jefe.],
    ) <fig:arena-jefe>

    El detalle de la lógica propia de cada nivel (puertas, palancas y demás elementos
    reutilizables) se documenta en el capítulo 5.

]

// ==========================================
// CAPÍTULO 4: SISTEMA ADAPTATIVO BASADO EN EL COMPORTAMIENTO DEL JUGADOR
// ==========================================
#capitulo(title: "Sistema adaptativo basado en el comportamiento del jugador")[

    Este capítulo explica cómo el comportamiento del jugador durante el nivel previo al
    jefe (capítulo 3) se traduce en ajustes sobre el repertorio de ataques de ese mismo
    jefe. La intención no es repetir aquí el mecanismo técnico exacto, las variables, los
    umbrales numéricos y la forma en que se almacenan los pesos se documentan en el
    capítulo 5, sino explicar la lógica detrás de cada regla de adaptación: qué se mide,
    por qué se eligió medir eso en particular, y en qué dirección general empuja el
    comportamiento del jefe.

    #figure(
      {
        let nb(cnt, fill: luma(215)) = rect(
          fill: fill, stroke: 0.8pt, radius: 4pt, inset: 8pt, width: 100%, cnt
        )
        let db(cnt) = rect(
          fill: luma(248),
          stroke: (dash: "dashed", paint: luma(120), thickness: 0.8pt),
          radius: 4pt, inset: 8pt, width: 100%, cnt
        )

        align(center,
          block(width: 130mm,
            stack(dir: ttb, spacing: 4pt,
              nb(align(center)[*Nivel previo al jefe*]),
              grid(columns: (1fr, 1fr, 1fr, 1fr),
                align(center)[↓], align(center)[↓], align(center)[↓], align(center)[↓]),
              grid(columns: (1fr, 1fr, 1fr, 1fr), column-gutter: 4pt,
                nb(align(center)[#text(size: 9pt)[Distancia \ promedio]], fill: luma(238)),
                nb(align(center)[#text(size: 9pt)[Melee vs. \ rango]], fill: luma(238)),
                nb(align(center)[#text(size: 9pt)[Efectividad \ de esquiva]], fill: luma(238)),
                nb(align(center)[#text(size: 9pt)[Zona de \ tanque]], fill: luma(238)),
              ),
              align(center)[↓],
              nb(align(center)[
                *Pesos de ataque (pre-combate)* \
                #text(size: 9pt)[(ajustados al iniciar el combate)]
              ]),
              align(center)[↓],
              nb(align(center)[
                *Behaviour Tree del jefe* \
                #text(size: 9pt)[(selección ponderada de ataques)]
              ], fill: luma(190)),
              grid(columns: (1fr, 1fr), column-gutter: 4pt,
                db(align(center)[#text(size: 9pt)[↑ Éxito por tipo de ataque \ #emph[(cada 15 ataques)]]]),
                db(align(center)[#text(size: 9pt)[↑ Curación del jugador \ #emph[(monitoreo continuo)]]]),
              ),
            )
          )
        )
      },
      caption: [Flujo del sistema de adaptación. Los bloques discontinuos (abajo) representan ajustes en tiempo real durante el combate.],
    ) <fig:flujo-adaptacion>

    == Perfil de juego: qué se mide y por qué

    El nivel previo al jefe reúne a los tres arquetipos de enemigo regulares (capítulo 3)
    precisamente porque cada uno expone una dimensión distinta del comportamiento del
    jugador. Al terminar ese nivel, esas observaciones se resumen en un perfil de cuatro
    dimensiones independientes entre sí, cada una capaz de inclinar la frecuencia de un
    subconjunto de esos ataques, no necesariamente excluyente del de las otras
    dimensiones, ya que más de una puede terminar reforzando un mismo ataque.

    Durante ese mismo nivel se registra, además, a qué porcentaje de vida suele curarse
    el jugador. A diferencia de las cuatro dimensiones anteriores, esta observación no se
    usa para ajustar los pesos antes del combate, sino durante este, como se describe más
    adelante en la sección "Ajuste durante el combate".

    Cabe señalar que los valores numéricos concretos que aparecen en las reglas de este
    capítulo (tanto los umbrales de activación como las magnitudes de los ajustes de peso)
    no se derivaron analíticamente, sino que se fijaron de forma iterativa mediante pruebas
    de juego durante el desarrollo, buscando que los cambios en el comportamiento del jefe
    resultaran perceptibles sin volverse abruptos.

    === Distancia

    Se registra la distancia promedio que el jugador mantiene frente al esqueleto normal
    y al esqueleto caballero (capítulo 3), pero no frente al mago: su zona suele enfrentar
    al jugador contra varios enemigos a la vez, lo que volvería ruidosa una medición de
    distancia pensada para un solo oponente. Frente al esqueleto normal y al caballero,
    en cambio, el jugador se enfrenta de forma más controlada, por lo que la distancia que
    decide mantener resulta una señal más limpia de su estilo de juego. Esta medición
    requiere un mínimo de 20 muestras registradas para activarse. Si el jugador mantiene
    una distancia promedio menor a 330 unidades, el límite del rango cercano del jefe se
    reduce en 50 unidades, acotando la zona en la que el jefe se considera en corta
    distancia y forzándolo a recurrir antes a sus ataques de rango medio o lejano; si la
    distancia promedio es mayor a 480 unidades, el límite del rango lejano se reduce en 75
    unidades y la duración de la persecución del jefe aumenta en 2 segundos. Entre ambos
    umbrales, considerado un comportamiento neutro, no se introduce ningún cambio. La
    @tbl:regla-distancia resume esta regla.

    #block(fill: luma(248), inset: 8pt, radius: 3pt, width: 100%)[
      *Ejemplo:* un jugador cuya distancia promedio frente a estos dos enemigos fue de
      300 unidades activa la primera condición. El límite del rango cercano del jefe se
      reduce en 50, por lo que este considerará "cerca" un radio más pequeño que el
      habitual y recurrirá antes a sus ataques de rango medio o lejano.
    ]

    #figure(
      align(center, table(
        columns: 2,
        align: (left, left),
        table.header([*Condición*], [*Ajuste*]),
        [Distancia promedio < 330], [Límite del rango cercano --50],
        [330 -- 480 (neutro)], [Sin cambios],
        [Distancia promedio > 480], [Límite del rango lejano --75; duración de persecución +2 s],
      )),
      caption: [Regla de adaptación por distancia promedio.],
    ) <tbl:regla-distancia>

    === Melee versus ataques a distancia

    Más allá de la distancia que mantiene, esta dimensión observa qué tipo de ataque usa
    el jugador con más frecuencia, cuerpo a cuerpo o a distancia, tanto en general (con
    un mínimo de 5 ataques registrados) como específicamente dentro de la zona de rango
    (con un mínimo de 3 ataques en la zona), donde esa decisión tiene mayor peso
    contextual. Si la proporción de ataques a distancia supera el 50% del total, aumentan
    en 15 los pesos de Charco y Persecución, que cierran distancia con rapidez, y de
    Salto, que presiona en rango medio; si baja del 35%, aumentan en 15 los de Espinas y
    Giro,
    pensados para castigar a quien se mantiene cerca. Entre ambos umbrales se considera un
    comportamiento mixto y no hay ajuste. Si, dentro de la zona de rango, predominó
    claramente uno de los dos tipos de ataque, se suman además 10 puntos al peso de
    Espinas (si predominó el cuerpo a cuerpo) o de Charco (si predominó el ataque a
    distancia). La @tbl:regla-melee-rango resume estas reglas.

    #block(fill: luma(248), inset: 8pt, radius: 3pt, width: 100%)[
      *Ejemplo:* un jugador que realizó 8 ataques cuerpo a cuerpo y 32 a distancia (80%
      del total) supera el umbral del 50%, por lo que Charco, Persecución y Salto suben
      en 15 cada uno. Si, de esos ataques, 2 fueron cuerpo a cuerpo y 6 a distancia
      dentro de la zona de rango, también se cumple el mínimo de 3 ataques en la zona y
      predominan los ataques a distancia, por lo que Charco recibe 10 puntos
      adicionales, terminando con un peso 25 puntos por sobre su valor base.
    ]

    #figure(
      align(center, table(
        columns: 2,
        align: (left, left),
        table.header([*Condición*], [*Ajuste*]),
        [Ataques a distancia > 50% del total], [Charco +15, Persecución +15, Salto +15],
        [Entre 35% y 50% (mixto)], [Sin cambios],
        [Ataques a distancia < 35% del total], [Espinas +15, Giro +15],
        [Predominio melee en zona de rango], [Espinas +10 adicional],
        [Predominio a distancia en zona de rango], [Charco +10 adicional],
      )),
      caption: [Regla de adaptación por preferencia melee vs. a distancia.],
    ) <tbl:regla-melee-rango>

    === Esquiva

    Esta dimensión mide qué proporción de las esquivas totales del jugador (mínimo 5
    registradas) corresponden específicamente a esquivas exitosas contra el ataque
    telegrafiado del esqueleto caballero (capítulo 3), el mismo dato usado, en su versión
    acotada a la zona de enemigos tanque, en la dimensión descrita más abajo. No todos
    los ataques del jefe son igual de fáciles de leer: Salto, Espinas y Muro requieren una
    preparación larga y son más fáciles de anticipar, mientras que Básico apenas se anuncia
    antes de conectar. Si esa proporción supera el 60%, aumenta en 15 el peso de Básico,
    precisamente por ser el más difícil de leer y, por lo tanto, el que más pone a prueba
    esa habilidad; si es menor al 40%, aumentan en 15 los pesos de Espinas, Muro y Salto,
    los ataques de preparación larga que de todas formas logran conectar incluso cuando se
    intenta evadirlos. Entre ambos umbrales no hay ajuste. La @tbl:regla-esquiva resume
    esta regla.

    #block(fill: luma(248), inset: 8pt, radius: 3pt, width: 100%)[
      *Ejemplo:* si de 10 esquivas registradas 7 correspondieron al ataque telegrafiado
      del caballero (70%), se supera el umbral del 60% y el peso de Básico sube en 15,
      ya que el jugador demostró ser especialmente hábil para leer el ataque de
      preparación larga y no tanto el que se anuncia poco antes de conectar.
    ]

    #figure(
      align(center, table(
        columns: 2,
        align: (left, left),
        table.header([*Condición*], [*Ajuste*]),
        [Esquivas a ataque telegrafiado > 60% del total], [Básico +15],
        [Entre 40% y 60% (normal)], [Sin cambios],
        [Esquivas a ataque telegrafiado < 40% del total], [Espinas +15, Muro +15, Salto +15],
      )),
      caption: [Regla de adaptación por efectividad de esquiva.],
    ) <tbl:regla-esquiva>

    === Zona de enemigos tanque

    La zona de enemigos tanque (capítulo 3) se diseñó deliberadamente para replicar, a
    menor escala, dos situaciones que el jugador volverá a enfrentar contra el jefe: un
    avance rápido que cierra distancia, similar a Salto, y un ataque de preparación larga,
    similar a Salto y Giro. Por eso, en lugar de una sola medición, esta dimensión
    observa dos comportamientos puntuales frente al caballero.

    Frente al avance del caballero (con un mínimo de 2 esquivas registradas para
    activarse), se registra hacia qué lado esquiva el jugador: si predominan las esquivas
    laterales, aumenta en 10 el peso de Giro; si predominan las esquivas hacia atrás,
    aumenta en 10 el de Salto, replicando el mismo patrón de reacción que el jugador ya
    mostró frente al avance del caballero.

    #block(fill: luma(248), inset: 8pt, radius: 3pt, width: 100%)[
      *Ejemplo:* si de 4 esquivas registradas frente al avance del caballero 3 fueron
      laterales, predomina ese lado y el peso de Giro sube en 10.
    ]

    Frente a su ataque telegrafiado (con un mínimo de 3 esquivas registradas para
    activarse), se calcula la proporción de esas esquivas que resultaron exitosas: si
    alcanza o supera el 50%, aumenta en 10 el peso de Básico; si queda por debajo,
    aumentan en 10 los pesos de Salto y Giro. La @tbl:regla-tanque resume ambas reglas.

    #block(fill: luma(248), inset: 8pt, radius: 3pt, width: 100%)[
      *Ejemplo:* si de 3 esquivas registradas frente al ataque telegrafiado solo 1
      resultó exitosa (33%), queda bajo el umbral del 50% y suben en 10 tanto Salto como
      Giro. Sumado al ejemplo anterior, el peso final de Giro quedaría 20 puntos por
      sobre su valor base.
    ]

    #figure(
      align(center, table(
        columns: 2,
        align: (left, left),
        table.header([*Condición*], [*Ajuste*]),
        [Avance: predominan esquivas laterales], [Giro +10],
        [Avance: predominan esquivas hacia atrás], [Salto +10],
        [Ataque telegrafiado: esquivas exitosas >= 50% del total], [Básico +10],
        [Ataque telegrafiado: esquivas exitosas < 50% del total], [Salto +10, Giro +10],
      )),
      caption: [Reglas de adaptación por comportamiento en la zona de enemigos tanque.],
    ) <tbl:regla-tanque>

    == De perfil a comportamiento: ajuste de pesos antes del combate

    Como se mencionó en el capítulo 3, los nueve ataques del jefe parten con la misma
    probabilidad de ser elegidos dentro de su banda de distancia correspondiente. Lo que
    hacen las cuatro dimensiones anteriores, en conjunto, es sumar bonificaciones sobre esa
    base pareja: cada regla que se activa aumenta la frecuencia relativa de algunos
    ataques puntuales, sin eliminar ni modificar ningún otro. Este ajuste ocurre una sola
    vez, al iniciar el combate, y se mantiene fijo durante todo el enfrentamiento salvo por
    los ajustes adicionales descritos en la siguiente sección.

    Para ilustrar cómo se combinan estas reglas, considérese un jugador que activó las
    condiciones de los tres ejemplos anteriores: un 80% de ataques a distancia con
    predominio de ese mismo tipo dentro de la zona de rango, un 70% de esquivas exitosas
    contra el ataque telegrafiado del caballero, y un predominio de esquivas laterales
    junto con una baja tasa de éxito frente a su ataque telegrafiado en la zona de
    enemigos tanque. La @tbl:ejemplo-combinado muestra el peso final de cada ataque
    afectado, partiendo todos de un valor base de 50; el resto de los ataques del jefe
    (Espinas, Muro, Proyectil y Proyectil homing) no se ven afectados por ninguna de estas
    reglas y permanecen en su valor base.

    #figure(
      align(center, table(
        columns: 2,
        align: (left, center),
        table.header([*Ataque*], [*Peso final*]),
        [Básico], [50 + 15 (esquiva) = 65],
        [Charco], [50 + 15 (melee/rango) + 10 (predominio en zona) = 75],
        [Persecución], [50 + 15 (melee/rango) = 65],
        [Salto], [50 + 15 (melee/rango) + 10 (tanque, telegrafiado) = 75],
        [Giro], [50 + 10 (tanque, avance) + 10 (tanque, telegrafiado) = 70],
      )),
      caption: [Ejemplo de combinación de reglas para un jugador hipotético que activa
        varias condiciones simultáneamente.],
    ) <tbl:ejemplo-combinado>

    Sobre el resultado de estas bonificaciones se aplica, además, una restricción que no
    depende del perfil del jugador: ningún ataque puede ser elegido tres veces
    consecutivas, sin importar cuánto haya aumentado su frecuencia. Esta restricción evita
    que la adaptación produzca el efecto contrario al buscado, ya que un jefe que repite el
    mismo ataque una y otra vez resulta tan previsible como uno completamente estático, y
    responde a la misma tensión planteada en el capítulo 2 a partir de las heurísticas de
    Pinelle et al.: que el jefe se adapte sin volverse impredecible o frustrante para el
    jugador.

    == Ajuste durante el combate

    La adaptación principal ocurre antes del combate, pero existen dos ajustes acotados
    que sí operan en tiempo real, distintos de la adaptación en tiempo real más ambiciosa
    que se descartó del alcance de este trabajo (capítulo 1).

    El primero observa, cada 15 ataques realizados por el jefe, qué proporción de los
    intentos de cada tipo de ataque efectivamente conecta con el jugador (siempre que
    existan al menos 3 intentos de ese tipo). Si la proporción de aciertos supera el 60%,
    el peso de ese ataque aumenta en 15; si es menor al 30%, se reduce en 15; entre ambos
    umbrales no hay ajuste. Así, el jefe deja de insistir en ataques que el jugador ya
    domina y dedica más turnos a los que sí le generan dificultad. La
    @tbl:regla-exito-ataque resume esta regla.

    #block(fill: luma(248), inset: 8pt, radius: 3pt, width: 100%)[
      *Ejemplo:* si de los últimos 15 ataques del jefe, Básico se intentó 5 veces y
      conectó en 4 de ellas (80%), supera el umbral del 60% y su peso sube 15 puntos
      adicionales. Si en ese mismo tramo Espinas se intentó 3 veces y no conectó ninguna
      (0%), su peso baja 15 puntos, ya que el jugador demostró saber esquivarlo con
      facilidad.
    ]

    #figure(
      align(center, table(
        columns: 2,
        align: (left, left),
        table.header([*Condición (por tipo de ataque)*], [*Ajuste*]),
        [Tasa de acierto > 60%], [Ese ataque +15],
        [Entre 30% y 60%], [Sin cambios],
        [Tasa de acierto < 30%], [Ese ataque --15],
      )),
      caption: [Regla de adaptación por éxito de cada tipo de ataque durante el combate.],
    ) <tbl:regla-exito-ataque>

    El segundo ajuste es reactivo a la vida del jugador y requiere al menos 2 curaciones
    registradas durante el nivel previo: a partir del promedio de vida al que el jugador
    se curó, el jefe reconoce cuándo entra a ese rango (con un margen de ±10 puntos
    porcentuales) y, mientras se mantiene ahí, aumenta en 15 los pesos de Básico, Salto,
    Charco y Proyectil homing, reduciendo la ventana disponible para curarse. Al salir de
    ese rango, revierte esos mismos 15 puntos en cada uno, evitando mantener una presión
    artificial una vez que el riesgo de curación ya pasó. La @tbl:regla-curacion resume
    esta regla.

    #block(fill: luma(248), inset: 8pt, radius: 3pt, width: 100%)[
      *Ejemplo:* si un jugador suele curarse cuando su vida llega al 40%, el jefe
      reconoce el margen entre 30% y 50% de vida como su "rango habitual de curación".
      En el momento en que la vida del jugador entra a ese rango durante el combate,
      Básico, Salto, Charco y Proyectil homing suben 15 puntos cada uno; si el jugador
      efectivamente usa una poción y su vida sube por sobre el 50%, esos mismos 15
      puntos se revierten.
    ]

    #figure(
      align(center, table(
        columns: 2,
        align: (left, left),
        table.header([*Condición*], [*Ajuste*]),
        [Jugador entra al rango habitual de curación (±10 pp)], [Básico +15, Salto +15, Charco +15, Proyectil homing +15],
        [Jugador sale de ese rango], [Revierte los mismos ajustes (--15 cada uno)],
      )),
      caption: [Regla de adaptación reactiva por proximidad al rango habitual de curación.],
    ) <tbl:regla-curacion>

]

// ==========================================
// CAPÍTULO 5: IMPLEMENTACIÓN DEL JUEGO
// ==========================================
#capitulo(title: "Implementación del videojuego")[


    Para el proyecto se decidió utilizar Unreal Engine 5.6. El juego se construyó tomando
como base la plantilla _Third Person_ incluida en Unreal Engine. Esta corresponde a un
ejemplo diseñado para demostrar las funcionalidades fundamentales del sistema de
personajes en tres dimensiones, incorporando un escenario simple, una cámara orbital y un
personaje capaz de desplazarse, correr y saltar. Si bien a primera vista los elementos
presentados parecen utilizables directamente para la implementación del proyecto, la
plantilla posee diversos aspectos que difieren del objetivo buscado y que requieren
modificaciones específicas.

A lo largo de esta sección se hará referencia frecuente al concepto de Blueprint. Los
Blueprints son el sistema de _scripting_ visual de Unreal Engine que permite crear lógica
de juego mediante nodos interconectados, sin necesidad de escribir código tradicional.
Esto facilita la iteración rápida y permite a diseñadores y artistas contribuir
directamente a la programación del juego.

La plantilla _Third Person_ proporciona una estructura de proyecto preconfigurada que
incluye varios componentes clave. El elemento principal es el `BP_ThirdPersonCharacter`,
un Blueprint que representa al personaje jugable y contiene toda la lógica de movimiento,
sistema de input y comportamiento básico. Sus componentes principales son la cápsula de
colisión, la malla del personaje (_Skeletal Mesh_), el componente de movimiento
(_Character Movement Component_) y la cámara con su brazo de resorte (_Spring Arm_). La
_Skeletal Mesh_ se reemplazo por un modelo 3D de elaboración propia, originalmente un
proyecto personal desarrollado en Blender, al que se le aplicó un rig con herramientas de
_auto-rig_ y se integró en Unreal Engine 5 mediante el sistema de _retargeting_, para
redirigir las animaciones del Mannequin por defecto al esqueleto del personaje.
Adicionalmente, la plantilla incluye el _Game Mode_, que define las reglas básicas del
juego, y diversos assets como animaciones base, materiales y el escenario de demostración.
#figure(
  image("imagenes/cap5/bp-jugador.png", width: 80%),
  caption: [Vista del Blueprint del jugador con sus componentes.],
) <fig:blueprint-jugador>


Un ejemplo de los ajustes necesarios es la estructura del personaje y sus sistemas de
locomoción, los cuales, si bien sirven como referencia inicial, deben ser adaptados o
reemplazados según las necesidades mecánicas del juego. Del mismo modo, el comportamiento
de la cámara, las animaciones base y la lógica de entrada proporcionadas por defecto
funcionan como punto de partida, pero no necesariamente representan la experiencia final
deseada.

Por ejemplo, se tuvieron que cambiar las animaciones de movimiento del personaje por
algunas que soportaran _Strafe Movement_. El _Strafe Movement_ (o simplemente _strafing_)
consiste en moverse lateralmente sin perder la orientación hacia un objetivo específico.
En lugar de girar todo el cuerpo para caminar hacia la izquierda o la derecha, el
personaje realiza un movimiento lateral mientras mantiene la mirada fija hacia adelante o
hacia un blanco. Este tipo de movimiento es común en juegos de acción y combate, ya que
permite al jugador mantener contacto visual con enemigos mientras se desplaza en cualquier
dirección.

Se importaron animaciones que soportan el _Strafe Movement_, con las opciones de _Root
Motion_ y _Enable Root Motion_ habilitadas. El _Root Motion_ permite que el movimiento del
personaje sea controlado directamente por las animaciones en lugar de ser aplicado
mediante código, lo que resulta en desplazamientos más naturales y sincronizados con las
animaciones reproducidas.

Lo siguiente fue crear un _Blend Space_ asociado al esqueleto del jugador, para poder
transicionar animaciones dependiendo de la velocidad y dirección del jugador. Un _Blend
Space_ es un asset de Unreal Engine que permite interpolar suavemente entre múltiples
animaciones basándose en valores de entrada. En este caso, se configuró con dos ejes: uno
horizontal que representa la dirección lateral del movimiento y uno vertical que representa
la velocidad hacia adelante o atrás.

#figure(
  image("imagenes/cap5/blendspace-jugador.png", width: 80%),
  caption: [Blend Space `BS_StrafeMovement`, con la dirección en el eje X y la velocidad en el eje Y.],
) <fig:blendspace-strafe>
En el _Animation Blueprint_ del personaje (`ABP_Daiko`), el sistema que selecciona qué
animación reproducir según el estado del personaje, se reemplazó la animación de _Idle_ que
venía en el template por una propia, del conjunto de animaciones de _Strafe Movement_.

Luego, se reemplazó en el estado de _Walking/Run_ el _Blend Space_ que venía en el
template por el _Blend Space_ creado previamente, permitiendo así transiciones fluidas
entre las diferentes direcciones de movimiento mientras se mantiene la orientación del
personaje. También se desactivó el parámetro "Orient Rotation to Movement" y se activó el
parámetro "Use Controller Desired Rotation" para que el jugador mire siempre hacia la
dirección que indica la cámara, independientemente de la dirección en la que se mueva.

Para desarrollar las capacidades de combate del jugador, se decidió crear un componente
`BPC_Combat` que hereda de _Actor Component_, el cual se ancla al Blueprint del jugador de tal
forma que esté centralizada la lógica de combate. De igual forma, para las estadísticas
del jugador se creó y ancló un componente `BPC_Stats`.

== Sistema de input

La entrada del jugador se gestiona mediante el sistema _Enhanced Input_ de Unreal Engine.
Cada acción del jugador (atacar, esquivar, correr, etc.) se representa como un
_Input Action_ independiente, desacoplado de la tecla o botón físico que lo activa. Esta
asociación entre la entrada física y el `Input Action` correspondiente se define en un
_Input Mapping Context_, lo que facilita el remapeo de controles sin modificar la lógica
interna de cada Blueprint. Actualmente el juego solo cuenta con soporte para teclado y mouse.

Los `Input Actions` del juego y sus controles asociados son los siguientes:

#align(center, table(
  columns: 2,
  align: (left, left),
  table.header([*Input Action*], [*Control*]),
  [`IA_Attack`], [Click izquierdo],
  [`IA_Dash-Roll`], [Barra espaciadora],
  [`IA_Run`], [Shift],
  [`IA_Magic`], [Q],
  [`IA_ScrollMagic`], [Rueda del mouse],
  [`IA_Lock`], [Click rueda del mouse],
  [`IA_MyInteract`], [E],
  [`IA_EscapeMenu`], [Escape],
))

En las secciones siguientes, cada acción del jugador se describe haciendo referencia
explícita al `Input Action` correspondiente (por ejemplo, `IA_Attack` o `IA_Dash-Roll`),
ya activado mediante el _Input Mapping Context_ descrito anteriormente.

== Estadísticas del jugador

Como se mencionó anteriormente, las estadísticas del jugador se implementaron en el
componente `BPC_Stats` anclado al jugador. Este maneja tres estadísticas: vida,
stamina y maná, cada una con su valor máximo, y guarda referencias a
las barras de la interfaz que las muestran.

Su función principal es `IncreaseVal`, que recibe la estadística a modificar y el valor del
cambio (positivo o negativo), actualiza la estadística acotándola entre cero y su máximo
mediante `Clamp`, y refresca la barra correspondiente en la interfaz. Si la vida llega a
cero, invoca el evento `Die`, que da inicio a la secuencia de muerte del jugador.

A diferencia de las barras de vida y maná, la de stamina solo se muestra mientras se está
gastando o recuperando, de forma similar a como lo implementan juegos como
_The Legend of Zelda: Breath of the Wild_
#footnote[
  The Legend of Zelda: Breath of the Wild es un videojuego de acción y aventuras en mundo
  abierto desarrollado y publicado por Nintendo en 2017. El juego introduce mecánicas
  innovadoras de supervivencia y exploración, incluyendo un sistema de stamina que se
  muestra dinámicamente solo cuando se está utilizando o recuperando.
  #link("https://www.zelda.com/breath-of-the-wild/")[Disponible en sitio web].
].

Finalmente, al iniciarse el componente activa dos timers que regeneran de forma continua la
stamina y el maná (eventos `RegainStamina` y `RegainMana`) mientras se cumplan las
condiciones correspondientes.

== Recepción de daño y muerte

El procesamiento del daño y la curación que recibe el jugador se centraliza en el evento
`ReceiveAnyDamage` de `BP_ThirdPersonCharacter`, el cual es invocado automáticamente por el
motor cada vez que se llama a la función `ApplyDamage` sobre el jugador, sin importar el
origen del daño. Este evento recibe el valor a aplicar y, según su signo, distingue entre
dos casos.

Si el valor es negativo, se interpreta como curación: se invoca directamente `IncreaseVal`
sobre `BPC_Stats` con el valor invertido, restaurando la vida del jugador según lo descrito
en la sección anterior.

Si el valor es positivo o cero, se interpreta como daño recibido y se ejecuta una
secuencia más elaborada. Si el causante del daño es el jefe, se registra el golpe en el
`PlayerMetricsComponent` (componente del jefe descrito en @sec:metricas), asociando cada
golpe recibido con el tipo de ataque que lo causó. Luego se distingue si el jugador se
encontraba esquivando en el momento del impacto:

- Si estaba esquivando, se registra la esquiva como exitosa y no se aplica ningún daño, lo
  que implementa la invulnerabilidad del jugador durante toda la esquiva descrita en el
  capítulo 3.
- Si no estaba esquivando, se registra el daño recibido y se reproduce el sonido de dolor
  correspondiente; si además el jugador se encontraba en la zona de tanque, se efectúa un
  registro adicional. Recién en ese caso se aplica el daño a la vida del jugador y, si el
  daño es mayor a cero, se reproduce la animación de reacción a daño, que detiene
  temporalmente su movimiento mientras dura.

Cuando la vida del jugador llega a cero, `IncreaseVal` invoca el evento `Die`, que gestiona
la secuencia de derrota. Este evento desactiva el componente de combate, reproduce una
animación de derrota (`MO_DefeatDaiko`) y, una vez finalizada, pausa el juego, muestra el
widget de "Try Again" y habilita el cursor del mouse. Si la derrota ocurrió en el nivel del
jefe, adicionalmente se vuelca a un archivo el registro de resultados del combate mediante
`DumpCombatResultToFile`, dato que forma parte del sistema de recolección de métricas del
estudio de usuario.
#figure(
  image("imagenes/cap5/deathscreen-jugador.png", width: 80%),
  caption: [Pantalla de Game Over mostrada al morir el jugador.],
) <fig:pantalla-muerte>
== Componente de combate

Como se mencionó anteriormente, se creó un _Actor Component_ llamado `BPC_Combat` que se
ancla al jugador y centraliza toda la lógica relacionada con el combate.

Este componente concentra las variables de estado del combate del jugador, que pueden
agruparse según su propósito:

- *Banderas de acción*: `isAttacking`, `isCombo`, `isDodging`, `isRunning` y
  `isRollingSideWays`, que indican qué está haciendo el jugador en cada momento.
- *Parámetros de consumo y daño*: `StaminaRollUse`, `StaminaRunUse`, `runSpeed`,
  `magicManaUse`, `healingManaUse` y `SwordDamage`.
- *Fijado de objetivo*: `TargetLock`, `TargetLockWidget` y `tmpTarget`.
- *Hechizos y objetos*: `CurrentSpellIndex` (opción equipada, hechizo de fuego o poción) y
  `PotiCount` (pociones disponibles).
- *Esquiva y telemetría*: `isEnemyDashing`, `isInCorrectDodgeWindow` y `MovInput`.

Estas variables se irán referenciando a lo largo de las secciones siguientes a medida que
se describe cada sistema.

== Ataque melee del jugador

El ataque del jugador se implementó en el componente de combate mencionado previamente.
Al recibirse el `Input Action` `IA_Attack`, antes de ejecutar la acción se comprueba que el
jugador no esté ya atacando ni esquivando y que no se esté reproduciendo el _Animation
Montage_ de reacción a daño (un _Animation Montage_ es una animación reproducible sobre el
personaje, como un ataque o una reacción a un golpe), de modo que el jugador no pueda atacar
mientras recibe un golpe. Si la condición se cumple, se registra el ataque para telemetría y
se ejecuta el _Animation Montage_ del ataque, que contiene una secuencia de tres golpes
consecutivos.

El encadenamiento de golpes (combo) se controla mediante una bandera que representa la
intención del jugador de continuar la secuencia. Si el jugador vuelve a presionar `IA_Attack`
mientras un ataque ya está en curso, no se inicia un ataque nuevo sino que se marca esa
intención, que queda almacenada hasta que la animación alcanza el siguiente punto de decisión.

Dicho punto de decisión se evalúa mediante un _Animation Notify_ (un marcador de evento que
se coloca en un punto específico de una animación y dispara lógica cuando la reproducción lo
alcanza) ubicado al final del primer y segundo golpe. Cada vez que se activa, si el jugador
sigue atacando y mantiene la intención de continuar, la secuencia avanza al siguiente golpe;
en caso contrario, el montage se detiene. Al completarse o interrumpirse, se restablece el
estado de ataque y se restaura el movimiento del personaje.

#figure(
  grid(
    columns: (1fr, 1fr),
    column-gutter: 8pt,
    row-gutter: 8pt,
    image("imagenes/cap5/montageattack_golpe1.png", width: 100%),
    image("imagenes/cap5/montageattack_golpe2.png", width: 100%),
    grid.cell(colspan: 2, align(center,
      image("imagenes/cap5/montageattack_golpe3.png", width: 50%),
    )),
  ),
  caption: [Secuencia de los tres golpes del ataque melee del jugador.],
) <fig:montage-golpes>

Con respecto a la detección de impacto, la implementación se basa en un sistema de _trace_
por temporizador. Un _Animation Notify State_ anclado al montage delimita la ventana en la
que el arma puede golpear, mediante un momento de inicio y uno de fin dentro de la animación.
Durante esa ventana, un temporizador ejecuta cada 0.1 segundos un _Sphere Trace_ entre dos
puntos anclados al arma, que marcan la base y la punta de la hoja; si detecta una colisión
válida, aplica el daño (`SwordDamage`) al actor impactado y se detiene tras el primer impacto
exitoso. Al terminar la ventana, el temporizador se invalida como medida de seguridad por si
el ataque no conectó.

== Proyectiles

Tanto el jugador como el jefe pueden lanzar proyectiles. Es por esto que se decidió crear
un Blueprint Class que represente la base de un proyectil (`BP_BaseProjectile`), para que
después tanto el proyectil del jugador como el del jefe hereden desde esta clase base y
ajusten variables específicas de cada uno. El comportamiento por defecto del proyectil es
avanzar con velocidad constante en línea recta hasta chocar con algo, momento en el cual
reproduce el efecto visual (VFX) y el sonido de impacto correspondientes, aplica daño al
objetivo impactado y se destruye.

El proyectil base expone las variables configurables que cada proyectil concreto ajusta:
velocidad, gravedad, si persigue a su objetivo (_homing_), daño al impactar y los efectos de
partículas y sonido del impacto. Su movimiento lo gestiona un componente `ProjectileMovement`.


#figure(
  image("imagenes/cap5/BP_BaseProj.png", width: 80%),
  caption: [Blueprint del proyectil base.],
) <fig:blueprint-proyectil-base>
El comportamiento por defecto del proyectil base es simple. Al inicializarse, ignora las
colisiones con el actor que lo disparó (para no chocar consigo mismo) y, si tiene la
persecución activada, fija su objetivo. Al impactar con cualquier otro actor que no sea su
dueño, reproduce su efecto de partículas y su sonido de impacto, aplica el daño
correspondiente (atribuido a quien lo disparó) y se destruye.

=== Proyectil del jugador

Uno de los hechizos que puede utilizar el jugador es el de disparar un proyectil,
representado por el Blueprint `BP_PlayerFireBall`, que hereda del proyectil base. Es un
proyectil rápido, sin gravedad y sin persecución, con un efecto de explosión de fuego al
impactar; su aspecto en movimiento se logra con un sistema de partículas en lugar de una
malla.

#figure(
  image("imagenes/cap5/BP_PlayerFireball.png", width: 80%),
  caption: [Blueprint del proyectil del jugador.],
) <fig:bp-playerfireball>




=== Proyectil del jefe

El jefe también lanza proyectiles mediante ciertos ataques. Es más lento que el del jugador, sin
gravedad y con un efecto de explosión de slime. Según el ataque, se usa en dos variantes:
una que avanza en línea recta y otra que persigue activamente al jugador. Además, si tras 5
segundos no ha impactado nada, se autodestruye dejando un efecto de partículas, para que los
proyectiles fallados no queden indefinidamente en la escena.




#figure(
  image("imagenes/cap5/BP_BossSlimeBall.png", width: 80%),
  caption: [Blueprint del proyectil del jefe.],
) <fig:bp-bossslimeball>

== Hechizos y consumibles del jugador

El jugador dispone de dos opciones que puede alternar y utilizar mediante una misma acción:
un hechizo de proyectil de fuego y una poción de vida. Esta mecánica se implementó con el
propósito de otorgar al jugador versatilidad en combate, pudiendo elegir entre una opción
ofensiva y una defensiva, y de proporcionar al jefe la oportunidad de demostrar capacidad de
aprendizaje y adaptación a las diferentes estrategias del jugador.

El jugador puede intercambiar entre el hechizo de fuego y la poción utilizando la rueda del
mouse, y la opción actualmente equipada se muestra representada con un símbolo en la esquina
inferior derecha de la pantalla. La selección se representa mediante la variable
`CurrentSpellIndex`, que cambia al mover la rueda del mouse; además de actualizar el valor,
se modifica la opacidad de la imagen del HUD para reflejar la opción activa.

Cuando el jugador ejecuta la acción de lanzar, el sistema evalúa la variable
`CurrentSpellIndex` para determinar qué opción está equipada. Si corresponde al hechizo de
fuego, se comprueba primero que se disponga del maná necesario antes de invocar el evento
del proyectil; si corresponde a la poción, se invoca directamente el evento de curación,
cuya disponibilidad depende de la cantidad de pociones que posea el jugador.

=== Hechizo de proyectil de fuego

El evento del hechizo de proyectil comienza comprobando que el jugador no esté atacando ni
esquivando, y que no se esté reproduciendo la animación de reacción a daño.
Si la condición se cumple, registra el ataque a distancia en el _Game Instance_ con fines de
telemetría, marca al jugador como atacando y reproduce la animación de lanzamiento, que
corresponde a un _Animation Montage_. Durante la reproducción se desactiva temporalmente el
movimiento del jugador, ya que mientras lanza el proyectil no debe poder desplazarse; el
movimiento se restablece cuando la animación finaliza o es interrumpida.

El proyectil en sí se genera mediante un _Animation Notify_ anclado al montage: en el
instante en que la animación lo indica, se instancia el proyectil del jugador con el jugador asignado como su dueño, de modo que el
proyectil no colisione con quien lo dispara. En ese mismo momento se reproduce el sonido de
lanzamiento y se consume el maná correspondiente.

#figure(
  image("imagenes/cap5/player-casting-firespell.png", width: 80%),
  caption: [Jugador lanzando el hechizo de proyectil de fuego.],
) <fig:hechizo-proyectil>
=== Poción de vida

La poción de vida constituye la opción defensiva del jugador. No restaura la vida de forma
instantánea, sino que requiere que el jugador beba una poción de una cantidad limitada que
posee, representada por la variable `PotiCount` y mostrada en el HUD. El evento
correspondiente comienza comprobando que el jugador no esté atacando ni esquivando, que no
se esté reproduciendo la animación de reacción a daño y, fundamentalmente, que disponga de al
menos una poción.

Si la condición se cumple, se registra el momento de curación en el _Game Instance_ (junto
con la vida actual y máxima del jugador), se decrementa el contador de pociones y se
actualiza el HUD, y se desactiva el movimiento mientras se reproduce la animación de beber,
que corresponde a un _Animation Montage_. Durante la
animación se genera y se ancla la malla de la poción a la mano del jugador, la cual se
destruye una vez finalizada. La restauración de vida se realiza mediante un _Animation
Notify_ anclado al montage: en el momento en que la animación muestra al jugador bebiendo,
se restaura su vida. Al completarse o interrumpirse la animación, se restablece el movimiento
del jugador.



#figure(
  image("imagenes/cap5/player-taking-potion.png", width: 80%),
  caption: [Jugador bebiendo una poción de vida.],
) <fig:pocion-vida>
== Fijado de objetivo <sec:target-lock>

El sistema de fijado de objetivo (_Target Lock_) permite al jugador centrar la cámara sobre
un enemigo y mantenerla orientada hacia él durante el combate, facilitando el seguimiento del
objetivo mientras se ataca o esquiva. Está implementado en el componente `BPC_Combat` y se
reparte entre dos partes: la activación/desactivación del fijado, gestionada por el
`Input Action` `IA_Lock`, y el mantenimiento de la orientación de la cámara, ejecutado en
cada tick.

Al recibirse el `Input Action` `IA_Lock`, el sistema actúa según si ya existe un objetivo
fijado, almacenado en la variable `Target Lock`. Si ya hay un objetivo, se interpreta como
una orden de soltarlo: se limpia la referencia, se restauran los parámetros de rotación del
personaje a su comportamiento normal (orientación según el movimiento) y se destruye el
widget visual del fijado. Si no hay objetivo, se procede a buscar uno: se realiza un
_Sphere Trace_ hacia adelante desde el personaje (con un radio y un alcance determinados);
si dicho trazado detecta un objetivo válido, se almacena en `Target Lock`, se ajustan los
parámetros de rotación para que el personaje se oriente hacia el objetivo, y se genera un
widget (`BP_TargetLockWidget`) que se ancla al enemigo como indicador visual del fijado.

Una vez fijado el objetivo, su seguimiento se realiza en el evento `Tick`. Mientras exista
un objetivo, en cada tick se calcula la rotación necesaria para que la cámara apunte hacia
él y se aplica a la rotación del controlador del jugador. Para obtener el punto exacto al que
mirar, el sistema comprueba si el objetivo implementa la interfaz `BPI_Lockable`: si la
implementa, solicita a través de ella un punto de fijado personalizado, lo que permite que
ciertos enemigos, como aquellos cuya geometría se deforma o cuyo centro visual no coincide
con su origen, definan explícitamente dónde debe apuntar la cámara; si no la implementa, se
utiliza directamente la ubicación del objetivo. Además, mientras el fijado está activo, se
reposiciona en pantalla el widget de la barra de stamina.

Actualmente, la única clase que implementa la interfaz `BPI_Lockable` es el jefe
(`BP_Slime`). Esto se debe a que su animación de ataque de charco desplaza visualmente al personaje hacia abajo, simulando que se hunde o agacha en el charco, sin que dicho desplazamiento se traduzca en un movimiento real del
actor en el mundo. Si la cámara utilizara directamente la ubicación del actor (su origen),
el punto de fijado quedaría desalineado respecto a la posición visual del jefe durante esta
animación. Al implementar `BPI_Lockable`, el jefe puede reportar un punto de fijado ajustado
a su posición visual real en cada momento, manteniendo la cámara correctamente orientada
incluso cuando la animación no coincide con la posición lógica del actor.

#figure(
  image("imagenes/cap5/player-locking-enemy.png", width: 80%),
  caption: [Jugador con un objetivo fijado mediante el sistema de Target Lock.],
) <fig:target-lock>

== Esquiva

La esquiva del jugador está implementada en el componente `BPC_Combat`. Se creó una función
auxiliar (`GetRollMontage`) para determinar qué animación de roll ejecutar, ya que se puede
realizar un roll hacia adelante, hacia atrás, o hacia los lados cuando se tiene un objetivo
fijado mediante el sistema de _Target Lock_.

La función `GetRollMontage` determina cuál de las cuatro animaciones de roll ejecutar a
partir de la dirección de movimiento del jugador. Para ello construye el vector de intención
de movimiento en espacio mundo, combinando la entrada de movimiento (`MovInput`, actualizada
continuamente mediante el `Input Action` `IA_Move`) con la rotación de la cámara (la
rotación del controlador), y lo normaliza. Luego proyecta ese vector sobre el _Forward
Vector_ y el _Right Vector_ del personaje mediante productos punto, y compara las magnitudes
de ambas proyecciones: si la componente hacia adelante/atrás es mayor o igual que la lateral,
el roll se considera frontal; en caso contrario, lateral.

Una vez determinado el eje dominante, el signo del producto punto define el sentido exacto
y, con ello, cuál de las cuatro animaciones de roll se ejecuta; en los rolls laterales se
marca además la variable `isRollingSideWays`.

Adicionalmente, esta función realiza un registro de telemetría específico para las esquivas
frente a una embestida del jefe: si el jefe está embistiendo y el jugador se encuentra en la
zona de tanque, se registra la esquiva indicando si fue lateral o frontal. Esto permite
recopilar métricas diferenciadas sobre cómo responde el jugador ante el ataque de embestida
según la dirección de su evasión.

En cuanto a la lógica del roll: cuando se recibe el `Input Action` `IA_Dash-Roll`, primero
se comprueba que el jugador no esté atacando, que disponga de stamina suficiente y que no se
esté reproduciendo la animación de reacción a daño. Si la condición se cumple, se registra la
esquiva para telemetría, se resta la stamina consumida, se marca al jugador como esquivando,
se reproduce el sonido de esquiva y se ejecuta la animación de roll correspondiente. Durante
la esquiva se bloquea la regeneración de stamina.

Al término de la animación de roll, tanto si se completa como si es interrumpida, se vuelve a
habilitar la regeneración de stamina y se limpian los estados de esquiva, devolviendo al
jugador a un estado neutro desde el cual puede volver a actuar.

Adicionalmente, el sistema distingue si la esquiva se realizó dentro de la ventana de tiempo
considerada como una evasión precisa o "perfecta". Cuando es el caso, se efectúa un registro
extra, lo que permite recopilar métricas sobre las esquivas realizadas con buen _timing_
frente a los ataques enemigos.

Cabe mencionar que todo esto se ejecuta dentro de un nodo _Do Once_, el cual, como bien
indica su nombre, solo se ejecuta una vez hasta que se resetee. El reseteo se realiza después
de 0.45 segundos mediante un nodo _Delay_. Esto permite que el jugador pueda hacer un roll
cada 0.45 segundos, pudiendo así encadenar rolls consecutivos para evadir múltiples ataques.

#figure(
  grid(
    columns: (1fr, 1fr),
    column-gutter: 8pt,
    row-gutter: 8pt,
    image("imagenes/cap5/player-dodge-1.png", width: 100%),
    image("imagenes/cap5/player-dodge-2.png", width: 100%),
    image("imagenes/cap5/player-dodge-3.png", width: 100%),
    image("imagenes/cap5/player-dodge-4.png", width: 100%),
  ),
  caption: [Secuencia de la animación de esquiva del jugador.],
) <fig:roll-adelante>

#figure(
  {
    set par(justify: false)
    let start-end(cnt, w, fill: rgb("#D5E8D4"), stroke-color: rgb("#82B366")) = ellipse(
      width: w, fill: fill, stroke: 1.1pt + stroke-color, inset: 5pt,
      align(center + horizon)[#text(size: 6.3pt)[#cnt]],
    )
    let action(cnt, w) = rect(
      width: w, fill: luma(245), stroke: 0.7pt, radius: 3pt, inset: 5pt,
      align(center + horizon)[#text(size: 6.3pt)[#cnt]],
    )
    let decision(cnt, w, note: none) = {
      let side = w * 0.8
      let items = (
        box(width: w, height: side * 0.85)[
          #place(center + horizon, rotate(45deg, rect(width: side * 0.56, height: side * 0.56, fill: rgb("#FFF2CC"), stroke: 1pt + rgb("#D6B656"))))
          #place(center + horizon, box(width: w * 0.62, align(center)[#text(size: 5.3pt, weight: "bold")[#cnt]]))
        ],
      )
      if note != none {
        items.push(align(center)[#text(size: 5.3pt, style: "italic")[#note]])
      }
      stack(dir: ttb, spacing: 3pt, ..items)
    }
    let outcome(header, effect, w, fill: luma(245)) = rect(
      width: w, fill: fill, stroke: 0.7pt, radius: 3pt, inset: 4pt,
      stack(dir: ttb, spacing: 2pt,
        align(center)[#text(size: 5.8pt, weight: "bold")[#header]],
        align(center)[#text(size: 5.5pt)[#effect]],
      ),
    )
    let arrow = align(center + horizon)[#text(size: 11pt)[→]]
    let panel-title(cnt) = align(center)[#text(size: 10pt, weight: "bold")[#cnt]]

    align(center, block(width: 100%,
      stack(dir: ttb, spacing: 16pt,
        stack(dir: ttb, spacing: 6pt,
          panel-title[Flujo 1 — Registro de esquivas ante ataque de avance],
          grid(columns: (20mm, auto, 18mm, auto, 22mm, auto, 22mm, auto, 26mm, auto, 24mm), column-gutter: 2pt, align: horizon,
            start-end([Inicia ataque de avance], 20mm),
            arrow,
            action([Marca avance activo], 18mm),
            arrow,
            decision([¿Zona tanque?], 22mm, note: [No: fin sin registro]),
            arrow,
            decision([¿Dirección?], 22mm),
            arrow,
            stack(dir: ttb, spacing: 3pt,
              outcome([Lateral], [Registra esquiva lateral], 26mm, fill: rgb("#D5E8D4")),
              outcome([Atrás], [Registra esquiva atrás], 26mm, fill: rgb("#D5E8D4")),
              outcome([Adelante], [No se registra], 26mm),
            ),
            arrow,
            stack(dir: ttb, spacing: 3pt,
              start-end([Termina el avance], 24mm, fill: rgb("#F8CECC"), stroke-color: rgb("#B85450")),
              action([Limpia estado de avance], 24mm),
            ),
          ),
        ),
        line(length: 100%, stroke: 0.5pt + luma(200)),
        stack(dir: ttb, spacing: 6pt,
          panel-title[Flujo 2 — Registro de esquivas ante ataque con ventana de tiempo],
          align(center)[#text(size: 8pt, style: "italic")[Aplicable a: Tanque, Esqueleto]],
          grid(columns: (20mm, auto, 18mm, auto, 22mm, auto, 22mm, auto, 26mm, auto, 22mm), column-gutter: 2pt, align: horizon,
            start-end([Se habilita ventana de esquiva], 20mm),
            arrow,
            action([Puede esquivar correctamente], 18mm),
            arrow,
            decision([¿En ventana?], 22mm, note: [No: sin registro]),
            arrow,
            decision([¿Zona tanque?], 22mm),
            arrow,
            stack(dir: ttb, spacing: 3pt,
              outcome([Sí], [Registra esquiva con delay (global) + zona tanque (pre‑combate)], 26mm, fill: rgb("#D5E8D4")),
              outcome([No], [Registra esquiva con delay (global)], 26mm, fill: rgb("#D5E8D4")),
            ),
            arrow,
            start-end([La ventana se cierra], 22mm, fill: rgb("#F8CECC"), stroke-color: rgb("#B85450")),
          ),
        ),
      ),
    ))
  },
  caption: [Flujos de registro de esquiva: ataque de avance (Flujo 1) y ventana de delay (Flujo 2).],
) <fig:flujo-esquiva>

== Correr

La carrera permite al jugador desplazarse a mayor velocidad a cambio de consumir stamina, y está implementada en el componente `BPC_Combat` mediante el `Input Action` `IA_Run`. A diferencia de otras acciones, esta responde a las distintas fases del input: el momento en que se presiona, mientras se mantiene presionado, y cuando se suelta, lo que permite controlar tanto la activación como el gasto continuo de stamina y el regreso al estado normal.

Como condición común a todas las fases, la carrera solo opera si no se está reproduciendo la animación de reacción a daño, de modo que recibir un golpe interrumpe la posibilidad de correr.

Al presionar el input, si el jugador dispone de stamina suficiente, se aumenta su velocidad
de movimiento y se bloquea la regeneración de stamina mientras corre. Mientras el input se
mantiene presionado, y siempre que quede stamina, esta se consume de forma continua. Al
soltar el input, se restaura la velocidad normal y se vuelve a habilitar la regeneración de
stamina, devolviendo al jugador a su estado de desplazamiento habitual.

#figure(
  image("imagenes/cap5/player running.png", width: 80%),
  caption: [Jugador corriendo.],
) <fig:jugador-corriendo>

== Interactuar

La interacción del jugador con elementos del entorno está implementada en el componente
`BPC_Combat` mediante el `Input Action` `IA_MyInteract`. Actualmente está orientada a las
palancas: al recibirse el input, si el jugador tiene una palanca al alcance y esta no ha
sido usada aún, se activa, reproduciendo su animación y ejecutando el efecto asociado.

El funcionamiento interno de las palancas se detalla en la sección
@sec:elementos-nivel.

== Menú de pausa

El acceso al menú de pausa está implementado en el componente `BPC_Combat` mediante el
`Input Action` `IA_EscapeMenu`. Al recibirse el input, si el juego no está ya pausado, se
muestra el widget del menú de pausa (`WB_PauseMenu`), se libera el cursor del mouse para
poder navegarlo y se pausa el juego.
#figure(
  image("imagenes/cap5/pause-menu.png", width:80%),
  caption: [Menú de pausa del juego.],
) <fig:menu-pausa>


== Widgets del jugador

La interfaz de usuario asociada al jugador se compone de varios _Widget Blueprints_, cada
uno encargado de mostrar un aspecto específico del estado del jugador o de gestionar una
pantalla concreta. La mayoría de estos widgets se actualizan desde la lógica de juego ya
descrita, principalmente desde el componente `BPC_Stats`, por lo que su Blueprint interno
es mínimo y se limitan a su composición visual.

#figure(
  image("imagenes/cap5/player-widgets.png", width: 80%),
  caption: [HUD del jugador en juego.],
) <fig:player-hud>

El widget principal es el HUD del jugador (`WB_PlayerHUD`, @fig:player-hud), un contenedor
que dispone en pantalla la barra de vida, la barra de maná y el widget de equipamiento.
Las barras de vida y maná no
tienen lógica propia: su valor se actualiza directamente desde la función `IncreaseVal` de
`BPC_Stats`. El widget de equipamiento muestra el hechizo de fuego y la poción junto con la
cantidad de pociones restantes, actualizados desde `BPC_Combat`. Por último, el widget de
fijado de objetivo (`WB_TargetLock`) es un ícono que se ancla sobre el enemigo fijado
(@sec:target-lock).

=== Barra de stamina (`WB_PlayerStamina`)

A diferencia de las barras de vida y maná, la barra de stamina sí posee lógica propia en su
Blueprint, ya que se representa mediante un material en lugar de una _Progress Bar_ estándar.
El widget se compone de una única imagen a la que se le aplica un material
dinámico, lo que permite representar la barra de stamina con una forma circular.

Su nivel se actualiza mediante la función `SetPercent`, que ajusta el parámetro `Percent`
del material dinámico según la stamina actual del jugador.

#figure(
  image("imagenes/cap5/stamina_widget.png", width: 20%),
  caption: [Barra de stamina circular del jugador.],
) <fig:stamina-widget>

=== Widget del menú de pausa (`WB_PauseMenu`)

El widget del menú de pausa presenta dos botones dispuestos verticalmente: reanudar y
volver al menú principal. Al presionar reanudar, se quita la pausa, se restablece el control
al jugador y se elimina el widget, devolviéndolo al combate. Al presionar el de menú
principal, se reanuda el juego y se carga el nivel del menú principal.

El aspecto visual de este widget puede verse en la @fig:menu-pausa.

=== Pantalla de derrota (`WB_TryAgain`)

Esta pantalla se muestra cuando el jugador es derrotado e incluye un mensaje de "Game Over"
junto con dos botones: reintentar y volver al menú principal. Al presionar reintentar, se
reanuda el juego, se incrementa el contador
de intentos almacenado en el `SlimeGameInstance`, dato relevante para el
seguimiento del estudio, y se recarga el nivel actual, permitiendo al jugador volver a
enfrentar el combate. Al presionar el botón de menú principal, se reanuda el juego y se carga
el nivel del menú principal.

El aspecto visual de esta pantalla puede verse en la @fig:pantalla-muerte, mostrada previamente en la sección de recepción de daño y muerte.

== Enemigos

Los modelos de los enemigos regulares y algunos props del juego se obtuvieron de Sketchfab
y del Fab de Epic Games. Las animaciones de estos enemigos se generaron con Mixamo, un 
servicio que permite aplicar animaciones de forma automática sobre modelos 3D. El
jefe es la excepción: su modelo y animaciones fueron creados desde cero por el autor, como
se describe en la @sec:modelo-animaciones-jefe.

=== Esqueleto normal

El enemigo más simple del juego es el esqueleto normal (`BP_Skeleton`), un enemigo de
combate cuerpo a cuerpo cuya estructura de componentes y comportamiento sientan la base
sobre la cual se construyen los demás enemigos. Su estructura reúne los componentes
habituales de un personaje de Unreal (cápsula de colisión como raíz, malla esquelética,
movimiento y una barra de vida), más un componente `PawnSensing` para detectar al jugador y
dos puntos de escena en la espada (`StartOfTrace` y `EndOfTrace`) que delimitan el _trace_
de impacto de su ataque.


#figure(
  image("imagenes/cap5/BP_Skeleton.png", height: 40%),
  caption: [Blueprint perteneciente al esqueleto normal],
) <fig:bp-skeleton>


==== Comportamiento general

Al iniciarse, el esqueleto inicializa su barra de vida al 100% y
almacena su posición de aparición en la _Blackboard key_ `spawnPoint` (una variable del
_Blackboard_, la estructura de datos compartida del sistema de IA del jefe), la cual utiliza
posteriormente para regresar a su punto de origen.

La detección del jugador se gestiona mediante el evento `On See Pawn` del componente
`PawnSensing`. Al detectar al jugador, el esqueleto invoca una función auxiliar
(`hasseen`) que verifica que el actor detectado sea efectivamente el jugador y, de ser así,
marca la _Blackboard key_ `hasSeenPlayer?` como `true`. Esta misma función auxiliar es
invocada también desde el evento de recepción de daño, descrito a continuación.

Adicionalmente, al detectar al jugador se inicia un temporizador en bucle de 0.5 segundos
que dispara un evento encargado de obtener la referencia al `SlimeGameInstance` e invocar
`RegisterDistance`, pasando como parámetro la distancia actual entre el esqueleto y el
jugador. Este mecanismo, compartido con el esqueleto caballero descrito más adelante, es el
que alimenta las variables de distancia de la sección de métricas y telemetría durante la
fase previa al combate contra el jefe.

==== Recepción de daño y muerte

El procesamiento de daño se centraliza en el evento `ReceiveAnyDamage`. Al recibir daño, en
primer lugar se invoca `hasseen` sobre el causante, de modo que un golpe del jugador también
provoca que el esqueleto lo detecte aunque no lo hubiera visto antes. A continuación se resta
el daño a la vida del esqueleto y se actualiza el porcentaje de su barra de vida.

Si la vida resultante es menor o igual a cero, el esqueleto reproduce un sonido de muerte e
invoca el delegado `OnEnemyDied` (escuchado por el Level Blueprint de `Lvl_Tutorial`) antes
de destruirse. Además, invoca la función `RemoveWidget` sobre el jugador para eliminar el
indicador de _Target Lock_ sobre este enemigo, en caso de que lo tuviera fijado al momento de
morir.


==== Ataque

El ataque del esqueleto utiliza el mismo patrón de detección por temporizador que el ataque
del jugador: la ventana de impacto está delimitada por un _Anim Notify State_ que dispara
`BeginSwordTrace` y `EndSwordTrace`, y durante ella un _Sphere Trace_ periódico detecta la
colisión y se detiene tras el primer impacto. El daño aplicado se define en la variable
`skeleton_damage`.

==== Behaviour Tree

El Behaviour Tree es el sistema de Unreal Engine utilizado para
modelar el comportamiento de un agente de IA mediante una estructura jerárquica de nodos. Se
compone de nodos compuestos, como _Selectors_ y _Sequences_, que determinan el orden y las
condiciones bajo las cuales se ejecutan sus nodos hijos; de tareas (_Tasks_), que representan
acciones concretas ejecutadas por el agente; y de decoradores y servicios, que agregan
condiciones o lógica auxiliar a otros nodos. En cada tick, el árbol se recorre desde la raíz,
evaluando los nodos según su tipo hasta determinar qué acción ejecutar.

El esqueleto utiliza un Behaviour Tree (`BT_AI`) con una estructura simple de tipo
Selector, que evalúa dos secuencias según el estado de la _Blackboard key_
`hasSeenPlayer?`:

- Si `hasSeenPlayer?` no está activa, se ejecuta la secuencia "Look Around": el esqueleto
  deambula por el área cercana a su punto de aparición (`BTTask_RoamAround`) y espera 2
  segundos antes de repetir el ciclo.
- Si `hasSeenPlayer?` está activa, se ejecuta la secuencia "Chase Player": el esqueleto
  persigue al jugador hasta alcanzar la distancia de ataque (`BTTask_ChaseB4Attack`) y luego
  ejecuta su ataque con espada (`BT_TaskSWORDAttack`). El detalle de cada una de estas
  tareas se describe a continuación.

Como se adelantó, el Blackboard funciona como una pizarra donde el Behaviour Tree y el
AI Controller escriben y leen valores que representan el estado actual de la IA,
permitiendo que distintos componentes trabajen con la misma información sin comunicarse
directamente entre sí.

El Blackboard asociado (`BBD_AI`) contiene las siguientes _keys_:

+ `SelfActor` (Object): referencia al propio enemigo.
+ `hasSeenPlayer?` (Bool): indica si el enemigo ha detectado al jugador.
+ `IsDead?` (Bool): indica si el enemigo está muerto.
+ `spawnPoint` (Vector): posición de origen, utilizada como punto de patrulla.
+ `distanceToPlayer` (Float): distancia actual respecto al jugador.

#figure(
  image("imagenes/cap5/BT_Skeleton.png", width: 90%),
  caption: [Behaviour Tree del esqueleto normal (`BT_AI`).],
) <fig:bt-skeleton>


==== Tareas del Behaviour Tree

- `BTTask_RoamAround` selecciona, mediante `Get Random Reachable Point In Radius`, un punto
  alcanzable aleatorio dentro de un radio de 500 unidades alrededor de la posición guardada
  en `spawnPoint`, y mueve al esqueleto hacia dicho punto con un radio de aceptación de 120
  unidades.

- `BTTask_ChaseB4Attack` mueve al enemigo hacia el jugador hasta alcanzar una distancia
  determinada por la variable `Acceptance Radius`, finalizando la tarea al llegar o al fallar
  el movimiento. Esta tarea es compartida con el esqueleto mago, el cual altera su
  comportamiento mediante la variable `infiniteRange` (descrita en la sección
  correspondiente a dicho enemigo); el esqueleto normal no la utiliza.

- `BT_TaskSWORDAttack` gestiona el ataque cuerpo a cuerpo del esqueleto en dos partes. Al
  activarse la tarea, marca la variable interna `onRotate` como `true`
  y reproduce el montage de ataque (`MO_Attack`) sobre el esqueleto; en el instante en que
  la animación lo indica (_Animation Notify_), `onRotate` se marca nuevamente como `false`.
  Por otro lado, mientras la tarea está activa, si `onRotate` es `true`,
  el esqueleto rota suavemente hacia la posición del jugador en cada tick, interpolando
  su rotación actual hacia la calculada. De esta forma, el esqueleto se orienta hacia el
  jugador mientras se prepara para golpear, pero deja de hacerlo justo en el instante del
  impacto, evitando que el golpe se desvíe por una rotación a mitad de la animación. Al
  completarse el montage, la tarea finaliza exitosamente.

#figure(
  grid(
    columns: (1fr, 1fr, 1fr),
    column-gutter: 8pt,
    image("imagenes/cap5/skeleton_attack1.png", width: 100%),
    image("imagenes/cap5/skeleton_attack2.png", width: 100%),
    image("imagenes/cap5/skeleton_attack3.png", width: 100%),
  ),
  caption: [Secuencia de los tres golpes del ataque cuerpo a cuerpo del esqueleto.],
) <fig:skeleton-ataque>



//TODO: En algun ladom no necesariamente aca, mencionar el tema como se anclo los static mesh de las armas a los juagdores
=== Esqueleto mago

El esqueleto mago (`BP_SkeletonMage`) comparte la base estructural y gran parte de la lógica
del esqueleto normal, descrita en la sección anterior, por lo que a continuación solo se
detallan las diferencias respecto a dicho enemigo.

==== Estructura y detección

La jerarquía de componentes es equivalente a la del esqueleto normal: cápsula de colisión
con barra de vida, malla esquelética con componentes de escena para el trace de impacto
cuerpo a cuerpo, componente de movimiento y `PawnSensing`.

La detección del jugador, sin embargo, incorpora una verificación adicional. Al activarse el
evento `On See Pawn`, antes de marcar al jugador como detectado se comprueba que la
diferencia de altura (eje Z) entre el mago y el jugador no supere las 300 unidades. Esta
verificación evita que el mago detecte y reaccione al jugador cuando este se encuentra en un
piso o nivel de altura distinto.

==== Behaviour Tree

El Behaviour Tree del mago reutiliza la secuencia "Look Around" del esqueleto
normal (`BTTask_RoamAround` + espera de 2 segundos) cuando no ha detectado al jugador. Una
vez detectado, en lugar de una única secuencia de persecución y ataque, el mago evalúa un
segundo Selector que distingue dos comportamientos según la distancia al jugador, mantenida
actualizada mediante un servicio (`BTS_MageUpdt`) que corre en paralelo a ambas secuencias y
que, en cada tick, calcula la distancia entre el mago y el jugador y la almacena en la
_Blackboard key_ `distanceToPlayer`:

- *Secuencia "FarSeq"* (distancia mayor a 280 unidades): el mago se acerca al jugador
  mediante `BTTask_ChaseB4Attack`, la misma tarea utilizada por el esqueleto normal. En
  algunos casos, según la configuración del mago en cuestión, la variable `infiniteRange`
  puede estar activada, lo que provoca que el `AIMoveTo` subyacente reciba un radio de
  aceptación extremadamente amplio y la tarea se dé por completada de inmediato sin que el
  mago se desplace efectivamente. A continuación, ejecuta `MagicAttack`, descrito más abajo.
- *Secuencia "CloseSeq"* (distancia menor o igual a 280 unidades): el mago ejecuta
  directamente `CloseMage`, su ataque cuerpo a cuerpo, descrito más abajo.

La decisión entre ambas secuencias se evalúa mediante la tarea `Task_MageDist`, la cual
finaliza con éxito si la distancia actual al jugador (_Blackboard key_
`distanceToPlayer`) es menor estricta que `max_dist` y, a la vez, mayor o igual que
`min_dist`, es decir, si cae dentro del rango `[min_dist, max_dist)` propio de la
secuencia evaluada, y con fracaso en caso contrario.

#figure(
  image("imagenes/cap5/BT_MageSkeleton.png", width: 60%),
  caption: [Behaviour Tree del esqueleto mago.],
) <fig:bt-mago>

==== Ataque a distancia (`MagicAttack`)

Al activarse esta tarea, se marca la variable `onRotate` como `true` y se reproduce el
montage `MO_MagicAttack`. Mientras `onRotate` es `true`, en cada tick el mago interpola su rotación hacia la
posición del jugador, de forma
idéntica al sistema de orientación visto en el ataque del esqueleto normal. En el instante
indicado por un _Animation Notify_ del montage, `onRotate` se marca como `false`, deteniendo
la rotación, y se instancia un proyectil (`BP_SkeletonBall`) desde una posición desplazada
300 unidades hacia adelante respecto al mago, con este último asignado como su dueño. El proyectil se configura con una velocidad de 800, sin influencia de gravedad,
sin comportamiento de persecución (_Homing_ desactivado), y un daño base de 15. Al
completarse el montage, la tarea finaliza exitosamente.

#figure(
  image("imagenes/cap5/range_attack_mage.png", width: 80%),
  caption: [Ataque a distancia del esqueleto mago.],
) <fig:mago-proyectil>

==== Ataque cuerpo a cuerpo (`CloseMage`)

Cuando el jugador se encuentra a corta distancia, el mago recurre a un ataque cuerpo a
cuerpo con su báculo. La tarea `CloseMage` reproduce el montage `MO_CloseStaff` y rota hacia
el jugador mientras se prepara, mediante el mismo mecanismo de interpolación que su ataque a
distancia.

Su detección de impacto reutiliza el mismo sistema de _trace_ por temporizador descrito para
el esqueleto normal, con la única diferencia de que el daño es un valor fijo de 11. El ataque
a distancia, en cambio, no usa este mecanismo: su detección recae en el propio proyectil al
colisionar.

#figure(
  grid(
    columns: (1fr, 1fr, 1fr),
    column-gutter: 8pt,
    image("imagenes/cap5/skeleton_staffattack1.png", width: 100%),
    image("imagenes/cap5/skeleton_staffattack2.png", width: 100%),
    image("imagenes/cap5/skeleton_staffattack3.png", width: 100%),
  ),
  caption: [Secuencia del ataque cuerpo a cuerpo del esqueleto mago.],
) <fig:mago-staffattack>

=== Esqueleto caballero

El esqueleto caballero (`BP_KnightSkele`) comparte la estructura de componentes y gran
parte del comportamiento base del esqueleto normal: cápsula de colisión con barra de
vida, malla esquelética con componentes de escena para el _trace_ de impacto
(`StartTrace`/`EndTrace`), componente de movimiento y `PawnSensing`; por lo que a
continuación solo se detallan las diferencias respecto a dicho enemigo. Este enemigo se
ubica en el nivel `Lvl_PreBoss`, donde, junto con el esqueleto normal, alimenta la
métrica de distancia previa al combate contra el jefe.

==== Detección y registro de distancia

La detección del jugador y el registro de distancia funcionan igual que en el esqueleto
normal; la única diferencia es que la distancia registrada corresponde a la posición del
propio caballero respecto al jugador.

==== Recepción de daño y muerte

El procesamiento de daño y muerte es idéntico al del esqueleto normal, salvo que el
caballero no reproduce sonido de muerte (igual que el esqueleto mago).

==== Ataque cuerpo a cuerpo

El ataque cuerpo a cuerpo es idéntico al del esqueleto normal, la única diferencia es la variable
de daño empleada, `KnightDamage`, la cual es levemente mayor que la del esqueleto normal.

==== Behaviour Tree

El Behaviour Tree del caballero reutiliza la secuencia "Look Around"
(`BTTask_RoamAround` + espera de 2 segundos) cuando no ha detectado al jugador, y la tarea
`BTTask_ChaseB4Attack`, sin la variable `infiniteRange`, al igual que el esqueleto
normal, para acercarse a él una vez detectado. A diferencia de los esqueletos anteriores,
tras la persecución el caballero no ejecuta una única tarea de ataque, sino que entra a un
nodo compuesto personalizado llamado "Alternating Selector", con dos ramas: `Attack 1`
(tarea `KnightAttack1` seguida de una espera de 1 segundo) y `Attack 2` (tarea
`KnightAttack2` seguida de una espera de 1 segundo).

===== Selector alternante de ataques

El nodo "Alternating Selector" corresponde a la clase `UBTComposite_RandomSelector`,
implementada en C++. A pesar de que el nombre de la clase sugiere una selección
aleatoria, su lógica no es aleatoria: en cada ejecución elige el
hijo siguiente al último ejecutado mediante el operador módulo sobre la cantidad de
hijos, partiendo del hijo 0 la primera vez. Es decir, el nodo alterna de forma determinística entre `Attack 1` y `Attack 2` en cada
ciclo, en lugar de elegir entre ellos al azar.

#figure(
  image("imagenes/cap5/BT_Knight.png", width: 90%),
  caption: [Behaviour Tree del esqueleto caballero.],
) <fig:bt-caballero>

===== Tareas `KnightAttack1` y `KnightAttack2`

Ambas tareas comparten una misma estructura. Al activarse, el caballero rota hacia el
jugador mientras reproduce su montage de ataque: `MO_AvanceV3` (a velocidad 1.0) en
`KnightAttack1` y `MO_AOEKnightV3` (a velocidad 1.2) en `KnightAttack2`.

Al completarse el montage, la tarea finaliza con éxito. En el instante señalado por un único
_Animation Notify_, el caballero deja de rotar y, a diferencia del ataque con espada por
temporizador, ejecuta un único _Box Trace_ (sin bucle) entre dos puntos ubicados a 150 y 225
unidades delante de él, en la dirección de su vector hacia adelante. La forma de la caja del trace difiere entre ambas tareas: en
`KnightAttack1` es un cubo de 50×50×50 unidades, mientras que en `KnightAttack2` es una
caja de 30×80×50 unidades, más ancha. De detectarse una colisión válida, se aplica daño
mediante `ApplyDamage`, con un valor fijo de 20 en ambas tareas (a diferencia de la
variable `KnightDamage`, utilizada en el ataque con espada).

Mientras la tarea está activa, y siguiendo el mismo patrón visto en el
resto de los enemigos, el caballero interpola suavemente su rotación hacia el jugador mientras `onRotate` sea
`true`, deteniéndose
justo en el instante del impacto.

#figure(
  grid(
    columns: (1fr, 1fr),
    column-gutter: 8pt,
    row-gutter: 8pt,
    image("imagenes/cap5/knightdash1.png", width: 100%),
    image("imagenes/cap5/knightdash2.png", width: 100%),
    image("imagenes/cap5/knightdash3.png", width: 100%),
    image("imagenes/cap5/knightdash4.png", width: 100%),
  ),
  caption: [Secuencia del ataque de avance del esqueleto caballero.],
) <fig:knight-dash>

== Jefe

=== Modelo y animaciones <sec:modelo-animaciones-jefe>

El modelo y las animaciones del jefe fueron creados desde cero en Blender. La motivación
principal fue contar con un control total sobre el resultado, de modo que el modelo y sus animaciones
pudieran ajustarse específicamente a los requerimientos de _gameplay_ del jefe, en
particular a los _Anim Notify States_ que delimitan las ventanas de ataque y a las
distintas formas que necesita adoptar durante el combate.

Dado que el slime no posee un esqueleto tradicional, gran parte de sus deformaciones se
modelaron mediante _shape keys_ (deformaciones predefinidas de la malla), tanto para las distintas formas que puede adoptar el
cuerpo (por ejemplo, su forma de charco, o su forma de espinas) como para las acciones propias
de cada ataque.

=== Componentes y variables

Además de los componentes habituales de un personaje (cápsula de colisión, malla
esquelética y movimiento), `BP_Slime` incluye el componente `PlayerMetrics`
(`PlayerMetricsComponent`, descrito en @sec:metricas), dos puntos de escena en su malla
(`StartTracePos` y `EndTracePos`) que delimitan el _trace_ de su ataque cuerpo a cuerpo, y
un volumen de colisión esférico `PULL_OUT` que detecta si el jugador quedó atrapado dentro
del jefe tras ciertos ataques (ver @sec:tareas-ataque-jefe).

Adicionalmente, `BP_Slime` implementa la interfaz `BPI_Lockable`, consultada por el
sistema de fijado de objetivo del jugador (@sec:target-lock) para obtener el punto exacto
al que debe apuntar la cámara mientras el jefe está fijado. Su función
`Get Lock On Target` retorna una posición desplazada hacia abajo respecto a la
ubicación del actor: 300 unidades en el eje Z si `bIsCharco` es `true`, o 100
unidades si es `false`.

Sus variables propias son la vida (`health` y `max_health`), la referencia a su barra de
vida (`progressbarref`) y la bandera `bIsCharco`, que indica si el jefe se encuentra en su
forma de charco.

#figure(
  image("imagenes/cap5/blueprint-del-jefe.png", width: 80%),
  caption: [Blueprint del jefe (`BP_Slime`).],
) <fig:blueprint-jefe>

=== AI Controller <sec:activacion-jefe>

El AI Controller del jefe (`BP_SlimeBossController`) expone una función llamada
`ActivateBossController`, invocada desde la zona de activación (`BP_ZonaEntradaJefe`,
ver sección @sec:entrada-jefe) al inicio de la arena del jefe. Al ejecutarse, esta
función arranca el Behaviour Tree (`BT_BaseSlimeBoss`), registra la referencia al
jugador en el Blackboard (`PlayerActor`) e invoca `ApplyPreCombatAdaptation` sobre
el `PlayerMetricsComponent`, aplicando los ajustes de pesos de ataque derivados de
las métricas recolectadas durante la fase previa al combate. Finalmente, vuelca
el estado resultante de los pesos a archivo mediante `DumpFinalTreeToFile`, tal
como se describió en la sección @sec:metricas.

=== Blackboard

El Blackboard del jefe (`BBD_SlimeBoss`) contiene las siguientes _keys_:

+ `SelfActor` (Actor): referencia al propio jefe.
+ `PlayerActor` (Actor): referencia al jugador detectado.
+ `PlayerDistance` (Float): distancia actual al jugador.
+ `LastAttack` (Enum `EBossAttackType`): último ataque ejecutado.
+ `LastAttackCount` (Integer): veces consecutivas que se ha repetido `LastAttack`.
+ `AttackWeightsJSON` (String): pesos de los ataques en formato JSON.
+ `CloseRange`, `FarRange` (Float): umbrales que definen los rangos cercano y lejano del jefe.
+ `0-KEY`, `FAR-KEY` (Float): valores fijos (0 y ~9999) usados para anular una de las cotas
  en la tarea genérica de chequeo de distancia.
+ `BossChaseDur` (Float): duración del estado de persecución del jefe.

Los valores fijos `0-KEY` y `FAR-KEY` permiten reutilizar una misma tarea de chequeo de
distancia para las tres secuencias de rango: cuando una secuencia no necesita límite
inferior usa `0-KEY`, y cuando no necesita límite superior usa `FAR-KEY`, en lugar de
implementar una tarea distinta para cada caso.

=== Behaviour Tree

El Behaviour Tree del jefe se organiza en niveles jerárquicos. El nodo raíz conecta con
un Selector principal que evalúa tres secuencias según la distancia al jugador
(_Blackboard key_ `PlayerDistance`, actualizada por el service `BTS_UPDTPlayerDistance`
descrito más arriba), intentando cada una en orden hasta que alguna tiene éxito:

+ *Secuencia lejana*: distancia mayor a `FarRange`.
+ *Secuencia media*: distancia entre `CloseRange` y `FarRange`.
+ *Secuencia cercana*: distancia menor a `CloseRange`.

Dentro de cada secuencia, un nodo `Task_SelectDistance` confirma que la distancia
actual cumple el rango correspondiente y, a continuación, un nodo
`BTComposite_RandomSelector`, descrito en la siguiente sección, con una instancia por
cada secuencia, reparte mediante selección aleatoria ponderada entre un subconjunto de
los nueve ataques del jefe (ver @tbl:ataques-jefe en el capítulo 3).

Por su tamaño, el árbol completo se presenta dividido en cuatro capturas (@fig:bt-jefe): la
raíz con el Selector principal y sus tres secuencias de rango, y el detalle de cada una de las
secuencias lejana, media y cercana.

#figure(
  grid(
    columns: (1fr, 1fr, 1fr),
    column-gutter: 8pt,
    row-gutter: 8pt,
    grid.cell(colspan: 3, image("imagenes/cap5/BT_SEPARADO_ROOT_W_SEQUENCES.png", width: 100%)),
    image("imagenes/cap5/BT_SEPARADO_FAR_RANGE.png", width: 100%),
    image("imagenes/cap5/BT_SEPARADO_MIDDLE_Range.png", width: 100%),
    image("imagenes/cap5/BT_SEPARADO_CLOSE_Range.png", width: 100%),
  ),
  caption: [Behaviour Tree del jefe (`BT_BaseSlimeBoss`). Arriba, la raíz con el Selector
    principal y sus tres secuencias de rango; abajo, el detalle de cada secuencia: lejana
    (proyectil dirigido, proyectil, persecución y charco), media (ataque básico, pesado y
    látigo) y cercana (ataque básico, de área y de muro).],
) <fig:bt-jefe>

==== BTComposite_RandomSelector (C++)

La elección del ataque dentro de cada secuencia de rango se gestiona mediante un nodo
compuesto personalizado implementado en C++. A diferencia de un Selector convencional, que
recorre sus hijos en orden hasta que uno tiene éxito, este nodo elige un único hijo
mediante una selección aleatoria ponderada y, una vez que dicho hijo termina de
ejecutarse, retorna directamente a su padre, sin intentar el resto de sus hijos.

La selección asigna a cada hijo un peso base de 1.0, el cual es
sobrescrito si existe una entrada con su nombre dentro del JSON almacenado en la
_Blackboard key_ `AttackWeightsJSON` (ver @sec:pesos-ataque). Sobre estos pesos se
aplica además una regla anti-repetición: si el último ataque ya se ejecutó dos veces
seguidas, su peso se fuerza a 0, impidiendo que se seleccione una tercera vez consecutiva. Sobre el arreglo de pesos resultante se realiza un sorteo
aleatorio ponderado para elegir el hijo a ejecutar.

Tras la selección, se actualiza el Blackboard: si el ataque elegido es el mismo que el
anterior, se incrementa `LastAttackCount`; en caso contrario, `LastAttack` se actualiza
al nuevo ataque y `LastAttackCount` se reinicia a 1.

En la raíz del Behaviour Tree corre un service (`BTS_UPDTPlayerDistance`), análogo
al `BTS_MageUpdt` del esqueleto mago, que en cada tick calcula la distancia
entre el jefe y el jugador y la almacena en la _Blackboard key_ `PlayerDistance`.

==== Tareas de ataque <sec:tareas-ataque-jefe>

El jefe cuenta con nueve tareas de ataque distintas, identificadas mediante el enum
`EBossAttackType` (`BA_BasicAttack`, `BA_AOEAttack`, `BA_HeavyAttack`,
`BA_ProjectilAttack`, `BA_BossChase`, `BA_Poddle`, `BA_HomingAttack`, `BA_WhipAttack`,
`BA_WallAttack`), seleccionadas por el `BTComposite_RandomSelector` descrito en la
sección anterior.

===== Ataque básico (`BA_BasicAttack`)

Al activarse la tarea, se registra el intento de ataque
y se reproduce el montage `MO_FixBasicAttack`, deteniendo cualquier otro montage en
reproducción. Al completarse o interrumpirse el montage, la tarea
finaliza con éxito. En el instante señalado por un único _Animation Notify_, se
ejecuta un único _Box Trace_ (sin temporizador en bucle) sobre una caja estática de
100×100×100 unidades, centrada 200 unidades hacia adelante de la posición del jefe y
orientada según su rotación; de detectarse una colisión válida, se aplica un daño
fijo de 10.

#figure(
  grid(
    columns: (1fr, 1fr),
    column-gutter: 8pt,
    row-gutter: 8pt,
    image("imagenes/cap5/slimebasicattack-1.png", width: 100%),
    image("imagenes/cap5/slimebasicattack-2.png", width: 100%),
    grid.cell(colspan: 2, align(center,
      image("imagenes/cap5/slimebasicattack-3.png", width: 50%),
    )),
  ),
  caption: [Secuencia del ataque básico del jefe.],
) <fig:slime-basic-attack>

===== Ataque de área (`BA_AOEAttack`)

Al activarse, se registra el intento de ataque y se reproduce el montage
`MO_SpykeV4`. Al completarse o interrumpirse, la tarea finaliza con éxito. En el
instante señalado por el _Animation Notify_, se ejecuta un _Sphere Trace_ de radio
370 unidades centrado en la posición del jefe; de detectarse una colisión válida, se
aplica un daño definido por la variable `SpykeDmg`.

#figure(
  grid(
    columns: (1fr, 1fr),
    column-gutter: 8pt,
    image("imagenes/cap5/slimespikeattack-1.png", width: 100%),
    image("imagenes/cap5/slimespikeattack-2.png", width: 100%),
  ),
  caption: [Secuencia del ataque de espinas del jefe.],
) <fig:slime-aoe-attack>

===== Ataque pesado (`BA_HeavyAttack`)

El ataque pesado corresponde a un ataque con salto. Al activarse, se registra el
intento de ataque y se almacenan, como instantánea (_snapshot_, sin actualizarse
posteriormente), la posición inicial del jefe y la posición del jugador en ese
momento. El jefe pasa a modo de movimiento `Flying` y deja de colisionar con Pawns,
y reproduce el montage `MO_JumpAttackV3`. Transcurridos 0.9 segundos desde el inicio
del montage, el jefe comienza a desplazarse en cada tick hacia la posición guardada
del jugador y a rotar hacia ella. En el instante señalado por el _Animation Notify_, se
ejecuta un _Sphere Trace_ de radio 450 centrado en la posición del jefe; de
detectarse una colisión válida, se aplica un daño de 10 al actor impactado y, si
dicho actor es el jugador, se cancelan sus montages de esquive y se lo lanza por los
aires en la dirección que va desde el jefe hacia el jugador, con una velocidad de
3000 tanto en el plano horizontal como en el vertical.

Al completarse o interrumpirse el montage, el jefe vuelve a modo `Walking`, restaura
su colisión con Pawns y, si completó normalmente, comprueba si quedó atrapado contra
algún actor mediante el componente `PULL_OUT`, de la misma forma descrita para el
ataque de charco (`BA_Poddle`) más abajo, antes de finalizar la tarea con éxito.

#figure(
  grid(
    columns: (1fr, 1fr),
    column-gutter: 8pt,
    row-gutter: 8pt,
    image("imagenes/cap5/slimejumpattack-1.png", width: 100%),
    image("imagenes/cap5/slimejumpattack-2.png", width: 100%),
    image("imagenes/cap5/slimejumpattack-3.png", width: 100%),
    image("imagenes/cap5/slimejumpattack-4.png", width: 100%),
  ),
  caption: [Secuencia del ataque de salto del jefe.],
) <fig:slime-heavy-attack>

===== Ataque de proyectil (`BA_ProjectilAttack`)

Al activarse, se reproduce el montage `MO_ProjectileAttack`. Al completarse o
interrumpirse, la tarea finaliza con éxito. En el instante señalado por el
_Animation Notify_, se recorre un arreglo fijo de desviaciones angulares (0°, 15°,
-15°, 30°, -30°, 45° y -45°) y, por cada una, se instancia un proyectil
(`BP_BossSlimeBall_C`) 100 unidades por debajo de la posición del jefe, con su
rotación compuesta a partir de la desviación correspondiente y la rotación del
jefe, generando un disparo en abanico de siete proyectiles. Cada proyectil se
configura con el jefe como dueño (_Owner_), velocidad 1000, sin gravedad, sin
comportamiento de persecución (_Homing_ desactivado) y un daño base de 10. Mientras
la tarea está activa, el jefe rota hacia el jugador con una velocidad de interpolación de 0.5.

A diferencia del resto de las tareas de ataque, ni esta ni el ataque homing
(`BA_HomingAttack`, descrito más abajo) invocan `RegisterBossAttackAttempt`: al
tratarse de ataques a distancia, no es directo determinar si efectivamente
conectaron con el jugador, por lo que no se registran en las métricas de ataque.

#figure(
  grid(
    columns: (1fr, 1fr),
    column-gutter: 8pt,
    image("imagenes/cap5/slimeproyectileattack-1.png", width: 100%),
    image("imagenes/cap5/slimeproyectileattack-2.png", width: 100%),
  ),
  caption: [Secuencia del ataque de proyectil del jefe.],
) <fig:slime-projectil-attack>

===== Persecución (`BA_BossChase`)

Al activarse, esta tarea mueve al jefe hacia el jugador con un radio de aceptación
propio de la tarea. En paralelo, corre un temporizador de una duración también propia
de la tarea, que actúa como límite de tiempo. Si el temporizador se completa primero,
se detiene el movimiento y la tarea finaliza con éxito. Si el movimiento llega al
destino primero, se ejecuta ese mismo bloque de detención y finalización.



===== Charco (`BA_Poddle`)

Esta tarea hace uso de la forma de charco del jefe, modelada mediante _shape keys_
(ver @sec:modelo-animaciones-jefe). Al activarse, se registra el intento de ataque,
se ajusta la velocidad de movimiento a 600 y se desactiva la colisión del jefe
contra Pawns y contra dos canales de colisión adicionales del proyecto. Se
reproduce el montage `MO_PoddleStart`, se inicia el movimiento hacia el jugador (sin
radio de aceptación), y se programan dos temporizadores: uno a 4 segundos
(`StartDetecting`) y otro a 7 segundos (`TimeoutdeAtaque`). Finalmente, se marca
`bIsCharco` como `true` y se reproduce el montage `MO_PoddleDown`, quedando el jefe
en su forma de charco.

Al dispararse `StartDetecting` (4 segundos después de iniciada la tarea), se marca
`bIsDetectingPlayer` como `true`. A partir de ese momento, en cada tick
se comprueba, mientras `bIsDetectingPlayer` sea `true`, si el
jugador se encuentra a menos de 250 unidades del jefe; de ser así, se marca
`bIsDetectingPlayer` nuevamente como `false`, se cancela el temporizador de
`TimeoutdeAtaque` y se invoca dicho evento manualmente, adelantando el fin del
ataque a que el jugador se haya acercado lo suficiente.

`TimeoutdeAtaque`, ya sea disparado por su propio temporizador a los 7 segundos o
adelantado desde el `Tick` como se describió arriba, detiene el movimiento del
jefe, reduce su velocidad a 285 y reproduce el montage `MO_PoddleUp`. En el instante
señalado por el _Animation Notify_ de este montage, se ejecuta un _Sphere Trace_ de
radio 225 alrededor del jefe; de detectarse al jugador, se le aplica un daño
definido por la variable `PoddleDamage`, se cancelan sus montages de esquiva en las
cuatro direcciones, y se lo lanza por los aires (_launch_). Al completarse el
montage, se restaura la colisión del jefe (bloqueo contra Pawns, bloqueo contra uno
de los canales adicionales y _overlap_ contra el otro) y se marca `bIsCharco`
nuevamente como `false`.

Finalmente, se comprueba si el jefe quedó atrapado dentro de otro actor durante la
transformación: se obtienen los actores que se superponen con el componente
`PULL_OUT` y se evalúa si dicho arreglo está vacío. Si está vacío, la tarea finaliza
con éxito directamente. Si no lo está, el jefe se reposiciona, desplazándose en la
dirección normalizada desde el actor encontrado hacia el jefe (a 1000 unidades de
distancia, con la altura igualada a la del jugador), y la tarea finaliza con éxito a
continuación.

#figure(
  image("imagenes/cap5/slimepoddlestate.png", width: 80%),
  caption: [El jefe en su forma de charco durante el ataque `BA_Poddle`.],
) <fig:slime-poddle>

===== Ataque homing (`BA_HomingAttack`)

Esta tarea es idéntica en estructura al ataque de proyectil (`BA_ProjectilAttack`,
descrito más arriba): reproduce el mismo montage (`MO_ProjectileAttack`) y, en su
_Animation Notify_, instancia proyectiles (`BP_BossSlimeBall_C`) en abanico. Las
diferencias son el arreglo de desviaciones angulares utilizado (0°, 60° y -60°, es
decir, tres proyectiles en lugar de siete), la velocidad de los proyectiles (850 en
vez de 1000) y que estos sí tienen activado el comportamiento de persecución
(_Homing_). Al igual que el ataque de proyectil normal, esta tarea no invoca
`RegisterBossAttackAttempt`.


===== Ataque de látigo (`BA_WhipAttack`)

El ataque de látigo corresponde a un ataque tipo espada/látigo. Al activarse, se
registra el intento de ataque y se reproduce el montage `MO_SwordSlimeAttack`.
Mientras la tarea está activa, el jefe rota hacia el jugador con
una velocidad de interpolación de 1.0. Al completarse el montage,
la tarea finaliza con éxito, siguiendo el mismo patrón
montage-completado-finalización del resto de las tareas de ataque.

A diferencia del resto de los ataques del jefe, la detección de impacto de este
ataque no se resuelve mediante un trace dentro de esta misma tarea, sino a través
de una interfaz de notificación de daño aparte.

#figure(
  grid(
    columns: (1fr, 1fr, 1fr),
    column-gutter: 8pt,
    image("imagenes/cap5/sword_slime1.png", width: 100%),
    image("imagenes/cap5/sword_slime2.png", width: 100%),
    image("imagenes/cap5/sword_slime3.png", width: 100%),
  ),
  caption: [Secuencia del ataque de látigo del jefe.],
) <fig:slime-whip-attack>

===== Ataque de muro (`BA_WallAttack`)

Al activarse, se registra el intento de ataque y se reproduce el montage
`MO_WallAttack`, mientras el jefe rota hacia el jugador. En el instante señalado por el
_Animation Notify_ deja de rotar y se ejecuta un único _Box Trace_ entre la posición del
jefe y un punto 520 unidades hacia adelante, con una caja de 100×100×100 unidades orientada
según su rotación; de detectarse una colisión válida, se aplica un daño fijo de 10. Al
completarse el montage, la tarea finaliza con éxito.

#figure(
  grid(
    columns: (1fr, 1fr, 1fr),
    column-gutter: 8pt,
    image("imagenes/cap5/wallattack1.png", width: 100%),
    image("imagenes/cap5/wallattack2.png", width: 100%),
    image("imagenes/cap5/wallattack3.png", width: 100%),
  ),
  caption: [Secuencia del ataque de muro del jefe.],
) <fig:slime-wall-attack>

=== PlayerMetricsComponent

El jefe cuenta con un componente `PlayerMetricsComponent`, encargado de registrar la
efectividad de sus ataques durante el combate y de traducir las métricas recolectadas
en ajustes sobre su propio comportamiento (los pesos de selección de ataque descritos
en @sec:pesos-ataque). Su funcionamiento se detalla en profundidad en
@sec:metricas, sección transversal a varios sistemas del juego.

Finalmente, la secuencia que activa al jefe al inicio del combate corresponde a la
zona de entrada de la arena (`BP_ZonaEntradaJefe`), descrita en la sección
@sec:entrada-jefe.

== Sistema de métricas y telemetría <sec:metricas>

De forma transversal a varios de los sistemas descritos en este capítulo, el juego
incorpora una infraestructura de recolección y uso de métricas sobre el comportamiento del
jugador, implementada principalmente en dos clases de C++: `SlimeGameInstance`, encargada
de recolectar las métricas y persistirlas, y `PlayerMetricsComponent`, anclado al jefe,
encargado de registrar la efectividad de sus ataques y de traducir las métricas recolectadas
en ajustes sobre su comportamiento.

#figure(
  {
    let nb(cnt, fill: luma(218)) = rect(
      fill: fill, stroke: 0.8pt, radius: 4pt, inset: 7pt, width: 100%, cnt
    )
    let db(cnt) = rect(
      fill: luma(248),
      stroke: (dash: "dashed", paint: luma(130), thickness: 0.8pt),
      radius: 4pt, inset: 7pt, width: 100%, cnt
    )
    let arr = align(center + horizon, text(size: 16pt, fill: luma(100))[→])

    align(center, block(width: 150mm,
      stack(dir: ttb, spacing: 6pt,
        grid(
          columns: (1fr, auto, 1fr, auto, 1fr, auto, 1fr),
          column-gutter: 3pt,
          align: horizon,
          nb(align(center)[
            #text(size: 8.5pt, weight: "bold")[Nivel previo] \
            #text(size: 8pt)[`SlimeGameInstance` \ registra distancia, \ ataques, esquivas \ y curaciones]
          ]),
          arr,
          nb(align(center)[
            #text(size: 8.5pt, weight: "bold")[Inicio del combate] \
            #text(size: 8pt)[`PlayerMetrics` \ `Component` traduce \ métricas en pesos \ de ataque]
          ]),
          arr,
          nb(align(center)[
            #text(size: 8.5pt, weight: "bold")[Blackboard] \
            #text(size: 8pt)[pesos de cada \ ataque almacenados \ en `AttackWeightsJSON`]
          ], fill: luma(205)),
          arr,
          nb(align(center)[
            #text(size: 8.5pt, weight: "bold")[Behaviour Tree] \
            #text(size: 8pt)[selección aleatoria \ ponderada del \ siguiente ataque]
          ], fill: luma(192)),
        ),
        db(align(center)[
          #text(size: 8.5pt)[
            Durante el combate los pesos se recalculan: según la tasa de acierto de cada ataque (cada 15 golpes)
            y la actividad de curación del jugador
          ]
        ]),
      )
    ))
  },
  caption: [Flujo de datos del sistema de métricas. El bloque discontinuo representa la retroalimentación en tiempo real durante el combate.],
) <fig:flujo-metricas>

=== Variables de `SlimeGameInstance`

Como se mencionó, `SlimeGameInstance` recolecta sus datos en dos fases paralelas, controladas mediante la variable `isInCombat`: una fase previa al combate (en `Lvl_PreBoss`),
condicionada además a que `bMetricsEnabled` esté activo, y una fase durante el combate
contra el jefe, cuyas variables llevan el prefijo `Combat`. A continuación se detallan las
variables principales, agrupadas por categoría.

Cabe precisar de antemano el rol efectivo de estas variables con prefijo `Combat` dentro del
sistema de adaptación. Si bien se registran de forma paralela a sus contrapartes sin
prefijo, mediante el mismo flag `isInCombat`, y forman parte del diseño original de la
infraestructura de métricas, que contemplaba adaptar también el comportamiento del jefe
durante el combate en base a estas métricas, dicha adaptación en tiempo real no se llegó a
implementar. La adaptación pre-combate (`ApplyPreCombatAdaptation` y sus subfunciones, ver
@sec:pesos-ataque) lee exclusivamente las variables sin prefijo; ningún punto del sistema
consulta las variables `Combat*` para tomar decisiones. Las únicas excepciones, es decir, las
únicas métricas recolectadas durante el combate que sí tienen un efecto real sobre el
comportamiento del jefe, son el registro de aciertos por tipo de ataque
(`TotalAttemptsPerType` y `SuccessfulHits`, en `PlayerMetricsComponent`), que alimenta
`ApplyInCombatSuccessfulHits`, y el monitoreo de curación en combate vía
`ApplyInCombatHealing`, que compara la vida actual del jugador contra `AverageHealingHP`,
calculada en la fase pre-combate, para ajustar la presión de ataque cuando el jugador entra
en su rango habitual de curación.

*Distancia*
+ `DistanceAccum`, `DistanceSamples`, `AverageDistance`: acumulador, contador de
  muestras y promedio de la distancia del jugador al enemigo.

*Ataques*
+ `MeleeAttacks`, `RangedAttacks`: conteo de ataques cuerpo a cuerpo y a distancia.
+ `MeleeAttacksInRangedZone`, `RangedAttacksInRangedZone`: conteo de cada tipo de ataque
  realizado dentro de una zona de rango.

*Curación*
+ `HealsAtHighHP`, `HealsAtMidHP`, `HealsAtLowHP`: conteo de curaciones según el rango de
  vida del jugador al curarse.
+ `HealingHPAccum`, `HealingCount`, `AverageHealingHP`: acumulador, contador y promedio
  del porcentaje de vida al que el jugador se cura.

*Esquivas y daño*
+ `TotalDodges`, `SuccessfulDodges`: conteo total de esquivas y de las marcadas como
  exitosas.
+ `TotalDodgesTankZone`, `DodgesFromDelayAttack`, `DodgesFromDelayAttack_TankZone`:
  esquivas en la zona de tanque y esquivas frente a ataques telegrafiados.
+ `LateralDodgesFromDash`, `BackwardDodgesFromDash`: esquivas laterales o hacia atrás
  frente al ataque de embestida del esqueleto caballero.
+ `DamageTaken`, `TotalDamageReceived`: impactos recibidos y daño total acumulado.

*Zona de tanque*
+ `isInTankZone`: indica si el jugador se encuentra en la zona de tanque.
+ `DamageTakenInTankZone`: daño recibido en dicha zona.

*Estudio*
+ `bAdaptiveEnabled`: condición experimental (`true` = adaptativo, `false` = control).
+ `bMetricsEnabled`: habilita la recolección durante el nivel.
+ `SessionId`, `AttemptNumber`: identificador de sesión y número de intento contra el jefe.

Como se explicó arriba, cada una de estas variables de la fase pre-combate tiene una
contraparte con prefijo `Combat` que se registra en paralelo durante el combate pero que,
salvo las excepciones señaladas, no se utiliza.

=== Funciones de registro (`SlimeGameInstance`)

Sobre estas variables opera una familia de funciones `Register*` (por ejemplo
`RegisterDistance`, `RegisterMeleeAttack`, `RegisterHealingMoment`, `RegisterTotalDodge` o
`RegisterDodgeResult`), cada una invocada desde el evento de juego correspondiente para
actualizar la variable asociada. Casi todas siguen el mismo patrón: bifurcan según
`isInCombat` para actualizar la variable de la fase que corresponda. Las excepciones son
`RegisterDashDodge` y `RegisterDamageTakenInTankZone`, que no dependen de `isInCombat` sino
únicamente de `bMetricsEnabled`.

=== Registro de ataques del jefe (`PlayerMetricsComponent`)

`PlayerMetricsComponent` lleva un registro independiente mediante dos mapas indexados por
tipo de ataque (`EBossAttackType`): `TotalAttemptsPerType` y `SuccessfulHits`.

`RegisterBossAttackAttempt(AttackType)` incrementa el contador de intentos correspondiente
en `TotalAttemptsPerType`, además de un contador global `TotalAttacksPerformed`. Cada 15
ataques realizados (`TotalAttacksPerformed % 15 == 0`), se dispara automáticamente
`ApplyInCombatSuccessfulHits`.

`RegisterBossAttackHit(AttackType)` incrementa el contador de aciertos correspondiente en
`SuccessfulHits`.

=== Adaptación pre-combate

Al finalizar la fase previa al combate, `ApplyPreCombatAdaptation` analiza las variables de
`SlimeGameInstance` y ajusta los pesos de selección de ataques del jefe (mecanismo descrito
en @sec:pesos-ataque) en cuatro dimensiones independientes, llamando para ello a las
funciones `ApplyPreCombatDistance`, `ApplyPreCombatMeleeVsRanged`, `ApplyPreCombatDodges` y
`ApplyPreCombatTankZone`, descritas a continuación. Todo el sistema de adaptación
solo se ejecuta si `IsAdaptiveEnabled` retorna verdadero, lo cual depende de
`bAdaptiveEnabled`.

*Distancia* (`ApplyPreCombatDistance`): según la distancia promedio que el jugador mantuvo
en el nivel previo, ajusta los rangos del jefe. Si se mantuvo muy cerca (por debajo de 330
unidades), acorta su rango cercano; si se mantuvo lejos (por encima de 480), acorta su rango
lejano y alarga su persecución. La @fig:bloque-distancia detalla estos umbrales.

#figure(
  {
    set par(justify: false)
    let guard(cnt) = rect(
      fill: luma(230), stroke: 0.8pt, radius: 4pt, inset: 8pt, width: 100%,
      align(center)[#text(size: 9pt)[#cnt]],
    )
    let branch(header, effect, fill: luma(245)) = rect(
      fill: fill, stroke: 0.8pt, radius: 4pt, inset: 7pt, width: 100%,
      stack(dir: ttb, spacing: 5pt,
        align(center)[#text(size: 8.5pt, weight: "bold")[#header]],
        align(center)[#text(size: 8pt)[#effect]],
      ),
    )
    let decision(cnt, w: 30mm) = {
      let side = w * 0.8
      align(center, box(width: w, height: side * 0.85)[
        #place(center + horizon, rotate(45deg, rect(width: side * 0.56, height: side * 0.56, fill: rgb("#FFF2CC"), stroke: 1pt + rgb("#D6B656"))))
        #place(center + horizon, box(width: w * 0.62, align(center)[#text(size: 8pt, weight: "bold")[#cnt]]))
      ])
    }
    align(center, block(width: 100%,
      stack(dir: ttb, spacing: 5pt,
        guard[Requisito: `DistanceSamples` >= 20],
        align(center)[↓],
        decision[`AverageDistance`],
        align(center)[↓],
        grid(columns: (1fr, 1fr, 1fr), column-gutter: 6pt, row-gutter: 0pt,
          branch([< 330], [Reduce 50 en `CloseRange` (Blackboard)], fill: rgb("#F8CECC")),
          branch([330 – 480], [Sin ajuste]),
          branch([> 480], [Reduce 75 en `FarRange` e incrementa 2s `BossChaseDur`], fill: rgb("#FFE6CC")),
        ),
      ),
    ))
  },
  caption: [Regla de adaptación pre-combate por distancia.],
) <fig:bloque-distancia>

*Melee versus a distancia* (`ApplyPreCombatMeleeVsRanged`): según si el jugador prefirió
atacar de cerca o a distancia en el nivel previo, refuerza los ataques del jefe más
adecuados para presionar cada estilo. Si más de la mitad de sus ataques fueron a distancia,
refuerza los ataques de acercamiento y salto; si predominó el combate cuerpo a cuerpo,
refuerza los de área. La @fig:bloque-melee-distancia detalla los umbrales y los ataques
afectados.

#figure(
  {
    set par(justify: false)
    let guard(cnt) = rect(
      fill: luma(230), stroke: 0.8pt, radius: 4pt, inset: 8pt, width: 100%,
      align(center)[#text(size: 9pt)[#cnt]],
    )
    let branch(header, effect, fill: luma(245)) = rect(
      fill: fill, stroke: 0.8pt, radius: 4pt, inset: 7pt, width: 100%,
      stack(dir: ttb, spacing: 5pt,
        align(center)[#text(size: 8.5pt, weight: "bold")[#header]],
        align(center)[#text(size: 8pt)[#effect]],
      ),
    )
    let note(cnt) = rect(
      fill: luma(248),
      stroke: (dash: "dashed", paint: luma(120), thickness: 0.8pt),
      radius: 4pt, inset: 7pt, width: 100%,
      align(center)[#text(size: 8pt)[#cnt]],
    )
    let decision(cnt, w: 30mm) = {
      let side = w * 0.8
      align(center, box(width: w, height: side * 0.85)[
        #place(center + horizon, rotate(45deg, rect(width: side * 0.56, height: side * 0.56, fill: rgb("#FFF2CC"), stroke: 1pt + rgb("#D6B656"))))
        #place(center + horizon, box(width: w * 0.62, align(center)[#text(size: 8pt, weight: "bold")[#cnt]]))
      ])
    }
    align(center, block(width: 100%,
      stack(dir: ttb, spacing: 5pt,
        guard[Requisito: `MeleeAttacks` + `RangedAttacks` >= 5],
        align(center)[↓],
        decision[`RangedRatio`],
        align(center)[↓],
        grid(columns: (1fr, 1fr, 1fr), column-gutter: 6pt,
          branch([> 0.5], [+15 a `BA_Poddle`, `BA_BossChase`, `BA_HeavyAttack`], fill: rgb("#D5E8D4")),
          branch([0.35 – 0.5], [Sin ajuste]),
          branch([< 0.35], [+15 a `BA_AOEAttack`, `BA_WhipAttack`], fill: rgb("#D5E8D4")),
        ),
        note[Independiente (no bloquea lo anterior): si `MeleeAttacksInRangedZone` + `RangedAttacksInRangedZone` >= 3 → +10 a `BA_AOEAttack` si predominó el melee en zona de rango, o a `BA_Poddle` si predominó el ataque a distancia],
      ),
    ))
  },
  caption: [Regla de adaptación pre-combate por proporción de ataques melee versus a distancia.],
) <fig:bloque-melee-distancia>

*Esquiva* (`ApplyPreCombatDodges`): según qué proporción de las esquivas del jugador se
realizaron dentro de la ventana de aviso de un ataque telegrafiado, refuerza distintos
ataques. Si más del 60% de sus esquivas cayeron dentro de la ventana (buena lectura de los
avisos), refuerza el ataque básico, que casi no se anuncia; si menos del 40%, refuerza los
ataques de preparación larga. La @fig:bloque-esquiva detalla los umbrales.

#figure(
  {
    set par(justify: false)
    let guard(cnt) = rect(
      fill: luma(230), stroke: 0.8pt, radius: 4pt, inset: 8pt, width: 100%,
      align(center)[#text(size: 9pt)[#cnt]],
    )
    let branch(header, effect, fill: luma(245)) = rect(
      fill: fill, stroke: 0.8pt, radius: 4pt, inset: 7pt, width: 100%,
      stack(dir: ttb, spacing: 5pt,
        align(center)[#text(size: 8.5pt, weight: "bold")[#header]],
        align(center)[#text(size: 8pt)[#effect]],
      ),
    )
    let decision(cnt, w: 30mm) = {
      let side = w * 0.8
      align(center, box(width: w, height: side * 0.85)[
        #place(center + horizon, rotate(45deg, rect(width: side * 0.56, height: side * 0.56, fill: rgb("#FFF2CC"), stroke: 1pt + rgb("#D6B656"))))
        #place(center + horizon, box(width: w * 0.62, align(center)[#text(size: 8pt, weight: "bold")[#cnt]]))
      ])
    }
    align(center, block(width: 100%,
      stack(dir: ttb, spacing: 5pt,
        guard[Requisito: `TotalDodges` >= 5],
        align(center)[↓],
        decision[`DodgeRatio`],
        align(center)[↓],
        grid(columns: (1fr, 1fr, 1fr), column-gutter: 6pt,
          branch([> 0.6], [+15 a `BA_BasicAttack`], fill: rgb("#D5E8D4")),
          branch([0.4 – 0.6], [Sin ajuste]),
          branch([< 0.4], [+15 a `BA_AOEAttack`, `BA_WallAttack`, `BA_HeavyAttack`], fill: rgb("#D5E8D4")),
        ),
      ),
    ))
  },
  caption: [Regla de adaptación pre-combate por momento de esquiva respecto a la ventana de aviso. `DodgeRatio` corresponde a `DodgesFromDelayAttack` / `TotalDodges`.],
) <fig:bloque-esquiva>

*Zona de tanque* (`ApplyPreCombatTankZone`): evalúa cómo esquivó el jugador las embestidas
del jefe en dos sub-reglas. La primera mira la dirección de las esquivas (laterales o hacia
atrás) y refuerza el ataque de látigo o el pesado según cuál predominó. La segunda mira la
precisión: si al menos la mitad de las esquivas en la zona cayeron dentro de la ventana de
aviso, refuerza el ataque básico; si no, los ataques pesado y de látigo. La
@fig:bloque-zonatanque las detalla.

#figure(
  {
    set par(justify: false)
    let guard(cnt) = rect(
      fill: luma(230), stroke: 0.8pt, radius: 4pt, inset: 8pt, width: 100%,
      align(center)[#text(size: 9pt)[#cnt]],
    )
    let branch(header, effect, fill: luma(245)) = rect(
      fill: fill, stroke: 0.8pt, radius: 4pt, inset: 7pt, width: 100%,
      stack(dir: ttb, spacing: 5pt,
        align(center)[#text(size: 8.5pt, weight: "bold")[#header]],
        align(center)[#text(size: 8pt)[#effect]],
      ),
    )
    let decision(cnt, w: 24mm) = {
      let side = w * 0.8
      align(center, box(width: w, height: side * 0.85)[
        #place(center + horizon, rotate(45deg, rect(width: side * 0.56, height: side * 0.56, fill: rgb("#FFF2CC"), stroke: 1pt + rgb("#D6B656"))))
        #place(center + horizon, box(width: w * 0.68, align(center)[#text(size: 6.5pt, weight: "bold")[#cnt]]))
      ])
    }
    let subregla(titulo, pregunta, ..bloques) = block(width: 100%,
      stack(dir: ttb, spacing: 5pt,
        align(center)[#text(size: 8.5pt, style: "italic")[#titulo]],
        align(center)[↓],
        decision(pregunta),
        align(center)[↓],
        grid(columns: (1fr, 1fr), column-gutter: 6pt, ..bloques),
      ),
    )
    align(center, block(width: 100%,
      grid(columns: (1fr, 1fr), column-gutter: 14pt,
        subregla(
          [Sub-regla A: `LateralDodgesFromDash` + `BackwardDodgesFromDash` >= 2],
          [¿Lateral o atrás?],
          branch([Predominó lateral], [+10 a `BA_WhipAttack`], fill: rgb("#D5E8D4")),
          branch([Predominó atrás], [+10 a `BA_HeavyAttack`], fill: rgb("#D5E8D4")),
        ),
        subregla(
          [Sub-regla B: `TotalDodgesTankZone` >= 3],
          [¿≥ 50%?],
          branch([Sí], [+10 a `BA_BasicAttack`], fill: rgb("#D5E8D4")),
          branch([No], [+10 a `BA_HeavyAttack` y `BA_WhipAttack`], fill: rgb("#FFE6CC")),
        ),
      ),
    ))
  },
  caption: [Reglas de adaptación pre-combate por zona de tanque (dos sub-reglas independientes).],
) <fig:bloque-zonatanque>

=== Adaptación durante el combate


`ApplyInCombatSuccessfulHits`, que se dispara cada 15 ataques del jefe, mide la tasa de
acierto de cada tipo de ataque (sobre aquellos con al menos 3 intentos): si un ataque conecta
en más del 60% de sus intentos, sube su peso en 15; si conecta en menos del 30%, lo baja en
15; entre ambos umbrales no hay ajuste.

`ApplyInCombatHealing`, por su parte, compara la vida del jugador con el porcentaje al que
suele curarse (medido en el nivel previo, con un margen de ±10 puntos): cuando el jugador
entra en ese rango, refuerza en 15 los pesos de sus ataques más agresivos (básico, salto,
homing y charco) para presionarlo, y revierte el ajuste al salir.

#figure(
  {
    set par(justify: false)
    let guard(cnt) = rect(
      fill: luma(230), stroke: 0.8pt, radius: 4pt, inset: 8pt, width: 100%,
      align(center)[#text(size: 9pt)[#cnt]],
    )
    let branch(header, effect, fill: luma(245)) = rect(
      fill: fill, stroke: 0.8pt, radius: 4pt, inset: 7pt, width: 100%,
      stack(dir: ttb, spacing: 5pt,
        align(center)[#text(size: 8.5pt, weight: "bold")[#header]],
        align(center)[#text(size: 8pt)[#effect]],
      ),
    )
    let decision(cnt, w: 30mm) = {
      let side = w * 0.8
      align(center, box(width: w, height: side * 0.85)[
        #place(center + horizon, rotate(45deg, rect(width: side * 0.56, height: side * 0.56, fill: rgb("#FFF2CC"), stroke: 1pt + rgb("#D6B656"))))
        #place(center + horizon, box(width: w * 0.62, align(center)[#text(size: 8pt, weight: "bold")[#cnt]]))
      ])
    }
    let panel-title(cnt) = align(center)[#text(size: 10pt, weight: "bold")[#cnt]]

    align(center, block(width: 100%,
      stack(dir: ttb, spacing: 14pt,
        stack(dir: ttb, spacing: 5pt,
          panel-title[Panel A — Efectividad por tipo de ataque],
          guard[Trigger: cada 15 ataques del jefe (`TotalAttacksPerformed % 15 == 0`) — evalúa cada tipo de ataque con `TotalAttemptsPerType` >= 3],
          align(center)[↓],
          decision[`Ratio`],
          align(center)[↓],
          grid(columns: (1fr, 1fr, 1fr), column-gutter: 6pt,
            branch([> 0.6], [Incrementa en 15 el peso de ese ataque], fill: rgb("#D5E8D4")),
            branch([0.3 – 0.6], [Sin ajuste]),
            branch([< 0.3], [Reduce en 15 el peso de ese ataque], fill: rgb("#F8CECC")),
          ),
        ),
        line(length: 100%, stroke: 0.5pt + luma(200)),
        stack(dir: ttb, spacing: 6pt,
          panel-title[Panel B — Curación del jugador (máquina de estados)],
          guard[Requisito: `HealingCount` >= 2 — se compara `PlayerHealthPercent` contra `AverageHealingHP` con un margen de ±10 puntos porcentuales (variable interna `bIsInHealingRange`)],
          grid(columns: (1fr, auto, 1fr), column-gutter: 8pt, align: horizon,
            rect(fill: rgb("#F8CECC"), stroke: 1.2pt + rgb("#B85450"), radius: 12pt, inset: 12pt, width: 100%,
              stack(dir: ttb, spacing: 4pt,
                align(center)[#text(size: 8.5pt, weight: "bold")[Fuera del rango habitual de curación]],
                align(center)[#text(size: 8pt)[Pesos base (sin bonus de presión)]],
              )),
            stack(dir: ttb, spacing: 1pt,
              align(center)[#text(size: 17pt)[→]],
              align(center)[#text(size: 6.5pt, style: "italic")[entra al margen]],
              v(6pt),
              align(center)[#text(size: 17pt)[←]],
              align(center)[#text(size: 6.5pt, style: "italic")[sale del margen]],
            ),
            rect(fill: rgb("#D5E8D4"), stroke: 1.2pt + rgb("#82B366"), radius: 12pt, inset: 12pt, width: 100%,
              stack(dir: ttb, spacing: 4pt,
                align(center)[#text(size: 8.5pt, weight: "bold")[Dentro del rango habitual de curación]],
                align(center)[#text(size: 8pt)[+15 a `BA_BasicAttack`, `BA_HeavyAttack`, `BA_HomingAttack`, `BA_Poddle`]],
              )),
          ),
        ),
      ),
    ))
  },
  caption: [Ajustes de adaptación durante el combate: efectividad por tipo de ataque (Panel A) y máquina de estados de curación del jugador (Panel B).],
) <fig:estado-adaptacion-combate>


=== Mecanismo de pesos de ataque <sec:pesos-ataque>

Los pesos de selección de ataques del jefe, utilizados por el nodo compuesto de selección
aleatoria ponderada del Behaviour Tree, se almacenan como una única cadena en formato JSON
dentro de la variable de Blackboard `AttackWeightsJSON`, en lugar de como variables
individuales. `SetAttackWeight(AttackType, NewWeight)` deserializa dicha cadena, actualiza el
peso correspondiente al tipo de ataque indicado, y vuelve a serializarla y almacenarla.
`GetAttackWeight(AttackType)` realiza el proceso inverso, retornando el peso actual de un
tipo de ataque (o -1 si no se encuentra).

=== Persistencia de datos para el estudio

Los datos se persisten en archivos JSON dentro de `Saved/StudyLogs`:

#[
#set par(justify: true)
#let c(x) = emph(x)
+ *DumpMetricsToFile* (#c("SlimeGameInstance")): vuelca las variables de la fase pre-combate
  (#c("AverageDistance"), #c("DistanceSamples"), #c("MeleeAttacks"), #c("RangedAttacks"),
  #c("MeleeAttacksInRangedZone"), #c("RangedAttacksInRangedZone"), #c("TotalDodges"),
  #c("SuccessfulDodges"), #c("AverageHealingHP"), #c("HealingCount"), #c("LateralDodgesFromDash"),
  #c("BackwardDodgesFromDash"), #c("DodgesFromDelayAttack"), #c("DamageTakenInTankZone"),
  #c("TotalDodgesTankZone"), #c("DodgesFromDelayAttack_TankZone")) a
  #c("session_{SessionId}_{condición}_metrics.json").
+ *DumpCombatResultToFile(bPlayerWon)* (#c("PlayerMetricsComponent")): vuelca #c("bPlayerWon"),
  #c("AttemptNumber") y el contenido de #c("AttackWeightsJSON") a #c("session_{SessionId}_{condición}_win.json")
  o #c("_retry_{AttemptNumber}.json"), según corresponda.
+ *DumpFinalTreeToFile* (#c("PlayerMetricsComponent")): vuelca únicamente #c("AttackWeightsJSON") a
  #c("session_{SessionId}_{condición}_tree.json").
]

En todos los casos, `SessionId` (generado a partir de fecha y hora) y la condición
experimental (`adaptive` o `control`, según `bAdaptiveEnabled`) identifican tanto el
contenido como el nombre del archivo.



== Niveles

Los niveles del juego comparten una ambientación de mazmorra, construida a partir de
_assets_ obtenidos principalmente de una entrega gratuita de Fab (Unreal Engine
Marketplace), complementados con _assets_ de otras fuentes. La estructura general de
los niveles, cómo se distribuyen y conectan entre sí, se describe en la sección
@sec:diseno-niveles;
a continuación se documentan los elementos reutilizables que los componen y, luego,
la implementación particular de cada nivel.

=== Elementos de nivel <sec:elementos-nivel>

Los niveles se construyen a partir de un conjunto de elementos reutilizables, cada uno
implementado como un Blueprint propio. Además de los descritos a continuación, se emplean
escaleras como elemento puramente visual y de navegación (un _Static Mesh_ sin lógica
asociada).

==== Maniquí

El maniquí#footnote[
  Modelo 3D "Medieval Combat Dummy" por CaptainHC, obtenido de Fab, licenciado bajo
  #link("https://creativecommons.org/licenses/by/4.0/")[CC BY 4.0].
  #link("https://www.fab.com/listings/d9d89431-ff36-454a-8c73-de5b5f8b03df")[Disponible en sitio web].
] es un enemigo funcional usado como objetivo de práctica: al recibir daño se tambalea y,
al llegar a cero de vida, dispara el delegado `OnDummyDied` (que abre la puerta
correspondiente) y luego regenera su vida progresivamente para poder practicar sobre él de
nuevo.

#figure(
  image("imagenes/cap5/bp-manequinn.png", width: 55%),
  caption: [Blueprint del maniquí.],
) <fig:bp-manequinn>

==== Puerta

La puerta#footnote[
  Modelo 3D "SM Door" por DenisFernandes, licenciado bajo
  #link("https://creativecommons.org/licenses/by/4.0/")[CC BY 4.0].
  #link("https://sketchfab.com/3d-models/sm-door-634fa1602d8f44e7a8e3868fb02c6d39")[Disponible en sitio web].
] (`BP_Door`) expone la función `OpenDoor`, invocada externamente, que la desliza hacia
arriba mediante una Timeline. El mismo Blueprint se reutiliza en el nivel previo al jefe
con una malla de portón metálico, acorde con la ambientación de mazmorra.

#figure(
  image("imagenes/cap5/bp_door.png", width: 55%),
  caption: [Blueprint de la puerta.],
) <fig:bp-door>

==== Espinas

Las espinas#footnote[
  Modelo 3D "Spike Trap 01" por Nichgon, obtenido de Sketchfab bajo licencia Standard.
  #link("https://sketchfab.com/3d-models/spike-trap-01-4022678cac214fd2963894aa152fc6f2")[Disponible en sitio web].
] (`BP_Spykes`) aplican un daño fijo al jugador que las toca y lo reposicionan de inmediato
en un punto seguro (`RespawnPoint`).

#figure(
  image("imagenes/cap5/bp-spykes.png", width: 55%),
  caption: [Blueprint de las espinas.],
) <fig:bp-spykes>

==== Puente

El puente#footnote[
  Modelo 3D "Bridge" por TAK0YT0, obtenido de Fab, licenciado bajo
  #link("https://creativecommons.org/licenses/by/4.0/")[CC BY 4.0].
  #link("https://www.fab.com/listings/71b99663-eed6-40e0-9674-96b218efc974")[Disponible en sitio web].
] (`BP_Bridge`) expone la función `RotateBridge`, invocada externamente, que lo baja
mediante una Timeline hasta habilitar el paso sobre el abismo.

#figure(
  image("imagenes/cap5/bp-bridge.png", width: 55%),
  caption: [Blueprint del puente.],
) <fig:bp-bridge>

==== Palanca

La palanca#footnote[
  Modelo 3D "Lever With Animation" por LeeMoorhead, licenciado bajo
  #link("https://creativecommons.org/licenses/by/4.0/")[CC BY 4.0].
  #link("https://sketchfab.com/3d-models/lever-with-animation-de90d94208e44741a754e57307ec68ec")[Disponible en sitio web].
] (`BP_Lever`) detecta al jugador dentro de su zona de interacción y, al activarse
(`IA_MyInteract`), reproduce su animación e invoca el delegado `OnLeverActivated`,
escuchado por el Level Blueprint de `Lvl_PreBoss` para abrir la puerta y el atajo
correspondientes.

#figure(
  image("imagenes/cap5/bp-lever.png", width: 55%),
  caption: [Blueprint de la palanca.],
) <fig:bp-lever>

==== Zonas de popup

Las zonas de popup (`BP_ZonaPopChico`) muestran textos de ayuda al entrar el jugador en
ellas: principalmente los controles del juego en `Lvl_Tutorial` y el aviso de interacción
junto a las palancas en `Lvl_PreBoss`. Cada instancia define su propio texto (`MensajePopUp`),
que se renderiza en el widget `WB_PopChico` mientras el jugador permanece en la zona.

=== Lvl_Tutorial

El nivel de tutorial combina los elementos Maniquí, Puerta, Espinas y Puente descritos
arriba; su distribución de salas y secuencia de aprendizaje se detallan en
@sec:diseno-niveles. La lógica propia de su Level Blueprint se organiza en torno a las
transiciones de cámara que acompañan la apertura de cada puerta: al derrotar al maniquí de
la primera sala, al esqueleto de la segunda y al maniquí al otro lado del abismo, el nivel
enfoca brevemente la cámara hacia la puerta (o el puente) correspondiente, la abre mediante
`OpenDoor` (o `RotateBridge` en el caso del puente) y luego devuelve el control al jugador.

=== Lvl_PreBoss

El nivel previo al jefe combina los elementos Palanca, Puerta y Escalera descritos arriba,
junto con los tres tipos de esqueleto (normal, mago y caballero); su distribución de salas
se detalla en @sec:diseno-niveles. Al comenzar, su Level Blueprint reproduce la música de
fondo y habilita la recolección de métricas del jugador (`bMetricsEnabled` en
`SlimeGameInstance`). Cada una de las dos palancas del nivel enfoca la cámara hacia las
puertas, abre su puerta principal y, tras una breve pausa, abre además un atajo de regreso,
devolviendo luego el control al jugador.

=== Lvl_ThirdPerson

La arena del jefe se describe en términos de diseño en la sección
@sec:diseno-niveles; aquí se documenta la lógica de su elemento más relevante: la
zona que activa el jefe al entrar a la sala.

==== Zona de entrada al jefe (`BP_ZonaEntradaJefe`) <sec:entrada-jefe>

Al entrar el jugador a la sala del jefe, esta zona dispara, una sola vez, una secuencia
cinemática de activación: deshabilita el input del jugador, reproduce la música del jefe,
enfoca la cámara hacia el jefe y luego hacia la puerta de entrada, que se cierra tras el
jugador (`OpenDoor`). Al terminar, devuelve la cámara al jugador, rehabilita su input y
activa al jefe mediante `ActivateBossController` (@sec:activacion-jefe), tras lo cual la
zona se destruye a sí misma.

== Widgets generales (MainMenu, WinnerScreen...)

=== Menú principal (`WB_MainMenu`)

El menú principal presenta cuatro botones de navegación: Tutorial (carga `Lvl_Tutorial`),
Dungeon (carga `Lvl_PreBoss`), Boss (carga directamente `Lvl_ThirdPerson`, permitiendo
saltar al combate contra el jefe sin pasar por los niveles anteriores) y Quit (cierra el
juego).

Además, en una esquina incluye la casilla `CheckBox_0`, mencionada en el capítulo 4, que
controla la condición experimental (adaptativa vs. control): al abrirse el menú refleja el
valor actual de `bAdaptiveEnabled`, y al cambiar su estado lo actualiza. Está separada de
los botones principales para no llamar la atención del participante.

#figure(
  image("imagenes/cap5/mainmenu.png", width: 70%),
  caption: [Menú principal del juego.],
) <fig:main-menu>

=== Pantalla de victoria (`WB_WinnerScreen`)

Se muestra al derrotar al jefe, con un mensaje de victoria y dos botones: reintentar, que
revierte la pausa y recarga el nivel actual para reiniciar el combate, y menú principal, que
carga `Lvl_MainMenu`.

#figure(
  image("imagenes/cap5/winnerscreen.png", width: 70%),
  caption: [Pantalla de victoria.],
) <fig:winner-screen>

=== Barra de vida del jefe (`WB_BossHealth`)

Muestra la vida del jefe junto con su nombre. No posee lógica propia: es el propio jefe
(`BP_Slime`) quien, mediante su variable `progressbarref`, actualiza directamente el
porcentaje de la barra al recibir daño.

#figure(
  image("imagenes/cap5/boss-healthwidget.png", width: 70%),
  caption: [Barra de vida del jefe.],
) <fig:boss-health-widget>

=== Barra de vida de enemigos normales (`WB_NormalHealth`)

Al igual que `WB_BossHealth`, esta barra no posee lógica propia: es cada actor que la
utiliza (el esqueleto normal, el mago, el caballero y el maniquí) quien actualiza
directamente su porcentaje al recibir daño. La rotación de la barra hacia la cámara del
jugador tampoco es lógica del widget, sino del actor que la porta.

#figure(
  image("imagenes/cap5/normalhealthwidget.png", width: 60%),
  caption: [Barra de vida de enemigos normales.],
) <fig:normal-health-widget>


]
// ==========================================
// CAPÍTULO 6: PRUEBA DE CONCEPTO
// ==========================================
#capitulo(title: "Prueba de concepto y evaluación")[

Este capítulo describe la evaluación diseñada para comprobar si enfrentar al
jefe adaptativo se percibe distinto de enfrentar a su versión de control. Se
trata de una prueba de concepto y no de un estudio a gran escala: el énfasis
está en comprobar que el protocolo de medición funciona y que arroja señales
interpretables, más que en obtener resultados generalizables a toda la
población de jugadores.

== Diseño experimental

La evaluación contrasta dos condiciones: el jefe con su sistema de
adaptación activo y el mismo jefe operando como versión de control, sin que
sus pesos de ataque se ajusten al comportamiento del jugador. En la condición
de control, el jefe usa el mismo repertorio de ataques descrito en el
capítulo 3, pero con sus pesos parejos durante todo el combate, sin que el
comportamiento del jugador en el nivel previo tenga ningún efecto sobre él.
Cada persona que participa juega una sola de las dos condiciones, nunca
ambas, para evitar que el aprendizaje acumulado en una partida contamine la
percepción de la otra.

La asignación a una u otra condición se controla mediante un botón escondido
en una esquina de la pantalla del menú principal, sin ningún propósito para
el jugador. Es quien administra el experimento quien lo presiona antes de
entregarle el control del computador al participante, de modo que este nunca
interactúa con él ni sabe a qué condición fue asignado, preservando el
cegamiento del experimento respecto al participante.

Es importante notar, además, que la recolección de datos durante el nivel
previo no depende de esta condición, sino de un interruptor independiente:
todos los jugadores generan el mismo perfil de comportamiento, sin importar
si pertenecen al grupo adaptativo o de control. Lo único que cambia entre
condiciones es si ese perfil efectivamente se aplica sobre los pesos del
jefe. Esto permite, entre otras cosas, comparar los perfiles de ambos grupos
para verificar que la asignación experimental no haya generado diferencias
sistemáticas de comportamiento previas al combate, tal como se hizo en la
sección de comportamiento en la fase de exploración de este capítulo.

== Participantes

Quienes se inscriben completan primero un cuestionario corto sobre su
familiaridad con videojuegos de acción exigentes y con mecánicas de esquiva,
melee y hechizos, considerando su frecuencia semanal de juego, las horas
acumuladas en el género y la cantidad de títulos soulslike o similares ya
jugados. La suma de esas
respuestas entrega un puntaje entre 0 y 9, que separa a los participantes en
dos perfiles: poca o nula experiencia (0 a 3) y con experiencia (4 a 9).

Ese perfil se usa después para repartir a la gente entre las dos
condiciones: en vez de asignar al azar de forma pura, se va alternando la
condición que recibe cada nuevo inscrito dentro de su propio perfil de
experiencia, de manera que ningún grupo termine con una proporción
desbalanceada de jugadores experimentados o novatos. El reclutamiento se
hace mediante un formulario difundido en foros universitarios, donde la
persona indica su disponibilidad y autoevalúa su experiencia; antes de
empezar, firma un consentimiento informado que detalla el propósito del
estudio, la confidencialidad de sus datos y su derecho a abandonar la
sesión cuando quiera.

En total se reclutó exitosamente a 33 participantes. Durante las primeras sesiones se
detectaron ajustes pendientes en algunas de las métricas registradas, lo
que invalidó los datos de 3 de esas sesiones; descartando esos casos, la
muestra final utilizada para el análisis quedó compuesta por 30
participantes.

== Equipo de prueba

Todas las sesiones se ejecutaron en el mismo equipo, con las siguientes
especificaciones:

- Procesador: Intel® Core™ i5-11400H (11.ª generación, 2.70 GHz).
- Tarjeta gráfica: NVIDIA® GeForce RTX™ 3050 Laptop GPU.
- Memoria RAM: 8 GB.
- Sistema operativo: Windows 11.

== Desarrollo de la sesión

Cada sesión sigue el mismo guión, sin importar la condición asignada: un
tutorial de controles, una fase de exploración del nivel previo al jefe,
donde el sistema ya empieza a registrar comportamiento, y finalmente el
combate contra el jefe. El investigador deja jugar libremente, e interviene
solo si la persona se traba en algo relacionado con los controles, no con
el combate en sí. La única indicación de juego que se dio por igual a todos los
participantes se entregaba al iniciar el nivel previo al jefe: que, durante su
exploración, enfrentaran y eliminaran a cada enemigo que encontraran antes de
seguir avanzando, en lugar de esquivarlos o arrastrarlos consigo mientras
recorrían el nivel. Esta instrucción común busca que el comportamiento registrado frente a
cada arquetipo provenga de enfrentamientos efectivos y comparables entre
participantes, y no de estrategias de evasión que dejarían al sistema sin
información suficiente para construir el perfil de juego. Cada sesión dura entre
25 y 40 minutos. Para mantener el
anonimato de los datos sin perder la trazabilidad, a cada participante se le
asigna un código al comienzo, que es lo único que conecta su cuestionario
inicial, sus métricas de juego y su cuestionario de salida. En ninguna de
las sesiones se observaron caídas de fps, por lo
que el rendimiento del juego no constituyó una variable de confusión en
los resultados obtenidos.

Al cerrar la sesión, se le pide responder dos instrumentos más: el SUS
(System Usability Scale) adaptado a videojuegos, y una selección de ítems
del GEQ (Game Experience Questionnaire), ambos en escala de 1 a 5. La
adaptación del SUS consistió en reemplazar las referencias al «sistema» por el
juego evaluado, una práctica documentada y aceptada en la literatura sobre
usabilidad que preserva la estructura, los diez ítems y el método de cálculo del
instrumento original. No se trata, por tanto, de un «SUS para videojuegos»
formalmente validado, que como tal no existe de manera única, sino de la
aplicación de esa práctica establecida al contexto de este estudio; esta decisión
se retoma en las limitaciones. Se
prefirió el GEQ sobre alternativas como el GAMEFULQUEST @GamefulQuest19 porque este último
mide «gamefulness», es decir, cuánto se parece una experiencia a un juego,
una pregunta pensada para sistemas gamificados y no para comparar el desafío,
la competencia, la tensión o la inmersión que es lo que realmente interesa
contrastar entre las dos condiciones del jefe. El GEQ además es más breve,
lo que ayuda a no agotar a quien ya respondió el SUS. Cierra la sesión un
bloque de preguntas abiertas sobre si el jefe se sintió predecible o
injusto, y si la persona notó algún tipo de adaptación en su comportamiento.

== Datos registrados

Durante cada sesión, el sistema descrito en la @sec:metricas va guardando
en segundo plano las variables de comportamiento del jugador: distancia al
jefe, proporción de ataques melee y a distancia, esquivas y tiempo en la
zona de tanque durante la exploración, además de los aciertos del jefe y la
cercanía de las curaciones durante el combate. Al terminar, deja persistidos
los pesos de
ataque finales que alcanzó el jefe en esa partida, según el mecanismo
descrito en la @sec:pesos-ataque. Cruzar esta información con las respuestas
de cada participante permite revisar, caso por caso, si el perfil que el
sistema infirió a partir del juego se condice con lo que la propia persona
reportó haber sentido.

Con esos datos se busca responder dos cosas: si el prototipo resulta usable
según el SUS, y si la condición adaptativa cambia, para mejor o peor, la
experiencia reportada en el GEQ y en las preguntas abiertas, en comparación
con la condición de control. En particular interesa ver si esas diferencias,
de existir, van en la dirección que cabría esperar dado cómo se ajustó
efectivamente el jefe en cada partida.

== Resultados

=== Verificación técnica del sistema adaptativo

Antes de analizar la experiencia reportada por los participantes, se verificó
que el mecanismo de adaptación descrito en @sec:pesos-ataque efectivamente se
comportó según lo documentado. Para ello se comparó, en cada una de las 15
sesiones del grupo adaptativo, el ajuste de pesos predicho por las reglas de adaptación pre-combate,
aplicadas manualmente sobre las métricas de exploración de cada participante,
contra el estado real registrado en el archivo de pesos previo al combate. Las
predicciones coincidieron exactamente con el registro real en las 15 sesiones,
lo que confirma que el mecanismo de adaptación pre-combate opera tal como fue
diseñado.

Asimismo, al comparar los pesos previos al combate con los registrados al final de
cada partida, se comprobó que el ajuste durante el combate también estuvo activo en 14
de las 15 sesiones, lo que confirma que ambos mecanismos de adaptación, el previo al
combate y el que ocurre durante este, operaron según lo diseñado.

=== Usabilidad (SUS)

Se aplicó el System Usability Scale (SUS) adaptado a contexto de videojuegos al
cierre de cada sesión, sobre el total de la muestra válida (N = 30; 15 en
condición control y 15 en condición adaptativa). El puntaje promedio general fue
de 77.9 (mediana 77.5, DE = 7.80), por encima del punto de referencia habitual
de la industria (68) y cercano al umbral considerado «Excelente» (80.3). De los
30 participantes, 11 calificaron su experiencia como Excelente, 14 como Buena y 5
como Aceptable, sin registrarse evaluaciones en la categoría Pobre.

Al desagregar por condición, el grupo control obtuvo un promedio de 77.83
(mediana 80.00, DE = 8.44) y el grupo adaptativo un promedio de 78.00 (mediana
77.50, DE = 7.39), sin diferencias apreciables en la distribución de bandas de
calificación entre ambos grupos (control: 6 Excelente, 6 Bueno, 3 Aceptable;
adaptativo: 5 Excelente, 8 Bueno, 2 Aceptable). La @tbl:sus-resumen resume los
estadísticos descriptivos del puntaje SUS por condición y para el total de la
muestra.

#figure(
  align(center, table(
    columns: 5,
    align: (left, center, right, right, right),
    table.header(
      [*Grupo*],
      [*N*],
      [*Promedio*],
      [*Mediana*],
      [*DE*],
    ),
    [Control], [15], [77.83], [80.00], [8.44],
    [Adaptativo], [15], [78.00], [77.50], [7.39],
    [General], [30], [77.92], [77.50], [7.80],
  )),
  caption: [Estadísticos descriptivos del puntaje SUS (0–100) por condición y
    para el total de la muestra.],
) <tbl:sus-resumen>

Se evaluó el supuesto de normalidad mediante la prueba de Shapiro-Wilk de forma
independiente para cada condición, sin encontrarse evidencia de desviación
respecto a la normalidad (control: $W = 0.951$, $p = 0.538$; adaptativo:
$W = 0.935$, $p = 0.322$). En todas las pruebas reportadas en este capítulo, el
valor $p$ corresponde a la probabilidad de obtener un resultado al menos tan
extremo como el observado si la hipótesis nula fuese verdadera, donde el
contenido concreto de dicha hipótesis depende de cada prueba. Un valor menor al
nivel de significancia adoptado ($alpha = 0.05$) se interpreta como evidencia
para rechazarla. Dado que en este caso no se encontró evidencia en contra de la
normalidad, se utilizó una prueba t de muestras independientes (Welch) para
comparar las medias de ambas condiciones. El resultado no mostró diferencias
significativas ($t(27.5) = -0.06$, $p = 0.955$, $d$ de Cohen $= -0.02$), lo que
indica que la usabilidad percibida del prototipo no se vio afectada por la
presencia del sistema de adaptación. Este resultado es coherente con lo
esperado: el mecanismo adaptativo modifica el comportamiento del jefe, no la
interfaz ni los controles del juego, por lo que no debería impactar la
usabilidad general.

=== Experiencia de juego (GEQ)

Se analizaron las cinco dimensiones del Game Experience Questionnaire (GEQ)
consideradas en este estudio: afecto positivo, afecto negativo, desafío, tensión
e inmersión, cada una calculada como el promedio de sus cuatro ítems en escala de
1 a 5. Al evaluar el supuesto de normalidad mediante la prueba de Shapiro-Wilk, se
encontró que tres de las cinco dimensiones (afecto positivo, afecto negativo y
tensión) presentaron desviaciones significativas de la normalidad ($p < 0.01$) en
ambos grupos, lo que motivó el uso de la prueba no paramétrica U de Mann-Whitney
de manera uniforme para todas las dimensiones.

La @tbl:geq-mannwhitney presenta la comparación entre condiciones. Ninguna de las
cinco dimensiones mostró diferencias estadísticamente significativas entre el
grupo control y el adaptativo (todos los valores de $p > 0.05$). Los tamaños de
efecto fueron pequeños en todos los casos. Las dos dimensiones más relevantes para
la hipótesis del estudio, desafío y tensión, mostraron efectos en la dirección
esperada (mediana de desafío levemente mayor en el grupo adaptativo, 2.50 frente a
2.25), pero de magnitud insuficiente para distinguirse del azar con el tamaño de
muestra disponible.

#figure(
  align(center, table(
    columns: 6,
    align: (left, center, center, right, right, right),
    table.header(
      [*Dimensión*],
      [*Md. Control*],
      [*Md. Adapt.*],
      [*U*],
      [*p*],
      [$r$],
    ),
    [Afecto positivo], [4.75], [4.50], [125.0], [0.602], [−0.11],
    [Afecto negativo], [1.25], [1.25], [137.0], [0.301], [−0.22],
    [Desafío], [2.25], [2.50], [96.5], [0.517], [+0.14],
    [Tensión], [1.25], [1.00], [125.0], [0.592], [−0.11],
    [Inmersión], [3.25], [3.50], [106.0], [0.802], [+0.06],
  )),
  caption: [Comparación de las dimensiones GEQ entre condiciones mediante la prueba
    U de Mann-Whitney. Md. corresponde a la mediana; $r$ corresponde al tamaño de
    efecto (correlación rango-biserial). Un valor positivo indica valores mayores en
    el grupo adaptativo.],
) <tbl:geq-mannwhitney>

Al igual que en el SUS, la falta de diferencias significativas en las dimensiones
GEQ indica que, comparando ambos grupos completos, no se puede atribuir al sistema
adaptativo un cambio en la experiencia de juego que reportó el conjunto de los
participantes.

No obstante, más allá de la comparación de medianas, resulta interesante observar
de forma descriptiva la dispersión de las respuestas en cada condición,
representada en la @fig:boxplot-geq. En la dimensión de desafío, si bien las
medianas de ambos grupos son similares, el rango intercuartílico del grupo
adaptativo (0.50) es visiblemente más compacto que el del grupo control (0.88); es
decir, el 50% central de las respuestas se concentra en un intervalo más estrecho.
Esta observación sugiere que el sistema adaptativo pudo haber regulado la
experiencia de desafío hacia un rango más consistente entre jugadores, en lugar de
simplemente elevar su nivel promedio.

#figure(
  grid(
    columns: (1fr, 1fr),
    column-gutter: 4pt,
    row-gutter: 4pt,
    align: center,
    image("imagenes/cap6/boxplot_geq_afecto_positivo.png", width: 100%),
    image("imagenes/cap6/boxplot_geq_afecto_negativo.png", width: 100%),
    image("imagenes/cap6/boxplot_geq_desafio.png", width: 100%),
    image("imagenes/cap6/boxplot_geq_tension.png", width: 100%),
    grid.cell(colspan: 2, align(center,
      image("imagenes/cap6/boxplot_geq_inmersion.png", width: 50%)
    )),
  ),
  caption: [Distribución de las cinco dimensiones GEQ por condición. Cada punto
    representa a un participante; la línea central de cada caja corresponde a la
    mediana y los bordes de la caja al primer y tercer cuartil.],
) <fig:boxplot-geq>

=== Comportamiento en la fase de exploración

Las métricas de comportamiento del jugador (distancia mantenida respecto a los
enemigos, proporción de ataques cuerpo a cuerpo, esquivas) se registran durante la
fase de exploración previa al combate, tal como se describe en
@sec:metricas. Es importante notar que, en esta fase, ambas condiciones juegan un
nivel idéntico: el sistema de adaptación solo actúa sobre el jefe, que aún no ha
aparecido. Por lo tanto, estas métricas no son un resultado de la adaptación, sino
que sirven para dos cosas. Por un lado, son la información que el sistema lee para
ajustar los pesos del jefe (ver @sec:pesos-ataque). Por otro, compararlas entre
grupos permite comprobar que ambos partieron de un estilo de juego parecido, antes
de que el jefe empezara a comportarse distinto en cada condición.

La @tbl:metricas-exploracion presenta esta comparación. Ninguna de las cuatro
métricas mostró diferencias estadísticamente significativas entre condiciones
(todos los valores de $p > 0.05$), lo que indica que ambos grupos exhibieron un
comportamiento de exploración comparable. Se observa una leve tendencia del grupo
adaptativo a jugar algo más lejos (menor proporción de ataques cuerpo a cuerpo,
efecto −0.32, $p = 0.135$). Esta diferencia no es significativa, y en todo caso
refleja una pequeña diferencia de partida entre los grupos, no un efecto de la
adaptación, ya que ocurre antes de que el jefe se comporte distinto en cada
condición.

#figure(
  align(center, table(
    columns: 6,
    align: (left, center, center, right, right, right),
    table.header(
      [*Métrica de exploración*],
      [*Md. Control*],
      [*Md. Adapt.*],
      [*U*],
      [*p*],
      [$r$],
    ),
    [Distancia a los enemigos], [323.44], [300.65], [133.0], [0.407], [−0.18],
    [Ratio de ataques melee], [0.72], [0.62], [149.0], [0.135], [−0.32],
    [Esquivas totales], [38.00], [32.00], [144.0], [0.198], [−0.28],
    [Esquivas exitosas], [3.00], [2.00], [132.0], [0.422], [−0.17],
  )),
  caption: [Comparación del comportamiento durante la fase de exploración entre
    condiciones, mediante la prueba U de Mann-Whitney. Estas métricas corresponden
    al nivel previo al jefe, idéntico para ambos grupos, y sirven como verificación
    de balance de línea base. Md. corresponde a la mediana; $r$ corresponde al
    tamaño de efecto (correlación rango-biserial).],
) <tbl:metricas-exploracion>

=== Duración del combate

A diferencia de las métricas anteriores, la duración del combate contra el jefe sí
corresponde a la fase en la que actúa la adaptación. Se calculó como el tiempo
transcurrido entre el inicio del combate (momento en que se guardan las métricas de
exploración) y la derrota del jefe. La mediana fue de 173 segundos en el grupo
control y de 224 segundos en el adaptativo. La diferencia no resultó
estadísticamente significativa (U de Mann-Whitney; $U = 86.0$, $p = 0.281$,
$r = +0.24$). Aun así, la tendencia va en la dirección esperada: los
combates contra el jefe adaptativo tendieron a durar más, lo que es coherente con una
experiencia algo más demandante, aunque este resultado se limita a la muestra
analizada y no puede generalizarse. La @fig:duracion-combate muestra esta distribución.

#figure(
  image("imagenes/cap6/duracion_combate.png", width: 45%),
  caption: [Duración del combate contra el jefe por condición. Cada punto es un
    participante; la línea central de cada caja corresponde a la mediana. La caja del
    grupo adaptativo aparece desplazada hacia duraciones algo mayores.],
) <fig:duracion-combate>

=== Adaptación percibida según el perfil de juego

Las secciones anteriores comparan al grupo adaptativo como un todo. Sin embargo, al
observar a los participantes jugar durante las sesiones, surgió la hipótesis de que el
efecto del sistema no se percibe por igual en todos los jugadores. Aunque el jefe se
adapta a ambos perfiles, la forma en que lo hace es más notoria para quienes juegan a
distancia: el sistema los presiona acercándose y obligándolos a moverse, un cambio de
comportamiento muy visible. En cambio, para quienes ya pelean de cerca, la adaptación
resulta menos evidente y menos castigadora, ya que se ajusta a un estilo de combate en
el que el jugador, de todos modos, permanece cerca del jefe y está preparado para ese
tipo de intercambio.

Para revisar esta idea, se dividió al grupo adaptativo en dos perfiles según la
distancia que mantuvieron durante la exploración, usando la mediana (300.65) como
corte: un perfil de _rango_ ($n = 8$) y uno de _cuerpo a cuerpo_ ($n = 7$). Conviene
notar que esta distancia se mide antes del combate, y es justamente la señal que el
sistema usa para adaptar al jefe. Es decir, se está agrupando a los jugadores según
algo que ocurre antes de la experiencia que luego reportan.

Al comparar la tensión reportada entre ambos perfiles, se observa una diferencia
apreciable: los jugadores de perfil de rango reportaron una tensión media de 1.69,
frente a 1.07 en los de perfil cuerpo a cuerpo. Esta diferencia alcanzó el nivel de
significancia habitual ($U = 43.5$, $p = 0.050$, $r = 0.55$), con un tamaño de efecto
grande, a pesar de lo pequeños que son los subgrupos. La dimensión
de desafío mostró una diferencia en la misma dirección pero menor y no significativa
(medias de 2.69 frente a 2.39; $p = 0.555$).

Lo más importante es que esta diferencia aparece únicamente en el grupo adaptativo.
Al aplicar la misma división al grupo control, ambos perfiles reportaron una tensión
prácticamente igual (medianas de 1.25 y 1.12 para cuerpo a cuerpo y rango). Esto es lo
que cabría esperar: aunque el jefe control también elige sus ataques según la distancia
momentánea del jugador, igual que el adaptativo, no ajusta sus pesos al estilo de juego
de cada persona, por lo que no presiona de forma especial a quienes se mantienen a
distancia. La @fig:distancia-tension ilustra este
contraste: la diferencia entre perfiles aparece únicamente en la condición
adaptativa. La misma conclusión se obtiene al analizar la relación de forma continua,
mediante la correlación entre la distancia de exploración y la tensión: esta resulta
positiva y significativa en el grupo adaptativo (Spearman $r_s = 0.517$, $p = 0.048$),
pero prácticamente nula en el grupo control ($r_s = -0.075$, $p = 0.790$). El hecho de
que la asociación aparezca solo cuando el jefe se adapta es la evidencia más directa de
este estudio de que el sistema logró generar una experiencia diferenciada. Si bien la
adaptación busca presionar a ambos perfiles de juego, acercándose a quienes juegan a
distancia y reforzando los ataques de corto alcance contra quienes pelean de cerca, su
efecto sobre la tensión fue más marcado en los jugadores de rango. Esto podría deberse a
la forma en que está construida la adaptación, que parece presionar con más eficacia a
quienes se mantienen lejos, y en parte también al perfil de experiencia de cada tipo de
jugador, como se discute a continuación.

#figure(
  image("imagenes/cap6/tension_por_perfil.png", width: 90%),
  caption: [Tensión reportada según el perfil de juego (cuerpo a cuerpo o rango,
    definido por la mediana de distancia de exploración de cada grupo), separada por
    condición. El área de cada violín representa cómo se distribuyen las respuestas y
    la línea horizontal marca la mediana; cada punto es un participante. En la
    condición adaptativa los jugadores de perfil de rango reportan una tensión mayor
    (el perfil cuerpo a cuerpo se concentra en el valor mínimo), mientras que en la
    condición control ambos perfiles son equivalentes.],
) <fig:distancia-tension>

Ahora bien, antes de atribuir este resultado al estilo de juego, conviene revisar una
explicación alternativa que surgió al observar a los participantes durante las sesiones:
los jugadores de estilo más cercano y agresivo solían ser también los más familiarizados
con este tipo de juegos. Si eso fuera cierto, la menor tensión de los jugadores cuerpo a
cuerpo no se debería a su estilo de juego, sino simplemente a que son más hábiles y al
sistema le cuesta más presionarlos. Para descartar esta posibilidad se hicieron tres
revisiones. Primero, se midió si la distancia de juego y la experiencia estaban realmente
relacionadas dentro del grupo adaptativo, y la relación resultó débil y no significativa
($r_s = -0.313$, $p = 0.256$). Segundo, se comparó la experiencia promedio de ambos
perfiles, que resultó muy parecida (6.25 en el perfil de rango y 6.71 en el de cuerpo a
cuerpo). Tercero, y lo más importante, se volvió a medir la relación entre distancia y
tensión pero descontando el efecto de la experiencia, mediante una técnica llamada
correlación parcial: si la tensión se debiera en realidad a la habilidad, esta relación
debería debilitarse al descontar la experiencia; en cambio, se mantuvo, e incluso siguió
siendo significativa ($r_s = 0.537$, $p = 0.039$). En conjunto, esto sugiere que la mayor
tensión de los jugadores de rango responde a su estilo de juego y no simplemente a
diferencias de habilidad.

En la misma línea, al examinar la relación entre el puntaje de experiencia y las
dimensiones del GEQ sobre el total de la muestra, no se encontró ninguna correlación
significativa (por ejemplo, experiencia frente a desafío: $r_s = -0.221$,
$p = 0.240$; frente a tensión: $r_s = -0.010$, $p = 0.959$). Es decir, en estos datos
los jugadores más experimentados no reportaron sistemáticamente una experiencia
menos desafiante o tensa.

Estos análisis, sin embargo, tienen una limitación de fondo: medir la experiencia
real de un jugador es difícil de por sí. El puntaje se construye a partir de la
frecuencia de juego, los años que lleva jugando y la cantidad de títulos similares
jugados, datos que reflejan cuánto ha jugado, pero no necesariamente qué tan hábil es
ni qué tan familiarizado está con este tipo de combate en particular. Se observaron
casos en que un participante con un puntaje alto mostraba, tanto en su desempeño como
en la conversación durante la sesión, una soltura menor a la que su puntaje sugería.
Esto, sumado a lo pequeña que es la muestra, implica que no se puede descartar del
todo esta posible confusión, y que el vínculo entre experiencia y estilo de juego
debe tomarse como algo tentativo y no como una relación comprobada.

=== Análisis de las preguntas abiertas

Al cierre de la sesión, cada participante respondió cuatro preguntas abiertas sobre
la predictibilidad del jefe, los aspectos más interesantes o frustrantes del combate,
si percibió que el jefe aprendía o cambiaba según sus acciones, y qué tan justo le
pareció su comportamiento. Las respuestas se codificaron temáticamente, asignando cada
una a una categoría mediante lectura manual del texto completo.

La pregunta sobre percepción de aprendizaje es la más directamente ligada a la
hipótesis del estudio. Como resume la @tbl:aprendizaje, 10 de los 15 participantes del
grupo adaptativo (67%) reportaron percibir que el jefe aprendía o cambiaba según sus
acciones, frente a 7 de 15 (47%) en el grupo control. Si bien la dirección es la
esperada, la diferencia no alcanza significancia estadística (prueba exacta de Fisher,
$p = 0.462$), lo que se explica en parte por el tamaño de la muestra y, como se discute
a continuación, por la notable proporción de respuestas afirmativas también en la
condición control.

#figure(
  align(center, table(
    columns: 3,
    align: (left, center, center),
    table.header(
      [*Condición*],
      [*Sí*],
      [*No*],
    ),
    [Adaptativo], [10], [5],
    [Control], [7], [8],
  )),
  caption: [Percepción de aprendizaje o adaptación del jefe según condición, a partir
    de la codificación de la pregunta abierta correspondiente.],
) <tbl:aprendizaje>

Ahora bien, este resultado debe matizarse con dos observaciones que emergen de la
lectura cualitativa. En primer lugar, varias respuestas clasificadas como afirmativas
describen en realidad el comportamiento por diseño del jefe según la distancia (por
ejemplo, "si me acercaba atacaba de cerca, y si me alejaba usaba ataques a distancia"),
un patrón que responde a la posición del jugador pero que no constituye necesariamente
un aprendizaje en el sentido de adaptación al historial de acciones. La pregunta no
obliga a distinguir entre ambos fenómenos, por lo que el conteo de respuestas
afirmativas probablemente sobreestima cuántos participantes percibieron una adaptación
real. En segundo lugar, y de manera reveladora, casi la mitad de los participantes del
grupo control (7 de 15), que enfrentaron un jefe de comportamiento completamente fijo,
también afirmaron percibir aprendizaje, describiendo con detalle cambios que el jefe no
realizó. Esto evidencia que la percepción de adaptación es una señal ruidosa,
susceptible de atribuciones que no se corresponden con el comportamiento real del
sistema.

Una posible razón de que varios jugadores del grupo control creyeran ver adaptación es
lo que se conoce como sesgo de expectativa. Como a los participantes nunca se les dijo
qué versión estaban jugando, y el estudio trata justamente sobre enemigos que se
adaptan, es probable que muchos llegaran esperando encontrar un jefe adaptativo. Esa
expectativa pudo hacer que interpretaran como adaptación cosas que en realidad no
cambiaban. Esto muestra, una vez más, que no conviene basarse solo en lo que el jugador
dice para saber si notó la adaptación.

La idea de que la percepción de adaptación no siempre coincide con lo que el jefe
realmente hizo pudo verificarse de forma directa, ya que el sistema guarda los pesos
de ataque reales de cada partida. Esto permite comparar lo que cada participante dijo
haber notado con los cambios que efectivamente ocurrieron en el _behaviour tree_
de su combate. Al hacer ese cruce, se encontró que la correspondencia
es baja. Un caso ilustrativo de
coincidencia es el de un participante del grupo adaptativo que reportó que el jefe "se
agachaba" para evitar sus proyectiles, lo que efectivamente coincide con un aumento
sustancial del peso del ataque de charco durante su combate. Sin
embargo, otros participantes describieron ataques que percibieron como intensificados
(por ejemplo, proyectiles que "se multiplicaban") cuyos pesos, al revisar el registro,
no se modificaron en absoluto. En el grupo control, por definición, la totalidad de
estas percepciones corresponden a atribuciones, dado que los pesos permanecieron fijos
durante toda la partida. Este contraste refuerza la idea de que lo que los jugadores
reportan sobre la adaptación del jefe debe interpretarse con cautela, y
constituye una de las razones por las que el análisis de este trabajo se apoya
principalmente en las métricas objetivas y en el registro interno del sistema.

Sobre la predictibilidad (pregunta 1), los resultados van en la línea de una
experiencia más diferenciada: en el grupo control, 11 de 15 participantes (73%)
describieron al jefe como predecible, mientras que en el grupo adaptativo solo lo
hicieron 7 de 15 (47%), y el resto lo calificó como poco predecible. En cuanto a la
justicia (pregunta 4), no hubo diferencias entre versiones: casi todos los
participantes de ambos grupos (14 de 15 en el adaptativo y 13 de 15 en el control)
consideraron justo el comportamiento del jefe, lo que indica que la dificultad, incluso
en la versión adaptativa, no se sintió como arbitraria o injusta.

Por último, las respuestas sobre lo más interesante o frustrante del combate (pregunta
2), más ligadas al diseño del juego que a la hipótesis del estudio, dejaron ver algunos
temas que se repitieron en ambos grupos. Los más mencionados fueron la imposibilidad de
cancelar las animaciones de ataque del jugador (señalada por cinco participantes como
algo frustrante) y, en el lado positivo, la variedad de ataques del jefe (destacada por
otros cinco como lo más interesante del combate). Aunque no responden directamente a
las preguntas del estudio, son comentarios útiles para mejorar el prototipo en el
futuro.

== Discusión

Los resultados permiten evaluar la hipótesis central del trabajo: que un jefe con un
sistema de adaptación genera una experiencia más desafiante y personalizada que un jefe
fijo. La respuesta que dan los datos es mixta. Por un lado, el sistema funciona como fue
diseñado y hay señales claras de que produjo una experiencia distinta en un grupo específico
de jugadores. Por otro, esa diferencia no apareció como un efecto parejo en toda la muestra,
al menos no con una fuerza que se pudiera detectar con la cantidad de participantes que se
tuvo.

En lo técnico, la revisión de los pesos de ataque confirmó que el mecanismo de adaptación
funciona como se especificó: las reglas previas al combate se cumplieron en todas las
sesiones y el ajuste durante el combate estuvo activo en casi todas. Esto importa porque
deja claro, antes de interpretar nada sobre la experiencia percibida, que el jefe realmente
ajustó su comportamiento a cada jugador. Así, si no se observa un efecto en las mediciones
subjetivas, no puede deberse a una falla en la implementación.

Al comparar los grupos completos en las mediciones de experiencia (SUS y las dimensiones
del GEQ), no se encontraron diferencias significativas. En el SUS, esta equivalencia es
esperable e incluso deseable: el sistema adaptativo cambia el comportamiento del jefe, no la
usabilidad del juego, por lo que no debía afectar este puntaje. En el GEQ, la falta de
diferencias en desafío y tensión, que son las dimensiones más importantes para la hipótesis,
indica que, mirando a los dos grupos en conjunto, no se puede afirmar que la adaptación haya
hecho la experiencia más desafiante para el jugador promedio. Las diferencias observadas van
en la dirección esperada, pero son pequeñas. Aun así, este resultado es coherente con cómo
funciona el sistema: un mecanismo que ajusta al jefe según el estilo de cada jugador no
tiene por qué subir el desafío de forma pareja en todos, sino que su efecto depende de a
quién y de qué manera se adapta.

Es justamente al dejar de mirar a los grupos como un todo, y observar dentro del grupo
adaptativo, donde aparece el resultado más importante del estudio. Los jugadores de perfil
de rango reportaron una tensión bastante mayor que los de perfil cuerpo a cuerpo, con un
efecto grande y en el límite de la significancia, a pesar de lo pequeños que son los
subgrupos. Lo clave es que este patrón aparece solo en la condición adaptativa: en el grupo
control, dividido de la misma forma, ambos perfiles reportan una tensión parecida. Como el
jefe control reacciona a la posición del jugador igual que el adaptativo, pero sin ajustar
sus pesos al estilo de juego, el hecho de que el efecto aparezca solo cuando la adaptación
está activa es la evidencia más directa de que el sistema logró generar una experiencia
distinta. Aunque el sistema busca presionar a ambos perfiles de juego, este efecto fue más
notorio en los jugadores de rango, lo que sugiere que la adaptación resultó más efectiva
contra quienes se mantienen a distancia. Además, el análisis del posible papel de la
experiencia previa sugiere que esta diferencia responde al estilo de juego y no simplemente
a la habilidad.

El análisis de las preguntas abiertas deja una lección importante. Aunque una mayor
proporción de participantes del grupo adaptativo dijo percibir que el jefe aprendía, la
diferencia con el grupo control fue chica, y casi la mitad de los participantes de control,
que jugaron contra un jefe completamente fijo, también afirmaron percibir adaptación. Al
cruzar estas respuestas con el registro real de pesos, se confirmó que lo percibido coincide
poco con lo que de verdad pasó. Esto muestra que lo que el jugador dice haber notado sobre la
adaptación es una señal poco confiable, influida probablemente por un sesgo de expectativa y
por lo difícil que es distinguir una adaptación real de un comportamiento que solo reacciona
a la posición. Tener un registro interno del sistema fue clave para no depender solo de la
percepción de los jugadores, y respalda la decisión de apoyar las conclusiones en las
métricas objetivas.

Otros dos hallazgos, más descriptivos, apuntan en la misma dirección de una experiencia
distinta. El jefe adaptativo se percibió como menos predecible que el control, lo que calza
con un comportamiento que varía según el jugador. Y la menor dispersión de las respuestas de
desafío en la condición adaptativa (reflejada en el menor rango intercuartílico de la
@fig:boxplot-geq) sugiere que el sistema pudo haber acercado la experiencia
de distintos jugadores a un rango más parejo, en lugar de subir su nivel promedio; esta
observación, aunque descriptiva y no confirmada mediante una prueba inferencial, calza con el
propósito de un ajuste de dificultad. Por último, que el jefe se percibiera como justo en ambas versiones indica
que la adaptación no se logró a costa de volverlo arbitrario o frustrante.

En síntesis, el trabajo muestra que es posible implementar un sistema de adaptación de este
tipo y que produce efectos apreciables sobre la experiencia, aunque de forma localizada y no
como un cambio parejo en toda la población de jugadores. La evidencia más sólida viene del
comportamiento distinto según el perfil de juego y del registro interno del sistema, más que
de las comparaciones entre grupos completos o de lo que los jugadores declararon. De todos modos, estos
resultados deben leerse considerando las limitaciones del estudio, que se detallan a
continuación, y que recomiendan tomarlos como indicios prometedores de una prueba de
concepto, más que como conclusiones que se puedan generalizar.

== Implicancias

Más allá de los resultados de este jefe en particular, hacer este trabajo dejó algunas
lecciones que pueden servir a quien quiera diseñar enemigos adaptativos en otros videojuegos
de índole similar.

Una primera lección es que, si se quiere que el jugador note la adaptación, conviene que esta
se note en algo llamativo y no solo en pequeños cambios de frecuencia. En este estudio, el
caso donde más claramente el jugador notó lo que realmente pasó fue uno en que el jefe empezó
a usar mucho más seguido una transformación bien vistosa, su forma de charco; en cambio,
cuando el cambio era solo que un ataque se repitiera un poco más que otro, casi nadie lo notó
o lo confundió con otra cosa. Esto sugiere que, para que la adaptación se sienta, conviene que
se traduzca en un comportamiento reconocible y no solo en ajustar un poco más seguido un
ataque que ya existía.

Vale la pena aclarar que esto no quiere decir que el jugador necesite darse cuenta de que el
jefe se está adaptando para que la adaptación cumpla su función. Acá, la tensión
de los jugadores de perfil de rango subió igual, aunque muchos de ellos no supieran explicar
conscientemente que eso se debía a un cambio de comportamiento del jefe. Que la adaptación sea
perceptible es más bien una decisión de diseño aparte: se puede buscar a propósito si se
quiere que el jugador sienta que enfrenta a un enemigo que le responde, pero la adaptación
puede seguir funcionando y cambiando cómo se siente el combate aunque el jugador no la note.

En esa misma línea, una buena adaptación tampoco es simplemente subirle los números al
enemigo, como hacer que un ataque pegue más fuerte o más rápido. Ese tipo de cambio es fácil
de hacer, pero el jugador lo suele sentir como que el juego se puso más difícil de forma
pareja para todos, no como que el enemigo cambió su forma de jugar. En el sistema desarrollado,
la adaptación no tocaba el daño ni la velocidad de los ataques del jefe, sino qué tan seguido elegía cada uno
según cómo jugaba la persona: el jefe seguía siendo igual de fuerte, pero cambiaba de
estrategia. Adaptar el comportamiento, y no solo subir los números base, es lo que permite que
el desafío suba sin sentirse como un ajuste artificial o injusto.

Además, ayuda que cada tipo de comportamiento del jugador tenga asociada una respuesta propia
y reconocible del enemigo, en vez de un solo ajuste genérico que lo hace todo más difícil por
igual. Acá, el jefe reaccionaba de forma distinta
según si el jugador peleaba de cerca o de lejos, si esquivaba tarde o temprano, o si se
quedaba mucho rato en una zona particular, y cada una de esas situaciones activaba ajustes
distintos. Diseñar así, con respuestas específicas para comportamientos específicos, hace más
fácil que el jugador, aunque sea de forma intuitiva, relacione lo que él hizo con lo que el
enemigo hizo después.

Por último, un sistema de ajuste de dificultad no necesita hacer el juego más difícil en
promedio para cumplir su objetivo. En los datos recogidos, el grupo adaptativo mostró menos
diferencias entre jugadores en cuánto desafío sintieron, comparado con el grupo de control.
Eso sugiere que la meta de un sistema como este puede ser que distintos jugadores sientan un
nivel de desafío parecido entre ellos, más que simplemente subirle la dificultad a todos por
igual.

== Cumplimiento de los objetivos

Con respecto a los objetivos planteados al inicio del trabajo, es posible revisar su grado
de cumplimiento a la luz de los resultados. El objetivo general, diseñar e implementar un
sistema de adaptación para un enemigo jefe capaz de ajustar su comportamiento a partir del
perfil del jugador, se cumplió: el sistema fue construido, funciona como se especificó y su
efecto sobre la experiencia fue evaluado mediante una prueba de concepto. A continuación se
revisa cada objetivo específico.

#[
- *Investigar y analizar enfoques existentes de inteligencia artificial adaptativa en
  videojuegos.* Cumplido. El estado del arte y los enfoques revisados se presentan en el
  capítulo de trabajo relacionado, y sirvieron de base para las decisiones de diseño del
  sistema.

- *Construir una versión base del juego con un jefe de comportamiento fijo que sirva como
  caso de control.* Cumplido. Se desarrolló una versión de control, idéntica a la adaptativa
  salvo en que los pesos de ataque del jefe no se ajustan, que se utilizó como grupo de
  comparación en el estudio.

- *Diseñar e implementar un conjunto de enemigos regulares que permitan construir un perfil
  del estilo de juego.* Cumplido. Los enemigos de la fase de exploración, junto con el
  sistema de métricas, permiten registrar el comportamiento del jugador y traducirlo en un
  perfil (distancia, uso de melee o distancia, esquivas, entre otros).

- *Implementar un mecanismo que ajuste los pesos de ataque del jefe a partir de dicho perfil
  antes del combate.* Cumplido. El mecanismo fue implementado y, además, se verificó que
  operó según lo diseñado: los ajustes predichos por las reglas coincidieron exactamente con
  los pesos reales registrados en las 15 sesiones del grupo adaptativo.

- *Validar el sistema mediante pruebas de jugabilidad, midiendo la capacidad de adaptación
  del jefe y la percepción de desafío.* Cumplido. Se realizaron pruebas con 30 participantes;
  la capacidad de adaptación se verificó a través del registro interno de pesos, y la
  percepción de desafío y tensión se midió con el GEQ. Si bien la comparación entre grupos
  completos no arrojó diferencias significativas, el objetivo de medir estos aspectos se
  cumplió, y el análisis por perfil de juego mostró un efecto apreciable en los jugadores de
  perfil de rango.

- *Comparar los resultados entre la versión adaptativa y la de control, identificando
  ventajas, limitaciones y posibles mejoras.* Cumplido. Se compararon ambas versiones en las
  métricas objetivas, el SUS, el GEQ y las preguntas abiertas. Como ventaja se identificó la
  experiencia diferenciada en el perfil de rango; como limitaciones, el tamaño reducido de la
  muestra, la debilidad de los efectos al mirar todo el grupo junto y la baja confiabilidad de lo que
  los jugadores reportaron; y como posibles mejoras, las que se detallan en el trabajo futuro.
]

== Limitaciones

Los resultados de este trabajo deben interpretarse considerando varias limitaciones,
propias de una prueba de concepto, que afectan tanto su confiabilidad como su capacidad de
generalización.

#[
- *Tamaño de la muestra.* Con 30 participantes (15 por condición), el estudio tiene un poder
  estadístico bajo. Diferencias reales de magnitud moderada podrían no alcanzar
  significancia, por lo que los resultados deben tomarse como descriptivos y no
  generalizables a toda la población de jugadores.


- *Dificultad para medir la experiencia.* El puntaje usado para clasificar la experiencia se
  construye a partir de la frecuencia de juego, los años jugando y la cantidad de títulos
  similares. Este indicador refleja cuánto ha jugado una persona, pero no necesariamente su
  habilidad real ni su familiaridad con este tipo de combate. Además, el corte elegido (de 0
  a 3 poca experiencia, de 4 a 9 con experiencia) resultó demasiado permisivo, ya que todos
  los participantes quedaron sobre el umbral; un corte más alto habría distinguido mejor los
  perfiles. En conjunto, esto limita cualquier análisis que dependa de la experiencia.

- *Desbalance entre grupos.* En relación con lo anterior, el grupo adaptativo quedó, en
  promedio, levemente más experimentado que el de control (6.47 frente a 6.07), y mostró
  además una pequeña diferencia de estilo de juego en la fase de exploración. Aunque ninguna
  de estas diferencias fue significativa, introducen una fuente de variación no controlada.

- *Confiabilidad de lo que reporta el jugador y sesgo de expectativa.* La percepción de adaptación
  reportada en las preguntas abiertas resultó poco confiable, con baja correspondencia entre
  lo percibido y los cambios reales del sistema. A esto se suma que, al no indicarse a los
  participantes qué versión jugaban y estar el estudio enmarcado en el diseño de enemigos
  adaptativos, muchos pudieron llegar esperando encontrar adaptación, lo que probablemente
  infló su percepción. Por estas razones, las conclusiones se apoyaron principalmente en las
  métricas objetivas y en el registro interno de pesos.

- *Alcance de la adaptación.* El sistema se concentra en la adaptación previa al combate. Si
  bien existe un ajuste durante el combate, su alcance es acotado, y una adaptación en tiempo
  real más completa quedó fuera del alcance de este trabajo. Los efectos observados
  corresponden, por tanto, principalmente a la adaptación pre-combate.

- *Instrumentos adaptados.* Tanto el SUS como el GEQ se aplicaron en versiones adaptadas. En
  el caso del SUS, la adaptación consistió en sustituir las referencias al «sistema» por el
  juego, siguiendo una práctica documentada y aceptada; aun así, no corresponde a un
  instrumento formalmente validado para videojuegos, por lo que se reporta como adaptación y
  no como el SUS validado textualmente. El GEQ, por su parte, se aplicó en una traducción al
  español. Estas adaptaciones facilitan la comprensión de los participantes, pero implican que
  no se trata de los instrumentos validados en su forma original, lo que introduce una posible
  imprecisión.


]

]

// ==========================================
// CAPÍTULO 7: CONCLUSIÓN Y TRABAJO FUTURO
// ==========================================
#capitulo(title: "Conclusión y trabajo futuro")[

    == Conclusión

    Este trabajo partió de un problema concreto: los enemigos de comportamiento fijo se
    vuelven predecibles una vez que el jugador aprende su patrón. Para abordarlo, se diseñó e
    implementó un jefe capaz de ajustar su comportamiento de combate al estilo de cada
    jugador, cambiando qué tan seguido elige cada uno de sus ataques según un perfil
    construido a partir de cómo la persona jugó antes del enfrentamiento. Todo el sistema se
    construyó con las herramientas nativas de Unreal Engine, sobre un juego del género
    _souls-like_ hecho especialmente para este trabajo, y se evaluó comparándolo contra una
    versión de control idéntica salvo por la adaptación.

    Los resultados se pueden resumir en tres puntos. Primero, el sistema funciona como se
    especificó: al comparar las reglas de ajuste con los pesos de ataque realmente
    registrados en cada sesión, se confirmó que el jefe sí ajustó su comportamiento al perfil
    de cada jugador. Segundo, al comparar la versión de control con la adaptativa mirando
    todo el grupo junto, las diferencias observadas fueron pequeñas y no alcanzaron a ser
    significativas; con una muestra tan pequeña, eso no permite descartar que exista un efecto
    real, solo indica que, con esta cantidad de participantes, no llegó a hacerse visible.
    Tercero, y más importante, al mirar el estilo de juego de cada persona el efecto sí
    apareció: los jugadores de perfil a distancia reportaron una tensión notablemente mayor en
    la versión adaptativa, mientras que en los de perfil cuerpo a cuerpo ese efecto casi no se
    notó, y esa diferencia no aparece en la versión de control.

    Así, la contribución principal de este trabajo es un sistema capaz de adaptar el
    comportamiento del jefe al estilo de cada jugador, que en la práctica funcionó mejor
    contra quienes se mantienen a distancia que contra quienes pelean cuerpo a cuerpo. Esa
    diferencia no se puede atribuir por completo al estilo de juego, ya que también podría
    influir la experiencia previa de cada perfil de jugador. A esto se suma una lección
    metodológica: confiar solo en lo que el jugador reporta tiene límites para evaluar
    sistemas de este tipo, y la evidencia más sólida terminó viniendo del registro interno del
    sistema más que de lo que los jugadores declararon.

    En conjunto, el objetivo general se cumplió: el sistema fue diseñado, implementado,
    verificado y evaluado mediante una prueba de concepto, y cada uno de los objetivos
    específicos se abordó según se detalla en el capítulo anterior. Los efectos observados,
    eso sí, deben leerse como indicios prometedores de una prueba de concepto y no como
    conclusiones generalizables a toda la población de jugadores, dadas las limitaciones ya
    discutidas.

    == Trabajo futuro

    A partir de lo aprendido, quedan varias líneas abiertas para continuar este trabajo.

    La más directa es repetir la evaluación con una muestra más grande y, de ser posible, con
    un diseño en que la misma persona juegue ambas versiones. Con más participantes se ganaría
    poder estadístico para detectar efectos de magnitud moderada que acá pudieron pasar
    desapercibidos, y un diseño intrasujeto ayudaría a separar el efecto de la adaptación de la
    experiencia previa de cada perfil de jugador, que en este estudio quedó como una posible
    fuente de confusión.

    Otra línea es reforzar la adaptación contra los jugadores de perfil cuerpo a cuerpo, que
    fue donde el sistema tuvo menos efecto. Vale la pena revisar si las reglas y los ataques
    disponibles alcanzan a presionar de forma reconocible a quien pelea de cerca, o si hace
    falta diseñar respuestas más específicas para ese estilo de juego.

    También queda pendiente extender la adaptación al combate mismo. El sistema actual se
    concentra en el ajuste previo al enfrentamiento, con solo un ajuste acotado durante la
    pelea; una adaptación en tiempo real más completa, que responda a las acciones del jugador
    a lo largo del combate, era parte de lo considerado en la propuesta original y quedó fuera
    del alcance de este trabajo.

    Otra línea, que surge directamente de lo que dijeron los jugadores en las preguntas
    abiertas, es pulir la jugabilidad del prototipo. El comentario negativo más repetido, hecho
    por cinco participantes de ambos grupos, fue la imposibilidad de cancelar las animaciones de
    ataque del propio personaje, algo que se sintió como una limitación del control durante el
    combate. Resolver esto, junto con otros ajustes de manejo que aparecieron en las respuestas,
    haría que la experiencia dependa menos de fricciones ajenas a la adaptación y permitiría
    evaluar el sistema sobre una base de juego más sólida. En el lado positivo, la variedad de
    ataques del jefe fue lo que más gente destacó como interesante, lo que sugiere que mejorar
    ese repertorio es un camino prometedor para futuras versiones.

    Por último, sería valioso complementar lo que el jugador declara con instrumentos menos
    dependientes de su opinión. Dado que en este estudio la percepción reportada resultó poco
    confiable, medidas más objetivas, como telemetría más fina del comportamiento en combate o
    señales fisiológicas, podrían dar una imagen más precisa del efecto real de la adaptación
    sobre la experiencia.

]

#show: end-doc

// ==========================================
// ANEXOS / APÉNDICES
// ==========================================
#apendice(title: "Cuestionario de Experiencia de Juego (GEQ)")[

    A continuación se presenta el _Game Experience Questionnaire_ @GEQuestionare traducido al
    español, tal como se aplicó en el estudio. Sus 20 afirmaciones se responden en una escala de
    5 puntos (1 = mínimo, 5 = máximo) y se agrupan en cinco dimensiones de cuatro ítems cada
    una. #footnote[Las afirmaciones se presentaron a los participantes en un orden mezclado, sin
    indicar a qué dimensión pertenecía cada una.]

    === Afecto positivo

    + Me sentí satisfecho/a.
    + Me sentí feliz.
    + Pensé que fue divertido.
    + Lo disfruté.

    === Afecto negativo

    + Me sentí aburrido/a.
    + Me pareció cansador/a.
    + Me puso de mal humor.
    + Pensé en otras cosas.

    === Desafío

    + Me sentí desafiado/a.
    + Pensé que fue difícil.
    + Tuve que esforzarme mucho.
    + Sentí presión de tiempo.

    === Tensión

    + Me sentí frustrado/a.
    + Me sentí molesto/a.
    + Me sentí irritable.
    + Me sentí presionado/a.

    === Inmersión

    + Me olvidé de todo lo que me rodeaba.
    + Me pareció impresionante.
    + Se sintió como una experiencia rica.
    + Perdí la conexión con el mundo exterior.

]