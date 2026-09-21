# Guion de defensa — 20 minutos

**Presupuesto de tiempo**

| Bloque | Diapositivas | Tiempo | % |
|---|---|---|---|
| Inicio | 1–5 | 0:00 – 1:55 | 9% |
| Antecedentes y diseño | 6–16 | 1:55 – 8:50 | 35% |
| Aporte propio (resultados y discusión) | 17–26 | 8:50 – 16:00 | 36% |
| Cierre | 27–30 | 16:00 – 18:00 | 10% |
| **Colchón** | — | 18:00 – 20:00 | 10% |

El bloque "antecedentes y diseño" incluye el sistema adaptativo, que es aporte
propio, pero funciona como el "materiales y métodos" de la exposición. Sin
contarlo, el reparto es 49% antecedentes y 51% aporte propio, dentro de lo
recomendado. Contándolo, el aporte propio sube a cerca de tres cuartos.

**Regla de rescate.** Si a los 11:35 todavía no llegaste a la diapositiva 21
("El hallazgo", que en pantalla aparece como 20/29), salta la 20 (GEQ) resumiéndola en una frase: *"ninguna
dimensión del GEQ mostró diferencias significativas mirando los grupos
completos"*. Nunca sacrifiques las diapositivas 21 y 22.

---

## INICIO — 0:00 a 1:55

### Diapositiva 1 — Portada · 0:00 – 0:20

> Buenas tardes, profesores. Mi nombre es Amaro Zurita y hoy les voy a presentar
> mi memoria para optar al título de Ingeniero Civil en Computación, titulada
> "Diseño e implementación de enemigos adaptativos en videojuegos", desarrollada
> bajo la guía del profesor Francisco Gutiérrez y la co-guía del profesor Elías
> Zelada.

*Respira. No leas la comisión en voz alta, está en pantalla.*

### Diapositiva 3 — El problema · 0:20 – 1:00

> Quiero partir por el problema concreto. En juegos de acción exigentes, como Elden Ring, los
> jefes siguen patrones de ataque fijos. Eso significa que después de varios
> intentos el jugador se los aprende de memoria, y a partir de ahí la dificultad
> deja de ser un desafío y pasa a ser un ejercicio de memorización.
>
> Ahora, sí existen técnicas para ajustar la dificultad de forma dinámica. Pero
> la gran mayoría ajusta *números*: la vida del enemigo, su daño, su velocidad.
> Ninguna cambia *cómo* se comporta.

### Diapositiva 4 — La excepción y la pregunta · 1:00 – 1:35

> Hay un caso especial, el ejemplo que más se repite cuando se habla de
> enemigos adaptativos. En *Alien: Isolation* el alien aprende dónde sueles
> esconderte y cambia sus rutas de patrullaje, así que el escondite que te
> salvó una vez deja de servirte. Que siempre se llegue al mismo juego ya dice
> lo poco común que es.

*Acá baja el ritmo y mira a la comisión, no a la pantalla. Es la pregunta
central de toda la defensa: dila, pero no la leas palabra por palabra.*

> Y de ahí sale la pregunta de este trabajo: ¿y si el jefe reconociera cómo
> juega cada persona y cambiara su estrategia según eso? Un mismo jefe podria ser distinto para todos. 
### Diapositiva 5 — Agenda · 1:35 – 1:55

*No leas los seis puntos, ya están en pantalla. Agrúpalos.*

> Para responder eso, la presentación va así. Primero los objetivos. Después,
> cómo se construyeron el juego y el sistema que adapta al jefe. Luego, cómo se
> puso a prueba con treinta personas. Y al final, los resultados, que fueron
> menos simples de lo esperado.

---

## ANTECEDENTES Y DISEÑO — 1:55 a 8:50

### Diapositiva 6 — Objetivos · 1:55 – 2:40

*Lee el objetivo general tal cual está en pantalla. Es casi el mismo que está
en el escrito, así que conviene no improvisarlo.*

> El objetivo general fue diseñar e implementar un sistema de adaptación para un
> enemigo jefe, capaz de ajustar su comportamiento de combate a
> partir de un perfil construido sobre las acciones previas del jugador, para
> reducir la previsibilidad del enfrentamiento y evaluar su efecto sobre la
> experiencia de juego.
>
> Los específicos van desde revisar el estado del arte hasta comparar la versión
> adaptativa contra una de control. Quiero destacar dos: el número dos, construir
> una versión base con jefe fijo que sirva de control, y el número tres, diseñar
> enemigos regulares que expongan el estilo de juego. Esos dos son los que hacen
> posible todo el resto.

### Diapositiva 8 — El juego · 2:40 – 3:25

> No había un juego base donde probar esto, así que se construyó uno. Es un juego de acción
> al estilo de Elden Ring, en Unreal Engine 5.6, hecho con Blueprints y C++, usando las herramientas
> nativas de inteligencia artificial del motor: Behaviour Tree y Blackboard.
>
> Tiene las mecánicas clásicas del género: combate melee, hechizos a distancia,
> esquiva con frames de invulnerabilidad, stamina, pociones y fijado de objetivo.
>
> El nivel previo al jefe no es relleno. Es ahí donde el sistema observa cómo
> juega la persona. Tiene tres arquetipos de enemigo, y cada uno está diseñado
> a propósito para exponer una dimensión distinta del estilo de juego.

### Diapositiva 9 — El repertorio del jefe · 3:25 – 3:40

> El jefe tiene nueve ataques, agrupados en rangos de distancia. Dentro de cada
> rango elige mediante un selector aleatorio ponderado implementado en C++, y
> todos los ataques parten con el mismo peso base: cincuenta.

### Diapositiva 10 — La decisión de diseño central · 3:40 – 4:05

*Dos columnas, no las leas en voz alta: la comisión ya las está leyendo. Di la
idea y deja que la pantalla haga el resto.*

> Y acá está la decisión de diseño central del trabajo. La adaptación no sube el
> daño, la velocidad ni la vida del jefe. Cambia qué tan seguido elige cada
> ataque, en qué rangos de distancia los usa y cuánto persigue al jugador. El
> jefe sigue siendo igual de fuerte, lo que cambia es su estrategia.

### Diapositiva 11 — El perfil de cuatro dimensiones · 4:05 – 5:40

*Esta es la diapositiva más densa. No leas la tabla completa: recórrela.*

> El perfil tiene cuatro dimensiones, y cada una se mide contra un enemigo
> distinto del nivel previo.
>
> La primera es la distancia promedio que el jugador mantiene. Si juega pegado,
> se achica el rango cercano del jefe, obligándolo a recurrir antes a ataques de
> rango medio.
>
> La segunda es qué tipo de ataque usa: si predominan los ataques a distancia,
> suben los pesos de los ataques que cierran distancia rápido.
>
> La tercera es la esquiva: qué proporción de sus esquivas fueron exitosas
> contra el ataque telegrafiado del caballero. Si esquiva muy bien lo que se
> anuncia con anticipación, sube el peso del ataque básico, que es el que apenas
> se telegrafía. Si esquiva mal, suben los de preparación larga, que igual le
> conectan.
>
> Y la cuarta observa hacia qué lado esquiva en la zona de tanque, y replica ese
> mismo patrón en el jefe.
>
> Cada regla que se activa suma diez o quince puntos al peso de ciertos ataques,
> sobre una base pareja de cincuenta, sin eliminar nunca un ataque del
> repertorio. No es que el ataque haga más daño: pesa más a la hora de elegirlo.
>
> En este mismo nivel se registra además a qué porcentaje de vida suele curarse
> el jugador, pero eso no ajusta los pesos antes del combate sino durante él,
> como voy a mostrar en un momento.

### Diapositiva 12 — De perfil a comportamiento · 5:40 – 6:25

> Este es un ejemplo concreto. Un jugador que juega a distancia, esquiva bien lo
> telegrafiado y tiende a esquivar de lado, termina enfrentando un jefe donde
> Charco y Salto pesan setenta y cinco, Giro setenta, y los demás quedan en su
> valor base. Es el mismo jefe, con el mismo repertorio, pero jugando distinto.
>
> Y hay una regla que no depende del perfil. Como la adaptación sube el peso de
> algunos ataques, el jefe podría terminar usando el mismo cinco veces seguidas,
> y eso no sería muy natural, además de muy previsible. Por eso ningún ataque puede salir tres veces
> seguidas.

### Diapositiva 13 — Ajustes durante el combate · 6:25 – 7:15

> Esos pesos se calculan una sola vez, al empezar el combate, y son la parte
> principal de la adaptación. Durante el combate hay además dos ajustes más
> acotados.
>
> El primero mira, cada quince ataques del jefe, qué proporción de cada tipo
> efectivamente conectó. Si conecta mucho, ese ataque sube; si el jugador lo
> esquiva siempre, baja. Así el jefe deja de insistir en lo que la persona ya
> domina.
>
> El segundo usa el dato de curación registrado en el nivel previo. El sistema
> sabe a qué porcentaje de vida suele curarse el jugador, y cuando entra a ese rango sube los pesos de los ataques
> más rápidos, reduciéndole la ventana para tomar la poción.

### Diapositiva 15 — Diseño experimental · 7:15 – 8:20

> Para evaluarlo se hizo una prueba A/B con diseño entre sujetos: cada persona
> juega una sola condición, nunca las dos. Así, lo que alguien aprende jugando
> una versión no influye en cómo percibe la otra.
>
> La condición de control es exactamente el mismo jefe, con los mismos nueve
> ataques, pero con los pesos parejos durante toda la partida.
>
> La condición se fija con un botón escondido en el menú principal, que se
> presiona antes de entregarle el control al participante, así que la persona nunca
> sabe qué versión está jugando.
>
> Y hay un detalle importante: la recolección del perfil es independiente de la
> condición. *Todos* los participantes generan perfil; lo único que cambia es si
> ese perfil se aplica o no. Eso permitió después verificar que ambos grupos
> partieron jugando parecido.
>
> Participaron treinta personas: quince en cada condición. Cada sesión duró entre veinticinco y cuarenta minutos.

### Diapositiva 16 — Qué se midió · 8:20 – 8:50

> La medición tuvo dos partes. Durante la partida, el propio juego lleva un
> registro interno con las métricas de comportamiento y, lo más importante, los
> pesos de ataque reales de cada partida.
>
> Después de jugar, cada participante respondió un cuestionario con tres
> bloques: el SUS adaptado, una selección de ítems del GEQ y preguntas abiertas.
>
> Que los pesos reales queden registrados es lo que después permite
> contrastar lo que el jugador *dijo* contra lo que el sistema *efectivamente
> hizo*.

---

## RESULTADOS — 8:50 a 16:00

### Diapositiva 18 — Verificación técnica · 8:50 – 9:25

> Lo primero fue verificar que el sistema efectivamente funcionó: el ajuste
> previo al combate fue el esperado en las quince sesiones adaptativas, y en
> catorce de quince los pesos además cambiaron durante la pelea.
>
> Así, cualquier resultado que venga después no se explica por un sistema que
> no funcionó.

### Diapositiva 19 — SUS · 9:25 – 9:50

> En usabilidad, el promedio general fue 77.9, por sobre el referente de
> industria que son 68 puntos, y cerca del umbral de "Excelente". El puntaje
> más bajo fue 62.5, que igual se considera aceptable: bajo 50 recién se
> habla de un sistema con problemas serios de usabilidad.
>
> Entre condiciones no hay ninguna diferencia, y eso es exactamente lo esperado:
> la adaptación cambia el comportamiento del jefe, no la interfaz ni los
> controles.

### Diapositiva 20 — GEQ global · 9:50 – 10:35

> En el GEQ, mirando los grupos completos, ninguna de las cinco dimensiones
> alcanzó significancia estadística, y todos los tamaños de efecto son pequeños.
> Desafío e inmersión van en la dirección esperada, pero no se distinguen del
> azar con esta muestra.
>
> Hay una observación descriptiva que sí vale la pena. En desafío, las medianas
> son parecidas, pero el rango intercuartílico del grupo adaptativo es
> visiblemente más compacto: 0.50 contra 0.88. Es decir, el cincuenta por ciento
> central de las respuestas se concentra en un intervalo más estrecho. Eso
> sugiere que el sistema pudo haber regulado el desafío hacia un rango más
> parejo entre jugadores, en vez de simplemente subirlo.

*Marca el tono: acá reconoces que el resultado global es negativo. No lo
escondas, pero no te quedes ahí — la frase siguiente es el giro.*

### Diapositiva 21 — El hallazgo · 10:35 – 11:50

> Al observar a los participantes jugar durante las sesiones surgió una
> hipótesis: el sistema no se percibe igual en todos. Daba la impresión de que
> quienes peleaban cuerpo a cuerpo acusaban menos la adaptación que quienes
> preferían mantenerse a distancia, y había que ver si los datos lo respaldaban.
>
> A quien juega a distancia, el jefe adaptado lo persigue y le cierra la
> distancia; es un cambio de comportamiento muy visible. En cambio, a quien ya
> pelea de cerca, la adaptación le refuerza ataques de corto alcance para los
> que de todas formas está preparado.
>
> A eso se suma que quienes pelean cuerpo a cuerpo solían ser también los más
> familiarizados con este tipo de juegos, así que parte del efecto podría venir
> de que al sistema le cuesta más presionar a un jugador experimentado. Es una
> explicación alternativa que reviso en un par de diapositivas más.
>
> Para comprobarlo se decidió dividir el grupo adaptativo por la mediana de
> distancia de exploración: quedaron ocho jugadores de perfil rango y siete de
> cuerpo a cuerpo.
>
> Los de perfil rango reportaron una tensión media de 1.69, contra 1.07 en los
> de cuerpo a cuerpo. La diferencia alcanza significancia, con un tamaño de
> efecto grande, a pesar de lo chicos que son los subgrupos.
>
> Y lo decisivo: al aplicar exactamente la misma división al grupo de control,
> ambos perfiles reportan una tensión prácticamente igual. La diferencia aparece
> solo cuando el jefe se adapta.

### Diapositiva 22 — La correlación · 11:50 – 12:20

> Lo mismo se ve midiéndolo de forma continua, sin cortar por la mediana. La
> correlación entre la distancia que la persona mantuvo en la exploración y la
> tensión que reportó después es positiva y significativa en el grupo
> adaptativo, y prácticamente nula en el control.
>
> Que la asociación exista solo cuando el jefe se adapta es la evidencia más
> directa de este estudio de que el sistema generó una experiencia diferenciada.

### Diapositiva 23 — Descartando la habilidad · 12:20 – 13:15

> Acá vuelvo a la explicación alternativa que mencioné hace un momento: los
> jugadores agresivos y cercanos solían ser también los más experimentados. Si
> eso fuera cierto, su menor tensión no sería por su estilo(y por el sistema), sino porque
> simplemente son mejores.
>
> Se hicieron tres revisiones. Primero, se midió si distancia y experiencia
> están relacionadas dentro del grupo adaptativo: la relación resultó débil y no
> significativa. Segundo, se comparó la experiencia promedio de ambos perfiles, y
> resultó casi idéntica.
>
> Y tercero, la más importante: se volvió a medir la relación entre distancia y
> tensión, pero descontando el efecto de la experiencia mediante correlación
> parcial. Si la tensión se debiera a la habilidad, esa relación debería
> debilitarse. No solo se mantuvo, sino que siguió siendo significativa.

### Diapositiva 24 — Lo que los jugadores dijeron · 13:15 – 14:30

> En las preguntas abiertas hay dos resultados y un hallazgo que obliga a
> leerlos con cuidado.
>
> El primero: en el grupo control, once de quince describieron al jefe como
> predecible; en el adaptativo, solo siete. Va en la dirección esperada.
>
> El segundo: diez de quince del grupo adaptativo dijeron percibir que el jefe
> aprendía, contra siete de quince en el control. La dirección es la correcta,
> pero no alcanza significancia.
>
> Y acá viene el tercero, que es uno de los resultados más
> interesantes del trabajo: siete personas del grupo de control, que enfrentaron
> un jefe completamente fijo, también afirmaron percibir aprendizaje, y
> describieron con detalle cambios que nunca ocurrieron.
>
> Como el sistema guarda los pesos reales, se pudo cruzar lo que cada persona
> reportó contra lo que efectivamente pasó en su partida, y la correspondencia
> es baja. Probablemente hay un sesgo de expectativa: el estudio trata sobre
> enemigos adaptativos y mucha gente llegó esperando encontrar uno.
>
> Por eso el análisis de este trabajo se apoya principalmente en las métricas
> objetivas y no en lo que el jugador declara.

### Diapositiva 26 — Implicancias de diseño · 14:30 – 16:00

*Esta diapositiva es tu aporte más transferible. Habla con soltura, no leas.*

> Más allá de este jefe en particular, el trabajo deja tres lecciones para
> quien quiera diseñar sistemas así.
>
> La primera es qué conviene cambiar: el comportamiento del enemigo, y no sus
> números fijos, como el daño o la velocidad. Subir los números el jugador lo
> siente como que el juego se puso más difícil para todos por igual, no como que
> el enemigo cambió su forma de jugar.
>
> La segunda es cómo lograr que se note, si es que el propósito es ese. Por un
> lado, conviene que la adaptación
> se traduzca en algo llamativo: el único caso donde alguien identificó
> correctamente lo que pasó fue cuando el jefe empezó a usar mucho su forma de
> charco, que es visualmente muy distinta; cuando el cambio era solo que un
> ataque se repitiera un poco más, nadie lo notó. Y por otro, que cada
> comportamiento del jugador tenga una respuesta propia y reconocible, en vez de
> un solo ajuste genérico, porque así es más fácil que la persona relacione lo
> que hizo con lo que el enemigo hizo después.
>
> Y la tercera, quizás la más interesante, es cuál puede ser la meta: un sistema
> así no necesita hacer el juego más difícil en promedio para cumplir su
> propósito. Puede apuntar a que distintos jugadores sientan un desafío más
> parejo entre ellos, que es justamente lo que sugiere ese rango intercuartílico
> más compacto.
>
> Un matiz importante: el jugador no necesita darse cuenta de la adaptación para
> que esta funcione. La tensión de los jugadores de rango subió igual, aunque
> muchos no supieran explicar por qué.

---

## CIERRE — 16:00 a 18:00

### Diapositiva 27 — Conclusiones · 16:00 – 17:00

> Primero, el sistema funciona como se especificó: las reglas predicen
> exactamente los pesos registrados en las quince sesiones.
>
> Segundo, comparando los grupos completos las diferencias fueron pequeñas y no
> significativas. Con una muestra de este tamaño, eso no descarta que exista un
> efecto real; solo indica que no llegó a hacerse visible.
>
> Y tercero, al mirar el estilo de juego el efecto sí aparece: los jugadores de
> perfil a distancia reportaron una tensión notablemente mayor en la versión
> adaptativa, y esa diferencia no existe en el control.
>
> La contribución principal, entonces, es un sistema capaz de adaptar el
> comportamiento del jefe al estilo de cada jugador, que en la práctica funcionó
> mejor contra quienes se mantienen a distancia que contra quienes pelean cuerpo
> a cuerpo. Con esto el objetivo general se cumplió.

### Diapositiva 28 — Limitaciones · 17:00 – 17:30

*Rápido. No te disculpes, enúncialas con seguridad: reconocerlas te da
credibilidad.*

> Estas conclusiones hay que leerlas con varias limitaciones. La principal es el
> tamaño de muestra: treinta participantes implica poco poder estadístico, así
> que los resultados son indicios de una prueba de concepto y no algo
> generalizable.
>
> A eso se suma que medir la experiencia previa resultó difícil, que hubo un
> leve desbalance entre grupos, que lo que el jugador reporta resultó poco
> confiable, y que tanto el SUS como el GEQ se aplicaron en versiones adaptadas.
>
> Y una última: el efecto que se observó corresponde sobre todo a la adaptación
> previa al combate, porque el ajuste en tiempo real es acotado.

### Diapositiva 29 — Trabajo futuro · 17:30 – 17:55

> Las líneas más directas: repetir la evaluación con más participantes, del
> orden de cuarenta por condición; reforzar la adaptación contra el perfil
> cuerpo a cuerpo, que es donde el sistema tuvo menos efecto; extender la
> adaptación al combate mismo; y complementar lo que el jugador declara con
> medidas menos dependientes de su opinión.

### Diapositiva 30 — Cierre · 17:55 – 18:00

> Eso es todo. Muchas gracias por su atención, y quedo atento a sus preguntas.

*No digas "eso sería" ni "no sé si me expliqué". Cierra firme y calla.*

---

## Notas de ensayo

- **Cronometra dos pasadas completas antes de la defensa.** Si la primera te da
  más de 19 minutos, el recorte va en la diapositiva 11 (perfil): describe dos
  dimensiones en detalle y menciona las otras dos.
- **Las tres frases que no pueden faltar**, aunque se te olvide todo lo demás:
  1. "La adaptación cambia qué tan seguido elige cada ataque, no cuánto daño hace."
  2. "La diferencia entre perfiles aparece solo en el grupo adaptativo."
  3. "Siete personas del grupo de control también creyeron ver adaptación."
- **Evita decir "no funcionó"** al hablar del resultado global. Di "no alcanzó
  significancia con esta muestra": es lo correcto estadísticamente y es lo que
  dice tu escrito.
- **Si te trabas**, vuelve a la diapositiva en pantalla y describe lo que se ve.
  Siempre hay un dato o una figura de donde retomar.
