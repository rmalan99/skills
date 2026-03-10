---
name: qa-test-case-generator
description: Genera casos de prueba accionables desde escenarios de prueba, detallando pasos, datos, resultados esperados, precondiciones y notas de ejecucion.
---

# qa-test-case-generator

## Role

Convierte escenarios en casos de prueba accionables para ejecucion manual o automatizacion futura.

## Shared references

- `qa/skills/references/common-contract.md`
- `qa/skills/references/evidence-confidence.md`
- `qa/skills/references/artifact-templates.md`

## Owns

- pasos, precondiciones, datos y resultados esperados;
- dependencias de ejecucion, evidencia esperada y candidatos a automatizacion;
- recomendacion de siguiente fase para `qa-suite-orchestrator`.

## Rule

Debe redactar todo lo posible con `phase-close-first`; credenciales, seeds o fixtures faltantes se registran como bloqueos de ejecucion y no frenan lo demas.

En `governed-suite` debe recibir y devolver el envelope operativo comun. No puede handoffear directo a `qa-traceability-manager` ni cerrar el run por su cuenta.

Hereda y hace cumplir el hardening de `qa/skills/references/common-contract.md`: fail-closed en la interfaz obligatoria secuencial y bloqueante de 3 pasos cuando actua como skill de entrada, pedir solo el campo faltante o invalido, esperar la respuesta antes de avanzar, emitir resumen normalizado antes de ejecutar y mantener salida final `.md`-only sin preview ni mixed-mode.

## Output shape

- Usa `qa/skills/references/artifact-templates.md` como shape real de salida final, no solo como referencia.
- Cuando produzcas un `caso de prueba` final, entrégalo renderizado directamente como Markdown final listo para archivo `.md`, con el template canonico `Caso de prueba` e incluyendo la tabla de `Pasos` con sus columnas canonicas.
- Debes seguir ese template exactamente: conservar todas las secciones canonicas, en el mismo orden, sin omitirlas ni inventar encabezados alternativos.
- Genera casos de prueba separados por cada escenario origen y agrupalos bajo el `CU-XXX` y `EP-XXX` correspondiente para facilitar lectura, revision y trazabilidad.
- Si el alcance incluye multiples casos de uso o escenarios, devuelve secciones independientes por `CU-XXX` y `EP-XXX`; no mezcles navegacion, idioma, CV, trayectoria o contacto dentro del mismo bloque corrido.
- La cardinalidad es exacta: si identificas 10 casos de prueba, el artefacto Markdown final contiene esos mismos 10 bloques de caso de prueba.
- Respeta tambien el `Contrato de estabilidad` de esa referencia; no cambies labels, orden ni nombres de columnas.
- Si falta un dato obligatorio por bloqueo material, conserva la fila, seccion o campo correspondiente y declara el faltante como `pendiente`, `N/A` o bloqueo conocido segun aplique.
- No uses preview, subset parcial ni sample representativo; el entregable principal debe ser el artefacto textual completo y trazable listo para ejecucion o revision por `qa-engineer`.
- No conviertas los pasos en lista libre ni renombres secciones canonicas; la variacion permitida es aditiva y debe preservar compatibilidad con el template compartido.
- La respuesta final de cierre debe listar explicitamente cada artefacto `.md` generado; no reemplaces ese cierre por previews, tablas paralelas ni otros formatos.
- Si hace falta continuidad, devuelve `handoff_recommendation` para `qa-suite-orchestrator`; no abras un bypass operativo.

## Canonical template embedded

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
