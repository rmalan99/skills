# qa-skills-suite phase flow

## Canonical flow

1. qa framing
2. suite orchestration
3. discovery
4. functional model baseline
5. use cases
6. test scenarios
7. test cases
8. traceability and resume state
9. final review

Exploration support through Playwright MCP or Chrome DevTools MCP can assist discovery, validation and evidence capture without replacing the owning skill for each artifact.

`phase-close-first` applies inside each producing phase. In `governed-suite`, phase closure returns to the governed flow before a new governed phase starts.

## Responsibility split

- `qa-engineer`: owns `qa_frame`, review intent, final review, validation of produced artifacts and approval to continue between governed phases.
- `qa-suite-orchestrator`: coordinates suite execution, sequencing, checkpoints, minimal context, governed handoffs and the shared operational envelope.
- `qa-discovery-engine`: owns discovery closure.
- `qa-functional-model-builder`: owns the functional baseline.
- `qa-use-case-generator`: owns use cases.
- `qa-test-scenario-generator`: owns scenarios.
- `qa-test-case-generator`: owns executable test cases.
- `qa-traceability-manager`: owns cross-artifact traceability and resume state.
- `qa-playwright-explorer`: owns Playwright MCP exploration support.
- `qa-chrome-devtools-explorer`: owns Chrome DevTools MCP exploration support.

Specialized skills produce artifacts or evidence for their assigned phase. They do not redefine `qa_frame`, do not self-authorize final closure of a governed suite run and do not route other specialized skills directly inside `governed-suite`.

In particular, `qa-use-case-generator`, `qa-test-scenario-generator` and `qa-test-case-generator` remain the primary generators of final `caso de uso`, `escenario de prueba` and `caso de prueba` outputs. `qa-engineer` reviews, validates and closes on top of those outputs.

## Mode selection

- `standalone`: one skill can complete the requested work end-to-end and return directly.
- `governed-suite`: `qa-engineer` frames the work, `qa-suite-orchestrator` coordinates execution as the only operational authority, and specialized skills return evidence or artifacts inside the common envelope.

## Checkpoints

At each checkpoint, the owning skill should leave:

- artifact state;
- assumptions still active;
- evidence and confidence;
- blockers and minimum next input;
- recommended next handoff.

In `governed-suite`, each checkpoint should also confirm whether the result is ready for `return-to-review` or still needs orchestrated follow-on work.

The checkpoint should also preserve `run_id`, `operation_id`, `phase_attempt`, `artifact_fingerprint`, `sequence_id`, `parallel_group`, `merge_policy` and `idempotency_scope` for retry and idempotency hardening.

## Final review closure

When the flow reaches final review, `qa-engineer` should close with the standardized output contract and must offer exactly these continuation options:

- `caso de uso`
- `escenario de prueba`
- `caso de prueba`
- `proceso completo`

This closure is mandatory even when the review concludes that the current artifact is insufficient and needs regeneration or refinement by a specialized skill.

## Deprecated compatibility aliases

- `qa-doc-orchestrator` is a compatibility alias for `qa-suite-orchestrator`.
- `qa-derivation-engine` remains a compatibility bridge that routes old derivation requests to the modular generators.
