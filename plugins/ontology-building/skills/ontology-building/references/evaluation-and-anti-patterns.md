# Evaluation and anti-patterns

How to tell whether an ontology is actually good, and a consolidated catalogue of documented ways it commonly goes wrong — merging academic, practitioner (Palantir), and production-governance (process) sources into one checklist.

## Gruber's five design criteria

The classical rubric for ontologies meant to support knowledge sharing (Gruber, 1993/95). Use these as a scoring checklist, not just aspirational language:

- **Clarity** — definitions communicate intended meaning objectively; documented in natural language wherever possible, independent of who's reading them.
- **Coherence** — the ontology only sanctions inferences consistent with its definitions; informal descriptions/examples don't contradict the formal axioms.
- **Extendibility** — new terms can be defined for special uses, building on the existing vocabulary, without revising existing definitions.
- **Minimal encoding bias** — the conceptualization is specified at the knowledge level, independent of a particular notation/serialization. Watch for a specific encoding's shape (a TypeScript interface, a table layout) quietly becoming "the model" rather than one of several ways to represent it.
- **Minimal ontological commitment** — assume as little as possible about the world beyond what's needed for the intended use, leaving room for future specialization without breaking what's already committed to.

## Detectable, not forbidden

When an irregularity might be a legitimate design choice in some cases and an error in others, don't hard-constrain it away. Model it as a derived, advisory finding that surfaces for human judgment instead — a validation rule that flags "this doesn't match the expected pattern" for review is more useful than a constraint that simply forbids the case outright, since real-world structures are often legitimately irregular. Reserve hard constraints for cases that are always errors; use advisory findings for cases that are sometimes errors.

## Quality dimensions trade off against each other — name whose judgment wins

Gruber's five criteria and the method families below can pull in different directions in practice: completeness vs. simplicity, flexibility vs. understandability, syntactic correctness (does it follow the modeling language's own rules) vs. semantic correctness (does it reflect reality) vs. pragmatic correctness (do the actual stakeholders understand and correctly interpret it). Moody's conceptual-model quality framework treats these as genuinely competing dimensions, not a single score to maximize — a developer cares most about syntactic quality; a domain expert cares most about pragmatic quality; naming whose judgment matters most for a given build is itself a design decision, not a detail to skip.

Run a **pragmatic-quality check** explicitly, not just the logical/structural checks below: have someone who didn't build the model read the populated result and see if they interpret it correctly — the model-level analogue of the competency-question recognition test in `competency-questions.md`, applied to the finished artifact rather than to a CQ's wording.

## Stipulative vs. descriptive constructs

Not everything in an ontology is a fact with a truth-value — some constructs are legitimately conventions, with an owner and a coherence-based adequacy test rather than a correctness test. A leveling scale that "asserts equivalent value, not equivalent scope" is a stipulation, not a description of an objective fact; two organizations can legitimately grade the same work differently with neither being wrong. Reconciling two independent stipulations is a mapping exercise, different in kind from correcting an error — don't treat a disagreement between two stipulative constructs as if one of them must be factually wrong.

## Evaluation method families

No single method is sufficient; pick from these based on what you're trying to catch:

- **Criteria-based** — score against dimensions like the five above, plus completeness/conciseness/consistency. (OQuaRE operationalizes this as a repeatable scorecard, adapting the ISO/IEC 25000 software-quality standard to ontologies.)
- **Gold-standard-based** — compare against an existing reference ontology/corpus for accuracy and conciseness, where one exists.
- **Corpus-based** — check coverage/fit against a real text/data corpus from the domain.
- **Task-based** — the strongest practical signal: does the ontology actually improve performance on the downstream application (or agent) it was built for, independent of how elegant its internal structure is.
- **Logical** — run a reasoner (or equivalent structural checks) for unsatisfiability, circularity, redundancy.
- **Statistical/ML quality metrics** — when instances are populated by an ML/extraction pipeline rather than hand-curated, track precision/recall/accuracy against a held-out sample as a companion to CQ-based evaluation. CQs test whether the *schema* can answer the right questions; this tests whether the *extracted instances* meet an acceptable accuracy bar — a distinct, necessary check whenever population isn't fully manual.

## Consolidated anti-pattern catalogue

Grouped by where each one tends to originate; most have both an academic name and a practitioner-visible symptom.

**Taxonomic / logical errors**
- **Circularity** — A defined in terms of B defined in terms of A.
- **Logical inconsistency** — e.g., a class declared subclass of two mutually disjoint classes (unsatisfiable).
- **Redundancy** — axioms/assertions already entailed by others, adding no semantics, only bloat.
- **Subsumption/instantiation confusion** — modeling an individual as a subclass rather than an instance, or vice versa.
- **Rigid class subsuming an anti-rigid one** — a role or phase (Student, Larva) rigidly subclassed as if it were a permanent type. See `hierarchy-and-structure.md`'s OntoClean section.
- **Inconsistent granularity** — mixing coarse- and fine-grained concepts at the same taxonomic level.
- **Part-of / is-a conflation** — modeling a meronomic (part-whole) relationship as a subclass hierarchy, or vice versa.
- **Overloaded relations** — a single generic relation ("has", "related-to") silently meaning structurally different things in different contexts.
- **The misnomer** — a vague, generic, or misleading name that fails to communicate intended meaning without tribal knowledge.
- **Definition defects** — circular, negative ("a non-X is anything that isn't X"), "is when/is where" category errors, definition-by-example-only, or a genus that contradicts the class's asserted parent. Each fails the substitutability test; see `definitions-and-documentation.md`.
- **Undefined terms** — a construct carrying a label and structure but no textual definition, which is where two teams' divergent readings quietly take root.
- **Unconnected/orphan elements** — a class or relation with no path connecting it to the rest of the model. Mechanical to check, easy to miss (OOPS! pitfall P04).
- **Missing disjointness** — sibling classes that should be mutually exclusive but aren't asserted as such, so a real classification error passes silently instead of surfacing as a contradiction (OOPS! P10). Pair with the sibling-generality rule in `hierarchy-and-structure.md` — assert disjointness so it becomes falsifiable structure, not just a stylistic preference.
- **Incomplete relation declaration** — a relation missing a declared domain or range, or with an unstated inverse/symmetry/transitivity/functionality, so its algebraic behavior is assumed rather than specified (OOPS! P05, P09, P11, P25–P29). Every relation should have both ends typed and its algebraic properties stated, even when the answer is "none of these apply."
- **Mandatory-relation constraints checked as single-hop existence when a legitimate indirect path exists.** A cardinality constraint like "must have at least one X" should sometimes be a graph-reachability check, not a direct-edge check — when a legitimate indirect satisfaction path exists (e.g., a requirement satisfied transitively through a chain), a naive single-hop existence check produces false negatives on valid data.

**Structural / scale anti-patterns (named by Palantir, but general)**
- **Kitchen Sink** — an entity type that mirrors a source system's schema quirks (every raw column becomes a property) instead of encoding real business/domain semantics.
- **System Silos** — separate entity types for the same real-world thing per source system, instead of one entity with resolved identity across sources. (This is a schema-*type*-level rule, not an instance-level one — it doesn't require resolving every ambiguous instance immediately; see the deferred-entity-resolution note in `conflicts-and-precedence.md`.)
- **Action Sprawl** — many narrow, single-field-mutating operations instead of a smaller number of operations that represent coherent, meaningful units of change. Especially dangerous once an ontology is agent-consumable: every sprawling micro-operation becomes a separate, easy-to-misuse agent tool.
- **Golden Hammer** — using the wrong primitive for the job (e.g., a manual action for what should be an automated derivation).
- **God Object** — a single entity type that accretes properties for every new use case until it's unmaintainable.
- **Center-of-Excellence Ontology** — a model that is logically excellent but has no path to adoption by non-specialist teams or stakeholders without an ontologist as translator. A widely-reported adoption pattern for large industry ontologies: technically sound, but too abstract for business stakeholders, with adoption stalling once it needs to spread beyond the team that built it. See `scale-and-governance.md`.

**Process / governance anti-patterns (hard-won, less commonly documented academically)**
- **Silent construct drift** — a correction lands in the primary record of a fact but a second place that restates the same fact is missed. Any fact expressible in more than one place is a standing liability regardless of how careful the last edit was (this is `SKILL.md` core principle 3, "One fact, one place," violated in practice).
- **Trusting a secondary cross-reference over the primary source** — a documented, real cause of false claims propagating through a model.
- **Narrative summaries going stale while version numbers are bumped correctly** — no mechanical check exists for prose currency, only for structured field values; don't assume a version bump means the prose is still accurate.
- **Applying a design test inconsistently** — even the person who just applied a test correctly can violate it minutes later on an adjacent decision. Discipline has to be mechanical (a literal checklist run every time), not memory-based.
- **Over-fitting a construct's name/scope to its first example** — breaks on the first broader instance that comes along; rename decisively rather than patching around it.
- **Building a bespoke construct for what's actually an instance of a general capability the model needs anyway** — mint the general mechanism once, rather than accumulating narrow special cases.
- **Orthogonal axes collapsed into one enum** — a single status/type value silently doing double or triple duty across independent dimensions of variation (e.g., mixing a category distinction with a maturity gradient with a provenance judgment). If a value has to represent more than one independent kind of variation, split it.
- **Non-commensurable confidence/trust axes blended into one score.** Distinct kinds of confidence (e.g., how reliable a source is at reporting facts vs. how credible their judgment/opinion is) should stay on separate, non-averaged scales — blending them into a single number hides which one is actually driving a low score.
- **"Primes, never gates" violated — a heuristic prior asserted as a definitional fact.** A statistically-common-but-not-universal association, useful for defaulting or narrowing a search, belongs in a separate, explicitly non-normative layer excluded from formal cardinality — never asserted as a schema-level fact. Check for this specifically whenever a "usually true" association is being formalized.
- **An untested competency-question catalogue** — CQs whose "answerable" status is asserted rather than verified by actually running them. See `competency-questions.md`.
- **Granularity mismatch when aligning to an external taxonomy** — forcing a 1:1 correspondence between tiers that don't actually align level-for-level, either losing real distinctions or importing false precision. See `reuse-and-alignment.md`.
- **Schema-constraint literalism** — treating an existing/target schema's incidental physical constraint (a `NOT NULL` column, a legacy nullable field, a denormalized shape) as direct proof of a conceptual fact, in either direction. A storage-layer constraint is evidence to weigh, not a conclusion to inherit. See `schema-informed-discovery.md`.

**LLM-construction-specific anti-patterns** (relevant only when an LLM assists in generating candidate structure — see `llm-assisted-construction.md` for the full treatment): fabricated/hallucinated relations, flattened hierarchies, high sensitivity to prompt wording, and error rates that scale with ontological complexity rather than with model size.

## Using this checklist

Run the taxonomic/logical checks first — they're the hard floor (see `SKILL.md`'s "When sources conflict" priority list, tier 1). Then check structural/scale anti-patterns, which mostly matter as an ontology grows or gets consumed by more than one team/system. Then check process anti-patterns, which are about how the ontology stays correct over time, not whether it's correct on day one. If an LLM assisted in generating candidate structure, run the LLM-construction-specific checks last, against the final result — they catch defects the other three groups don't specifically look for (flattening, fabricated relations, prompt-sensitivity artifacts).
