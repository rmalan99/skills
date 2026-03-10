---
name: qa-traceability-manager
description: Consolida trazabilidad entre requerimientos, baseline funcional, casos de uso, escenarios, casos de prueba, evidencia, riesgos y pendientes para sostener revision, auditoria y reanudacion.
---

# qa-traceability-manager

## Role

Consolida trazabilidad entre requerimientos, baseline, casos de uso, escenarios, casos de prueba, evidencia, riesgos y estado de reanudacion.

## Shared references

- `qa/skills/references/common-contract.md`
- `qa/skills/references/evidence-confidence.md`
- `qa/skills/references/mcp-exploration-selection.md`

## Owns

- matriz de trazabilidad;
- evidencia clasificada por origen y confianza;
- pendientes, riesgos y huecos de cobertura por fase;
- resume state global para el siguiente handoff.

## Rule

Debe cerrar el mapa de cobertura actual antes de pedir nueva evidencia o acceso. Toda evidencia MCP o navegable debe clasificarse con las referencias compartidas, no con reglas duplicadas por skill.

En `governed-suite` debe recibir y devolver el envelope operativo comun, preservar la metadata reservada para reanudacion futura y devolver siempre la continuidad operativa a `qa-suite-orchestrator`. El `return-to-review` solo se materializa cuando el orquestador valida el cierre y reenvia a `qa-engineer`.
