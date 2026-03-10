# Evidence and confidence reference

Use this reference with `qa/skills/references/common-contract.md`.

## Evidence sources

- `documental`: tickets, specs, notes, docs and existing artifacts.
- `mcp`: structured runtime, diagnostics, app metadata or tool context.
- `playwright-mcp`: browser automation evidence captured through Playwright MCP.
- `chrome-devtools-mcp`: Chrome-specific DOM, console, network, Lighthouse or performance evidence.
- `navigation-public`: direct observation without authentication.
- `navigation-authenticated`: direct observation with controlled access.
- `inferred`: reasoned conclusion not yet confirmed.

## Confidence heuristics

- Prefer `high` when the observation is direct and reproducible.
- Prefer `medium` when the observation is partial, environment-bound or indirect.
- Prefer `low` when the point depends on inference, missing access or conflicting sources.

## Minimal evidence log shape

```text
- source_type:
- source_ref:
- observation:
- environment:
- confidence:
- confidence_reason:
```

## Traceability rules

- Link evidence to the smallest relevant artifact: discovery item, functional rule, use case, scenario or test case.
- Keep facts separate from interpretation.
- When evidence is missing, record the gap as a pending item, not as silent omission.
- If authenticated evidence is not yet available, close the public or documentary phase first.
