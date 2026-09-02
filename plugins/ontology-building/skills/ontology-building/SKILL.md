---
name: ontology-building
description: Builds, extends, reviews, or audits an ontology, domain model, conceptual/data model, taxonomy, or knowledge-graph/property-graph schema — deciding what entities, classes, relations, or aggregates should exist, how to shape a class or role hierarchy, how to scope with competency questions, and how to validate coherence (is-a correctness, anti-patterns, agent-actionability). Use when designing a data model, building a taxonomy, modeling a domain, defining a class hierarchy or knowledge-graph schema, or reviewing an existing ontology/domain model for coherence or AI-agent fitness. Skip for trained ML/statistical models, or routine schema tweaks with no structural decision.
when_to_use: Trigger phrases include "design a data model", "build a taxonomy", "model this domain", "ontology", "competency questions", "class hierarchy", "bounded context", "aggregate design", "entity-relationship model", "knowledge graph schema", "conceptual model", "object model", "domain-driven design", "refactor this taxonomy". Also trigger when auditing an existing ontology/domain model for coherence, correctness, or fitness for AI-agent consumption. Do not trigger when "model" means a trained ML/statistical model (training, fine-tuning, evaluation metrics), or for a routine, structurally-inconsequential schema tweak (renaming a column, adding an index) with no new entity/relationship/hierarchy decision.
---

# Building a coherent ontology

A domain-agnostic methodology for building ontologies, domain models, taxonomies, and knowledge graphs — independent of what you encode the result in (OWL, a property graph, a relational schema, typed code, a Palantir-style object model). It synthesizes several lineages that don't always agree, and says explicitly where they conflict and which one wins. Full source list and how the lineages are reconciled: [conflicts-and-precedence.md](references/conflicts-and-precedence.md).

## How to use this skill

1. Read this file for the core principles, operating modes, and process.
2. Pick your operating mode before running any steps.
3. Use the reference map to load the specific file for the step you're on — don't front-load all of them.
4. When two pieces of guidance seem to disagree, check [conflicts-and-precedence.md](references/conflicts-and-precedence.md) first — most apparent conflicts are already resolved there, not genuinely open.

## Reference map

**Core loop — the seven-step process below runs through these:**

| File | Load it when... |
|---|---|
| [competency-questions.md](references/competency-questions.md) | Scoping — eliciting/grading competency questions and peer schema requirements |
| [reuse-and-alignment.md](references/reuse-and-alignment.md) | Deciding whether to adopt/map an external standard, vocabulary, or pattern |
| [hierarchy-and-structure.md](references/hierarchy-and-structure.md) | Defining classes, hierarchy, or relations; a reification or role-assignment question |
| [definitions-and-documentation.md](references/definitions-and-documentation.md) | Writing the definition of a construct, or the documentation its consumers will read |
| [evaluation-and-anti-patterns.md](references/evaluation-and-anti-patterns.md) | Evaluating a model, or checking it against known anti-patterns |
| [process-and-governance.md](references/process-and-governance.md) | Setting up or following the decision/versioning governance pipeline |

**Situational — load when the condition applies:**

| File | Load it when... |
|---|---|
| [schema-informed-discovery.md](references/schema-informed-discovery.md) | An existing or target schema already exists (migration, legacy integration, materialization target) |
| [formalism-and-semantics.md](references/formalism-and-semantics.md) | Choosing semantic commitments — open- vs. closed-world, class hierarchy vs. concept scheme, identifiers/keys, expressivity budget |
| [temporality-and-change.md](references/temporality-and-change.md) | Modeling time, history, evolution, or state mutation — effective dating, bitemporality, state machines, fluents |
| [scale-and-governance.md](references/scale-and-governance.md) | More than one team/bounded context is in play, or the model must outlive its first consuming application |
| [refactoring-and-evolution.md](references/refactoring-and-evolution.md) | Restructuring a model that already has consumers — triggers, named refactorings, breaking changes, deprecation, versioning |
| [llm-assisted-construction.md](references/llm-assisted-construction.md) | An LLM is helping generate candidate structure, or mediating competency-question elicitation |

**Conditional extensions — invoke only when the domain triggers them (see the hooks below):**

| File | Load it when... |
|---|---|
| [agent-actionability.md](references/agent-actionability.md) | The ontology must be read from, written to, or retrieved by AI agents |
| [statement-and-provenance.md](references/statement-and-provenance.md) | Facts come from sources that can disagree, or need provenance, confidence, or retraction history |

**Working aids:**

| File | Load it when... |
|---|---|
| [templates.md](templates.md) | Ready-to-copy templates and checklists — CQ entries, decision records, change requests, naming/discovery/reification checklists, per-mode checklists |
| [examples.md](examples.md) | Worked-example skeletons (placeholders, to be filled from real runs) |
| [conflicts-and-precedence.md](references/conflicts-and-precedence.md) | Two pieces of guidance in this skill seem to disagree; also the full source list |

## Core principles (the convergent bedrock)

Most of these were arrived at independently by nearly every source in the lineage. Treat all six as non-negotiable defaults; everything else is refinement.

1. **Competency questions before commitment.** Write the concrete questions a real stakeholder would ask, in their own words. Exploration may start anywhere — an entity sketch, attribute discovery, relationship walking (see Operating modes) — but *commitment* may not: nothing is promoted into the model until a competency question or a binding schema requirement needs it. → `references/competency-questions.md`
2. **Minimal commitment.** Model only what's needed to answer the current competency questions, plus one deliberate margin for known near-term extension — not everything that happens to be true of the domain. If a concept decomposes cleanly into existing constructs, don't mint a class for it just because it has a name.
3. **One fact, one place.** Anything derivable from more primitive facts is computed, not stored redundantly. Anything statable in more than one construct is a standing liability — pick the single authoritative location and reference it, never restate it.
4. **Know each fact's epistemic status.** Every fact is either *stipulated* (your model defines it — an internal category, a grading scale, an ID scheme) or *reported* (a source asserts it, and could be wrong, disputed, or later corrected). Don't silently mix the two, and never fold who-said-it into a fact's own content, where two sources' versions become structurally incomparable. Whether that separation additionally needs a *reified* statement layer is a domain question, not a universal. → `references/statement-and-provenance.md`
5. **Correctness is necessary; purpose is decisive.** Some models are objectively bad — circular definitions, a role rigidly subclassed as a type, an enum smuggling two independent axes into one value. Rule those out mechanically, first. Among the surviving valid models, the right one is whichever serves the ontology's actual intended use — there is no context-free single correct model of any domain (Noy & McGuinness).
6. **Iterate; expect more than one pass.** Build, test against real cases and competency questions, revise. A model that hasn't been exercised against real instances isn't validated — it's asserted.

## Operating modes

Pick the mode before running any steps. Checklists for all four are in [templates.md](templates.md).

**Build (green-field).** The seven-step Process below, in order. The *discovery style* within steps 1–4 is flexible; the gates are not. Valid entry points, all converging on the same rule (exploration is free; commitment is gated by CQs/requirements):
- **CQ-first** (the default): elicit questions, derive structure.
- **Entity-sketch first ("lite schema")**: sketch candidate entity descriptions, then derive and iterate CQs against the sketch.
- **Attribute/application-driven**: walk a domain object's real-world attributes and what consuming applications need to read off it (use the attribute-discovery checklist in `templates.md`).
- **Relationship/interaction-driven**: trace the world model's interactions and relationships between entities, letting structure emerge from how things act on each other.
- **Existing-schema-informed**: mine an existing/target schema as evidence — `references/schema-informed-discovery.md`.

**Extend (the common case).** Adding or changing components in a live model. Every generative act triggers an **impact-and-overlap review** before the normal gates: (1) check existing elements for *impact* (blast-radius classification, `references/process-and-governance.md`); (2) check the candidate against existing elements for *duplicative, intersecting, or overlapping scope, effect, or utility* (precedent check, decomposition test) — but scope that check to the bounded context: apparent duplication across a *deliberate, mapped* context boundary is the design, not a defect (`references/refactoring-and-evolution.md`); (3) then run the change through the gate pipeline and the change request's four-part adequacy check.

**Refactor (restructuring a model that already has consumers).** Small, individually-verified, behaviour-preserving transformations — never a rewrite. Scope the unit (sub-tree, region, bounded context, or seam) → discover triggers from three channels (the seeded deficiency, a sweep of the region for errors *and* omissions, connective-tissue review against adopted base ontologies) → order the deficiencies, group them, and work the groups sequentially with a consistency-and-coherence pass between each → track breaking changes continuously and report them consolidated at the end. → `references/refactoring-and-evolution.md`

**Review / audit (an existing, possibly undocumented model).** Ordered workflow: inventory the model → recover the implicit competency questions from its consumers, queries, and documentation, and grade their answerability → run the mechanical taxonomy checks (`references/hierarchy-and-structure.md`) → check definition quality and consumer documentation (`references/definitions-and-documentation.md`) → sweep the anti-pattern catalogue in its stated order (`references/evaluation-and-anti-patterns.md`) → audit temporal and semantic assumptions (which timestamps mean valid vs. transaction time; where closed-world assumptions are silently made — `references/temporality-and-change.md`, `references/formalism-and-semantics.md`) → produce a severity-ranked findings report, each finding mapped to a named test or anti-pattern, with suggested remediation and blast radius.

**Working with a human.** In any mode: elicit CQs from the stakeholder rather than inventing CQs for them (verbalize candidates back — the recognition test); confirm scope boundaries before modeling; and present contested calls (subclass-vs-property, reify-or-not) as decisions with a recommendation and its accepted cost, not as silent choices.

## Process

The seven steps of **Build** mode. Extend, Review, and Refactor reuse this machinery differently — see Operating modes above. Detailed version with artifact types and gates: `references/process-and-governance.md`.

1. **Scope.** Settle four things before modeling:
   - **Purpose and consumers** — human readers? downstream applications? AI agents that read or act on it?
   - **One ontology, or several bounded contexts?** More than one team or sub-domain in play changes the unit of governance. → `references/scale-and-governance.md`
   - **Will this outlive or outnumber its first consuming application?** If yes, reuse discipline and governance rigor go up materially. → `references/scale-and-governance.md`
   - **Maintainers** — who owns it, who decides.

   Two conditional inputs, where they apply: an existing or target schema is *evidence to mine in parallel with* step 2, never a substitute for it (`references/schema-informed-discovery.md`); LLM-generated candidate structure is a heavily-gated candidate channel, never a direct edit (`references/llm-assisted-construction.md`).
2. **Elicit competency questions and known schema/system requirements as peer inputs**, both graded by status (answerable/satisfiable now / deferred / gap). A materialization target, existing consumer shape, or integration commitment is a source of binding complexity to solve for — not just evidence to mine. Treat conflicts between the two catalogues as first-class open issues, never silently resolved by favoring one. → `references/competency-questions.md`
3. **Check for reuse before inventing.** Search for an existing standard or vocabulary that already covers the concept; bias strongly toward borrowing for base machinery (time, provenance, units, org structure). If adopting, adopt the class's actual definition — don't cherry-pick fields — and import only what's used plus minimal ancestry. → `references/reuse-and-alignment.md`
4. **Define classes, hierarchy, and relations — and write their definitions.** Apply the is-a litmus test, the sibling-generality check, and the subclass-vs-property test to every candidate; write a genus-differentia definition for each construct as you mint it, not afterwards. **Hooks (tags only — no schema commitment yet):** flag anything that *changes state in the world* (rather than merely recording a fact) as an **action-candidate**; flag any property whose value could legitimately differ by source, be disputed, or need tracing back to who asserted it as a **statement-candidate**. → `references/hierarchy-and-structure.md`, `references/definitions-and-documentation.md`
5. **Populate with real instances** and run the competency questions against them as executable tests, not assertions.
6. **Evaluate, then resolve step 4's tags.** Run the anti-pattern checklist in its stated order. Then: if the ontology must support agent read/write, convert action-candidates via `references/agent-actionability.md`; if the domain needs provenance, confidence, or coexisting rival assertions, convert statement-candidates via `references/statement-and-provenance.md`. Leaving a tag unresolved is a decision — record it as one. → `references/evaluation-and-anti-patterns.md`
7. **Record the decision, not just the result** — a rationale that survives the person who made it, including the accepted cost of the option chosen. → `references/process-and-governance.md`

## Why step 4 tags candidates: the two extension hooks

The base methodology is deliberately minimal — agent-agnostic, and neutral about provenance machinery — because most ontologies need neither, and forcing every model through an Objects/Actions lens, or giving every fact a provenance wrapper, is over-modeling (core principle 2).

But both are expensive to *retrofit*: you end up rediscovering, after the fact, every place a "just update this property" was really a governed decision needing validation and audit, or every place a bare value silently came from a source that could be wrong. So the base process anticipates each extension without building it — a tag, not a schema commitment:

- **action-candidate** → if the ontology later needs agent write-back, `references/agent-actionability.md` turns these into governed Actions.
- **statement-candidate** → if it later needs provenance, confidence, or coexisting rival assertions, `references/statement-and-provenance.md` turns these into a statement layer.

If neither is ever needed, the tags cost nothing.

## When sources conflict

See [conflicts-and-precedence.md](references/conflicts-and-precedence.md) for the full analysis. Short version, in priority order when defaults collide:

1. **Logical/taxonomic correctness** (OntoClean, Gruber) — a hard floor, not negotiable by purpose.
2. **Production-tested process discipline** (the governance/artifact-type layer) — for anything about *how decisions get made and recorded*.
3. **Classical hierarchy/scoping discipline** (Stanford 101) — for anything about *how classes and relations get shaped*.
4. **Extension guidance** — agent-actionability (Palantir) and statement/provenance patterns — applies only once the domain triggers that extension, per the hooks above, and never overrides tiers 1–3.
