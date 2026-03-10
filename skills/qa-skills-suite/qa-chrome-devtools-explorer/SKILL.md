---
name: qa-chrome-devtools-explorer
description: Skill local de exploracion con Chrome DevTools MCP para inspeccion de DOM, consola, red, Lighthouse y performance como evidencia tecnica dentro de qa-skills-suite.
---

# qa-chrome-devtools-explorer

## Role

Obtiene evidencia tecnica de frontend con Chrome DevTools MCP: DOM snapshots, consola, red, Lighthouse, performance y diagnostico runtime especifico de Chrome.

## Shared references

- `qa/skills/references/common-contract.md`
- `qa/skills/references/evidence-confidence.md`
- `qa/skills/references/mcp-exploration-selection.md`

## Use when

- el problema es frontend o runtime especifico;
- se necesitan console logs, network traces, performance o Lighthouse;
- Chrome DevTools MCP esta disponible y la necesidad no es solo recorrer el flujo.

## Owns

- evidencia tecnica Chrome-specific;
- diagnostico de consola, red y performance;
- evidencia y observaciones para discovery, baseline o trazabilidad, siempre devueltas via `qa-suite-orchestrator` en `governed-suite`.

## Rule

Debe complementar, no reemplazar, la skill dueña del artefacto. Si el flujo requiere primero confirmar el recorrido del usuario, la preferencia inicial sigue la politica de `qa/skills/references/mcp-exploration-selection.md`. No puede abrir handoff lateral ni promover otra skill por cuenta propia en `governed-suite`.
