# Process and governance

How decisions about meaning get made, recorded, and kept from silently rotting. This is the least glamorous and most load-bearing part of ontology work — most ontology failures are governance failures (an undocumented decision gets re-litigated, a correction lands in one place but not its restatement elsewhere) rather than modeling failures.

## Two build modes — choose per layer, not once for the whole ontology

- **Prospective (design-first):** for foundational/upper layers, where you deliberately adopt or design structure ahead of specific instances, because getting the top of the hierarchy wrong is expensive to unwind later.
- **Accretive (grown-from-usage):** for domain content, where you codify existing institutional knowledge and promote patterns once they recur across real instances, rather than guessing at structure that hasn't been exercised yet.

Deciding, per layer, which mode applies is itself a design decision — don't force "design everything up front" or "let everything emerge" as a blanket policy.

## The gate pipeline

*(This pipeline assumes a small, deliberate decision-making group building one ontology. For governance across multiple teams, multiple bounded contexts, or continuously-arriving crowd/automated contribution, see `scale-and-governance.md` — the underlying discipline still applies, but the mechanics change.)*

Every change to meaning travels a fixed sequence. Don't skip gates even under time pressure — skipped gates are where undocumented, unrecoverable decisions come from.

1. **Staging.** A non-normative area where a candidate is worked out visibly and provisionally. Nothing here is binding until promoted.
2. **Open issue.** Raised the moment a decision is *owed* — question, options, and the evidence that would settle it, written down explicitly, never left implicit in someone's head.
3. **Decision record.** Lands in one authoritative place, capturing the *why* — even for decisions that don't yet touch the schema.
4. **Schema-change instrument.** For anything that does touch the model (see the change-request template below). Blocks dependent work until cleared.
5. **Version bump + closed drift-check.** Every document/system that consumes the model is enumerated once; a version bump triggers a mechanical sweep for changed terms across that enumerated list — never an ad hoc "let people notice." **Version at exactly one granularity — the document or module — never a term, region, or substructure.** Encoding a version or scope marker into a finer-grained identifier means a later reorganization (renumbering, re-scoping) invalidates every reference that encoded it, all at once.

## Keep the ontology under source/version control

A prerequisite for everything below, not a tooling preference: without version control there is no mechanical diff between releases, and without a diff every change description reduces to someone's recollection. Treat the ontology as source — reviewable changes, attributable history, releases you can diff. Annotate constructs with their decision-record IDs inline so that the *rationale* for a change can be reassembled from the files themselves rather than depending on whoever made it (`refactoring-and-evolution.md`).

## Two invariants underneath the pipeline

- **One-way authority flow.** A "why" artifact (rationale) feeds a "what must be true" artifact (requirements), which feeds a "how represented" artifact (formal model). Exactly one back-edge is permitted: a requirement that can't be phrased against the current design returns upstream as a new open question — it never gets silently patched downstream.
- **Append-and-supersede, never mutate.** Corrections are new records that supersede old ones; nothing is silently overwritten. This is what makes "why did we do it this way" answerable a year later.

## Decision-making techniques

- **Separate conflated claims before adjudicating a disagreement.** Two people can appear to disagree when they're actually holding partly-compatible positions on different, bundled claims — separate the bundle into its distinct component claims first; the apparent disagreement often dissolves once each component is judged on its own.
- **When a decision rests on more than one independent ground, track each ground as independently revisitable.** A conclusion cited going forward should be re-checked against all of its original grounds, not carried forward on the strength of whichever ground was true when it was first decided — one ground expiring while the conclusion keeps getting cited as fully supported is a distinct failure from ordinary stale restatement.
- **The transcribe-vs-judge test for relayed assertions.** When one party passes along another's claim, decide whether they acted as a conduit (passed the content unchanged — keep the original asserter's attribution, plus a separate transmission-fidelity fact) or as a new asserter (interpreted or edited the content — attribute the resulting claim to them, not the original source).

## Three separated backlogs

Keep these distinct — collapsing them into one list erases the different promotion paths and decision criteria each requires.

| Backlog | Contents | Review cadence |
|---|---|---|
| Open Issues | Decisions owed but not yet made | Per sprint |
| Deferred | Deliberately not built (with the reason recorded) | Quarterly |
| Build | Decided but not yet implemented | Per sprint |

A deferred decision is safe. A deferred decision with no recorded reason is not — the specific failure/rejection reason is what stops someone from re-proposing and re-litigating an idea that was already tried and found wanting.

## Reusable artifact types

- **Rationale.** Narrative decisions with rejected alternatives, plus a flat, append-only, numbered decision register (one row per decision, confidence-tagged, never deleted — resolution replaces "open" status in place while the row's ID persists). The single most transferable artifact here. Record the accepted cost of the chosen option explicitly, not just why it beat the alternatives — a decision that names what it gave up is easier to revisit honestly later than one that only records why it won. See `templates.md` for a ready-to-copy decision-record template.
- **Requirements / ORSD** (Ontology Requirements Specification Document). Scope, two parallel acceptance-suite catalogues — competency questions (what must be answerable) and known schema/system requirements (what must be materializable, compatible, or interoperable; see `competency-questions.md`'s peer-requirement section) — a term-resolution glossary (colloquial phrase → canonical construct → one-line rationale), and declared mandatory obligations — derived from and pinned to the rationale, but independently authoritative for "what must be true."
- **Formal ontology.** The actual machine-checkable schema, kept deliberately separate from the rationale and requirements so meaning-authority and representation-mechanics never collide.
- **Schema-change instrument** (an "OCR" — ontology change request). See `templates.md` for the fields. Distinct from a decision record: it's the concrete change proposal, gated by an explicit adequacy check, not just the recorded reasoning behind it.
- **Staging document.** One per not-yet-merged sub-domain, explicitly non-normative and allowed to move fast; merged into the main model only once mature.
- **Region.** Distinct from a staging document: a *persistent* named sub-division of one ontology that differs in persistence rules, write-governance, or maturity from its sibling regions, while deliberately sharing one vocabulary and definitional coherence across all of them (e.g., a strictly-governed core region vs. a faster-moving working region, coexisting long-term rather than one being merged into the other). See `scale-and-governance.md`'s "'Region' vs. bounded context" section for how this differs from a bounded context.
- **Worked examples.** A first-class, versioned artifact serving three roles at once: regression test, product documentation, and legibility aid explaining *why* a construct exists and *what error it prevents*.
- **Session/corrections log.** Indexes every claim later withdrawn (with the specific false belief that caused it) and every gate gap discovered (with what was added in response). A surviving decision is visible in the model; a rejected one is invisible unless something records it.
- **Imports/mapping register.** Separates terms whose semantics are actually adopted from external schemes that are merely aligned-to for interoperability, under a stated minimal-import principle (see `reuse-and-alignment.md`).
- **Construct-resolution/colloquial-term register.** Records colloquial-term → canonical-construct mappings, including genuine multi-sense collisions (the same colloquial word legitimately meaning different things in different constructs) — disambiguated by context and recorded, not eliminated by forcing an artificial rename.

## Validation practices

- **Competency questions as the literal acceptance suite** — a construct isn't "done" until its questions are answerable, or carry a logged, named deferral. See `competency-questions.md`.
- **Two-tier validation compiled from one shared model.** Author freely against a loose/permissive profile; gate promotion to shared/authoritative scope behind a strict profile — so there is never a second "official" schema to keep in sync by hand.
- **Executable competency questions** — expressed as runnable queries against test data, not only prose (see `competency-questions.md`'s asserted-vs-verified distinction).
- **T-box-gap vs. A-box-conformance routing.** First determine whether a problem is "the schema can't express this" (→ a formal change request) or "valid schema, dirty data" (→ a data fix). Conflating the two produces either needless schema churn or a papered-over gap.
- **Enumerated, closed consumer graph.** Name every consumer of the model once; route drift-checks against that fixed list on two cadences (every-version vs. reconcile-on-promote) depending on how tightly each consumer is coupled to the model. **The enumeration itself can be scoped too narrowly** — a document can be safe to archive within the ontology's own graph and still be load-bearing outside it (another team's planning doc citing it as a source of authority); make sure the enumeration reaches beyond the ontology's own directory/repo before treating a change as consequence-free.
- **Classify a change's blast radius before propagating it.** Distinguish an additive, optional change with no cardinality/enum impact from a cardinality change that touches specific downstream consumers from a change scoped to one sub-domain with no impact elsewhere — and route propagation effort accordingly. Treating every change as equally consequential wastes effort on trivial ones and under-invests in the ones that actually reach consumers.
- **Verify propagation by content, not by pointer.** A version-bump or reconcile step isn't verified by checking that a downstream document's version header was updated — check that the actual new terms/fields the changelog introduced were added to the document body. Updating the pointer while leaving the body stale is a distinct, sharper failure than the general "stale narrative" anti-pattern (see `evaluation-and-anti-patterns.md`): it's a single reconcile operation silently doing only half its job.
- **Trace corroboration to root provenance, not immediate record count.** Two records that both ultimately derive from one underlying source are one piece of evidence, however many times each was separately entered — count distinct roots, not distinct restatements, when assessing how well-corroborated a fact is.
- **Per-predicate freshness policy, distinct from schema-version drift-checks.** Data staleness tolerance varies by property, not just by model version — a stock price and a country's capital need entirely different currency/refresh policies. Don't assume one freshness rule covers the whole model; state it per property where it matters.
