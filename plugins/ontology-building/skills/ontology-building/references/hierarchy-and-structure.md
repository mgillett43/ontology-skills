# Class, hierarchy, and relation design

How to decide what's a class, what's a property, what's a relation, and how they should be organized. Combines Stanford 101's classical procedure with the formal justification (OntoClean) for why its rules of thumb work.

## Contents

- The seven-step scaffold (Noy & McGuinness)
- Scope discipline
- Class hierarchy design rules
- The formal grounding: OntoClean's four meta-properties
- Property and relation placement
- Mechanical tests to run before minting anything
- Authorized/intended vs. actual/observed
- Closing a taxonomy by construction
- Reification
- Concrete patterns for reification and role assignment
- Quantities and measurements
- Verbalization check (ORM)
- Declaring the grain (for event/fact-like classes)
- Phrase the differentia as an answerable question
- Naming

## The seven-step scaffold (Noy & McGuinness)

1. Determine domain and scope: what it's for, what questions it must answer, who maintains it.
2. Consider reusing existing ontologies/vocabularies before building from scratch (see `reuse-and-alignment.md`).
3. Enumerate important terms without yet worrying about class/property/overlap distinctions.
4. Define the classes and class hierarchy (top-down, bottom-up, or a combination). Don't default to pure top-down when an existing or target schema already exists — see `schema-informed-discovery.md` for a bottom-up/combination procedure that mines existing structure as evidence without letting it dictate the model.
5. Define the properties of classes.
6. Define the facets of properties (cardinality, value type, domain/range, defaults).
7. Create instances.

Steps 4 and 5 are the most important and are "closely intertwined" — expect to revisit each while doing the other. Treat this as an iteration loop, not a checklist to complete once, top to bottom.

## Scope discipline

- The ontology should not contain all possible true information about the domain — at most one extra level of generality each way beyond what the application needs. This is Stanford 101's specific operationalization of `SKILL.md` core principle 2's minimal-commitment margin, applied to class-hierarchy generality: the "one extra level" should still be tied to a known or reasonably anticipated near-term need, not taken as an unconditional allowance.
- Don't add a class/property just because it's technically true; add it because a competency question needs it.
- **Terminological hierarchies are the one deliberate exception**: a sub-hierarchy with no new properties is still worth having if it has real navigation/communication value (e.g., a reference taxonomy humans browse). Know the difference between this and accidental over-modeling — and note that such a hierarchy is often better homed as a concept scheme than as property-less classes; see the class-hierarchy-vs-concept-scheme fork in `formalism-and-semantics.md`.

## Class hierarchy design rules

- **is-a discipline:** A is a superclass of B if and only if every instance of B is *necessarily* an instance of A. This is not the same relation as instance-of — deciding "is this a class or an individual" is itself a distinct design step, driven by the granularity the competency questions actually need.
- **The is-a litmus test (mechanical, apply to every candidate subclass):** "Every [Child] is a [Parent]" must be true. "Every [Parent] is a [Child]" must be false. If either fails, the relation isn't is-a.
- **No singular/plural duplication.** `Wine` is not a subclass of `Wines` — those are the same concept, not two.
- **Transitivity, no cycles.** A cycle in subclass relations collapses two classes into equivalence, which is almost never intended.
- **Classes represent concepts, not names.** Synonyms must not become separate classes.
- **Sibling generality.** Direct siblings under the same parent (except at the root) must be conceptually parallel — like same-level sections in a book outline. A sibling set mixing "type of X" with "phase of X" with "role played by X" is a reliable smell.
- **Subclass-count heuristics (a smell detector, not a hard rule).** A single subclass usually signals a modeling problem or unnecessary nesting. More than roughly a dozen flat siblings usually calls for an intermediate category.
- **Multiple inheritance is fine when genuinely true** — a concept that really is two things at once (e.g., something that is both a type of X and a type of Y) should have both parents, not one arbitrarily chosen. Sharpen this with UFO's **Role vs. RoleMixin** distinction: a RoleMixin is a role that can be played by instances of otherwise-disjoint parent types (e.g., "Customer" playable by both a Person and an Organization) — model it as a role cutting across the type hierarchy, not as an awkward shared parent or a duplicated role per playing type.
- **New class vs. property value:** mint a subclass only when it adds new properties, restrictions, or relationships not true of the superclass (with the terminological-hierarchy exception above). A distinction that would "migrate" often on a single instance over its lifetime (e.g., a temporary state) should stay a property value, not a class.

## The formal grounding: OntoClean's four meta-properties

Use these when the is-a litmus test alone doesn't resolve a hard case, or to explain *why* a proposed hierarchy is wrong rather than just asserting it is:

- **Identity** — does the class have a criterion for telling its instances apart and re-identifying them over time?
- **Rigidity** — is the property essential to every instance, in every possible circumstance (rigid), never essential (anti-rigid), or does it depend (non-rigid)? A **type** is rigid (a Person is essentially a Person). A **role** (Student, Manager) or **phase** (Larva, Caterpillar-then-Butterfly) is anti-rigid — the same individual can stop being one without ceasing to exist.
- **Unity** — does the class have a well-defined notion of parts and wholeness? ("Lake" has unity; "amount of water" doesn't.)
- **Dependence** — does an instance's existence require the existence of some other, external entity? (A Role like "Student" depends on an institution existing; a Type usually doesn't depend on anything external.)

For the plain-language version of these distinctions — usable with someone who doesn't want the vocabulary — see `categories-and-relations.md`, which also covers the capability/purpose/role three-way split that rigidity alone doesn't separate.

**The constraint that resolves most real hierarchy disputes:** a rigid class cannot be a subclass of an anti-rigid one (a Type cannot be a subtype of a Role), and a class with unity cannot be subsumed by one without unity. In practice: if what you're modeling is really a role or a phase (anti-rigid), don't rigidly subclass it under the entity that plays it — use composition, an interface, or a separate linked "role assignment" construct instead. This is the actual justification for "prefer composition over deep hierarchy" — it's not a blanket anti-hierarchy stance, it's a rigidity check. When modeling a dependence relation itself, point it from the dependent class to what it depends on, not the reverse — this keeps the relation's direction consistent with which side would stop making sense first if the other were removed.

## Property and relation placement

- Attach a property/relation to the *most general* class for which it legitimately holds — but not so general it lands on a universal root ("Thing").
- Distinguish intrinsic properties (true of the entity itself), extrinsic/relational properties (true only in relation to something else), and part-whole relations — don't conflate part-of with is-a; a meronomic relationship modeled as a subclass hierarchy produces invalid inherited properties.
- **Placement-by-stability rule:** a fact belongs on whichever construct changes it least often — frequently the parent, not the member. Stating an organizing fact once on a parent (rather than redundantly restating it on every child) prevents internal inconsistency and lets legitimately mixed/irregular real-world structures surface as a finding rather than being forbidden by fiat.
- **Model a negated classification as a derived complement over a partition, not a first-class term.** Something like "non-billable" should be computed as "not in the billable partition," not stored as its own independently-asserted category — treating it as first-class reopens the open-world problem (absence of a positive assertion is not the same as a confirmed negative) that the partition was supposed to close.

## Mechanical tests to run before minting anything

Before applying any test below, check whether your own existing artifacts already resolved the question — a proposed new construct is sometimes withdrawn the moment someone checks what the model already demonstrates elsewhere (e.g., a precedent already established that an entity carries a fact directly, making a proposed companion-record class redundant). Checking your own precedent is cheaper than any mechanical test and should come first.

1. **Subclass-vs-property test.** If the difference between two candidate variants is *required-vs-forbidden structure*, it's a subclass. If it's merely *populated-vs-empty* on an otherwise-identical structure, it's a property. Apply this to every proposal — it's easy to apply correctly once and then violate it minutes later on an adjacent, superficially different decision, so treat it as a mechanical check, not a memorized rule.
2. **Decomposition test.** Before minting a class for a concept, check whether it decomposes cleanly into existing constructs (a combination of an existing class plus properties/relations already in the model). If it does, don't mint a class just because the concept has a colloquial name. **The mirror failure mode is premature fusion**: don't fuse several independently-varying concerns into one construct just because they share a colloquial name — if two aspects evolve or fail independently, keep them as separate constructs so a problem can be localized to its actual locus.
3. **The taxonomy-artifact test.** Before splitting a construct into two variants, check whether the apparent difference is intrinsic to the domain or merely an artifact of an unrelated boundary you drew elsewhere in your own model. If it's an artifact of your own prior modeling choice rather than a fact about the thing itself, one construct should serve both cases.
4. **The three-way placement test for an external checklist or methodology.** Incorporating an external framework wholesale would otherwise mean minting an ontology class for the whole methodology. Split each item instead into: purely procedural (stays a guided process/skill outside the ontology), formally checkable (becomes a graph/schema constraint), or evidential (an activity producing ontology-native outputs, such as issues or hypotheses). This avoids modeling a methodology as if it were a domain entity.

## Authorized/intended vs. actual/observed — assert both, don't derive one from the other

When what's officially authorized or intended can diverge from what's actually observed to happen, model both independently rather than treating one as derivable from the other — the divergence between them is often exactly the signal the ontology exists to detect. This pattern recurs often enough across unrelated domains that it's worth checking for explicitly whenever a class name contains an implicit "should" (authorized, intended, established, target): ask whether an "actual/observed" counterpart needs to exist as its own independently-asserted construct, not a computed view of the authorized one.

## Closing a taxonomy by construction

Where a taxonomy would otherwise be an open, enumerated list that can never be proven complete, check whether it can instead be generated as the cross-product of a small number of orthogonal dimensions, rather than named case-by-case as new cases are noticed. A taxonomy closed by construction is complete by definition and immediately reveals which combinations are meaningful; an enumerated list only ever grows.

## Reification

Reify a relation into its own construct only when it needs its own state (provenance, confidence, a resolution status) that genuinely can't live on either endpoint — not merely to preserve history if a general history/versioning mechanism already covers the residual fact. Before reifying, ask: what fact would be lost if this stayed a plain relation? If a mechanism you're already building for other reasons covers that fact, don't build a special case.

## Concrete patterns for reification and role assignment

Don't reinvent the shape each time — these are named, citable, production-tested constructs for the two hardest recurring cases:

- **The N-ary Relation pattern (W3C)** is the default concrete answer when a relation needs to be reified: mint a small class representing the relation itself, with one property per participant/role, rather than trying to force a binary relation to carry extra facts it wasn't designed for.
- **UFO's Relator** is the formal justification for *when* this is warranted — a relator is the reified relation that mediates between its participants and legitimately carries its own existence-dependent properties (the same judgment the reification question above is asking informally).
- **AgentRole / ObjectRole (Content ODP)** is the named pattern for role assignment specifically: model "plays a role" as its own linked assignment construct, not as a subclass of the role-player. **gist's "Assignment" pattern** (Semantic Arts) is a production-tested instance of exactly this — task assignment, pay-rate assignment, and supervisor assignment are all modeled as relationship/assignment constructs, never as rigid subclasses of the person holding them. **Silverston's effective-dated role/classification-assignment pattern** is a temporal-aware worked instance of the same idea: a person's assignment to a role is dated and reified, without ever making the role (e.g., "Manager") a subclass of the role-player (e.g., "Person").

Two further patterns worth naming:

- **Prescriptive template vs. bearer-side realization.** A role, position, or seat and its current occupant are two different entities linked by an explicit event, not one entity with two states. A position can legitimately persist unoccupied, with obligations arising only when someone takes it up (a "concretization" event); relationships conferred "by virtue of holding" a seat (e.g., ex-officio membership) should attach to the seat itself, with the current holder derived from occupancy — so succession happens automatically rather than requiring the relationship to be re-asserted per person. This sharpens the placement-by-stability rule above: the seat changes less often than its occupant, so facts really about the seat belong on it.
- **Stakeholder-relative facts as an explicit position/perspective tuple.** When a fact (a target, a valuation, a goal) legitimately differs by whose perspective it's asserted from, model it as a tuple keyed by the holder of that perspective, not as a direct property of the shared node it's about — otherwise the same node can't honestly carry two parties' disagreeing positions on it at once.

## Quantities and measurements

Model a measured value as value + unit + quantity kind, explicitly (QUDT and OM are the established vocabularies) — never a bare number with its unit implied by convention. Where the measuring act itself matters, distinguish the observation (the act, with its time, method, and instrument) from its result — SOSA/SSN's core distinction. Note that an observation is a *reported* fact with a source, so a model carrying many of them is a common trigger for the statement-layer extension (`statement-and-provenance.md`); a model carrying a few stable measurements usually is not.

## Verbalization check (ORM)

Before minting any relation, read it back as a plain sentence to a domain expert — e.g., "Every Employee works for exactly one Department, at a time" — and check they recognize it as both true and complete. This is cheaper and more specific than a competency question, and it catches cardinality and wording errors immediately rather than after the fact. Halpin's Object-Role Modeling formalizes this as part of its Conceptual Schema Design Procedure: verbalize the candidate fact, populate it against small example data sets (including deliberately-chosen edge cases), then refine — the same "test against real instances" discipline as core process step 5, applied one relation at a time, earlier.

## Declaring the grain (for event/fact-like classes)

For any class that represents an event, transaction, or measurement — not a stable entity — state explicitly and precisely what one instance represents, at the most atomic level possible, before defining its properties (Kimball's "declare the grain" discipline). Never let a fact-like class silently mix grains (e.g., one row sometimes meaning a single transaction, sometimes a daily total) — this is a sharper, fact-class-specific version of the decomposition test above, and it pairs naturally with the action-candidate hook in `SKILL.md`: an action's effect is usually exactly one grain-declared fact being appended.

## Phrase the differentia as an answerable question

When writing the differentia that distinguishes a subclass from its siblings (the genus-differentia definition used in the change-request template, see `templates.md`), phrase it as an answerable yes/no question, not just a descriptive clause. A distinguishing question doubles as the operational test for classifying new candidates and for later deciding whether two variants should merge — a descriptive clause has to be reinterpreted each time; a question can just be asked. For the full definition-writing discipline — necessary vs. sufficient conditions, the substitutability test, primitives and elucidations, and the label/definition/scope-note/example separation — see `definitions-and-documentation.md`.

## Naming

Name a construct for its most general case, not its first example, and rename decisively once a broader instance appears rather than patching around a name that's become too narrow. A vague or misleading name ("the misnomer") is a documented, common failure mode in its own right — see `evaluation-and-anti-patterns.md`.
