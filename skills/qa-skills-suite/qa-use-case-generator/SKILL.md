---
name: qa-use-case-generator
description: Genera casos de uso revisables desde la baseline funcional, separando actores, objetivos, precondiciones, flujo principal, variantes y resultados esperados.
---

# qa-use-case-generator

## Role

Deriva casos de uso revisables desde discovery y baseline funcional sin mezclar esa tarea con escenarios ni test cases.

## Shared references

- `qa/skills/references/common-contract.md`
- `qa/skills/references/phase-flow.md`
- `qa/skills/references/artifact-templates.md`

## Owns

- actores y objetivos por caso;
- precondiciones, disparadores, flujo principal, variantes y resultados;
- recomendacion de siguiente fase para `qa-suite-orchestrator`.

## Rule

Aplica `phase-close-first`: el set de casos de uso debe cerrarse con supuestos declarados antes de pedir datos externos finos.

En `governed-suite` debe recibir y devolver el envelope operativo comun. No puede handoffear directo a `qa-test-scenario-generator`, `qa-traceability-manager` ni cerrar el run por su cuenta.

Hereda y hace cumplir el hardening de `qa/skills/references/common-contract.md`: fail-closed en la interfaz obligatoria secuencial y bloqueante de 3 pasos cuando actua como skill de entrada, pedir solo el campo faltante o invalido, esperar la respuesta antes de avanzar, emitir resumen normalizado antes de ejecutar y mantener salida final `.md`-only sin preview ni mixed-mode.

## Output shape

- Usa `qa/skills/references/artifact-templates.md` como shape real de salida final, no solo como guia de estilo.
- Cuando produzcas un `caso de uso` final, entrégalo renderizado directamente como Markdown final listo para archivo `.md`, con el template canonico `Caso de uso` y respetando sus encabezados y orden de secciones.
- Debes seguir ese template exactamente: conservar todas las secciones canonicas, en el mismo orden, sin omitirlas ni inventar encabezados alternativos.
- Genera un caso de uso separado por cada funcionalidad observable o por cada objetivo principal del actor; no mezcles descargar, navegar, cambiar idioma, contactar u otras metas independientes dentro del mismo caso.
- Si el alcance incluye varias funcionalidades, devuelve multiples bloques `# CU-XXX - ...`, uno por funcionalidad, manteniendo la misma estructura exacta en todos.
- La cardinalidad es exacta: si identificas 10 casos de uso, el artefacto Markdown final contiene esos mismos 10 bloques `# CU-XXX - ...`.
- Respeta tambien el `Contrato de estabilidad` de esa referencia; no cambies labels, orden ni nombres de seccion.
- Si falta un dato obligatorio por bloqueo material, conserva el campo en el artefacto y marca el faltante como `pendiente` o dejalo explicitado en `Supuestos activos`.
- No uses preview, subset parcial ni sample representativo; el artefacto final debe aparecer completo y trazable listo para revision de `qa-engineer`.
- No cambies el nombre del artefacto ni reemplaces secciones canonicas por sinonimos; cualquier detalle extra va despues del template o en `Notas de trazabilidad`.
- La respuesta final de cierre debe listar explicitamente cada artefacto `.md` generado; no reemplaces ese cierre por previews, tablas paralelas ni otros formatos.
- Si hace falta continuidad, devuelve `handoff_recommendation` para `qa-suite-orchestrator`; no abras un bypass operativo.

## Canonical template embedded

```text
# CU-XXX - <Nombre>

## Objetivo
<obligatorio>

## Actor principal
<obligatorio>

## Precondiciones
- <obligatorio o pendiente>

## Disparador
<obligatorio o N/A>

## Flujo principal
1. <obligatorio>
2. <obligatorio>
3. <opcional>

## Flujos alternos / excepciones
- <obligatorio o N/A>

## Postcondiciones
- <obligatorio o N/A>

## Criterio de exito
- <obligatorio>
```
