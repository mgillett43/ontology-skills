# Agent-actionability extension

This is an **extension**, not part of the base methodology. Invoke it only once an ontology's purpose explicitly includes being read from and acted on by AI agents (not just queried by humans or downstream applications). It's based on Palantir's Foundry/AIP ontology model — the most mature public treatment of ontologies designed for exactly this.

If you've been following the core process, every place this extension needs to attach was already tagged as an **action-candidate** in step 4 (see `SKILL.md`). This document is about what to do with those tags.

## The core abstraction

Split the ontology into two layers, kept explicitly distinct:

- **Semantic layer** — objects, properties, links: what exists and how it relates. This is the base methodology's output; nothing here changes for this extension.
- **Kinetic layer** — actions, functions: what can change the semantic layer, and how. This is what the extension adds.

An **action** is a governed, schema-validated, permissioned, audited unit of change — parameters, validation logic, and side effects bundled together. A **function** is read-only logic (queries, derivations) that can be invoked by an action or by an application/agent directly.

## Why the split matters for agents specifically

**Agents and humans should share one interface, not two.** Don't build a looser, agent-only data plane. An agent should only ever touch the semantic and kinetic layers through the same exposed objects, actions, and functions a human-facing application would use — never raw underlying tables, and never a way to bypass an action's validation.

**Actions are the only legitimate write path — for agents exactly as for humans.** This is what makes agent write-back safe: the action is the trust boundary, not the agent. An agent cannot make an arbitrary write; it can only invoke a pre-approved, schema-checked class of write, with the same validation and audit trail a human-initiated change would get.

## Aggregates and consistency boundaries

Before converting an action-candidate into a governed Action, name its **aggregate** — the cluster of objects that must change together, atomically, to preserve an invariant (Vernon's DDD aggregate pattern). An action's validation logic operates within this boundary; objects outside it should be referenced by identity, not assumed to change consistently within the same transaction. This is orthogonal to the class hierarchy in `hierarchy-and-structure.md` — a well-formed is-a hierarchy says nothing about which objects must be updated together, and skipping this step is a common source of actions that look coherent on paper but leave the ontology inconsistent mid-execution.

## Converting an action-candidate into a governed action

For each tag left by core process step 4:

1. **Scope it as a coherent operation, not a field mutation.** An action should read as something a domain expert would recognize as one meaningful unit of change ("ApproveRefund"), not "SetStatusField." Many narrow, single-property-mutating actions ("Action Sprawl" — see `evaluation-and-anti-patterns.md`) is directly dangerous once agent-consumable: every sprawling micro-action becomes a separate, easy-to-misuse tool.
2. **Attach validation criteria and parameters explicitly** — what has to be true before this action can run, and what inputs it needs. This is what a downstream reasoner/agent framework will actually enforce.
3. **Decide the autonomy posture for this specific action, not for the ontology as a whole.** Graduated autonomy is a governance dial, not a one-time permission: an action can require human review of every proposed invocation (staged as a scenario), or — once enough of a track record exists for that specific action/agent pairing — be permitted to execute without review. Set this per action, and revisit it as confidence in that pairing changes.
4. **Capture decision lineage automatically.** Every action execution should record what data version, what logic, and what application or agent produced the change — for audit, and as the feedback loop for evaluating and improving agent behavior over time.
5. **Assign an owner and a lifecycle status** (e.g., experimental / active / deprecated) to the action, the same as you would to an object type — this is what prevents action sprawl and "god object"-style accretion as the ontology and its agent surface grow.

## What not to do

- Don't expose the whole ontology schema for an agent to freely scan and write against — agents interact only through the specific objects, functions, and actions deliberately exposed to them.
- Don't skip validation/permissioning "just for the agent path" for expedience — that reopens exactly the write-safety problem the action abstraction exists to close.
- Don't treat this extension as a reason to model everything as a decision/action up front (see `SKILL.md`'s hook rationale) — the base methodology's minimal-commitment principle still applies; only convert what's genuinely an action-candidate with a real motivating use case.
- **Don't let an unenforced (advisory-only) rule look structurally identical to an enforced one** — that creates false confidence that a constraint is being checked when it isn't. When deferring enforcement of a rule, name the specific future trigger that would force building the real control, not just the reason for deferring it.

## The read side: retrieval design for agent consumption

Everything above concerns the *write* path (Actions). Agents also need a well-designed *read* path — how they retrieve relevant parts of the ontology, especially once it's too large to fit in a single context window. This is vendor-neutral guidance (from current GraphRAG/property-graph practice), distinct from the Palantir-specific material above:

- **Route deterministic queries to structured retrieval, not similarity search.** Counts, aggregates, and exact lookups should go through typed queries against the graph/schema; reserve vector/embedding similarity for genuinely fuzzy matching. Vector-only retrieval over structured facts can silently return plausible-looking wrong answers.
- **Design for dynamic schema-subsetting, not a fully in-context schema.** An agent usually can't hold the full ontology in context; retrieval needs to fetch the relevant schema subset and relevant instances per query, not assume the whole model is visible at once.
- **Bias toward small, need-justified schemas for retrieval-heavy use, growing incrementally** — an extension of core principle 2 (minimal commitment) for agent/RAG contexts specifically: add a relation or type only if some required retrieval or reasoning path genuinely can't happen without it.
- **Treat retrieval quality as its own evaluation axis** (not covered by the method families in `evaluation-and-anti-patterns.md` by default) — a schema can be conceptually correct and still retrieve poorly if its granularity doesn't match how agents actually query it.
- **A subsetting or lens mechanism must bind reasoning and display together.** If something is hidden from what a viewer (human or agent) sees, it must not still silently feed a computation that viewer can't see the inputs to — otherwise explainability breaks: the visible output can't be justified from the visible inputs.

For fully emergent, LLM-clustered schema construction (e.g., GraphRAG-style, as an alternative to the design-first approach above), see `llm-assisted-construction.md` and `conflicts-and-precedence.md` — that approach is scoped narrowly and is not a substitute for the design discipline in this skill once the ontology needs to be reused, governed, or written back to.
