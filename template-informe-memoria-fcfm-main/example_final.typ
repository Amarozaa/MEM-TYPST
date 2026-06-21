#import "final.typ": conf, resumen, dedicatoria, agradecimientos, start-doc, end-doc, capitulo, apendice
#import "metadata.typ": example-metadata

#show: conf.with(metadata: example-metadata)

#resumen(metadata: example-metadata)[
    #lorem(150)
    
    #lorem(100)
    
    #lorem(100)
]

#dedicatoria[
    Una dedicatoria especial para alguien especial.
]

#agradecimientos[
    #lorem(150)
    
    #lorem(100)
    
    #lorem(100)
]

#show: start-doc

// ==========================================
// CAPÍTULO 1: INTRODUCCIÓN
// ==========================================
#capitulo(title: "Introducción")[
    #lorem(150)
    
    == Problema abordado
    #lorem(100)
    
    == Solución propuesta
    #lorem(100)
    
    == Objetivos
    #lorem(50)
    
    == Metodología
    #lorem(80)
]

// ==========================================
// CAPÍTULO 2: TRABAJO RELACIONADO
// ==========================================
#capitulo(title: "Trabajo relacionado")[
    #lorem(100)
    
   
]

// ==========================================
// CAPÍTULO 3: DISEÑO DEL VIDEOJUEGO
// ==========================================
#capitulo(title: "Diseño del videojuego")[
    #lorem(100)
    
    == Género y mecánicas principales 
    #lorem(120)
    
    == Diseño de niveles y entornos de prueba 
    #lorem(150)
    
    == Diseño y arquetipos de enemigos
    #lorem(100)

    asdadaasdas

]

// ==========================================
// CAPÍTULO 4: SISTEMA ADAPTATIVO BASADO EN EL COMPORTAMIENTO DEL JUGADOR
// ==========================================
#capitulo(title: "Sistema adaptativo basado en el comportamiento del jugador")[

    
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

La plantilla _Third Person_ proporciona una estructura de proyecto preconfigurada que
incluye varios componentes clave. El elemento principal es el `BP_ThirdPersonCharacter`,
un Blueprint que representa al personaje jugable y contiene toda la lógica de movimiento,
entrada de usuario y comportamiento básico.

A lo largo de esta sección se hará referencia frecuente al concepto de Blueprint. Los
Blueprints son el sistema de _scripting_ visual de Unreal Engine que permite crear lógica
de juego mediante nodos interconectados, sin necesidad de escribir código tradicional.
Esto facilita la iteración rápida y permite a diseñadores y artistas contribuir
directamente a la programación del juego.

Este Blueprint incluye componentes como la cápsula de colisión, la malla del personaje
(_Skeletal Mesh_), el componente de movimiento (_Character Movement Component_) y la
cámara con su brazo de resorte (_Spring Arm_). Adicionalmente, la plantilla incluye el
_Game Mode_, que define las reglas básicas del juego, y diversos assets como animaciones
base, materiales y el escenario de demostración.
/*
#figure(
  image("imagenes/blueprint-jugador.png", width: 80%),
  caption: [Screenshot de Blueprint del jugador.],
) <fig:blueprint-jugador>
*/


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
personaje desliza su movimiento lateral mientras mantiene la mirada fija hacia adelante o
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

/*
#figure(
  image("imagenes/blendspace-strafe.png", width: 80%),
  caption: [
    BlendSpace del Strafe Movement, donde el eje X representa la dirección, y el Y la
    velocidad.
  ],
) <fig:blendspace-strafe>
*/
En el _Animation Blueprint_ del personaje (`ABP_Manny`), específicamente en el _Animation
Graph_ dentro de la máquina de estados de _Locomotion_, se reemplazó la animación de
_Idle_ que venía en el template por una propia, perteneciente al conjunto de animaciones
del _Strafe Movement_.

Luego, se reemplazó en el estado de _Walking/Run_ el _Blend Space_ que venía en el
template por el _Blend Space_ creado previamente, permitiendo así transiciones fluidas
entre las diferentes direcciones de movimiento mientras se mantiene la orientación del
personaje. También se desactivó el parámetro "Orient Rotation to Movement" y se activó el
parámetro "Use Controller Desired Rotation" para que el jugador mire siempre hacia la
dirección que indica la cámara, independientemente de la dirección en la que se mueva.

Cabe recalcar que la mayoría del desarrollo de las implementaciones está realizado en
Blueprint. Sin embargo, en el futuro se espera incorporar componentes heredados de C++.

Para desarrollar las capacidades de combate del jugador, se decidió crear un componente
`BPC_Combat` que hereda de _Actor Component_ y se ancla al Blueprint del jugador, de tal
forma que esté centralizada la lógica de combate. De igual forma, para las estadísticas
del jugador se creó y ancló un componente `BPC_Stats`.

== Estadísticas del jugador

Como se mencionó anteriormente, las estadísticas del jugador se implementaron en el
componente `BPC_Stats` anclado al jugador. Este componente posee múltiples variables,
entre las cuales están:

+ `health`: Tipo _Float_. Representa la vida actual del jugador.
+ `Progress Bar Ref`: Tipo _Progress Bar_. Es la referencia a la barra de progreso que
  muestra la vida.
+ `maxHealth`: Tipo _Float_. Representa el valor máximo de vida del jugador.
+ `stamina`: Tipo _Float_. Representa la stamina actual del jugador.
+ `maxStamina`: Tipo _Float_. Representa la stamina máxima del jugador.
+ `Stam Bar Ref`: Tipo _WB Player Stamina_. Es la referencia al widget que muestra la
  barra de stamina.
+ `canRecoverStamina`: Tipo _Boolean_. Indica si el jugador puede recuperar stamina.
+ `maxMana`: Tipo _Float_. Representa el valor máximo de maná del jugador.
+ `mana`: Tipo _Float_. Representa el maná actual del jugador.
+ `Mana Bar Ref`: Tipo _Progress Bar_. Es la referencia a la barra que muestra el maná.

La funcionalidad principal de este componente es una función llamada `IncreaseVal`, la
cual recibe como parámetros un enum que indica la estadística que se quiere modificar,
junto con el valor del cambio (positivo para incrementar, negativo para disminuir). Según
el valor del enum, se actualiza la estadística correspondiente sumándole el valor recibido,
acotando siempre el resultado entre cero y su valor máximo (`maxHealth`, `maxMana` o
`maxStamina`, según corresponda) mediante la función `FClamp`, de modo que ninguna
estadística pueda exceder su máximo ni quedar en negativo.

Si la estadística modificada es la vida (`health`), tras actualizarla se realizan dos
acciones en paralelo: por un lado, se comprueba si la vida resultante es menor o igual a
cero, y de ser así se invoca el evento `Die`, que da inicio a la secuencia de muerte del
jugador; por otro, se calcula el porcentaje de vida actual (`health`/`maxHealth`) y, desde
la referencia a la barra (`Progress Bar Ref`), se llama al método `Set Percent`, que
actualiza visualmente la barra con dicho porcentaje. En caso de recibir el enum
perteneciente a la estadística de maná, el proceso de actualización visual es análogo.

Para la estadística de stamina también es similar, con la diferencia de que el widget de
la stamina no se muestra siempre, solo cuando se está gastando o recuperando stamina,
similar a como lo implementan juegos como _The Legend of Zelda: Breath of the Wild_
#footnote[
  The Legend of Zelda: Breath of the Wild es un videojuego de acción y aventuras en mundo
  abierto desarrollado y publicado por Nintendo en 2017. El juego introduce mecánicas
  innovadoras de supervivencia y exploración, incluyendo un sistema de stamina que se
  muestra dinámicamente solo cuando se está utilizando o recuperando.
  #link("https://www.zelda.com/breath-of-the-wild/")[Disponible en sitio web].
].

Así, al recibirse el enum de stamina, se debe revisar si existe un widget creado en
pantalla. Si se posee, simplemente se le indica al widget que cambie su porcentaje y al
final se revisa si el jugador posee toda la stamina. En caso contrario, significa que el
widget no ha sido creado, por lo que se crea y se añade a la pantalla.

Finalmente, se revisa si la stamina es mayor o igual al máximo (100%). En caso de ser
verdadero, significa que el jugador ya posee toda la stamina, por lo que se procede a
remover el widget de la pantalla.

Al iniciarse el componente este activa dos timers que se ejecutan cada 0.01 segundos y
llaman a los eventos `RegainStamina` y `RegainMana`. Estos eventos pasan por una rama que
verifica si corresponde regenerar la estadística respectiva; si la condición es verdadera,
se usa el nodo `IncreaseVal` para aumentar la stamina o el maná en pequeñas cantidades,
creando así un sistema de regeneración continua controlada por condiciones. Es importante
mencionar que este enfoque de regeneración mediante timers de alta frecuencia podría
optimizarse en el futuro.

== Recepción de daño y muerte

El procesamiento del daño y la curación que recibe el jugador se centraliza en el evento
`ReceiveAnyDamage` de `BP_ThirdPersonCharacter`, el cual es invocado automáticamente por el
motor cada vez que se llama a la función `ApplyDamage` sobre el jugador, sin importar el
origen del daño. Este evento recibe el valor a aplicar y, según su signo, distingue entre
dos casos.

Si el valor es negativo, se interpreta como curación: se invoca directamente `IncreaseVal`
sobre `BPC_Stats` con el valor invertido, restaurando la vida del jugador según lo descrito
en la sección anterior.

Si el valor es positivo, se interpreta como daño recibido, y se ejecuta una secuencia más
elaborada. En primer lugar, se intenta identificar si el causante del daño es el jefe
(`BP_Slime`); de ser así, se consulta su _Behavior Tree_ para obtener cuál fue su último
ataque (`LastAttack`) y se registra en el `PlayerMetricsComponent` mediante
`RegisterBossAttackHit`, asociando así cada golpe recibido con el tipo de ataque que lo
causó. A continuación, se distingue si el jugador se encontraba esquivando en el momento del
impacto (`isDodging`): si es así, se registra como un dodge fallido mediante
`RegisterDodgeResult`; en caso contrario, se registra el daño normalmente mediante
`RegisterDamageTaken`, y se reproduce el sonido de dolor correspondiente. Si además el
jugador se encontraba dentro de una zona específica del combate (`isInTankZone`), se efectúa
un registro adicional (`RegisterDamageTakenInTankZone`).

Finalmente, se aplica el daño a la vida del jugador mediante `IncreaseVal` y, si el daño es
mayor a cero, se reproduce la animación de reacción a daño (`HitReact_Montage`), que
interrumpe temporalmente el movimiento del jugador. Esta interrupción respeta las acciones
que ya estén en curso: si el jugador se encuentra en medio de la animación de beber poción,
de lanzar un hechizo, o del combo de ataque con espada, el `HitReact_Montage` no detiene el
movimiento, evitando que la reacción a daño corte abruptamente otra acción ya iniciada.

Cuando la vida del jugador llega a cero, `IncreaseVal` invoca el evento `Die`, que gestiona
la secuencia de derrota. Este evento desactiva el componente de combate, reproduce una
animación de derrota (`MO_DefeatDaiko`) y, una vez finalizada, pausa el juego, muestra el
widget de "Try Again" y habilita el cursor del mouse. Si la derrota ocurrió en el nivel del
jefe, adicionalmente se vuelca a un archivo el registro de resultados del combate mediante
`DumpCombatResultToFile`, dato que forma parte del sistema de recolección de métricas del
estudio de usuario.
/*
#figure(
  image("imagenes/pantalla-muerte.png", width: 80%),
  caption: [Pantalla mostrada al morir el jugador],
) <fig:pantalla-muerte>
*/
== Componente de combate

Como se mencionó anteriormente, se creó un _Actor Component_ llamado `BPC_Combat` que se
ancla al jugador y centraliza toda la lógica relacionada con el combate.

Este componente posee múltiples variables, entre las cuales están:

+ `TargetLock`: Tipo _Actor_. Es la referencia al objetivo que se tiene fijado por la
  cámara.
+ `Player BP`: Tipo _Object Reference_ a _BP Third Person Character_. Referencia al
  jugador.
+ `TargetLockWidget`: Tipo _Object Reference_ a _BP Target Lock Widget_. Es la referencia
  al widget del símbolo que se crea cuando se fija un objetivo.
+ `isAttacking`: Tipo _Boolean_. Es una bandera que se levanta cuando el jugador está
  atacando.
+ `isCombo`: Tipo _Boolean_. Bandera que se levanta cuando el jugador tiene la intención de
  continuar el ataque.
+ `isDodging`: Tipo _Boolean_. Bandera que se levanta cuando el jugador está realizando una
  esquiva.
+ `StamWidget`: _Object Reference_ a _WB Player Stamina_. Es la referencia al widget de la
  stamina que se muestra cuando se gasta o recupera stamina.
+ `StaminaRollUse`: Tipo _Float_. Define la cantidad de stamina que consume la acción de
  rodar.
+ `isRunning`: Tipo _Boolean_. Bandera que se levanta cuando el jugador está corriendo.
+ `StaminaRunUse`: Tipo _Float_. Define la cantidad de stamina que gasta el jugador al
  correr.
+ `runSpeed`: Tipo _Float_. Define la velocidad del jugador al correr.
+ `CurrentSpellIndex`: Tipo _Float_. Índice que indica el hechizo que tiene equipado el
  jugador actualmente.
+ `SpellImageObject`: Tipo _Image_. Referencia a la imagen que indica el hechizo equipado
  actualmente en la interfaz.
+ `magicManaUse`: Tipo _Float_. Define la cantidad de maná que consume el proyectil mágico
  del jugador.
+ `healingManaUse`: Tipo _Float_. Define la cantidad de maná que consume el hechizo de
  curación.
+ `SwordDamage`: Tipo _Float_. Define el daño base que inflige la espada del jugador.
+ `currentLever`: Tipo _Object Reference_ a _BP Lever_. Referencia a la palanca con la que
  el jugador está interactuando actualmente.
+ `isEnemyDashing`: Tipo _Boolean_. Bandera que indica si el enemigo está realizando una
  embestida o desplazamiento rápido.
+ `isInCorrectDodgeWindow`: Tipo _Boolean_. Bandera que indica si el jugador se encuentra
  dentro de la ventana temporal adecuada para ejecutar una esquiva efectiva.
+ `isRollingSideWays`: Tipo _Boolean_. Bandera que indica si la esquiva actual se está
  realizando lateralmente.
+ `MovInput`: Tipo _Vector2D_. Almacena la dirección de movimiento introducida por el
  jugador.
+ `FireBallImage`: Tipo _Image_. Referencia a la imagen utilizada en la interfaz para
  representar el hechizo de bola de fuego.
+ `PotionImage`: Tipo _Image_. Referencia a la imagen utilizada en la interfaz para
  representar las pociones del jugador.
+ `PotiCount`: Tipo _Integer_. Indica la cantidad actual de pociones disponibles.
+ `Potion Count Text Var`: Tipo _Text_. Referencia al elemento de texto de la interfaz que
  muestra la cantidad de pociones disponibles.
+ `healingPotion`: Tipo _Static Mesh_. Referencia al modelo 3D de la poción de curación utilizada por el jugador.
+ `tmpTarget`: Tipo _Vector_. Almacena una ubicación temporal utilizada por los enemigos como objetivo durante la ejecución de sus comportamientos.

== Sistema de input

La entrada del jugador se gestiona mediante el sistema _Enhanced Input_ de Unreal Engine.
Cada acción del jugador (atacar, esquivar, correr, etc.) se representa como un
_Input Action_ independiente, desacoplado de la tecla o botón físico que lo activa. Esta
asociación entre la entrada física y el `Input Action` correspondiente se define en un
_Input Mapping Context_, lo que facilita el remapeo de controles sin modificar la lógica
interna de cada Blueprint. Actualmente el juego solo cuenta con soporte para teclado y mouse.

Los `Input Actions` utilizados por el componente de combate (`BPC_Combat`) y sus controles
asociados son los siguientes:

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

== Ataque melee del jugador

El ataque del jugador se implementó en el componente de combate mencionado previamente.
Al recibirse el `Input Action` `IA_Attack`, antes de ejecutar la acción se comprueba que el jugador
no esté ya atacando ni esquivando (variables `isAttacking` e `isDodging`) y, además, que
no se esté reproduciendo el _Animation Montage_ de reacción a daño (`HitReact_Montage`),
de modo que el jugador no pueda atacar mientras recibe un golpe. Si la condición se
cumple, se setea `isAttacking` como `true`, se registra el ataque cuerpo a cuerpo en el
_Game Instance_ (para fines de telemetría) y se ejecuta el _Animation Montage_ asociado al
ataque, que contiene una secuencia de tres golpes consecutivos.

El encadenamiento de golpes (combo) se controla mediante la variable `isCombo`, que
representa la intención del jugador de continuar la secuencia. Esta variable se activa de
forma diferida: si el jugador vuelve a recibir el `Input Action` `IA_Attack` mientras un ataque ya
está en curso (es decir, cuando la condición inicial es `false` porque `isAttacking` es
`true`), en lugar de iniciar un ataque nuevo se setea `isCombo` como `true`. De esta forma
el sistema "almacena" la intención de combo hasta el siguiente punto de decisión.

Dicho punto de decisión se evalúa mediante un _Animation Notify_ ubicado en el montage, al
final del primer y segundo golpe. Cada vez que el notify se activa, se comprueba si el
jugador sigue atacando y si tiene la intención de continuar (variables `isAttacking` e
`isCombo`). Si ambas son verdaderas, se permite que la secuencia continúe y se resetea
`isCombo` a `false` (a la espera de un nuevo input). En caso contrario, se detiene el
montage prematuramente mediante `Montage_Stop` y se limpian las variables `isAttacking` e
`isCombo`. Cuando el montage se completa o es interrumpido, se restablecen también
`isAttacking` e `isCombo` a `false` y se restaura el estado de movimiento del personaje;
en el caso de interrupción, se distingue además si la causa fue la reproducción del
`HitReact_Montage`.

/*
#figure(
  image("imagenes/montage-golpe1.png", width: 80%),
  caption: [Primer golpe del montage de ataque],
) <fig:montage-golpe1>
*/

/*
#figure(
  image("imagenes/montage-golpe2.png", width: 80%),
  caption: [Segundo golpe del montage de ataque],
) <fig:montage-golpe2>
*/

/*
#figure(
  image("imagenes/montage-golpe3.png", width: 80%),
  caption: [Tercer golpe del montage de ataque],
) <fig:montage-golpe3>
*/

Con respecto a la detección de impacto del ataque, la implementación se basa en un sistema
de _trace_ por temporizador. El montage tiene asociado un Blueprint que hereda de _Animation Notify State_, el cual delimita la ventana en la
que el arma debe poder golpear mediante un momento de inicio y un momento de fin dentro del
montage. Al recibirse la señal de inicio, se invoca el evento `Begin Damage Trace`, que
inicia un _timer_ en bucle que, cada 0.1 segundos, ejecuta un _Sphere Trace_ entre dos
componentes de escena anclados al arma (`Start Sword Trace Pos` y `End Sword Trace Pos`),
que marcan la base y la punta de la hoja. Si el _trace_ detecta una colisión válida, se
llama a la función `ApplyDamage` sobre el actor impactado, utilizando el valor de la
variable `SwordDamage` y al jugador como causante del daño. Al recibirse la señal de fin,
se invoca el evento `End Damage Trace`, que invalida el _timer_, desactivando la detección
hasta el siguiente golpe.

== Proyectiles

Tanto el jugador como el jefe pueden lanzar proyectiles. Es por esto que se decidió crear
un Blueprint Class que represente la base de un proyectil (`BP_BaseProjectile`), para que
después tanto el proyectil del jugador como el del jefe hereden desde esta clase base y
ajusten variables específicas de cada uno. El comportamiento por defecto del proyectil es
avanzar con velocidad constante en línea recta hasta chocar con algo, momento en el cual
reproduce el efecto visual (VFX) y el sonido de impacto correspondientes, aplica daño al
objetivo impactado y se destruye.

El proyectil base posee múltiples componentes, entre los cuales están:

+ `BoxCollision`: Componente de colisión (_Box Collision_). Define el volumen de colisión
  principal del proyectil.
+ `Arrow`: Componente _Arrow_. Sirve como referencia visual y direccional para indicar hacia
  dónde se moverá u orientará el proyectil.
+ `StaticMesh`: Componente _Static Mesh_. Representa la malla estática visible del
  proyectil, en caso de necesitarse.
+ `ProjectileMovement`: Componente _Projectile Movement_. Controla el movimiento del
  proyectil, incluyendo velocidad, gravedad y comportamiento de persecución (_homing_).

Las variables de las que se compone son:

+ `Speed`: Tipo _Float_. Define la velocidad a la que se mueve el proyectil.
+ `Gravity`: Tipo _Float_. Controla cuánta influencia tiene la gravedad sobre el proyectil.
+ `Homing`: Tipo _Boolean_. Indica si el proyectil tiene la capacidad de perseguir
  automáticamente a un objetivo.
+ `Base Damage`: Tipo _Float_. Define el daño base que causa el proyectil al impactar.
+ `Impact Effect`: Tipo _Particle System_. Es la referencia al sistema de partículas que se
  reproduce cuando el proyectil impacta.
+ `Sound Impact`: Tipo _Sound Base_. Es la referencia al sonido que se reproduce cuando el
  proyectil impacta.


/*
#figure(
  image("imagenes/blueprint-proyectil-base.png", width: 80%),
  caption: [Blueprint del proyectil base],
) <fig:blueprint-proyectil-base>
*/
El comportamiento del proyectil base se define mediante los siguientes eventos. Al
inicializarse (`BeginPlay`), el proyectil configura su componente de colisión para ignorar
al actor que lo originó (`GetOwner`), evitando así que colisione consigo mismo o con quien
lo disparó. Además, si la variable `Homing` está activada, se habilita el modo de
persecución del componente _Projectile Movement_ (`bIsHomingProjectile`) y se establece el
componente objetivo de la persecución.

La detección de impacto se gestiona mediante un evento ligado al solapamiento del
componente de colisión. Cuando el proyectil se solapa con otro actor, se comprueba que dicho
actor no sea su propio dueño (`GetOwner`); de no serlo, se invoca la función
`SpawnImpactEffect`, que reproduce el sistema de partículas `Impact Effect` en el punto de
colisión junto con el sonido `Sound Impact`. A continuación se aplica el daño definido en
`Base Damage` sobre el actor impactado —indicando al dueño del proyectil como causante del
daño— y finalmente el proyectil se destruye.

=== Proyectil del jugador

Uno de los hechizos que puede utilizar el jugador es el de disparar un proyectil. El
Blueprint que representa al proyectil del jugador (`BP_PlayerFireBall`) hereda de
`BP_BaseProjectile` y configura las siguientes variables: `Speed` con un valor alto (para
que sea más rápido que el proyectil del jefe), `Gravity` en 0 (sin influencia
gravitacional), `Homing` como `false` (no persigue objetivos), y el `Impact Effect` con un
VFX de explosión de fuego. En cuanto a los componentes visuales, el `StaticMesh` permanece
vacío y en su lugar se utiliza un componente _Particle System_ que representa el efecto
visual del proyectil en movimiento.

/*
#figure(
  image("imagenes/bp-playerfireball.png", width: 80%),
  caption: [Blueprint del proyectil del jugador],
) <fig:bp-playerfireball>
*/




=== Proyectil del jefe

El jefe puede lanzar proyectiles mediante ciertos ataques. El Blueprint que los representa
(`BP_BossSlimeBall`) hereda de `BP_BaseProjectile` y configura sus variables de la
siguiente manera: `Speed` con un valor moderado (menor que el del jugador), `Gravity` en 0,
el `Impact Effect` con un VFX de explosión de slime, y `Homing` que varía según el tipo de
ataque. El jefe dispone de dos variantes de ataque con proyectiles: uno donde el proyectil
avanza en línea recta a velocidad constante (`Homing` en `false`), y otro donde persigue
activamente al jugador hasta alcanzarlo o explotar tras un tiempo determinado (`Homing` en
`true`). Al igual que el proyectil del jugador, el `StaticMesh` permanece vacío y se emplea
un componente _Particle System_ para el efecto visual del proyectil en movimiento.

Esta subclase sobreescribe (_override_) el evento `BeginPlay` para extender el
comportamiento heredado: al instanciarse, primero ejecuta el `BeginPlay` de la clase base
(configurando la colisión y el _homing_ según corresponda) y, a continuación, inicia un
temporizador de 5 segundos. Transcurrido ese tiempo, si el proyectil aún no ha impactado
contra nada, spawnea un sistema de partículas Niagara (`NS_Projectile_03_Hit`) en su
ubicación actual y se autodestruye, garantizando así que los proyectiles que no alcancen al
jugador no permanezcan indefinidamente en la escena.




/*
#figure(
  image("imagenes/bp-bossslimeball.png", width: 80%),
  caption: [Blueprint del proyectil del jefe],
) <fig:bp-bossslimeball>

*/

== Hechizos y consumibles del jugador

El jugador dispone de dos opciones que puede alternar y utilizar mediante una misma acción:
un hechizo de proyectil de fuego y una poción de vida. Esta mecánica se implementó con el
propósito de otorgar al jugador versatilidad en combate —pudiendo elegir entre una opción
ofensiva y una defensiva— y de proporcionar al jefe la oportunidad de demostrar capacidad de
aprendizaje y adaptación a las diferentes estrategias del jugador.

El jugador puede intercambiar entre el hechizo de fuego y la poción utilizando la rueda del
mouse, y la opción actualmente equipada se muestra representada con un símbolo en la esquina
inferior derecha de la pantalla. La selección se representa mediante la variable
`CurrentSpellIndex`, que cambia al mover la rueda del mouse (`IA_ScrollMagic`); además de
actualizar el valor, se modifica el ícono y la opacidad de la imagen del HUD para reflejar
la opción activa.

Cuando el jugador ejecuta la acción de lanzar (`IA_Magic`), el sistema evalúa la variable
`CurrentSpellIndex` para determinar qué opción está equipada. Si corresponde al hechizo de
fuego, se comprueba primero que se disponga del maná necesario (`magicManaUse` frente a la
variable `mana`) antes de invocar el evento del proyectil; si corresponde a la poción, se
invoca directamente el evento de curación, cuya disponibilidad depende de la cantidad de
pociones que posea el jugador.

=== Hechizo de proyectil de fuego

El evento del hechizo de proyectil (`ProjMagicEvent`) comienza comprobando que el jugador no
esté atacando ni esquivando, y que no se esté reproduciendo la animación de reacción a daño.
Si la condición se cumple, registra el ataque a distancia en el _Game Instance_ con fines de
telemetría, marca al jugador como atacando y reproduce la animación de lanzamiento, que
corresponde a un _Animation Montage_. Durante la reproducción se desactiva temporalmente el
movimiento del jugador, ya que mientras lanza el proyectil no debe poder desplazarse; el
movimiento se restablece cuando la animación finaliza o es interrumpida.

El proyectil en sí se genera mediante un _Animation Notify_ anclado al montage: en el
instante en que la animación lo indica, se instancia el proyectil del jugador
(`BP_PlayerFireBall`) con el jugador asignado como su dueño (_Owner_), de modo que el
proyectil no colisione con quien lo dispara. En ese mismo momento se reproduce el sonido de
lanzamiento y se realiza el consumo de maná, llamando a la función `IncreaseVal` del
componente `BPC_Stats`, pasando como parámetro el valor de la variable `magicManaUse` con
signo negativo para representar la disminución.

/*
#figure(
  image("imagenes/hechizo-proyectil.png", width: 80%),
  caption: [Jugador lanzando el hechizo de proyectil],
) <fig:hechizo-proyectil>

*/
=== Poción de vida

La poción de vida constituye la opción defensiva del jugador. No restaura la vida de forma
instantánea, sino que requiere que el jugador beba una poción de una cantidad limitada que
posee, representada por la variable `PotiCount` y mostrada en el HUD. El evento
correspondiente (`HealingMagicEvent`) comienza comprobando que el jugador no esté atacando
ni esquivando, que no se esté reproduciendo la animación de reacción a daño y,
fundamentalmente, que disponga de al menos una poción (`PotiCount` mayor que cero).

Si la condición se cumple, se registra el momento de curación en el _Game Instance_ (junto
con la vida actual y máxima del jugador), se decrementa el contador de pociones y se
actualiza el HUD, y se desactiva el movimiento mientras se reproduce la animación de beber,
que corresponde a un _Animation Montage_. Para reforzar visualmente la acción, durante la
animación se genera y se ancla la malla de la poción a la mano del jugador, la cual se
destruye una vez finalizada. La restauración de vida se realiza mediante un _Animation
Notify_ anclado al montage: en el momento en que la animación muestra al jugador bebiendo,
se llama a la función `IncreaseVal` para restaurar la vida del jugador. Al completarse o
interrumpirse la animación, se restablece el movimiento del jugador.



/*
#figure(
  image("imagenes/pocion-vida.png", width: 80%),
  caption: [Jugador bebiendo una poción de vida],
) <fig:pocion-vida>
*/
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

Una vez determinado el eje dominante, el signo del producto punto correspondiente define el
sentido exacto y, con ello, el _Animation Montage_ que se retorna: hacia adelante
(`Dodge_F_MontageDAIKO`) o hacia atrás (`Dodge_B_MontageDAIKO`) en el caso frontal, y hacia
la derecha (`Dodge_R_MontageDAIKO`) o hacia la izquierda (`Dodge_L_MontageDAIKO`) en el caso
lateral. Cuando el roll es lateral, además se marca la variable `isRollingSideWays` como
`true`.

Adicionalmente, esta función realiza un registro de telemetría específico para las esquivas
realizadas frente a una embestida del jefe: si en el momento del roll el jefe se encuentra
embistiendo (`isEnemyDashing`) y el jugador está dentro de una zona determinada
(`isInTankZone`), se llama a la función `RegisterDashDodge` del _Game Instance_, pasándole el
parámetro `bWasLateral` para indicar si la esquiva fue lateral (`true`, en los rolls hacia
los lados) o frontal (`false`, en los rolls hacia adelante o atrás). Esto permite recopilar
métricas diferenciadas sobre cómo responde el jugador ante el ataque de embestida según la
dirección de su evasión.

En cuanto a la lógica del roll: cuando se recibe el `Input Action` `IA_Dash-Roll`, primero
se comprueba que el jugador no esté atacando (variable `isAttacking`), que disponga de la
stamina suficiente para realizar la esquiva (comparando la `stamina` actual contra
`StaminaRollUse`) y que no se esté reproduciendo la animación de reacción a daño
(`HitReact_Montage`). Si la condición se cumple, se registra la esquiva en el _Game Instance_
mediante la función `RegisterTotalDodge` y se procede a ejecutar la acción: se llama a la
función `IncreaseVal` para restar la stamina consumida, se marca `isDodging` como `true`, se
reproduce el sonido de esquiva y se ejecuta la animación de roll correspondiente (obtenida
mediante `GetRollMontage`). Inmediatamente se setea la variable `canRecoverStamina` como
`false` para evitar que se regenere stamina durante la esquiva.

La limpieza de los estados se realiza al término de la animación de roll. Tanto si el montage
se completa exitosamente como si es interrumpido, se restablece `canRecoverStamina` a `true`
(permitiendo nuevamente la regeneración de stamina) y se limpian las variables `isDodging` e
`isRollingSideWays`, devolviendo al jugador a un estado neutro desde el cual puede volver a
actuar.

Adicionalmente, el sistema distingue si la esquiva se realizó dentro de una ventana de tiempo
considerada como una evasión precisa o "perfecta", mediante la variable
`isInCorrectDodgeWindow`. Cuando este es el caso, se efectúa un registro extra en el _Game
Instance_ mediante la función `RegisterDodgeFromDelayAttack`, lo que permite recopilar
métricas sobre las esquivas realizadas con buen _timing_ frente a los ataques enemigos.

Cabe mencionar que todo esto se ejecuta dentro de un nodo _Do Once_, el cual, como bien
indica su nombre, solo se ejecuta una vez hasta que se resetee. El reseteo se realiza después
de 0.45 segundos mediante un nodo _Delay_. Esto permite que el jugador pueda hacer un roll
cada 0.45 segundos, pudiendo así encadenar rolls consecutivos para evadir múltiples ataques.

/*
#figure(
  image("imagenes/roll-adelante.png", width: 80%),
  caption: [Jugador haciendo roll hacia adelante],
) <fig:roll-adelante>
*/

== Fijado de objetivo (Target Lock)

El sistema de fijado de objetivo (_Target Lock_) permite al jugador centrar la cámara sobre
un enemigo y mantenerla orientada hacia él durante el combate, facilitando el seguimiento del
objetivo mientras se ataca o esquiva. Está implementado en el componente `BPC_Combat` y se
reparte entre dos partes: la activación/desactivación del fijado, gestionada por el
`Input Action` `IA_Lock`, y el mantenimiento de la orientación de la cámara, ejecutado en
cada fotograma dentro del evento `Tick`.

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
un objetivo, cada fotograma se calcula la rotación necesaria para que la cámara apunte hacia
él y se aplica a la rotación del controlador del jugador. Para obtener el punto exacto al que
mirar, el sistema comprueba si el objetivo implementa la interfaz `BPI_Lockable`: si la
implementa, solicita a través de ella un punto de fijado personalizado, lo que permite que
ciertos enemigos —como aquellos cuya geometría se deforma o cuyo centro visual no coincide
con su origen— definan explícitamente dónde debe apuntar la cámara; si no la implementa, se
utiliza directamente la ubicación del objetivo. Además, mientras el fijado está activo, se
reposiciona en pantalla el widget de la barra de stamina.

Actualmente, la única clase que implementa la interfaz `BPI_Lockable` es el jefe
(`BP_Slime`). Esto se debe a que su animación de ataque de charco  desplaza visualmente al personaje hacia abajo —simulando que se hunde o agacha en el charco— sin que dicho desplazamiento se traduzca en un movimiento real del
actor en el mundo. Si la cámara utilizara directamente la ubicación del actor (su origen),
el punto de fijado quedaría desalineado respecto a la posición visual del jefe durante esta
animación. Al implementar `BPI_Lockable`, el jefe puede reportar un punto de fijado ajustado
a su posición visual real en cada momento, manteniendo la cámara correctamente orientada
incluso cuando la animación no coincide con la posición lógica del actor.

/*
#figure(
  image("imagenes/target-lock.png", width: 80%),
  caption: [Jugador con un objetivo fijado mediante el sistema de Target Lock],
) <fig:target-lock>
*/

== Correr

La carrera permite al jugador desplazarse a mayor velocidad a cambio de consumir stamina, y está implementada en el componente `BPC_Combat` mediante el `Input Action` `IA_Run`. A diferencia de otras acciones, esta responde a las distintas fases del input —el momento en que se presiona, mientras se mantiene presionado, y cuando se suelta—, lo que permite controlar tanto la activación como el gasto continuo de stamina y el regreso al estado normal.

Como condición común a todas las fases, la carrera solo opera si no se está reproduciendo la animación de reacción a daño (`HitReact_Montage`), de modo que recibir un golpe interrumpe la posibilidad de correr.

Al presionar el input, si el jugador dispone de stamina suficiente, se aumenta su velocidad
de movimiento (`MaxWalkSpeed`) al valor definido por la variable `runSpeed` y se bloquea la
regeneración de stamina (`canRecoverStamina` en `false`), ya que no debe recuperarse stamina
mientras se corre. Mientras el input se mantiene presionado, y siempre que aún quede stamina,
se consume de forma continua llamando a la función `IncreaseVal` del componente `BPC_Stats`
con el valor de `StaminaRunUse` en negativo, lo que reduce progresivamente la stamina
disponible durante la carrera. Finalmente, al soltar el input, se restaura la velocidad de
movimiento a su valor normal y se vuelve a habilitar la regeneración de stamina, devolviendo
al jugador a su estado de desplazamiento habitual.

/*
Aca pondre una figura del jugador corriendo, pero no tengo una imagen todavia
*/

== Interactuar

La interacción del jugador con elementos del entorno está implementada en el componente
`BPC_Combat` mediante el `Input Action` `IA_MyInteract`. Actualmente esta acción está
orientada a la interacción con palancas: al recibirse el input, primero se comprueba que
exista una palanca con la que el jugador pueda interactuar en ese momento, mediante la
referencia `currentLever`. Si existe dicha referencia, se procede a verificar si ya fue
utilizada (`bAlreadyUsed`); de no haberlo sido, se invoca la función `PlayLever` sobre el
Blueprint de la palanca (`BP_Lever`), que se encarga de reproducir su animación y de
ejecutar el efecto asociado a su activación.

// TODO: mencionar algo asi pos: "el funcionamiento interno de las palancas se detalle en..."
/*l funcionamiento interno de las palancas se detalla
en la sección @sec:elementos-nivel (o el label/número que corresponda a esa sección
*/

== Menú de pausa

El acceso al menú de pausa está implementado en el componente `BPC_Combat` mediante el
`Input Action` `IA_EscapeMenu`. Al recibirse el input, se comprueba si el juego ya se
encuentra pausado; si no lo está, se procede a abrirlo: se instancia el widget del menú de
pausa (`WB_PauseMenu`) y se añade al _viewport_, se cambia el modo de entrada a uno orientado
exclusivamente a la interfaz (de forma que el movimiento del mouse deje de controlar la
cámara), se habilita la visibilidad del cursor, y finalmente se pausa el juego.
/*
#figure(
  image("imagenes/menu-pausa.png", width: 80%),
  caption: [Menú de pausa del juego],
) <fig:menu-pausa>
*/


== Widgets del jugador

La interfaz de usuario asociada al jugador se compone de varios _Widget Blueprints_, cada
uno encargado de mostrar un aspecto específico del estado del jugador o de gestionar una
pantalla concreta. La mayoría de estos widgets se actualizan desde la lógica de juego ya
descrita —principalmente desde el componente `BPC_Stats`—, por lo que su Blueprint interno
es mínimo y se limitan a su composición visual.

El widget principal es el HUD del jugador (`WB_PlayerHUD`), que actúa como contenedor de los
elementos que se muestran de forma persistente durante el juego. Está compuesto por un
_Canvas Panel_ que agrupa la barra de vida (`WB_PlayerHealth`), la barra de maná
(`WB_PlayerMana`) y el widget de equipamiento (`WB_Equips`). Este widget no posee lógica en
su grafo de eventos, ya que su única función es disponer espacialmente en pantalla a los
sub-widgets que contiene.

Los widgets de barra de vida (`WB_PlayerHealth`) y de maná (`WB_PlayerMana`) son
estructuralmente simples: cada uno se compone de un _Canvas Panel_ que contiene un borde
decorativo y una barra de progreso (_Progress Bar_). No poseen lógica en su grafo de
eventos, ya que su valor se actualiza directamente desde la función `IncreaseVal` de
`BPC_Stats`, la cual modifica el porcentaje de la barra cada vez que cambia la estadística
correspondiente, tal como se describió en la sección de estadísticas del jugador.

El widget de equipamiento (`WB_Equips`) muestra los consumibles y hechizos disponibles del
jugador. Se compone de una caja horizontal con la imagen del hechizo de fuego
(`Fireball_IMG`) y, superpuestos, la imagen de la poción (`Potion_IMG`) junto con un texto
que indica la cantidad de pociones restantes (`PotionCountText`). Tampoco posee lógica en su
grafo, pues tanto el ícono activo como el contador se actualizan desde `BPC_Combat`.

Finalmente, el widget de fijado de objetivo (`WB_TargetLock`) consiste únicamente en una
imagen (un ícono) que se ancla sobre el enemigo fijado, según lo descrito en la sección de
_Target Lock_.

=== Barra de stamina (`WB_PlayerStamina`)

A diferencia de las barras de vida y maná, la barra de stamina sí posee lógica propia en su
Blueprint, ya que se representa mediante un material en lugar de una _Progress Bar_ estándar.
El widget se compone de una única imagen (`Image_176`) a la que se le aplica un material
dinámico, lo que permite representar la barra de stamina con una forma circular.

La actualización del nivel de stamina se realiza mediante la función `SetPercent`. Esta
función primero comprueba si la instancia dinámica del material (`RoundStaminaBarInst`) ya
fue creada: si es válida, simplemente actualiza el parámetro escalar `Percent` del material
con el nuevo valor. Si aún no existe, crea una instancia dinámica a partir del material base
(`M_StaminaBar_Inst`), la asigna como _brush_ de la imagen, y luego actualiza su parámetro
`Percent`. De esta forma, la instancia del material se crea una sola vez (la primera vez que
se actualiza la barra) y se reutiliza en las llamadas posteriores.

=== Widget del menú de pausa (`WB_PauseMenu`)

El widget del menú de pausa presenta dos botones dispuestos verticalmente: reanudar
(`ResumeBtn`) y volver al menú principal (`MainMenuButton`). Su lógica responde a los eventos
de pulsación de cada botón. Al presionar el botón de reanudar, se reanuda el juego
(quitando la pausa), se restablece el modo de entrada a uno orientado exclusivamente al
juego, se oculta el cursor del mouse, y se elimina el propio widget de la pantalla,
devolviendo al jugador al combate. Al presionar el botón de menú principal, se reanuda el
juego y se carga el nivel del menú principal (`Lvl_MainMenu`).

=== Pantalla de derrota (`WB_TryAgain`)

Esta pantalla se muestra cuando el jugador es derrotado e incluye un mensaje de "Game Over"
junto con dos botones: reintentar (`Retry Button`) y volver al menú principal
(`Main Menu Button`). Al presionar reintentar, se reanuda el juego, se incrementa el contador
de intentos (`AttemptNumber`) almacenado en el `SlimeGameInstance` —dato relevante para el
seguimiento del estudio— y se recarga el nivel actual, permitiendo al jugador volver a
enfrentar el combate. Al presionar el botón de menú principal, se reanuda el juego y se carga
el nivel del menú principal.

== Enemigos
   === Esqueleto normal
   === Esqueleto mago
   === Esqueleto caballero
== Jefe (BP_Slime)
== Sistema de métricas y telemetría
== Niveles
   === Lvl_Tutorial
   === Lvl_PreBoss
   === Lvl_ThirdPerson
   === Elementos de nivel
   === Widgets de tutorial
== Widgets generales (MainMenu, WinnerScreen...)


]
// ==========================================
// CAPÍTULO 6: PRUEBA DE CONCEPTO
// ==========================================
#capitulo(title: "Prueba de concepto y evaluación")[
    
]

// ==========================================
// CAPÍTULO 7: CONCLUSIÓN Y TRABAJO FUTURO
// ==========================================
#capitulo(title: "Conclusión y trabajo futuro")[
    #lorem(100)
    
 
]

#show: end-doc

// ==========================================
// ANEXOS / APÉNDICES
// ==========================================
#apendice(title: "Anexo")[
    #lorem(100)
    
    #lorem(100)
]