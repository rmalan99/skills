---
name: qa-doc-orchestrator
description: Alias deprecated de qa-suite-orchestrator. Mantiene compatibilidad y redirige al agente orquestador canonico de qa-skills-suite.
---

# qa-doc-orchestrator

## Status

Deprecated compatibility alias for `qa-suite-orchestrator`.

## Use this alias only when

- un flujo historico todavia invoque `qa-doc-orchestrator`;
- haga falta aclarar la transicion al nuevo nombre canonico.

## Canonical reference

- Skill canonica: `qa/skills/qa-suite-orchestrator/SKILL.md`
- Contrato comun: `qa/skills/references/common-contract.md`
- Flujo de fases: `qa/skills/references/phase-flow.md`

## Behavior

- Reenviar la orquestacion a `qa-suite-orchestrator`.
- No crear una segunda fuente de verdad.
- Mantener `phase-close-first` y el mismo handoff package definido en el contrato comun.
- Si el flujo es `governed-suite`, preservar el envelope operativo comun y la autoridad unica de `qa-suite-orchestrator`.
- Preservar tambien la interfaz obligatoria previa a la ejecucion con esta secuencia exacta y bloqueante: `Paso 1 - Tipo de salida QA` (opciones normalizadas: `proceso completo`, `caso de uso`, `escenario de prueba`, `caso de prueba`, `exploracion QA`, `documentacion PRD`); luego `Paso 2 - Fuente objetivo` (opciones normalizadas: `desde cero`, `URL publica`, `URL autenticada`, `baseline existente`, `codigo/artefactos`); luego `Paso 3 - Cual es el limite de alcance`, mostrando un ejemplo como `solo landing`.
- Hacer una sola pregunta por vez y esperar la respuesta valida antes de avanzar al siguiente paso; no agrupar preguntas pendientes.
- Si el usuario no responde validamente los 3 pasos, no proceder; si falta o falla un campo, pedir solo ese campo, quedar bloqueado en ese paso y no generar artefactos todavia.
- Una vez validada la interfaz, ecoar el resumen normalizado de ejecucion antes de correr: tipo de salida QA, fuente objetivo, limite de alcance, ruta elegida y confirmacion de salida final `.md`.
- Preservar tambien la regla vigente de artefactos Markdown finales directos, sin preview y con cardinalidad 1:1 entre items identificados y entradas del `.md`.
- Preservar tambien la exigencia de que cualquier accion soportada termine obligatoriamente creando y devolviendo archivos Markdown `.md` como resultado final requerido.
- Preservar tambien la exigencia de listar claramente los artefactos `.md` creados en la respuesta final y evitar salida mixta o formatos alternativos.
- Preservar tambien la exigencia de estructura exacta del template canonico: mismas secciones, mismo orden y sin omitir ni inventar encabezados.
