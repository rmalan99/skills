---
name: qa-test-scenario-generator
description: Genera escenarios de prueba desde la baseline funcional y los casos de uso, cubriendo caminos felices, alternos, negativos, de borde y de permisos.
---

# qa-test-scenario-generator

## Role

Deriva escenarios de prueba desde baseline y casos de uso, con foco en cobertura, prioridad, riesgo y evidencia esperada.

## Shared references

- `qa/skills/references/common-contract.md`
- `qa/skills/references/evidence-confidence.md`
- `qa/skills/references/artifact-templates.md`

## Owns

- escenarios felices, alternos, negativos, de borde, permisos o integracion;
- prioridad y expectativa observable por escenario;
- recomendacion de siguiente fase para `qa-suite-orchestrator`.

## Rule

Debe cerrar primero el mapa de escenarios util; los datos reales que falten pasan como pendientes del contrato comun.

En `governed-suite` debe recibir y devolver el envelope operativo comun. No puede handoffear directo a `qa-test-case-generator`, `qa-traceability-manager` ni cerrar el run por su cuenta.

Hereda y hace cumplir el hardening de `qa/skills/references/common-contract.md`: fail-closed en la interfaz obligatoria secuencial y bloqueante de 3 pasos cuando actua como skill de entrada, pedir solo el campo faltante o invalido, esperar la respuesta antes de avanzar, emitir resumen normalizado antes de ejecutar y mantener salida final `.md`-only sin preview ni mixed-mode.

## Output shape

- Usa `qa/skills/references/artifact-templates.md` como shape real de salida final, no solo como referencia.
- Cuando produzcas un `escenario de prueba` final, entrégalo renderizado directamente como Markdown final listo para archivo `.md`, con el template canonico `Escenario de prueba` y manteniendo el orden y los nombres exactos de sus secciones.
- Debes seguir ese template exactamente: conservar todas las secciones canonicas, en el mismo orden, sin omitirlas ni inventar encabezados alternativos.
- Genera escenarios separados por cada caso de uso origen y agrupalos bajo el `CU-XXX` correspondiente para facilitar lectura, revision y trazabilidad.
- Si el alcance incluye multiples casos de uso, devuelve secciones independientes por `CU-XXX`; no mezcles pasos de navegacion, idioma, CV, trayectoria o contacto dentro del mismo escenario.
- La cardinalidad es exacta: si identificas 10 escenarios de prueba, el artefacto Markdown final contiene esos mismos 10 bloques de escenario.
- Respeta tambien el `Contrato de estabilidad` de esa referencia; no cambies labels, orden ni nombres de seccion.
- Si un campo obligatorio no puede cerrarse por falta de evidencia, mantenlo visible en el artefacto y declara el gap como `pendiente`, supuesto activo o nota trazable.
- No uses preview, subset parcial ni sample representativo; el resultado principal debe ser el artefacto textual completo listo para recomendacion de continuidad via `qa-suite-orchestrator` o validacion de `qa-engineer`.
- La cobertura adicional o contexto de riesgo debe vivir en `Riesgos o notas` o despues del template, sin deformar la estructura canonica.
- La respuesta final de cierre debe listar explicitamente cada artefacto `.md` generado; no reemplaces ese cierre por previews, tablas paralelas ni otros formatos.
- Si hace falta continuidad, devuelve `handoff_recommendation` para `qa-suite-orchestrator`; no abras un bypass operativo.

## Canonical template embedded

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
