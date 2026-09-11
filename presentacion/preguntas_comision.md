# Preparación de preguntas — comisión

Valentín Muñoz Apablaza y Cristián Llull Torres. Las anotaciones de Llull en el
PDF corregido (`correcciones/`) son el mejor predictor de por dónde va a
preguntar: ya te marcó la duda sobre adaptación en tiempo real versus historial,
y ya preguntó por el origen de los valores numéricos. Prepara esas dos sí o sí.

---

## Las que casi seguro te van a hacer

### 1. "¿Por qué reglas y umbrales fijos, y no aprendizaje automático?"

Es la pregunta más probable de toda la defensa.

> Fue una decisión deliberada, por tres razones. Primero, por trazabilidad: como
> las reglas son explícitas, pude verificar que el sistema hacía exactamente lo
> que decía hacer, aplicándolas a mano y comparándolas contra el registro. Con un
> modelo aprendido esa verificación no habría sido posible, y habría quedado sin
> saber si un resultado nulo se debía al sistema o al método de evaluación.
>
> Segundo, por datos: un enfoque de aprendizaje necesita muchas más partidas de
> las que este estudio podía generar. Tengo treinta sesiones, y una sola por
> persona.
>
> Y tercero, porque un sistema basado en reglas es lo que un estudio de
> videojuegos puede efectivamente ajustar y depurar. La literatura de dificultad
> dinámica que revisé va mayoritariamente por ahí.
>
> Dicho eso, lo que construí deja el terreno preparado: la telemetría, el perfil
> y el mecanismo de pesos ya existen; reemplazar la capa de reglas por un modelo
> aprendido es un paso natural con más datos.

### 2. "¿De dónde salen los números? ¿Por qué 330 unidades, por qué +15?"

*Llull ya te lo anotó en la página 39 del PDF corregido.*

> No se derivaron analíticamente. Los fijé de forma iterativa mediante pruebas de
> juego durante el desarrollo, buscando que el cambio en el comportamiento del
> jefe fuera perceptible sin volverse abrupto. Está declarado explícitamente en
> el capítulo 4.
>
> Es una limitación real: son valores calibrados a mano para este juego en
> particular, no constantes con respaldo teórico. Lo que sí puedo defender es la
> *estructura* de las reglas —qué se mide, contra qué enemigo, y en qué dirección
> empuja— que es lo que se transfiere a otro juego. Los números concretos habría
> que recalibrarlos.

**Si insisten en por qué no los ajustaste sistemáticamente:** porque un barrido
de parámetros habría requerido muchas más sesiones de las disponibles, y el
objetivo del trabajo era evaluar si el mecanismo produce una experiencia
distinta, no encontrar su configuración óptima.

### 3. "¿El jefe se adapta en tiempo real o según el historial previo?"

*Llull anotó exactamente esta confusión en la página 15.*

> Las dos cosas, pero con pesos muy distintos. El mecanismo principal es
> pre-combate: el perfil se construye durante el nivel previo y se aplica una vez,
> al iniciar el enfrentamiento. Durante el combate hay dos ajustes acotados —por
> tasa de acierto cada quince ataques, y por la ventana de curación— pero son
> secundarios.
>
> Una adaptación en tiempo real más completa, que reaccione a patrones ricos
> durante el propio combate, estaba en la propuesta original y quedó fuera del
> alcance. Los efectos que reporté corresponden principalmente a la adaptación
> pre-combate.

### 4. "Con n=30 y p=0.050 justo en el borde, ¿no estás sobreinterpretando?"

Esta es la más incómoda. No la esquives.

> Es una preocupación legítima y quiero ser preciso sobre qué estoy afirmando y
> qué no.
>
> No afirmo que el sistema aumente la tensión en la población general de
> jugadores. El resultado del grupo completo no fue significativo, y lo reporto
> como tal.
>
> Lo que sí afirmo es más acotado: dentro del grupo adaptativo, la distancia de
> exploración se asocia con la tensión reportada, y esa asociación no existe en
> el control. Eso lo verifiqué de tres formas independientes: la comparación por
> perfil, la correlación continua de Spearman, y la correlación parcial
> descontando experiencia. Las tres apuntan en la misma dirección.
>
> El argumento más fuerte no es el valor p, es la *ausencia* del efecto en el
> control. Si esto fuera ruido de submuestreo, no habría razón para que aparezca
> solo en la condición donde el jefe efectivamente se adapta.
>
> Aun así, lo presento en el escrito como indicio de una prueba de concepto y no
> como resultado generalizable, y calculo que confirmarlo requeriría del orden de
> cuarenta participantes por condición.

**Si presionan sobre comparaciones múltiples:** reconócelo. "Es cierto que hice
varias comparaciones y no apliqué corrección; con corrección este resultado no
sobreviviría. Por eso lo presento como hipótesis generada por los datos, que
requiere confirmación en un estudio con más participantes, y no como una
hipótesis confirmada."

### 5. "El corte por la mediana de distancia, ¿no es un análisis post-hoc?"

> Sí, lo es, y lo declaro como tal en el escrito: la hipótesis surgió observando
> a los participantes jugar, no antes de recolectar los datos.
>
> Lo que la hace defendible es que la variable de corte no es arbitraria: la
> distancia de exploración es precisamente la señal que el sistema usa para
> adaptar al jefe, y se mide *antes* de la experiencia que después se reporta. No
> elegí entre muchas variables la que daba un resultado bonito; usé la que el
> sistema ya estaba usando.
>
> Además, hice el mismo análisis de forma continua con Spearman, sin cortar por
> mediana, y da lo mismo. Eso descarta que el resultado dependa de dónde puse el
> corte.

---

## Las que pueden aparecer

### 6. "¿Y si el efecto en el perfil de rango es simplemente que la versión adaptativa es más difícil para ellos?"

> Esa sería una interpretación válida y no la descarto — de hecho es
> consistente con lo que el sistema busca hacer: presionar más a quien el jefe
> antes no alcanzaba. Lo que sí puedo decir es que no se logró subiendo números:
> el daño y la velocidad son idénticos en ambas condiciones. Si el combate se
> volvió más exigente para ese perfil, fue por un cambio de estrategia del jefe.
>
> Y hay evidencia de que no se sintió injusto: catorce de quince del grupo
> adaptativo calificaron el comportamiento del jefe como justo.

### 7. "¿Por qué el sistema no funcionó contra los jugadores de cuerpo a cuerpo?"

> Creo que hay dos razones. La primera es de diseño: contra quien pelea de cerca,
> la adaptación refuerza ataques de corto alcance —Espinas, Giro— para los que
> ese jugador ya está posicionado y preparado. El cambio existe, pero es menos
> disruptivo que perseguir a alguien que estaba cómodo a distancia.
>
> La segunda es que el repertorio disponible puede no tener suficientes
> herramientas para castigar el juego cercano de forma reconocible. Lo dejé
> planteado como trabajo futuro: revisar si hacen falta ataques diseñados
> específicamente para ese perfil.

### 8. "El SUS que usaste no está validado para videojuegos."

*Llull ya te marcó cosas de instrumentos; ten la respuesta corta.*

> Correcto, y lo reporto como adaptación y no como el SUS validado. La adaptación
> consistió únicamente en sustituir las referencias al «sistema» por el juego,
> que es una práctica documentada en la literatura de usabilidad y que preserva
> la estructura, los diez ítems y el método de cálculo. No existe un «SUS para
> videojuegos» formalmente validado y único. Está declarado en las limitaciones.

### 9. "¿Cómo aseguras que el nivel previo generó perfiles comparables entre grupos?"

> Lo verifiqué explícitamente. El nivel previo es idéntico en ambas condiciones
> —el jefe todavía no aparece— y comparé las cuatro métricas de exploración entre
> grupos: distancia, ratio de ataques melee, esquivas totales y esquivas
> exitosas. Ninguna mostró diferencias significativas.
>
> Hay una tendencia del grupo adaptativo a jugar algo más lejos, con p igual a
> 0.135. No es significativa, pero la reporto como fuente de variación no
> controlada en las limitaciones.

### 10. "¿Por qué entre sujetos y no intrasujeto, si tenías tan pocos participantes?"

> Porque en este juego el aprendizaje entre partidas es muy fuerte. Si la misma
> persona jugara ambas versiones, en la segunda ya conocería el repertorio del
> jefe, el mapa y los controles, y sería imposible separar el efecto de la
> adaptación del efecto de haber jugado antes.
>
> Reconozco el costo: perdí poder estadístico. En el trabajo futuro planteo que
> un diseño intrasujeto con contrabalanceo, y con más participantes, ayudaría a
> separar mejor el efecto de la adaptación de la experiencia previa.

### 11. "La instrucción de matar a todos los enemigos, ¿no sesga el comportamiento?"

> Puede haberlo condicionado, sí, y es un costo que asumí conscientemente. Sin
> esa instrucción, un jugador que esquiva a todos los enemigos llega al jefe sin
> que el sistema tenga información suficiente para construir un perfil, y esa
> sesión se pierde. La instrucción fue idéntica para ambas condiciones, así que
> no introduce diferencias entre grupos, solo acota qué estilos de juego pude
> observar.

### 12. "¿Cuál es el aporte real, si el resultado principal no es significativo?"

Ten esta lista clara, es tu respuesta de cierre.

> Yo diría que hay tres aportes.
>
> Uno es el sistema en sí: un mecanismo de adaptación por comportamiento y no por
> parámetros, implementado y verificado sobre un juego completo con las
> herramientas nativas del motor.
>
> El segundo es el hallazgo de que el efecto de un sistema así depende del estilo
> de juego de la persona, algo que se pierde por completo si uno solo compara
> promedios de grupo. Para quien diseñe o evalúe sistemas similares, ese es un
> resultado accionable.
>
> Y el tercero es metodológico: mostrar que la percepción reportada de adaptación
> es una señal poco confiable —casi la mitad del grupo de control creyó ver
> adaptación donde no la había— y que hace falta contrastarla contra el registro
> interno del sistema.

---

## Preguntas trampa: qué no decir

| No digas | Di |
|---|---|
| "No funcionó" | "No alcanzó significancia con esta muestra" |
| "Probamos que el sistema aumenta la tensión" | "Encontramos una asociación que aparece solo en la condición adaptativa" |
| "Los jugadores no se dieron cuenta, así que falló" | "La percepción resultó poco confiable, por eso el análisis se apoya en métricas objetivas" |
| "No tuve tiempo de hacer X" | "X quedó fuera del alcance definido y está planteado como trabajo futuro" |
| "No sé" (y quedarte ahí) | "No lo analicé, pero con los datos registrados se podría revisar así: …" |

**Si de verdad no sabes algo**, dilo derecho y ofrece cómo lo averiguarías. Es
mejor respuesta que improvisar. Tienes los datos crudos en
`analisis_resultados/`, así que casi siempre puedes decir qué análisis
respondería la pregunta.

---

## Números que tienes que saber de memoria

| Dato | Valor |
|---|---|
| Participantes | 33 reclutados, 3 descartados, **30 válidos** (15 / 15) |
| Verificación pre-combate | **15 / 15** exactas |
| Verificación durante combate | 14 / 15 activas |
| SUS general | **77.9** (industria: 68; "Excelente": 80.3) |
| Tensión perfil rango vs. melee (adaptativo) | **medias 1.69 vs. 1.07**, p = 0.050, r = 0.55 |
| Tensión por perfil en control | medianas 1.12 (rango) y 1.25 (melee) — sin diferencia |
| Desafío por perfil (adaptativo) | medias 2.69 vs. 2.39, p = 0.555 (no significativo) |
| Spearman distancia–tensión (adaptativo) | **0.517**, p = 0.048 |
| Spearman distancia–tensión (control) | −0.075, p = 0.790 |
| Correlación parcial descontando experiencia | **0.537**, p = 0.039 |
| Predecible: control vs. adaptativo | 11/15 (73%) vs. 7/15 (47%) |
| Percibió aprendizaje | 10/15 adaptativo vs. **7/15 control** |
| Duración del combate (mediana) | 173 s control vs. 224 s adaptativo (p = 0.281) |
| IQR de desafío | 0.88 control vs. **0.50** adaptativo |
| Muestra necesaria para confirmar | ~40 por condición (80 total) |
| Ataques del jefe | 9, peso base 50, máximo 2 repeticiones seguidas |
