# qa-skills-suite common contract

This document is the shared contract for every skill in `qa-skills-suite`.

## Purpose

Keep one reusable contract for inputs, outputs, handoffs, evidence, confidence, phase state, blockers, resume behavior and the shared operational envelope used by `governed-suite` runs.

## Shared artifact templates

- `qa/skills/references/artifact-templates.md` defines the canonical textual templates for `caso de uso`, `escenario de prueba` and `caso de prueba`.
- Specialized generators should use those templates as the final Markdown output shape written for the artifact, not as a preview or optional presentation layer.
- `artifact-templates.md` is the normative source for final artifact rendering in this suite.
- Final artifacts must follow the predefined template structure exactly: keep every canonical section, preserve order and labels, and do not omit, rename or invent sections.
- This reference is additive: it standardizes structure without changing phase ownership, review ownership or the existing common contract fields.

## Governance model

- `standalone`: one skill can complete the requested artifact without suite coordination.
- `governed-suite`: `qa-engineer` owns `qa_frame`, approves phase intent, requests suite work through `qa-suite-orchestrator` and performs final review.
- `qa-suite-orchestrator` is the only operational authority for a `governed-suite` run. It coordinates sequencing, minimal-context handoffs, checkpoint collection and resume routing.
- specialized skills own artifact or evidence production for their assigned phase; they do not redefine `qa_frame`, they do not route other specialized skills directly inside `governed-suite`, and they do not self-approve final closure.
- when specialized generators exist for `caso de uso`, `escenario de prueba` or `caso de prueba`, those generators remain the primary producers and `qa-engineer` remains the review and validation layer.

## Common operational envelope

Every `governed-suite` request and response must use a shared operational envelope. The envelope carries the durable operational state; the inner artifact content stays owned by the current skill.

### Envelope sections

- `operation`: routing and execution metadata for the current governed step.
- `qa_frame`: authoritative framing from `qa-engineer`.
- `package`: current objective, in-scope artifacts, assumptions, evidence context and requested phase closure.
- `result`: phase output, evidence, blockers, confidence and resume state.

### Reserved operation metadata

The following keys are reserved now and must be preserved verbatim even when some values are still `pending`:

- `run_id`
- `operation_id`
- `phase_attempt`
- `artifact_fingerprint`
- `sequence_id`
- `parallel_group`
- `merge_policy`
- `idempotency_scope`

Use them as follows:

- `run_id`: stable identifier for the whole governed suite run.
- `operation_id`: identifier for the current delegated operation.
- `phase_attempt`: monotonic attempt counter for the same phase intent.
- `artifact_fingerprint`: stable content or artifact-set fingerprint when available.
- `sequence_id`: ordered position within the governed run.
- `parallel_group`: shared label when parallel work is intentionally coordinated.
- `merge_policy`: rule for consolidating parallel or retried outputs.
- `idempotency_scope`: scope boundary for future retry and dedup behavior.

### Envelope minimum shape

```text
operation:
  mode: standalone | governed-suite
  authority: qa-suite-orchestrator | self
  run_id: <reserved>
  operation_id: <reserved>
  phase_attempt: <reserved>
  sequence_id: <reserved>
  parallel_group: <reserved or N/A>
  merge_policy: <reserved or N/A>
  artifact_fingerprint: <reserved or pending>
  idempotency_scope: <reserved or pending>
  from_skill: <skill>
  to_skill: <skill>
  requested_closure: <phase target>

qa_frame:
  objective: <required>
  mode: standalone | governed-suite
  phase: <required>
  artifact_targets: <required>
  scope: <required>
  risk_focus: <required>
  evidence_expectation: <required>
  review_owner: qa-engineer

package:
  available_artifacts: <required>
  constraints: <required>
  evidence_context: <required>
  assumptions_active: <required>
  open_questions: <required>

result:
  artifact_delta: <required>
  handoff_recommendation: <required>
  phase_status: in_progress | phase_closed | blocked | awaiting_input
  evidence_log: <required>
  confidence: <required>
  blockers: <required>
  resume_state: <required>
```

In `standalone`, the same shape is recommended when practical, but only `governed-suite` makes it mandatory.

## qa_frame contract

`qa_frame` is the governing package set by `qa-engineer` before delegated suite work starts.

At minimum, `qa_frame` should state:

- `objective`: requested QA outcome.
- `mode`: `standalone` or `governed-suite`.
- `phase`: current phase and intended closure target.
- `artifact_targets`: artifacts expected from the current run.
- `scope`: system, route, feature, journey or constraint boundary in scope.
- `risk_focus`: risk, uncertainty or failure areas that deserve priority.
- `evidence_expectation`: minimum evidence needed for review.
- `review_owner`: normally `qa-engineer`.

In `governed-suite`, `qa_frame` remains authoritative until `qa-engineer` updates it.

## Minimum inputs

Each skill should expect, at minimum, a compact package with:

- `operation`: authority, routing and reserved metadata for the current run.
- `objective`: what must be clarified, modeled, generated or consolidated.
- `phase`: current phase and intended closure target.
- `available_artifacts`: reusable inputs already produced by the suite.
- `constraints`: environment, access, scope, risk or timing limits.
- `evidence_context`: known evidence, missing evidence and confidence notes.

## Mandatory entry interface

Before any supported execution that enters `qa-skills-suite`, the receiving entry skill must collect and validate this mandatory 3-step interface, in this exact order and without skipping ahead:

- `Paso 1 - Tipo de salida QA` with normalized options `proceso completo`, `caso de uso`, `escenario de prueba`, `caso de prueba`, `exploracion QA`, `documentacion PRD`.
- `Paso 2 - Fuente objetivo` with normalized options `desde cero`, `URL publica`, `URL autenticada`, `baseline existente`, `codigo/artefactos`.
- `Paso 3 - Cual es el limite de alcance` and the prompt must show an example like `solo landing`.

Fail closed rules:

- The skill must ask exactly one question at a time and wait for the user's response before asking the next step.
- The skill must not proceed, must not infer a default, and must not generate artifacts until all 3 steps are answered validly.
- If only one field is missing or invalid, the skill should ask only for that missing or invalid field instead of restating the full interface.
- If a selection is ambiguous, out of range or mixes multiple values for the same field, the skill should ask only for the field that needs correction and wait on that same step.
- Until all 3 fields are valid, the skill should remain in input collection state and return no execution handoff, no artifact generation and no mixed-mode output.
- While collecting input, the skill must not bundle pending later questions together; it should unlock `Paso 2` only after `Paso 1` is valid, and unlock `Paso 3` only after `Paso 2` is valid.

If one field is missing, the skill should infer what is safe, declare the gap and keep `phase-close-first` unless the gap materially blocks the current phase. This inference rule does not override the mandatory 3-step entry interface, which must be answered explicitly and sequentially before suite execution starts.

In `governed-suite`, delegated skills should also receive the active `qa_frame` or a compact reference to it.

If `operation.authority` is not `qa-suite-orchestrator` inside `governed-suite`, the receiving skill should treat that as an operational contract violation and return it as a blocker instead of continuing with an implicit bypass.

## Expected outputs

Each skill should return a compact result with these sections:

- `operation`: preserved metadata plus the current `from_skill`, `to_skill` and requested closure.
- `artifact_delta`: what was created, updated or confirmed in this phase.
- `handoff_recommendation`: next skill, why it is next and what package it receives.
- `phase_status`: `in_progress`, `phase_closed`, `blocked` or `awaiting_input`.
- `evidence_log`: evidence consumed or produced, with source and confidence.
- `confidence`: overall confidence plus the main reasons behind it.
- `blockers`: only blockers that materially stop the current skill.
- `resume_state`: enough state to continue without rediscovery.

Before starting execution after the 3-step interface is valid, the entry skill or orchestrator should echo a normalized execution summary that confirms, at minimum:

- selected QA output type;
- selected target source;
- selected scope limit;
- normalized mode or route to be executed;
- confirmation that final output will be Markdown `.md` artifacts only.

When a specialized generator is producing a final `caso de uso`, `escenario de prueba` or `caso de prueba`, `artifact_delta` should include that artifact rendered as the final Markdown artifact with the canonical textual template from `qa/skills/references/artifact-templates.md`, not only a summary about it.

Preview mode is not allowed for final artifacts: do not emit sampled entries, partial batches or teaser sections in place of the final Markdown deliverable.

Mixed-mode outputs are not allowed for final delivery: do not combine previews, alternate tabular summaries, JSON-only payloads, informal lists or other substitute formats alongside or instead of the required Markdown artifact files.

Artifact cardinality must remain exact: if the current phase confirms or derives `N` artifact items, the generated Markdown artifact must contain exactly `N` canonical entries of that same artifact type.

Final artifact rendering must preserve the full canonical structure exactly: required sections stay present in the defined order, missing values use `pendiente` or `N/A`, and no extra replacement sections or invented headings may be introduced.

The final response that closes an artifact-producing run must clearly list every `.md` artifact created, using the normalized artifact names or file paths, so the user can see exactly what was produced.

For final review style responses, the suite should also preserve a standardized closure shape:

- `review_verdict`: what was validated, confirmed or still needs attention.
- `recommended_next_step`: the most useful next move given the current phase.
- `closing_options`: normalized menu of allowed continuation targets when the reviewing skill owns final closure.

`closing_options` is mandatory for final `qa-engineer` evaluations and must offer exactly these values, with no additions or substitutions:

- `caso de uso`
- `escenario de prueba`
- `caso de prueba`
- `proceso completo`

## Handoff package

Every handoff between skills should carry:

- `operation`
- `from_skill`
- `to_skill`
- `phase`
- `objective`
- `artifacts_in_scope`
- `assumptions_active`
- `open_questions`
- `evidence_log`
- `requested_closure`

Handoffs should pass references and summaries, not duplicated long-form content.

In `governed-suite`, handoffs should preserve `qa_frame` terminology exactly and avoid reinterpreting scope, risk or review ownership.
In `governed-suite`, only `qa-suite-orchestrator` may emit the next operational handoff to another specialized skill.

## Standalone versus governed-suite rules

Use `standalone` when one skill can complete the requested output with no meaningful coordination, no cross-phase artifact chain and no separate review governor.

Use `governed-suite` when any of these are true:

- the request spans multiple artifact-producing skills or phases;
- `qa-engineer` must set or preserve a shared `qa_frame`;
- evidence from one skill must be reviewed before another skill proceeds;
- final closure depends on a distinct review step after delegated production.

When `governed-suite` is active, direct specialized-skill-to-specialized-skill routing is forbidden, even if the logical next artifact is obvious.

If uncertain, prefer `governed-suite` for multi-phase work and `standalone` for narrow single-artifact work.

## Evidence metadata

Every evidence item should track, when available:

- `source_type`: `documental`, `mcp`, `playwright-mcp`, `chrome-devtools-mcp`, `navigation-public`, `navigation-authenticated` or `inferred`.
- `source_ref`: link, tool, artifact name, page, route or note that makes the evidence traceable.
- `observation`: short factual statement.
- `environment`: public, staging, local, prod-like, authenticated, etc.
- `timestamp`: collection time if relevant.
- `confidence`: `high`, `medium` or `low`.
- `confidence_reason`: why that level was assigned.

## Confidence rules

- `high`: directly observed or confirmed by authoritative source.
- `medium`: strongly supported but still partial, indirect or environment-specific.
- `low`: inferred, provisional or blocked by missing confirmation.

Never present inferred behavior as confirmed behavior.

## Phase state rules

- `in_progress`: useful work exists but the phase is not yet reviewable.
- `phase_closed`: the phase is reviewable and the suite can move on.
- `blocked`: current phase cannot safely close with available information.
- `awaiting_input`: current phase is already closed; the next phase needs external input.

`phase-close-first` means a skill should prefer `phase_closed` plus a precise next request over prematurely returning `blocked`.

## Blockers

Blockers must include:

- `blocking_item`
- `impact`
- `phase_affected`
- `minimum_input_needed`
- `can_continue_partially`: yes or no

If partial continuation is possible, the skill should close everything else first.

## Operational failure taxonomy

Use these base categories for operational blockers, retries and auditability:

- `authority_violation`: a governed action was attempted without `qa-suite-orchestrator` as operational authority.
- `bypass_attempt`: a specialized skill tried to hand off directly to another specialized skill or tried to close outside governed review.
- `envelope_missing`: the required operational envelope or reserved metadata is missing.
- `envelope_invalid`: the envelope exists but contains conflicting or malformed operational fields.
- `phase_contract_mismatch`: the requested closure does not match the current governed phase intent.
- `artifact_contract_mismatch`: the produced artifact does not match the canonical template or required artifact target.
- `evidence_insufficient`: evidence is too weak to close the assigned phase safely.
- `input_missing_material`: a material input is missing and partial closure is no longer possible.
- `resume_state_incomplete`: the skill cannot hand off or stop safely because resume data is insufficient.
- `merge_conflict`: concurrent or retried outputs cannot be reconciled under the active `merge_policy`.

These categories are intentionally small for the MVP. Skills may add local detail, but they should map the blocker to one of these categories first.

## Resume protocol

Each skill should leave a resume package with:

- `last_closed_phase`
- `artifacts_ready`
- `artifacts_pending`
- `open_questions`
- `active_assumptions`
- `required_next_input`
- `recommended_next_skill`

## Handoff and return rules

- `handoff`: a forward transfer from `qa-engineer` or `qa-suite-orchestrator` to the next producing skill with the active `qa_frame` and requested closure.
- `return-to-review`: the mandatory path back to `qa-engineer` after delegated work closes its assigned phase or reaches a material blocker.
- specialized skills in `governed-suite` should return through `qa-suite-orchestrator`; they must not route directly to another specialized skill, and they must not self-close the governed run.
- `qa-suite-orchestrator` may then choose another governed handoff or `return-to-review`.
- no producing skill should silently continue into a new governed phase without an explicit handoff.
- keep `phase-close-first`: close the assigned phase, record assumptions and evidence, then request the next handoff.
- final `qa-engineer` closure should validate or challenge the produced artifact, not replace the specialized generator as the primary author of `caso de uso`, `escenario de prueba` or `caso de prueba` outputs.

## Backward compatibility policy

- treat this contract as additive: existing skill outputs remain valid if they can map cleanly to the shared fields here.
- older flows that reference `qa-doc-orchestrator` should map to `qa-suite-orchestrator`.
- older requests without explicit `qa_frame` may infer one from `objective`, `phase`, `constraints` and existing artifacts, but the inferred frame should be declared.
- `standalone` remains valid for legacy single-skill execution; governed behavior should only add routing and review structure, not remove prior artifact expectations.

## Shared operating rule

All skills in `qa-skills-suite` follow `phase-close-first`: close the current phase with explicit assumptions, evidence and risk before asking for credentials, private access or more data for the next phase.
