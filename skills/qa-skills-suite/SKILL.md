# qa-skills-suite

Skill contenedora y canonica para operar la suite `qa-skills-suite` como punto de entrada unico para discovery QA, modelado funcional, derivacion de artefactos, trazabilidad, compatibilidad y continuidad entre fases.

## Cuando aplicar

- Cuando un asistente IA necesita arrancar o retomar un flujo QA completo y modular.
- Cuando el trabajo puede empezar desde cero, desde una URL, desde un baseline existente o con contexto enriquecido por codigo.
- Cuando hace falta coordinar discovery, baseline funcional, artefactos de prueba y trazabilidad sin mezclar responsabilidades.

## Como usarla como punto de entrada

- Antes de ejecutar cualquier accion soportada, la suite debe presentar obligatoriamente esta interfaz de interaccion al usuario y esperar una seleccion valida.
- La secuencia requerida es exacta y bloqueante: `Paso 1 - Tipo de salida QA` (opciones normalizadas: `proceso completo`, `caso de uso`, `escenario de prueba`, `caso de prueba`, `exploracion QA`, `documentacion PRD`), luego `Paso 2 - Fuente objetivo` (opciones normalizadas: `desde cero`, `URL publica`, `URL autenticada`, `baseline existente`, `codigo/artefactos`), luego `Paso 3 - Cual es el limite de alcance` mostrando un ejemplo como `solo landing`.
- La suite debe hacer una sola pregunta por vez y esperar la respuesta valida del usuario antes de habilitar el siguiente paso; no debe agrupar preguntas pendientes.
- Si el usuario no responde validamente los 3 pasos, la suite no debe continuar, no debe inferir defaults y no debe generar artefactos todavia.
- Si la seleccion es ambigua o invalida, la suite debe pedir solo el campo faltante o invalido y esperar esa correccion en ese mismo paso antes de ejecutar.
- Una vez validados los 3 pasos, la suite debe ecoar un resumen normalizado de ejecucion antes de correr: tipo de salida QA, fuente objetivo, limite de alcance, ruta o modo a ejecutar y confirmacion de salida final en `.md`.
- Invoca esta skill primero cuando quieras entrar a la suite sin decidir manualmente cada skill especializada.
- Esta skill evalua el contexto inicial, activa la regla `phase-close-first` y delega la coordinacion al `qa-suite-orchestrator`.
- El `qa-suite-orchestrator` decide el modo operativo, selecciona el explorador disponible, enruta por tipo de artefacto y encadena los handoffs entre skills.
- Si el modo es `governed-suite`, el `qa-suite-orchestrator` es la unica autoridad operativa del run y toda skill especializada debe recibir y devolver el envelope operativo comun.
- Si una fase ya esta cerrada, la suite continua a la siguiente; si falta input externo, lo pide solo despues del cierre de fase actual.

## Regla de ruteo y cierre

- El ruteo canonico por artefacto final es: `caso de uso` -> `qa-use-case-generator`, `escenario de prueba` -> `qa-test-scenario-generator`, `caso de prueba` -> `qa-test-case-generator`.
- Por defecto, si el usuario no pide un set especifico, la suite debe devolver los tres artefactos en este orden: `caso de uso` -> `escenario de prueba` -> `caso de prueba`.
- Cuando el pedido cubre varios artefactos o una cadena completa, el `qa-suite-orchestrator` coordina la secuencia sin colapsar ownership entre skills.
- Para `caso de uso`, la suite debe derivar un caso de uso por funcionalidad observable o por objetivo principal del actor; no debe agrupar multiples funcionalidades independientes dentro de un solo caso de uso.
- Las skills generadoras especializadas producen el artefacto final usando su template canonico embebido y manteniendo compatibilidad con `qa/skills/references/artifact-templates.md`.
- El render final debe respetar de forma estricta el `Contrato de estabilidad` de `qa/skills/references/artifact-templates.md` para que la salida conserve siempre la misma estructura base.
- Esa estructura es obligatoria y exacta: no se pueden omitir secciones canonicas, inventar encabezados nuevos ni reemplazar una seccion requerida por una variante libre.
- El artefacto final debe salir directamente como documento Markdown listo para escribirse en un archivo `.md`; no se permite modo preview, muestra parcial ni version resumida del artefacto.
- Toda accion soportada por la suite debe terminar obligatoriamente creando y devolviendo artefactos Markdown `.md`; ese resultado es requerido, no opcional, incluso cuando el pedido sea de exploracion o documentacion PRD.
- La respuesta final debe listar de forma clara los artefactos `.md` creados; no alcanza con describirlos de forma general.
- Queda prohibida la salida mixta o en formato alternativo: no combinar previews, tablas libres, JSON, bullets sustitutos o respuestas parciales en lugar del entregable Markdown final.
- El flujo gobernado debe volver a `qa-engineer` para revision y cierre final; la suite no debe terminar en generacion directa ni en cierre final fuera del flujo gobernado.
- En `governed-suite` queda prohibido el bypass: ninguna skill especializada puede handoffear directo a otra skill especializada ni autoaprobar el cierre del run.
- `qa-derivation-engine` solo permanece como bridge de compatibilidad para pedidos historicos y debe reenviar al ruteo canonico.

## Modos cubiertos

- `from-zero`: inicio sin artefactos ni baseline.
- `public-url`: discovery desde una URL publica.
- `auth-url`: discovery desde una URL autenticada o con acceso restringido.
- `baseline-to-artifacts`: derivacion a partir de un baseline funcional existente.
- `code-enriched`: flujo apoyado por contexto de codigo, artefactos o evidencia tecnica adicional.

## Componentes agrupados

- `qa-suite-orchestrator`: orquestador principal, checkpoints, handoffs, continuidad y estado de reanudacion.
- `qa-discovery-engine`: discovery funcional, contexto inicial y cierre del entendimiento observable.
- `qa-functional-model-builder`: baseline funcional verificable para derivacion posterior.
- `qa-use-case-generator`: generacion de casos de uso.
- `qa-test-scenario-generator`: generacion de escenarios de prueba.
- `qa-test-case-generator`: generacion de casos de prueba.
- `qa-derivation-engine`: bridge de compatibilidad para pedidos legacy de derivacion; no es owner canonico del artefacto.
- `qa-traceability-manager`: trazabilidad cross-artefacto, evidencia y resume state.
- `qa-playwright-explorer`: exploracion y captura de evidencia via Playwright MCP cuando esta disponible.
- `qa-chrome-devtools-explorer`: exploracion y captura de evidencia via Chrome DevTools MCP cuando Playwright no aplica o no esta disponible.

## Referencias compartidas

- `qa/skills/references/common-contract.md`
- `qa/skills/references/phase-flow.md`
- `qa/skills/references/evidence-confidence.md`
- `qa/skills/references/mcp-exploration-selection.md`
- `qa/skills/references/artifact-templates.md`

## Regla operativa compartida

- `phase-close-first`: cada skill debe cerrar la fase actual con artefactos revisables, evidencia, supuestos activos, confianza y blockers reales antes de pedir credenciales, acceso privado o datos para la fase siguiente.
- `common-operational-envelope`: en `governed-suite`, toda fase usa el envelope comun de `qa/skills/references/common-contract.md`, preservando `run_id`, `operation_id`, `phase_attempt`, `artifact_fingerprint`, `sequence_id`, `parallel_group`, `merge_policy` e `idempotency_scope`.
- `anti-bypass`: toda continuidad operativa entre skills especializadas pasa por `qa-suite-orchestrator`.

## Regla de salida deterministica

- Cuando el usuario no solicite un set especifico, la salida final debe incluir siempre `caso de uso`, `escenario de prueba` y `caso de prueba`.
- Cuando el pedido termine en `caso de uso`, `escenario de prueba` o `caso de prueba`, la suite debe devolver cada artefacto con el template canonico correspondiente y sin variar nombres, orden de secciones ni encabezados.
- Si una seccion canonica no puede completarse, igual debe aparecer en el artefacto final con `pendiente` o `N/A`; no se permite omitirla ni sustituirla por una seccion inventada.
- Para `caso de uso`, cada bloque debe usar siempre la estructura canonica por caso y repetirse una vez por cada funcionalidad cubierta.
- Para `escenario de prueba`, la salida debe agruparse por `caso de uso` y mantener un espacio propio por cada `CU-XXX`, evitando mezclar escenarios de funcionalidades distintas en un solo bloque corrido.
- Para `caso de prueba`, la salida debe agruparse por `caso de uso` y `escenario relacionado`, manteniendo un espacio propio por cada combinacion `CU-XXX` -> `EP-XXX` cubierta.
- La cardinalidad debe ser exacta: si discovery o derivacion identifica `N` items del artefacto objetivo, el Markdown final debe contener exactamente `N` entradas canonicas del mismo tipo, sin consolidar, omitir ni duplicar items.
- Si faltan datos, la salida debe conservar el campo usando `pendiente` o `N/A`; no debe omitir secciones canonicas.
- Los IDs de `caso de uso`, `escenario de prueba` y `caso de prueba` deben salir siempre asignados con valores reales, unicos y trazables; `pendiente` no es valido para IDs salvo bloqueo material declarado.
- Cualquier contexto adicional debe ir fuera del template canonico o en la seccion permitida por el propio template.
- Cada skill especializada debe ser autocontenida: su template operativo debe vivir dentro de la propia skill y no depender de archivos de ejemplo externos.

## Delegacion al orquestador

- Esta skill no ejecuta directamente discovery ni derivacion profunda.
- Su funcion es servir como puerta de entrada canonica y delegar la coordinacion al `qa-suite-orchestrator`.
- El `qa-suite-orchestrator` reparte contexto minimo a las skills especializadas, preserva el contrato de salida normalizado, decide el handoff recomendado y conserva continuidad de fase hasta el retorno a revision final.
- Si detecta una solicitud que intenta saltar el envelope comun o cerrar el run fuera del flujo gobernado, debe reconducirla al `qa-suite-orchestrator` en lugar de ejecutar el bypass.

## Nota de alcance

- Esta skill agrupa la suite y estandariza la entrada.
- No reemplaza las skills especializadas: cada componente sigue siendo el owner de su artefacto, evidencia o soporte de exploracion.
- `qa-engineer` sigue siendo el owner del cierre de revision final en flujos `governed-suite`.

## Mapa rapido

- Referencia general: `qa/skills/README.md`
- Punto de orquestacion: `qa-suite-orchestrator`
- Regla comun: `phase-close-first`
