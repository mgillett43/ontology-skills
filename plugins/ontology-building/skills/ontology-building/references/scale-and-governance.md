# Scale and governance beyond one team

Everything in `process-and-governance.md` assumes a small, deliberate decision-making group building one ontology. This file covers what changes once more than one team, more than one bounded sub-domain, or continuously-arriving crowd/automated contribution is involved — genuinely different problems, not just "the same process, more people."

## Decide bounded-context boundaries first

Not every domain should be forced into one unified model. Domain-Driven Design's central claim: for large or multi-team domains, "total unification of the domain model for a large system will not be feasible or cost-effective" (Fowler). A term can legitimately mean different things in different parts of the same organization's work — that's not an error to fix, it's a boundary to name.

- **Decide explicitly** (as part of `SKILL.md` step 1, Scope) whether this is one coherent ontology or several bounded contexts, each internally consistent, connected by explicit translation rather than forced into one shared vocabulary.
- If more than one context is in play, **run the full core process once per context** — each gets its own competency questions, its own decision register, its own gate pipeline.
- **Name the relationships between contexts explicitly**, using a context-map artifact. Common relationship types (from DDD): *Shared Kernel* (a small, jointly-owned subset both contexts depend on), *Customer-Supplier* (one context's model constrains the other's, with negotiated priority), *Conformist* (one context simply adopts the other's model as-is, no translation), *Anti-Corruption Layer* (an explicit translation layer isolates one context's model from another's, deliberately not conforming). Naming the relationship type prevents the default failure mode — *Big Ball of Mud* — where the seam between contexts is never decided and just accretes ad hoc translation code.
- The per-context term-resolution glossary (`process-and-governance.md`) still applies within each context; the context map is what governs meaning *across* the seam.

## "Region" vs. bounded context — don't conflate them

Some ontology-development practice (including prior work this skill draws on) uses **"Region"** for named sub-divisions of a *single* ontology that differ in persistence rules, write/governance rules, or maturity — while deliberately keeping **one shared vocabulary and definitional coherence across all regions**. Structurally, this looks like a bounded context (a named, governed subdivision of a larger system), which invites conflating the two. They solve opposite problems:

- **Bounded context** exists to let *vocabulary/meaning* legitimately diverge across a boundary — the same word can mean different things on either side — with explicit translation machinery at the seam where it does (a context map: Shared Kernel, Customer-Supplier, Conformist, Anti-Corruption Layer).
- **Region** exists to let *persistence, write-governance, or maturity* diverge (e.g., a strictly-governed core region vs. a fast-moving staging region) while vocabulary deliberately does **not** diverge — a term means the same thing in every region.

Check which problem you actually have before reaching for either device: do you need different *vocabularies* to coexist (→ bounded context, with a context map), or do you need different *governance/maturity regimes* to coexist under one shared vocabulary (→ regions, as in `process-and-governance.md`'s Region artifact)? They can also compose — a single bounded context can be internally divided into regions — but neither is a synonym, subset, or superset of the other, and using the wrong one won't surface as an error until the assumption it silently encodes (shared vocabulary, or shared governance) turns out to be false.

## Sharing across bounded contexts: type-level is often safe, instance-level often isn't

Sharing a *type* definition across bounded contexts is usually safe — two contexts can agree on the shape of "Person" without agreeing on everything else. Sharing a *particular instance* (a specific node) across contexts is a different and riskier decision, even when both sides would call it "the same" entity: a shared graph node visible across contexts (or tenants) can leak information structurally, through its topology and back-references, regardless of what access controls are layered on top of it. Before sharing a node (not just a type) across a context boundary, check what its neighborhood reveals to each side, not just what property-level permissions say.

## Forward-referencing a not-yet-built context

When work in one bounded context needs to reference an entity that properly belongs to another context that hasn't been built yet, avoid both extremes — blocking the dependent work until the other context exists, and using untyped free text as a placeholder. Use a **typed stub** instead: a type-tag plus an identifier and a display label, with no referential-integrity enforcement yet. This keeps dependent work unblocked while making the eventual migration mechanical (a search-and-replace on the type tag once the real context exists) rather than a re-authoring exercise.

## Multi-team, multi-ontology governance at scale

When several independently-maintained sub-ontologies (or bounded contexts, from above) need to interoperate, borrow the OBO Foundry's discipline — the most successful real-world example of many independently-maintained ontologies staying interoperable at scale:

- **A named locus of authority per sub-ontology/context** — one accountable owner per shared construct, distinct from the overall governance process. Without this, "who decides" for a shared term becomes ambiguous exactly when it matters most.
- **Cross-team naming-uniqueness discipline.** Don't let two contexts silently mint the same term with different meanings, or the same meaning under different names, without it being visible somewhere (the term-resolution glossary, scaled across contexts).
- **Orthogonality discipline: don't re-model a concept that properly belongs to a sibling context — reuse or extend theirs instead.** This is the multi-team-scale corollary of `reuse-and-alignment.md`'s "borrow before invent," not a competing rule — see `conflicts-and-precedence.md`. Be honest that full orthogonality is hard to sustain even with explicit, sustained effort (OBO Foundry's own community has documented persistent overlap after years of trying) — treat it as a discipline to keep approaching, not a binary pass/fail.
- **A promotion bar before a sub-model becomes a shared/reusable module.** Require documented, independent adoption by more than one consuming team before a locally-built construct graduates to "shared standard" status (OBO's admission principle) — this prevents one team's convenient local shortcut from being mistaken for settled shared meaning. Consider an explicit, time-boxed **incubation** status for a candidate pending promotion, rather than leaving it in permanent limbo.
- **Watch for the mirror image of orthogonality: a cross-cutting concern accidentally homed in whichever context needed it first.** A construct that's genuinely general (e.g., shared accounting/allocation machinery) must not become permanently owned by one bounded context's staging area merely because that context happened to need it first. Check any construct proposed inside one context's scope against whether it's actually general before it settles there.

## The Center-of-Excellence Ontology anti-pattern

A recurring theme in published practitioner and analyst commentary on large industry ontologies — FIBO in financial services is the most-discussed example — is that a model can be technically excellent yet still see adoption stall once it needs to spread beyond the specialist team that built it, because non-specialist stakeholders find it too abstract to map onto their day-to-day systems. Contributing causes reported in that commentary: tooling friction (specialized editors, dedicated infrastructure), a scarcity of people who are both ontologists and domain experts, and a model that needs an ontologist as translator for anyone else to use it. Treat this as a widely-reported adoption pattern to design against, not a verdict on any particular standard.

Treat adoption-friction and non-specialist usability as a first-class design constraint, not an afterthought to solve later. Task-based evaluation (`evaluation-and-anti-patterns.md`) is the right test — if the people who need to use the model day-to-day can't, without a specialist intermediary, that's a failing result regardless of how logically clean the model is. The concrete remedy is usually not structural: legible definitions and audience-appropriate documentation are the mechanism by which this failure is avoided or caused — see `definitions-and-documentation.md`.

## Application-independence as a scoping question

Ask explicitly, during scoping: **is this model meant to outlive or outnumber its first consuming application?** If yes — if it's meant to be a shared, application-independent substrate rather than one application's private schema — that materially raises how much reuse discipline, minimal-import rigor, and cross-team governance (above) is warranted from the start. If no — if it's genuinely scoped to one application's lifetime — most of this file's guidance can be deferred until (if ever) a second consumer shows up.

## Multi-contributor / web-scale schema evolution

When contribution is distributed or crowd-scale (a large user base continuously validating machine-inferred facts) or arrives continuously from many independent automated sources, rather than from a small deliberate committee, the mechanics of `process-and-governance.md`'s gate pipeline change even though the underlying discipline doesn't:

- **Track quality on multiple independent axes** — coverage, correctness, structure, freshness — scored separately, rather than as one composite number. A model can be highly correct but have poor coverage, or vice versa; conflating them hides which lever actually needs pulling.
- **Confidence-weighted reconciliation with retained provenance**, extending the append-and-supersede invariant to high-volume, many-source contexts: when many sources disagree about the same fact, keep the competing claims with their sources and confidence rather than letting the most recent or most numerous one silently overwrite the others.
- **Continuous validation by the consuming population itself** can substitute for (or augment) a small governance team's review capacity — but only where the population is large and engaged enough to make this reliable; don't assume it as a default without that condition.
