# Statement and provenance extension

An **extension**, not part of the base methodology — the same conditional status as `agent-actionability.md`. Most ontologies don't need it. Invoke it only when the tests below say the domain calls for it.

## Do you need a reified statement layer?

**Default: no.** Most ontologies are single-authority models: the modeling team is the authority for what's in them, and the governance layer's audit trail — who changed what, when (`process-and-governance.md`) — already answers every provenance question anyone actually asks. A product taxonomy, a units vocabulary, an internal reference scheme, a geometry model: none of these need individual facts to carry "according to whom."

**You need one when any of these hold:**

- Facts arrive from multiple sources that can legitimately disagree, and the disagreement must *survive* rather than be resolved by overwrite.
- A competency question asks *according to whom*, *how do we know*, *how confident*, or *what did we believe as of when*.
- Assertions can be retracted or superseded and the history of belief itself is queryable (regulatory, diligence, scientific, intelligence domains).
- Source reliability varies and must be *weighed*, not merely recorded.
- The model carries judgments and assessments, not only observations.

**You don't when:** the facts are stipulated by you; there is a single authoritative source; only current truth matters and correction history is an operations concern; or the governance audit trail already suffices.

**Cost in both directions.** Retrofitting is expensive — which is what the statement-candidate tag in `SKILL.md` step 4 exists to make cheap. But building it unneeded multiplies constructs and routes every query through indirection for provenance nobody asks about; that is core principle 2 violated. Decide deliberately, and record the decision either way.

## The universal residue: stipulated vs. reported

This part applies to every ontology, reified layer or not.

Know which facts your model *defines* and which it *repeats from elsewhere*, and never let the two blur. A stipulation has an owner and a coherence test rather than a truth value (see stipulative vs. descriptive constructs in `evaluation-and-anti-patterns.md`); a reported fact has a source that can turn out to be wrong. Mixing them silently means you cannot tell "we decided this" from "someone told us this" — and only one of those is yours to change unilaterally.

And regardless of layering: **never fold who-said-it into the fact's own content.** An attribute like `revenueAsReportedByAuditor` bakes the source into the payload and makes two sources' versions of the same fact structurally incomparable — the single commonest capture error, and one that a reified layer is not required to avoid.

## If you need one: borrow the shape

- **W3C PROV** — Entity / Activity / Agent, with `wasDerivedFrom` / `wasAttributedTo` / `wasGeneratedBy`. The standard provenance vocabulary; adopt it (or its shape) rather than minting bespoke properties.
- **The Wikidata statement model** — each fact is a statement carrying *qualifiers* (contextual scope such as time or applicability), *references* (sources), and *ranks* (preferred / normal / deprecated). The largest production precedent operating at scale: rival sources coexist with their provenance instead of overwriting one another — the same discipline as confidence-weighted reconciliation in `scale-and-governance.md`. (Note: Wikibase internally calls a statement-minus-its-references a "claim" — a reminder that this vocabulary is not standardized across the field. This skill uses **statement** throughout, per its own one-term-per-concept rule.)
- **Nanopublications** — assertion + provenance + publication-info as a single citable unit, where individual facts must be independently attributable and cited.
- **Encoding options** — named graphs, RDF-star, reified n-ary constructs, property-graph edge properties. Settle the knowledge-level structure first, then choose the encoding (`conflicts-and-precedence.md` #5).

## Design rules once you have one

- Separate fact from provenance *structurally*, not just by intention.
- **A disputed fact needs a "why."** Two conflicting values alone are not a conflict: require either a rival reading of the same referent, or an explicit mediating rule that makes them jointly untenable. Bare doubt about a source is a trust signal, not a structural contest — keep the two in different constructs.
- **Prefer duplicate-tolerant identity to forced coreference** where sameness genuinely cannot be known at capture time: let duplicates coexist, link them non-destructively and revisably when sameness is asserted, and make merging a deliberate, reversible act (see also deferred entity resolution, `conflicts-and-precedence.md` #10).
- Keep non-commensurable trust axes separate (`evaluation-and-anti-patterns.md`) — reliability at reporting facts and credibility of judgment are different scales, never one blended score.
- Count corroboration by root provenance, not by restatements (`process-and-governance.md`).
- Apply the transcribe-vs-judge test to relayed assertions (`process-and-governance.md`).
- Where a fact legitimately differs by whose perspective it is asserted from, use a stakeholder-relative position tuple (`hierarchy-and-structure.md`).
- Belief time vs. world time: when-asserted and when-retracted live on the statement; when-true-in-the-world lives on the subject (`temporality-and-change.md`).
