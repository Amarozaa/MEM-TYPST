# Contexto: documentación de Memorials (tesis UE5)

Estoy documentando la sección "Implementación de la solución" de mi informe de tesis
(Computer Engineering, U. de Chile) en Typst. El juego es un souls-like en Unreal Engine
5.6, mezcla de Blueprints y C++.

## Qué es el texto que te voy a pasar

Te voy a pegar la salida de un script propio que condensa Blueprints (copiados con Ctrl+A +
Ctrl+C desde el editor) a pseudocódigo legible. No es código ejecutable.

Convenciones:
- `EVENT X` / `INPUT X`: puntos de entrada (evento de Blueprint o Input Action).
- `IF (condición)` con `[true]`/`[false]`: ramas de un branch.
- Indentación = anidamiento del flujo de ejecución.
- `SET X` / `GET X`: lectura/escritura de variable.
- `Funcion(args)`: llamada con argumentos de nodos puros ya resueltos en línea.
- `Objeto.Funcion()`: la función se llama sobre un target específico, no sobre self.
- `[ya visto]`: el flujo vuelve a un nodo ya descrito (referencia, no duplicación).
- `[NombrePin]` antes de una rama: el pin de salida que la dispara (`[OnCompleted]`,
  `[then_0]`, `[Triggered]`).
- Un `?` en vez de un valor: el script no logró resolver esa entrada de datos.

## Limitaciones conocidas del script (importante)

El condensador a veces falla de formas específicas. Cuando algo se vea raro, el primer
sospechoso es el script, no el Blueprint:

- A veces **omite la etiqueta `[NombrePin]`** de una rama aunque la conexión real exista
  (ej. una línea que debería decir `[OnCompleted]` aparece sin etiqueta, como si fuera
  secuencial). No asumas que falta la conexión solo porque no se ve el corchete — pregunta.
- Cuando dos nodos de evento ligados a un componente (`PawnSensing`, etc.) no tienen nombre
  reconocible, aparecen como `ComponentBoundEvent` genérico. Hay que preguntar el nombre
  real (normalmente algo como "On See Pawn").
- `TransformComponent` genérico suele ser el RootComponent del actor, sin resolver bien.
- Eventos nativos con varios pines de salida (`ReceiveAnyDamage`, etc.) a veces muestran el
  nombre del evento entero en vez del pin específico (ej. `Damage`, `DamageCauser`).
- Cuando el condensado mezcla cadenas de ramas no conectadas linealmente
  (`ExecutionSequence`s complejos), a veces agrupa mal nodos de partes distintas del grafo.
  Si algo se ve incoherente con el resto del Blueprint (variables que no deberían estar
  ahí, lógica que no tiene sentido en ese evento), es señal de esto — preguntar antes de
  documentar.

## Cómo trabajamos (importante, así es como quiero que sigas)

1. **No asumas nada que no esté en el texto o que yo no haya confirmado.** Si algo es
   ambiguo, raro, o parece un bug, pregúntalo en una lista corta y específica, no en
   prosa larga. Pero antes de preguntar, revisa si la duda se explica por una de las
   limitaciones conocidas de arriba — muchas dudas típicas (`ComponentBoundEvent`,
   `TransformComponent`, pines sin resolver) ya tienes la respuesta probable acá mismo,
   no hace falta preguntarlas todas como si fueran nuevas cada vez.
2. **No le des trato de "error" a algo solo porque se ve inusual.** Pregunta primero;
   muchas veces es una decisión de diseño válida o un patrón que ya se repite en otros
   Blueprints del proyecto (ej. el patrón montage → notify → limpieza de estado, presente
   en casi todas las habilidades).
3. **Documentamos por diferencia.** Cuando un Blueprint comparte base con otro ya
   documentado (ej. enemigos del mismo "tipo"), no repitas lo común — solo describe qué
   cambia, y referencia la sección anterior para lo que se mantiene igual.
4. **Marca lo pendiente con `// TODO:` en Typst**, nunca inventes contenido para rellenar
   un hueco. Si falta el grafo de una función llamada desde otro lado, dilo y sigue con
   el resto en vez de bloquear todo el avance.
5. **No documentes el "para qué" ni el diseño/justificación salvo que se pida.** Esta
   sección es descriptiva/técnica: qué hace el grafo, no por qué se diseñó así. Las
   excepciones a esto las indico yo explícitamente cuando corresponda.
6. **Precisión sobre generalidad.** Si el grafo da un número, nombre de variable o función
   exacto, úsalo. No generalices si el dato concreto está disponible.

## Estilo de redacción

- Español de Chile, formal/académico, sin coloquialismos.
- Typst: backticks para identificadores (`isAttacking`, `BP_Slime`), cursivas para tipos
  o conceptos propios de UE (`_Animation Montage_`, `_Behavior Tree_`), `==`/`===`/`====`
  para secciones según profundidad.
- Cuando algo requiere más contexto que no cabe en el cuerpo, usa nota al pie
  (`#footnote[...]`) en vez de interrumpir el párrafo.

## Cómo vamos a trabajar en esta sesión

Te voy a ir pasando condensados de Blueprints de a uno o varios relacionados. Para cada
uno, dame primero un resumen breve de lo que entendiste (2-4 líneas) y la lista de dudas
si las hay (aplicando el punto 1 de arriba: filtra primero contra las limitaciones
conocidas). Cuando confirme o aclare, recién ahí redactas la sección o subsección en
Typst, lista para pegar.