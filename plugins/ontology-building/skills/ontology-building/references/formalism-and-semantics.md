# Formalism and semantics choices

Decisions about the representational substrate itself — what absence means, whether a taxonomy is a class tree or a concept scheme, how identifiers work, and how much axiomatic rigor to buy. These are choices to make deliberately per model (and record as decisions), not defaults to inherit from whatever tool is nearest.

## Open-world vs. closed-world: layer them, don't pick one

**The distinction.** Under the open-world assumption (OWA — OWL, description-logic reasoners), absence of an assertion means *unknown*: "no employer is recorded" does not entail "unemployed." Under the closed-world assumption (CWA — SQL, property graphs, SHACL validation), absence means *false*. Neither is right in general; picking one globally is the mistake.

**Recommendation for practical, pragmatic ontologies built progressively and iteratively: author under open-world semantics; validate under closed-world profiles at promotion gates.**

- During an iterative build, most absence is "not yet modeled." CWA-by-default punishes work-in-progress with false conclusions (everything unfinished reads as false); OWA-everywhere means you can never check completeness at all. Layering resolves both: the model's *meaning* stays open (extension-friendly, consistent with minimal commitment), while each promotion gate applies a closed-world validation profile (SHACL-style) asserting, for that specific scope and moment, "everything required here is present." This is `process-and-governance.md`'s two-tier validation, stated in semantic terms.
- **Make completeness a deliberate, local, recorded act — never a side effect.** Closing an enumeration or a partition ("these are ALL the kinds of X") is a decision with a decision-record entry, scoped to the construct it closes, not an ambient assumption. The negated-classification rule in `hierarchy-and-structure.md` (derive "non-billable" as the complement of a closed partition) only works where a partition has been explicitly closed this way.
- Name which assumption every validation check runs under. A "mandatory relation" check is a closed-world act — and per `evaluation-and-anti-patterns.md`, may need to be a reachability check, not single-hop existence.

## Class hierarchy vs. concept scheme

**The fork.** A distinction can live as a genuine class in the hierarchy (subclass semantics: instances inherit membership and properties, constraints and disjointness apply, the is-a litmus test must pass) or as a *concept* in a concept scheme (SKOS-style: each node is an instance of a Concept class, linked by broader/narrower, carrying its own labels, lifecycle status, and provenance, with no inference commitment).

**Decide by function, not by what the domain calls it ("taxonomy" is used for both):**

- **Class hierarchy** when the model must *infer and constrain*: properties inherited, instances automatically classified, disjointness checked. Every link must pass the is-a litmus test; the tree is schema, so changing it is a gated schema change.
- **Concept scheme** when the job is *tagging, navigation, and crosswalking*: reference taxonomies, industry classifications, subject categories, maturity tiers. Nodes are data, not schema — domain experts can maintain them, each node carries its own metadata, adding or moving one is not a schema change, and graded mappings to external schemes (broad/narrow/close-match, `reuse-and-alignment.md`) attach naturally. gist's "categories" pattern is the production-tested shape: category values as instances of a Category class, referenced from entities via a categorization property, instead of exploding the class tree.
- **The litmus:** if a candidate link fails the is-a test, if a node needs its own status/provenance/ownership, or if the hierarchy is curated judgment rather than logical necessity — it's a concept scheme. If you need inheritance or validation to flow through it — it's a class.
- **Hybrid is the normal, recommended end state**: a small, rigid, OntoClean-clean class spine, with one or more concept schemes hung off it via categorization properties. The terminological-hierarchy exception in `hierarchy-and-structure.md` is usually better served as a concept scheme than as property-less classes.
- **The metamodeling trap:** needing the same thing to be both a class and an instance (e.g., "Eagle" as a class of birds and as an instance of Species) is the classic sign the concept-scheme side is being forced into the class tree. Formal workarounds (punning) exist, but the cleaner move is usually to acknowledge the node is a concept, not a class.

## Identity and keys in practice

- Identity *criteria* (OntoClean, `hierarchy-and-structure.md`) decide when two records are one thing; keys merely implement that decision. Settle the criterion before engineering the key.
- Prefer stable, opaque, string-typed identifiers. **Never encode a mutable or reorganizable fact (region, version, classification, org placement) into an identifier** — the same rule as `process-and-governance.md`'s version-at-one-granularity invariant: a later reorganization invalidates every reference that encoded it.
- Keep natural keys as properties with uniqueness checks, not as the identifier itself — natural keys turn out to be less unique, less stable, and less permanent than assumed, and identity-resolution conflicts inherited from source systems are a leading cause of expensive rebuilds (`schema-informed-discovery.md`, System Silos in `evaluation-and-anti-patterns.md`).

## Expressivity is a budget, not free rigor

Richer axiomatization has real computational cost at scale — large, heavily-axiomatized industry ontologies have documented reasoning-performance problems. Axiomatize what will actually be checked or inferred by something; everything else is better carried as clear natural-language definitions (Gruber's clarity criterion) than as axioms nothing consumes. This is minimal commitment applied to the formalism itself.
