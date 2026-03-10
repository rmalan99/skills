# qa-skills-suite

Mapa visual y referencia corta de la suite local `qa-skills-suite`: orquestacion QA, discovery, modelado funcional, derivacion de artefactos, trazabilidad y evidencia.

```text
[AI assistant / invoker]
          |
          v
[qa/skills/SKILL.md]
canonical entry point
          |
          v
[qa-engineer]
framing / review intent
          |
          v
[qa-suite-orchestrator]
only operational authority in governed-suite
routes phases, checkpoints and all governed returns
          |
          +--------> [qa-discovery-engine] ----------------------+
          |                                                     |
          |                support evidence when needed         |
          |        +------ [qa-playwright-explorer] --------+   |
          |        |                                        |   |
          |        +------ [qa-chrome-devtools-explorer] ---+   |
          |                                                     |
          +--------> [qa-functional-model-builder] ------------+
          |                                                     |
          +--------> [qa-use-case-generator] ------------------+
          |                                                     |
          +--------> [qa-test-scenario-generator] -------------+---> [qa-suite-orchestrator]
          |                                                     |
          +--------> [qa-test-case-generator] -----------------+
          |                                                     |
          +--------> [qa-traceability-manager] ----------------+
          |
          v
[qa-engineer]
return-to-review / governed close
```

## Entry point

- `qa/skills/SKILL.md`: skill contenedora y punto de entrada canonico para asistentes IA.
- `qa-suite-orchestrator`: coordina modos, checkpoints, handoffs y continuidad entre fases.
- `qa-engineer`: skill reusable de rol QA para framing, riesgo, cobertura, evidencia, validacion y cierre final de la evaluacion gobernada.
- En `governed-suite`, `qa-suite-orchestrator` es la unica autoridad operativa y aplica el envelope comun anti-bypass.

## Instalacion

- Flujo unico recomendado: ejecutar `scripts/install-qa-skill.sh`; instala la suite en OpenCode y Codex por defecto.
- Targets nativos detectados por el instalador: `~/.config/opencode/skills` para OpenCode y `~/.codex/skills` para Codex.
- La instalacion es idempotente sobre `qa-skills-suite`: reemplaza solo el arbol administrado por el script, preserva skills no gestionadas y crea aliases/compatibilidad cuando no chocan con nombres existentes.
- Flags soportados: `--opencode`, `--codex`, `--dry-run`, `--help`.

```bash
./scripts/install-qa-skill.sh
./scripts/install-qa-skill.sh --opencode
./scripts/install-qa-skill.sh --codex --dry-run
```

## Instalacion con curl

- El script tambien funciona fuera del repo: si no encuentra `skills/qa-skills-suite` en local, descarga el tarball oficial y extrae solo la suite antes de instalar.
- Uso curl-friendly:

```bash
curl -fsSL https://raw.githubusercontent.com/rmalan99/skills/main/scripts/install-qa-skill.sh | bash
curl -fsSL https://raw.githubusercontent.com/rmalan99/skills/main/scripts/install-qa-skill.sh | bash -s -- --opencode
curl -fsSL https://raw.githubusercontent.com/rmalan99/skills/main/scripts/install-qa-skill.sh | bash -s -- --codex
```

- Overrides utiles:
  - `OPENCODE_HOME` para cambiar la raiz de OpenCode.
  - `CODEX_HOME` para cambiar la raiz de Codex.
  - `QA_SKILLS_SUITE_TARBALL_URL` para apuntar a otro tarball compatible.

## Descarga rapida con curl

- Si solo queres bajar la suite para copiarla a otro workspace, descarga el repo como tarball y extrae `skills/qa-skills-suite`.

```bash
curl -L https://github.com/rmalan99/skills/archive/refs/heads/main.tar.gz -o qa-skills-suite.tar.gz
tar -xzf qa-skills-suite.tar.gz skills-main/skills/qa-skills-suite
cp -R skills-main/skills/qa-skills-suite ./skills/
```

## Flow at a glance

- Modos soportados: `from-zero`, `public-url`, `auth-url`, `baseline-to-artifacts`, `code-enriched`.
- Seleccion de explorador: `qa-playwright-explorer` como ruta preferida, `qa-chrome-devtools-explorer` como fallback.
- Cadena de derivacion gobernada: `discovery -> functional model -> use cases -> test scenarios -> test cases -> traceability -> return-to-review`.
- Routing por artefacto: `qa-use-case-generator` produce `caso de uso`, `qa-test-scenario-generator` produce `escenario de prueba` y `qa-test-case-generator` produce `caso de prueba`.
- Salida por defecto: si el usuario no pide un set especifico, la suite entrega siempre los tres artefactos en secuencia `caso de uso -> escenario de prueba -> caso de prueba`.
- Regla de ownership: las skills especializadas generan el artefacto final con templates canonicos; `qa-engineer` revisa, valida y cierra.
- Regla de cierre: `phase-close-first`; solo se pide informacion extra despues del cierre de fase.
- Regla anti-bypass: ninguna skill especializada abre handoff directo a otra skill especializada ni cierra el run fuera de `qa-engineer`.
- Cierre final normalizado: toda evaluacion final de `qa-engineer` debe ofrecer exactamente `caso de uso`, `escenario de prueba`, `caso de prueba` o `proceso completo`.
- Salida normal: toda skill especializada devuelve su resultado al `qa-suite-orchestrator`; el retorno final a `qa-engineer` ocurre solo via `return-to-review` para cierre gobernado.

## Shared references

- `qa/skills/references/common-contract.md`: contrato comun para entradas, salidas, handoffs, evidence, confidence, envelope operativo, taxonomia de fallas, bloqueos y reanudacion.
- `qa/skills/references/phase-flow.md`: flujo canonico y reparto de responsabilidades.
- `qa/skills/references/evidence-confidence.md`: catalogo de evidencia y niveles de confianza.
- `qa/skills/references/mcp-exploration-selection.md`: criterio de seleccion entre Playwright MCP y Chrome DevTools MCP.
- `qa/skills/references/artifact-templates.md`: templates textuales canonicos para `caso de uso`, `escenario de prueba` y `caso de prueba`.

## Compatibility

- `qa-doc-orchestrator` queda como alias deprecated de `qa-suite-orchestrator`.
- `qa-derivation-engine` queda como bridge deprecated para enrutar derivacion historica al modelo modular.
- `qa/skills/playwright-mcp-guide.md` queda como puntero corto a las referencias compartidas.

## Standalone skill

- `qa/skills/qa-engineer/SKILL.md`: skill base para operar como QA engineer en este workspace con metodologia operativa y referencia QA embebida.
- Puede usarse sola para framing y evaluacion QA, o como capa de entrada antes de delegar en `qa-suite-orchestrator` y las skills modulares.
- Cuando el flujo termina en artefactos finales, su rol canonico es revisar el resultado especializado, comprobar consistencia con los templates y emitir el cierre final normalizado.

## ASCII governed flow

```text
[qa-engineer] -------- framing / review intent --------> [qa-suite-orchestrator]

[qa-suite-orchestrator] -------- route discovery --------> [qa-discovery-engine]
[qa-suite-orchestrator] ---- route functional model ----> [qa-functional-model-builder]
[qa-suite-orchestrator] -------- route use cases --------> [qa-use-case-generator]
[qa-suite-orchestrator] ------ route scenarios ---------> [qa-test-scenario-generator]
[qa-suite-orchestrator] ------- route test cases --------> [qa-test-case-generator]
[qa-suite-orchestrator] ------ route traceability ------> [qa-traceability-manager]

[qa-discovery-engine] -------- envelope result ---------> [qa-suite-orchestrator]
[qa-functional-model-builder] - envelope result --------> [qa-suite-orchestrator]
[qa-use-case-generator] ------- envelope result --------> [qa-suite-orchestrator]
[qa-test-scenario-generator] -- envelope result --------> [qa-suite-orchestrator]
[qa-test-case-generator] ------ envelope result --------> [qa-suite-orchestrator]
[qa-traceability-manager] ----- envelope result --------> [qa-suite-orchestrator]

[qa-suite-orchestrator] -------- return-to-review -------> [qa-engineer]
[qa-engineer] -------- phase-close-first / continue -----> [qa-suite-orchestrator]
```
