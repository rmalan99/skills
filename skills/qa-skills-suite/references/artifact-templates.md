# qa-skills-suite artifact templates

Plantillas textuales canonicas para los artefactos finales de la suite.

## Uso previsto

- Estas plantillas definen un formato estable, reutilizable y autocontenido para los artefactos finales de la suite.
- Definen la forma canonica de salida para `caso de uso`, `escenario de prueba` y `caso de prueba`; no son una referencia opcional de estilo.
- Son la fuente normativa para el render final de artefactos en `qa-skills-suite`.
- El render final debe producirse directamente como contenido Markdown listo para persistirse en un archivo `.md`.
- Toda skill generadora que produzca uno de esos artefactos debe usar este shape como base obligatoria de redaccion y estructura.
- Los generadores especializados producen el artefacto final; `qa-engineer` valida consistencia, cobertura y calidad de salida.
- Los campos marcados como `obligatorio` deben estar presentes salvo bloqueo material declarado.

## Contrato de estabilidad

- El nombre del artefacto debe salir exactamente como `Caso de uso`, `Escenario de prueba` o `Caso de prueba`.
- Mantener exactamente el orden de secciones definido en esta referencia.
- No renombrar encabezados, no mezclar idiomas en los labels y no reemplazar listas por prosa libre.
- Seguir exactamente la estructura definida para cada artefacto: no omitir secciones canonicas, no insertar secciones inventadas y no sustituir una seccion requerida por otra similar.
- No usar modo preview, avance parcial, sample reducido ni respuesta teaser; el artefacto entregado debe ser el Markdown final completo.
- Para `Caso de uso`, generar un bloque independiente por cada funcionalidad observable o por cada objetivo principal del actor; no consolidar funcionalidades distintas en un solo bloque.
- Para `Escenario de prueba`, agrupar la salida por `Caso de uso relacionado` y dejar un espacio independiente por cada `CU-XXX` cubierto.
- Para `Caso de prueba`, agrupar la salida por `Caso de uso relacionado` y `Escenario relacionado`, dejando un espacio independiente por cada `CU-XXX` y `EP-XXX` cubierto.
- Mantener cardinalidad 1:1 entre items identificados y bloques renderizados del mismo tipo: si se derivan 10 items, el `.md` final contiene esos mismos 10 bloques, sin omisiones, consolidaciones ni duplicados.
- Los IDs deben asignarse siempre en la entrega final usando identificadores reales, unicos y trazables; no dejar `pendiente` en IDs salvo bloqueo material declarado.
- Si falta un dato, usar `pendiente`; si no aplica, usar `N/A`.
- No inventar actores, reglas, resultados ni evidencias.
- Los detalles extra van al final en `Notas de trazabilidad`, `Riesgos o notas` o `Notas de ejecucion`, segun el artefacto.
- Si falta contenido para una seccion requerida, conservar igualmente la seccion y completar su valor con `pendiente` o `N/A` segun corresponda.
- El envelope operativo de `qa/skills/references/common-contract.md` envuelve el artefacto; esta referencia define solo el contenido final que vive dentro de `artifact_delta`.

## Relacion con el envelope operativo

- En `governed-suite`, el artefacto final se entrega dentro de `result.artifact_delta` del envelope comun.
- El envelope puede incluir metadata reservada como `run_id`, `operation_id`, `phase_attempt`, `artifact_fingerprint`, `sequence_id`, `parallel_group`, `merge_policy` e `idempotency_scope`, pero esa metadata no reemplaza ni altera el shape textual del artefacto.
- Si hay conflicto entre metadata operativa y template textual, el template textual sigue siendo la fuente de verdad para la forma final del artefacto y el conflicto se reporta como falla operativa.

## Reglas comunes de redaccion

- Mantener lenguaje claro, verificable y sin datos inventados.
- Declarar supuestos de forma explicita cuando falte confirmacion.
- Separar hechos observables de reglas inferidas.
- Evitar nombres del dominio de ejemplo salvo cuando el input original los traiga y sean necesarios para trazabilidad.
- Preferir frases cortas y accionables.

## Template canonico: caso de uso

### Render obligatorio

```text
# CU-004 - Descargar CV

## Objetivo
Permitir al visitante obtener el archivo CV disponible en el sitio.

## Actor principal
Visitante.

## Precondiciones
- El sitio se encuentra disponible.
- La página principal cargó correctamente.
- El enlace o botón `Download CV` está habilitado.

## Disparador
El visitante selecciona la opción `Download CV`.

## Flujo principal
1. El sistema presenta la opción `Download CV` en la sección correspondiente.
2. El visitante hace clic sobre `Download CV`.
3. El sistema redirige, abre o inicia la descarga del archivo CV asociado.
4. El visitante accede al documento.

## Flujos alternos / excepciones
- **3a.** Si el archivo no está disponible, el sistema informa que el recurso no pudo cargarse.

## Postcondiciones
- El visitante obtiene acceso al CV.

## Criterio de éxito
- El archivo correcto se abre o descarga sin error.
```

### Guia de uso

- Cada bloque debe iniciar con `# CU-XXX - Nombre` y representar una funcionalidad o un objetivo principal independiente.
- `Flujo principal` describe la ruta exitosa de punta a punta para esa funcionalidad puntual.
- `Flujos alternos / excepciones` captura rechazos, validaciones, bloqueos y desvíos del mismo objetivo; no agregar aqui funcionalidades paralelas.
- `Postcondiciones` expresa el estado final observable del sistema o del actor despues del flujo.
- `Criterio de exito` declara la condicion verificable que confirma que el caso de uso quedo resuelto correctamente.
- Asignar un ID real por cada caso de uso usando una secuencia trazable, por ejemplo `CU-001`, `CU-002`, `CU-003`.

## Template canonico: escenario de prueba

### Render obligatorio

```text
## Caso de uso relacionado: <CU-XXX - Nombre>

### Escenario de prueba: <Nombre>
- ID: <obligatorio o pendiente>
- Objetivo de validacion: <obligatorio>
- Rol/Actor: <opcional o N/A>
- Tipo: <obligatorio; feliz | alterno | negativo | borde | permisos | integracion | otro>
- Prioridad: <opcional; alta | media | baja>
- Feature/Modulo relacionado: <opcional o N/A>
- Precondiciones: <obligatorio; lista inline o `pendiente`>

#### Pasos
1. <obligatorio>
2. <obligatorio>
3. <opcional>

#### Resultado esperado
- <obligatorio>

#### Evidencia esperada
- <opcional o N/A>

#### Riesgos o notas
- <opcional o N/A>

#### Supuestos activos
- <opcional o N/A>
```

### Guia de uso

- La linea `Escenario` debe nombrar la validacion principal con la menor ambiguedad posible.
- Cada bloque `## Caso de uso relacionado: ...` debe agrupar solo escenarios del mismo `CU-XXX`.
- `Pasos` conserva el estilo secuencial observado en la muestra `Escenarios.extraido.md`, pero normalizado a lista estable.
- `Resultado esperado` debe poder observarse sin reinterpretacion ambigua.
- `Evidencia esperada` puede incluir UI visible, respuesta, archivo, log o cambio persistido.
- Asignar un ID real por cada escenario de prueba usando una secuencia trazable, por ejemplo `EP-001`, `EP-002`, `EP-003`.

## Template canonico: caso de prueba

### Render obligatorio

```text
## Caso de uso relacionado: <CU-XXX - Nombre>

### Escenario relacionado: <EP-XXX - Nombre>

Caso de prueba

ID: <obligatorio o pendiente>
Titulo: <obligatorio>
Modulo: <opcional o N/A>
Descripcion: <obligatorio>
Precondiciones:
- <obligatorio o pendiente>

Escenario relacionado: <obligatorio o N/A>
Caso de uso relacionado: <obligatorio o N/A>
Prioridad: <opcional; alta | media | baja>
Tipo de ejecucion: <opcional; manual | automatizable | automatizado>

Tabla de pasos:
| # | Steps | Test Data | Expected Result |
|---|-------|-----------|-----------------|
| 1 | <obligatorio> | <obligatorio o N/A> | <obligatorio> |
| 2 | <obligatorio> | <obligatorio o N/A> | <obligatorio> |

Resultado final esperado:
- <opcional o N/A>

Postcondiciones:
- <opcional o N/A>

Evidencia a capturar:
- <opcional o N/A>

Notas de ejecucion:
- <opcional o N/A>

Bloqueos conocidos:
- <opcional o N/A>
```

### Guia de uso

- Se conserva la estructura tabular inspirada en `Caso de prueba.extraido.md` para maximizar repetibilidad.
- Cada bloque `## Caso de uso relacionado: ...` y `### Escenario relacionado: ...` debe agrupar solo casos del mismo origen trazable.
- Los nombres de columnas deben permanecer exactamente como `#`, `Steps`, `Test Data` y `Expected Result`.
- Cada fila debe describir una accion concreta y su resultado esperado verificable.
- `Test Data` puede indicar valores, fixtures, perfil, entorno o `N/A` cuando no aplique.
- Asignar un ID real por cada caso de prueba usando una secuencia trazable, por ejemplo `CP-001`, `CP-002`, `CP-003`.

## Trazabilidad minima recomendada

- `caso de uso` -> referencia a feature, modulo o fuente funcional.
- `escenario de prueba` -> referencia a caso de uso y foco de cobertura.
- `caso de prueba` -> referencia a escenario y, cuando exista, al caso de uso origen.

## Nota de autocontencion

- Esta referencia funciona como contrato compartido.
- Cada skill generadora debe incluir tambien su propio template canonico embebido para no depender de ejemplos externos ni de rutas auxiliares.
- Si existe conflicto entre una skill especializada y esta referencia, debe prevalecer esta referencia y la skill debe alinearse al mismo shape canonico.
