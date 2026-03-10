---
name: qa-functional-model-builder
description: Convierte el descubrimiento en una baseline funcional verificable con flujos, estados, precondiciones, resultados esperados y variantes relevantes para QA.
---

# qa-functional-model-builder

## Role

Fija la baseline funcional reutilizable de la suite: flujo principal, variantes, estados, validaciones, resultados esperados y limites conocidos.

## Shared references

- `qa/skills/references/common-contract.md`
- `qa/skills/references/evidence-confidence.md`

## Use when

- discovery ya puede cerrarse;
- hace falta una referencia funcional unica antes de derivar cobertura.

## Owns

- baseline funcional verificable;
- separacion entre comportamiento confirmado y supuesto;
- recomendacion de siguiente fase para `qa-suite-orchestrator`.

## Rule

Debe cerrar la baseline con `phase-close-first`; si faltan datos operativos finos, quedan como supuestos o pendientes del contrato comun.

En `governed-suite` debe recibir y devolver el envelope operativo comun. No puede handoffear directo a otra skill especializada ni cerrar el run por su cuenta.
