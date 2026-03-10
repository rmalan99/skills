---
name: qa-derivation-engine
description: Skill puente y deprecada para derivacion QA. Redirige pedidos legacy al ruteo canonico por artefacto, preserva compatibilidad y evita mantener una responsabilidad agregada ambigua.
---

# qa-derivation-engine

## Status

Deprecated compatibility bridge.

## Canonical routing

- `qa-use-case-generator`
- `qa-test-scenario-generator`
- `qa-test-case-generator`
- `qa-traceability-manager`
- `qa-suite-orchestrator`

## Shared references

- `qa/skills/references/common-contract.md`
- `qa/skills/references/phase-flow.md`

## Behavior

- Mantener compatibilidad con pedidos historicos de derivacion.
- Detectar si el pedido legacy apunta a `caso de uso`, `escenario de prueba`, `caso de prueba` o a una cadena multi-artefacto.
- Repartir la salida por artefacto en lugar de centralizarla.
- Enviar pedidos de artefacto unico al generador especializado correspondiente solo cuando el modo sea `standalone`; en `governed-suite` todo pedido debe pasar por `qa-suite-orchestrator`.
- Preservar el formato normalizado ya producido por las skills canonicas; no reformatear ni resumir el artefacto final como salida alternativa.
- Volver a `qa-engineer` para revision y cierre final cuando el flujo siga el modelo `governed-suite`.
- No convertirse en una segunda fuente de verdad ni en owner del cierre final.
- No abrir handoffs directos entre skills especializadas dentro de `governed-suite`.
