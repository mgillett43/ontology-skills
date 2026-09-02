# LLM-assisted construction

An additional discovery channel, alongside pure top-down competency-question elicitation and `schema-informed-discovery.md`'s existing-schema mining: using an LLM to help generate candidate structure (from unstructured text, existing documentation, code, or conversational elicitation with a stakeholder), or to mediate competency-question elicitation itself. This channel carries documented risks the other two don't, and needs its own guardrails.

## The LLM-candidate tag: gate everything, more strictly than schema evidence

Treat all LLM-proposed structure as a candidate hypothesis — never a direct edit — routed through the same adequacy checks as any other candidate (decomposition test, is-a litmus test, competency-question mapping; see `hierarchy-and-structure.md` and `process-and-governance.md`). Given the failure modes below, default to a *stricter* review bar than for schema-mined candidates: don't promote an LLM-proposed construct on a single generation pass.

## Documented failure modes

- **Fabrication / hallucinated relations.** Structured-extraction tasks have reported fabrication rates in some fields exceeding 90% — don't assume a plausible-looking relation is a real one without independent verification.
- **Flattening.** LLM-generated hierarchies tend to under-nest relative to real domain structure — flat lists of siblings where a real intermediate category should exist. Check output against the sibling-generality and subclass-count heuristics (`hierarchy-and-structure.md`) specifically, since this is where LLM output most often fails them.
- **Prompt sensitivity.** Minor wording changes to the same generation prompt have been shown to produce materially different structures. Don't trust a single generation pass — regenerate with varied phrasing and diff the results; convergence across variations is a much stronger signal than any single output.
- **Cascading error from early mistakes.** An entity-recognition error early in a pipeline propagates and tends to dominate downstream error more than a modeling mistake made later — invest review effort at the earliest extraction stage, not just at the final schema.
- **Error scales with ontological complexity, not model size.** A bigger or more capable model does not reliably fix this — the failure mode is intrinsic to how much structure is being asked for in one pass, not to model capability. Break large asks into smaller, independently-checkable ones rather than expecting scale to solve it.

## Mitigations

- **LLM-as-checker is safer than LLM-as-generator.** LLMs have shown reasonable accuracy at labeling OntoClean-style meta-properties (rigidity, identity, unity, dependence) on *existing* candidate structure — a narrower, more constrained task than generating structure from scratch. Prefer using an LLM to check/label a human- or schema-derived candidate over using it to originate the candidate unsupervised.
- **Dual validation is the line between toy and production**: a structural/shape check (e.g., SHACL-style constraints) plus a logical consistency check (a reasoner or equivalent), applied to anything LLM-proposed before it's promoted — neither check alone is sufficient.
- **Regenerate and diff before trusting stability**, given documented prompt sensitivity.

## LLM-mediated competency-question elicitation

Unmediated "just ask the LLM domain-expert questions and see what comes back" elicitation is documented to underperform — domain experts prompting LLMs without a structured protocol struggle to produce useful competency questions. Prefer a structured elicitation sequence instead: generate candidate user stories/scenarios with the stakeholder → extract and cluster candidate competency questions from those stories → verbalize each candidate CQ back to the stakeholder for confirmation (the same recognition test already in `competency-questions.md`) before treating it as scoped. The structure is what makes this reliable, not the presence of an LLM by itself.

## GraphRAG and emergent-schema construction — a scoped tool, not a substitute

GraphRAG-style approaches (LLM extracts entities/relations from chunked text, then clusters them into a hierarchy of semantic communities with no predefined schema and no competency-question grounding) build a serviceable structure for one specific job: question-answering over a largely static corpus of narrative text. They are not a substitute for the competency-question-first, gated design discipline in this skill (core principle 1) whenever the resulting model needs to be reused by other consumers, governed over time, or written back to — see `conflicts-and-precedence.md` for the explicit resolution. Scope emergent-schema construction narrowly and deliberately; don't reach for it as a general design method just because it requires less up-front modeling effort.
