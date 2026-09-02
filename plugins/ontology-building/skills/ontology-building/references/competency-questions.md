# Competency questions

Competency questions (CQs) are the concrete, natural-language questions the finished ontology must be able to answer. They're the single most-agreed-on practice across every source consulted for this skill — used both to scope the build (before modeling) and to validate it (after modeling).

## Why CQs, not up-front enumeration of concepts

Starting from "what questions does someone actually need answered" produces a tighter, more defensible scope than starting from "what concepts exist in this domain," because the latter has no natural stopping point — everything is related to everything eventually. CQs give you a principled boundary: if no plausible competency question needs it, it's out of scope (for now).

## Authoring discipline

- **Phrase every CQ in the words of the person who would actually ask it.** Not "What is the cardinality of the hasEmployer relation?" but "Who does this person currently work for?" Construct/class names belong in an appended trace back to the model, never in the question's primary text.
- **The recognition test:** someone who has never read the ontology should recognize the CQ as their own question. If a CQ only makes sense to someone who already knows the model, it's not really scoping anything — it's just restating the schema.
- CQs don't need to be exhaustive up front; they're a sketch list, refined iteratively as the model develops and new gaps surface.

## Entry points and group elicitation

CQ-first is the default entry point, not the only one. Exploration can equally begin from an entity sketch ("lite schema"), from walking a domain object's real-world attributes and application needs, from tracing the world model's interactions and relationships, or from mining an existing schema (`schema-informed-discovery.md`) — see `SKILL.md`'s Operating modes. The invariant holds regardless of entry point: exploration is free, commitment is gated — nothing is promoted into the model until a competency question or a binding schema requirement needs it.

For group elicitation, two recognized workshop disciplines feed CQs well: **EventStorming** (Brandolini) — the group maps the domain's events chronologically on a shared surface, surfacing entities, actions, policies, and hot spots as a side effect — and **Domain Storytelling** — stakeholders narrate concrete work episodes that are transcribed live as actor-activity-object sentences. Both produce outputs (domain events, actor-activity narratives) that convert almost mechanically into candidate CQs, entity sketches, and action-candidates, and both keep the vocabulary in the stakeholders' own words — the same recognition test above, applied at elicitation time.

## Grade every CQ's status — don't leave it binary

For each competency question, record one of:

- **Answerable now** — the current model, populated with real or representative data, actually returns the right answer.
- **Deferred** — not answerable yet, but tied to a named future build item or a specific pending decision that will resolve it. A deferral without a named resolution path is really a gap wearing a nicer label.
- **Gap** — not answerable, and no plan yet to make it so. Track it as a gap explicitly rather than letting it go unnoticed.

This turns "is the ontology complete" from a vague impression into an auditable, gradeable status list.

See `templates.md` for a ready-to-copy competency-question entry template (ID, question text, construct trace, status, executable check).

## Use CQs as executable tests, not prose

Where possible, express CQs as runnable queries against real or representative test data — not only as a written catalogue. A large, well-organized CQ list whose "answerable" status is *asserted* rather than *verified* looks like rigor while providing none; the only way to know a CQ is actually answerable is to run it and check the output, the same way you'd run a test rather than read the test's docstring and assume it passes.

## Scoping with CQs

Record three buckets explicitly, not just a single "in scope" list:

- **In scope** — concepts/relations a current CQ needs.
- **Out of scope** — concepts explicitly considered and excluded, with the reason, so they aren't accidentally re-litigated later.
- **Deferred** — concepts that will be needed eventually (tied to a specific future CQ or known use case) but aren't being built now.

## Schema/system requirements — a peer source of complexity, not just evidence

Known schema or system requirements — a materialization target, an existing consumer's shape, an integration commitment — are not only bottom-up evidence for discovering candidate structure (see `schema-informed-discovery.md`). They are also a second, independent source of requirement the ontology must satisfy, standing *alongside* competency questions rather than subordinate to them. A competency question asks "what must be answerable"; a schema requirement asks "what must this model remain compatible with, or be materializable into." Both bound the solution space and both contribute real complexity — treat them as two parallel catalogues feeding the same Requirements/ORSD artifact (`process-and-governance.md`), not as one being mere discovery fodder for the other.

Grade schema requirements with the same rigor as CQs: satisfiable-now / deferred (tied to a named future build or decision) / gap (acknowledged, unresolved).

When a competency question and a schema requirement pull in different directions — a CQ implies a distinction the existing materialization target can't represent without a breaking change, or a required integration shape would force collapsing a distinction the domain actually needs — don't silently resolve it by favoring one side. Surface it as an open issue and solve for it explicitly: often the right answer isn't to compromise the conceptual model but to introduce an explicit mapping between a conceptually clean model and a materialized/exposed shape that satisfies the schema requirement. See `schema-informed-discovery.md`.

## Relationship to the rest of the process

- CQs drive step 4 of the core process (class/relation definition) — every class or relation should trace back to at least one CQ that needs it (principle 2, minimal commitment).
- CQs are the acceptance suite for step 5 (populate with instances) and step 6 (evaluate).
- A CQ that can't be phrased against the current model's constructs is exactly the one permitted "back-edge" in the governance flow (see `process-and-governance.md`): it goes back upstream as a new open question, it doesn't get silently patched into the existing schema.
