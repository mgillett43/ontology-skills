# Schema-informed discovery

An alternate, parallel entry point to the core process (`SKILL.md`), for use when an existing or target schema — a legacy database, an operational system, a materialization target — already exists. This is a genuine extension beyond what any of this skill's source lineages formalize as a general practice: it's grounded in one validated precedent and the classical bottom-up/combination hierarchy-building approach, not in a mature, already-proven methodology. Say so if you're applying it, rather than presenting it as more established than it is.

## When to reach for this

- A legacy system or existing schema already encodes real, validated domain structure — the categories a working system actually uses are strong evidence of real structure, not just an artifact to translate around.
- A migration, where an existing physical model is a primary source of truth about what the domain actually contains.
- A materialization target already exists and its shape carries information (e.g., what fields practitioners actually populate, what source systems actually carry).

Prefer pure top-down, competency-question-first modeling (the core process) when the domain is genuinely greenfield — no existing schema means no evidence to mine, and mining would just mean inventing a schema and then treating your own invention as evidence, which is circular.

## The governing rule: schema is evidence, not authority

This preserves the one-way authority flow already in `process-and-governance.md` (rationale → requirements → formal model, with exactly one back-edge: unresolved gaps go back upstream as a question) rather than breaking it. A schema-mined candidate never becomes part of the model by default — it has to earn its place through the same gates any other candidate does. The difference from pure top-down modeling is only that schema-mining gives you a second, independent source of candidates and a reality check, not a shortcut past the gates.

## Two distinct roles schema information plays

Keep these separate — they're solved differently:

- **As discovery evidence** (the procedure below): existing structure is mined as *candidate hypotheses* for what classes/relations/cardinalities might exist, gated by the same tests as any other candidate, and discarded freely if they fail those tests.
- **As a binding requirement** (see `competency-questions.md`'s peer-requirement section): a materialization target, an existing consumer's shape, or an integration commitment is not optional evidence to weigh — it's something the ontology must remain compatible with, whether or not it matches the conceptually cleanest model. This can't be discarded the way a failed discovery hypothesis can; it has to be solved for.

When a genuine requirement conflicts with what the conceptually correct model would otherwise be, don't distort the conceptual model to fit it. Introduce an explicit, recorded mapping between the canonical model and the required shape (a substrate vs. materialized-read-model split) and let the mapping absorb the mismatch. This keeps the conceptual model correct on its own terms while still satisfying the binding requirement, and makes the accommodation visible and gated rather than an invisible compromise baked into the classes themselves.

## Procedure

1. **Inventory the schema.** Entities/tables, fields/columns, constraints (foreign keys, uniqueness, nullability), and existing naming/vocabulary.
2. **Convert each element into a candidate hypothesis — not a decision:**
   - A table/entity boundary → a candidate class-boundary hypothesis.
   - A foreign key → a candidate relation hypothesis, with a candidate cardinality.
   - A column grouping → a candidate property grouping (possibly a struct).
   - A column's name/vocabulary → candidate practitioner-vocabulary evidence — this can legitimately override an invented term (see the worked precedent below).
   - A constraint (NOT NULL, CHECK, unique) → a candidate signal about cardinality or identity, never a conclusion. See the guardrail below — this is the step most likely to be done wrong.
3. **Elicit competency questions independently first**, before looking closely at the schema's structure, so they aren't unconsciously anchored to whatever the existing system happens to already do.
4. **Reconcile.** Keep a schema-derived hypothesis only if it:
   - survives the decomposition test and the is-a litmus test (`hierarchy-and-structure.md`),
   - maps to at least one real competency question, and
   - isn't merely reproducing a source system's incidental shape rather than domain reality (the Kitchen Sink check, `evaluation-and-anti-patterns.md`).
   Discard or flag anything that fails these — a table boundary that exists only for a legacy system's storage convenience is not evidence of a domain class boundary.
5. **Record the outcome as a normal decision.** Schema evidence is cited as part of the rationale's "why," the same as any other input — never a silent, ungated edit to the conceptual model.
6. **Where schema-mining and independent competency-question elicitation disagree, treat the disagreement itself as signal.** Surface it as an open issue rather than quietly picking one side.

## The guardrail: decouple physical constraint from conceptual commitment

A schema's `NOT NULL`/nullable status is evidence, not proof, of conceptual mandatoriness — in **both** directions:

- A `NOT NULL` column may reflect an old system's storage pragmatics, a migration-era default, or an accident of whoever wrote the DDL — not a real domain requirement.
- A nullable column may hide something genuinely mandatory in the domain — incomplete population, data-quality debt, or an application-layer check that never made it into the DDL.

Treat cardinality/mandatoriness as a conceptual commitment, decided the same way every other conceptual fact is (competency questions + a decision record) — a **promotion gate**, not something inferred backward from a physical constraint. This mirrors `process-and-governance.md`'s two-tier validation discipline, applied to physical storage specifically: keep the base store as a permissive superset and treat mandatory cardinalities as a promotion gate rather than encoding them as `NOT NULL` at the storage layer.

## Worked precedent

An invented category enum was retired in favor of a plain field, specifically because that's what real source systems already carried and what practitioners already called it — genuine schema/practitioner-vocabulary evidence overriding a purely theoretical construct. This still went through the normal decision-record process; it wasn't a silent schema-driven edit. This is the pattern to replicate — not "the schema wins," but "the schema supplied evidence strong enough to win the normal argument."

## Classical grounding: top-down, bottom-up, combination

(Noy & McGuinness's three approaches to building a class hierarchy — referenced only briefly in `hierarchy-and-structure.md`; this is the expanded version.)

- **Top-down** — start from the most general classes, specialize downward from competency questions. Best for genuinely greenfield domains with no existing data to mine.
- **Bottom-up** — start from the most specific classes (often visible directly in existing schema/data), then group them upward into more general categories. Best when a working system with real data already exists — categories that emerge from actual usage are strong evidence of real domain structure.
- **Combination** — run both independently and reconcile (step 4 above). Usually the strongest choice when a legacy or existing system exists but the domain is still evolving.
