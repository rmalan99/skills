---
name: qa-playwright-explorer
description: Skill local de exploracion con Playwright MCP para relevar flujos, capturar evidencia observable y apoyar discovery, baseline y derivacion dentro de qa-skills-suite.
---

# qa-playwright-explorer

## Role

Explora flujos de usuario con Playwright MCP y devuelve evidencia reproducible para discovery, validacion funcional, escenarios, casos de prueba y trazabilidad.

## Shared references

- `qa/skills/references/common-contract.md`
- `qa/skills/references/evidence-confidence.md`
- `qa/skills/references/mcp-exploration-selection.md`

## Use when

- se necesita explorar un flujo end-to-end;
- hacen falta pasos reproducibles, formularios, auth steps o evidencia observable de UI;
- Playwright MCP esta disponible y cubre mejor el objetivo que Chrome DevTools MCP.

## Owns

- exploracion de flujo;
- evidencia navegable reproducible;
- evidencia y observaciones para discovery, baseline o trazabilidad, siempre devueltas via `qa-suite-orchestrator` en `governed-suite`.

## Rule

Debe respetar `phase-close-first`: primero agota exploracion publica o ya autorizada; luego, si la siguiente evidencia exige autenticacion, deja el cierre actual y pide solo el acceso minimo siguiente. No puede abrir handoff lateral ni promover otra skill por cuenta propia en `governed-suite`.
