# MCP exploration selection

This reference explains how `qa-skills-suite` chooses between Playwright MCP and Chrome DevTools MCP.

## Shared rule

Use the cheapest reliable source first:

1. existing artifacts and docs
2. MCP context or diagnostics
3. public exploration
4. authenticated exploration

Always keep `phase-close-first`.

## Use Playwright MCP when

- the goal is end-to-end exploration of user flows;
- the flow spans multiple pages, forms, uploads, downloads or auth steps;
- you need stable automation-style steps or reusable reproduction paths;
- browser choice flexibility matters more than Chrome-only diagnostics.

## Use Chrome DevTools MCP when

- the goal is Chrome-specific runtime inspection;
- you need console, network, Lighthouse, performance or memory evidence;
- you need DOM snapshots and direct browser debugging details;
- the issue is likely frontend/runtime specific rather than flow modeling only.

## Selection policy

- If only one MCP is available, use that one and record the constraint.
- If both are available, prefer Playwright MCP for flow exploration and Chrome DevTools MCP for deep frontend diagnostics.
- If both are needed, use Playwright MCP first to confirm the flow, then Chrome DevTools MCP to inspect runtime evidence.
- If neither MCP is available, continue with docs, existing artifacts and manual/public evidence, then document the limitation.

## Public versus authenticated exploration

- Public exploration can happen during discovery if it helps close the current phase.
- Authenticated exploration should only start after the current phase is already closed and the missing evidence is clearly identified.

## Output expectation

Any explorer skill should report:

- MCP used and why;
- scope explored;
- evidence captured;
- confidence level;
- whether the current phase closed or which exact input is still required.
