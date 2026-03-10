---
name: qa-discovery-engine
description: Releva alcance, actores, reglas, dependencias, restricciones y supuestos iniciales para cerrar la fase de descubrimiento con una base QA reutilizable.
---

# qa-discovery-engine

## Role

Cierra discovery dentro de `qa-skills-suite`: delimita alcance, actores, reglas visibles, restricciones, dependencias, supuestos y vacios.

## Shared references

- `qa/skills/references/common-contract.md`
- `qa/skills/references/phase-flow.md`
- `qa/skills/references/mcp-exploration-selection.md`

## Use when

- inicia un flujo QA;
- se retoma un modulo con contexto incompleto;
- hace falta separar hechos observados de inferencias.

## Owns

- cierre de discovery;
- criterio de alcance y objetivo de validacion;
- recomendacion de exploracion publica o autenticada;
- recomendacion de siguiente fase para `qa-suite-orchestrator`, incluyendo explorer MCP si hace falta mas evidencia observable.

## Explorer interaction

- Puede pedir apoyo a `qa-playwright-explorer` o `qa-chrome-devtools-explorer`.
- Debe decidir usando `qa/skills/references/mcp-exploration-selection.md`.
- No pide credenciales antes de cerrar todo lo posible en discovery.
- En `governed-suite` debe recibir y devolver el envelope operativo comun y dejar la continuidad operativa en manos de `qa-suite-orchestrator`.
