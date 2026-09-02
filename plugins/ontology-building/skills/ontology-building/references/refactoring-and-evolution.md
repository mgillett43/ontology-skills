# Refactoring and evolution

Changing the structure of a model that already exists and already has consumers. The governing stance, borrowed from Fowler: **refactoring is a sequence of small, individually-verified, behaviour-preserving transformations — not a rewrite.** You can refactor a model in whole, but do it in parts, with a consistency-and-coherence pass between each part.

## Contents

- Scope the refactoring
- Discover the triggers
- Trigger catalogue
- Order, group, sequence
- Named refactorings
- Breaking changes and the context map
- Deprecation policy
- Versioning, diff, and rationale

## Scope the refactoring

Pick the unit before you start, and make it the smallest one that contains the deficiency:

- **A sub-tree or region** — a branch of the hierarchy, or a governance region (`process-and-governance.md`).
- **A bounded context** — the natural unit when vocabulary is at stake, because it's the boundary within which one vocabulary holds (`scale-and-governance.md`).
- **A context seam** — a change to what crosses the boundary. Different risk class entirely; see breaking changes below.
- **The whole model** — legitimate, but execute it as an ordered series of the above, never as one transaction.

**Respect the boundary.** Within a bounded context, two constructs meaning nearly the same thing is a duplication defect worth resolving. *Across* contexts, it may be the design — DDD deliberately permits the same term to mean different things on either side of a mapped seam. Before "consolidating" apparent duplication across a boundary, apply the discriminator: divergence at a **deliberate, mapped** boundary is intended and should be left alone (fix the map, not the model); divergence at an **accidental, unmapped** boundary is a genuine defect. See `conflicts-and-precedence.md` for the full resolution.

## Discover the triggers

Three channels, run together rather than in sequence:

1. **The seeded deficiency** — the complaint that prompted the work. Take it seriously but don't stop at it; a reported symptom is usually one instance of a pattern.
2. **A sweep of the chosen region or sub-tree** for both *errors* (something asserted wrongly) and *omissions* (something the domain has that the model can't express). The anti-pattern catalogue in `evaluation-and-anti-patterns.md` is the checklist; graded competency questions surface the omissions.
3. **Connective-tissue review against adopted base ontologies** — walk the constructs in scope against the external standards you've adopted (`reuse-and-alignment.md`) looking for missed inheritance, a bespoke construct that duplicates a maintained term, an adopted term whose upstream definition has since moved, and alignment that has gone stale since the last version bump.

## Trigger catalogue

Fowler's "smells," for ontologies. Everything in `evaluation-and-anti-patterns.md` is a trigger; these are the *evolution-specific* ones that only appear in a model that has been alive for a while:

- **Definition drift** — the definition no longer matches how the construct is actually used or populated.
- **Genus mismatch** — a definition's stated parent is not the class's asserted parent.
- **Competency-question regression** — a CQ that was answerable is now deferred or a gap.
- **Unresolved tags accumulating** — action-candidates or statement-candidates flagged long ago and never converted or explicitly declined.
- **Stale external alignment** — an adopted standard has versioned forward; the mapping was never revisited.
- **Speculative generality** — a construct with no instances after several cycles, or a level of the hierarchy nothing bottoms out in.
- **Workaround pressure** — consuming systems repeatedly working around the same modelling decision. The strongest empirical signal available; treat it as evidence, not complaint.
- **A deferred item whose trigger has fired** — the named future condition recorded at deferral time has now occurred (`process-and-governance.md`).
- **Growth thresholds crossed** — a single subclass, or more than roughly a dozen flat siblings (`hierarchy-and-structure.md`).
- **Orthogonality violation** — a construct that properly belongs to a sibling context has been re-modelled locally, or a cross-cutting concern is homed in whichever context needed it first (`scale-and-governance.md`).

## Order, group, sequence

1. **Order the deficiencies.** Rank by severity (logical/taxonomic defects first — they're the hard floor), then by blast radius, then by how much other work each unblocks. Deficiencies that invalidate others should be resolved first.
2. **Identify candidate solutions within the model.** For each deficiency, name the specific refactoring(s) below that would resolve it, and what each would cost.
3. **Group them.** Cluster changes that touch the same constructs, need the same migration, or must land together to leave the model coherent. A group is the unit that ships.
4. **Work through the groups sequentially.** After each group: re-run the mechanical checks on the touched sub-tree *and its immediate neighbours*, re-run the affected competency questions, and run the consumer drift-check. This is the consistency-and-coherence pass; skipping it is how a refactoring turns into a rewrite.
5. **Never have two groups in flight at once** in the same region — you lose the ability to attribute a regression to a change.

## Named refactorings

**Construct-level:**

| Refactoring | Trigger |
|---|---|
| Extract Class | God Object; a class doing two jobs |
| Inline Class | Fails the decomposition test; composes from existing constructs |
| Extract Superclass | Repeated structure across siblings; >12 flat siblings |
| Collapse Hierarchy | A single subclass, or a level that adds nothing |
| Replace Subclass with Property | Subclass-vs-property test says populated-vs-empty |
| Replace Property with Subclass | Subclass-vs-property test says required-vs-forbidden |
| Extract Role | A rigid subclass that is really an anti-rigid role or phase |
| Reify Relation | The relation needs its own state, provenance, or interval |
| Dereify Relation | The state that justified reification now lives elsewhere |
| Split Overloaded Relation | One relation meaning structurally different things |
| Split Conflated Enum | Orthogonal axes collapsed into one value |
| Push Property Up / Pull Down | Placement-by-stability violated |
| Introduce Derived Property | A stored value that disagrees with its own inputs |
| Convert Class Tree to Concept Scheme | Curated judgment, not logical necessity (`formalism-and-semantics.md`) |
| Rename Construct | Name over-fitted to its first example |
| Adopt External Term | A bespoke construct duplicating a maintained standard |
| Add Temporal Rung | A fact needing history it doesn't carry (`temporality-and-change.md`) |
| Extract Action / Extract Statement Layer | Accumulated action- or statement-candidates coming due |

**Context-level (strategic):**

| Refactoring | Trigger |
|---|---|
| Split Bounded Context | One context has grown two vocabularies |
| Merge Bounded Contexts | Two contexts never actually diverged |
| Extract Shared Kernel | A genuinely common core being duplicated on both sides |
| Introduce Anti-Corruption Layer | Enabling move: insert translation *before* a risky upstream change, so the change becomes local |
| Convert Conformist to ACL | A downstream consumer is exposed to every upstream change |
| Relocate Cross-Cutting Concern | A general construct homed in the context that happened to need it first |
| Promote to Shared Module | A local construct now meets the multi-team adoption bar |

## Breaking changes and the context map

A breaking change is any change that would impact a system, team, or model that has adopted the ontology. Track them continuously *as you go* — not reconstructed afterwards — and report them as a consolidated set at the end of the refactoring.

The context map (`scale-and-governance.md`) classifies the risk directly:

| Seam relationship | What a change does | What's owed |
|---|---|---|
| Separate Ways | Nothing crosses | Nothing |
| Anti-Corruption Layer | Absorbed by the layer | Update the ACL; consumer unaffected |
| Customer-Supplier | Downstream breaks | Negotiation, advance notice, migration window |
| Conformist | Propagates directly into an unprotected consumer | Highest care; consider introducing an ACL first |
| Shared Kernel | Breaks both sides simultaneously | Joint agreement and coordinated release |

For each breaking change record: the construct, the seam it crosses, which consumers are affected (from the enumerated consumer graph), the migration path, and the deprecation window.

## Deprecation policy

- **Obsolete; don't delete.** Mark the construct deprecated, keep its identifier resolvable, and point forward — a direct replacement where one exists, or candidate replacements where the mapping isn't one-to-one.
- **Never reuse a retired identifier for a new meaning.** A redefinition substantial enough to change what the term denotes requires a new identifier, not an edit to the old one — the same discipline as append-and-supersede.
- **Announce before release**, not with it.
- **Run in parallel** through the migration window: old and new coexist, with the old marked.
- **Remove only when the enumerated consumer graph is clear** — and record the removal as a decision.

## Versioning, diff, and rationale

**Keep the ontology under source/version control.** This is a prerequisite, not a nicety: without it there is no diff, and without a diff the change description is someone's recollection.

Every refactoring produces two complementary descriptions of what changed, and both are needed:

1. **The mechanical diff** — what changed between version A and B, derived from version control, not written by hand. Classify each entry as breaking / additive / editorial.
2. **The rationale narrative** — *why* it changed, assembled from the notes carried inside the ontology files themselves (editor notes, decision-record IDs annotated on constructs, change-request references). This is why constructs should carry their decision IDs inline: it makes the narrative reconstructable rather than dependent on the person who made the change.

Version at document/module granularity only, never at term or region level (`process-and-governance.md`) — and bump according to the highest severity in the diff: any breaking entry makes the whole release breaking.
