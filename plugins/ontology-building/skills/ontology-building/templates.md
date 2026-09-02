# Templates and checklists

Copy the relevant template or checklist into your own working docs; these are structures, not prescriptive tools.

## Contents

- Competency question entry
- Decision record (register row)
- Ontology change request (schema-change instrument)
- Breaking-change register row
- Checklist: definition quality
- Checklist: attribute naming
- Checklist: attribute discovery at a node
- Checklist: per-entity category and relation sweep
- Checklist: reify or not
- Checklist: Build mode
- Checklist: Extend mode (impact-and-overlap review)
- Checklist: Review/audit mode
- Checklist: Refactor mode

## Competency question entry

```
ID: CQ-<n>
Question (stakeholder's own words): "..."
Construct trace (which classes/relations this exercises): [...]
Status: answerable-now | deferred | gap
  If deferred: resolved by <named build item or pending decision>
  If gap: no plan yet (explicit, tracked)
Executable check: <query/test that verifies "answerable-now", or "n/a">
```

## Decision record (register row)

```
ID: DEC-<n>
Date: <date>
Decision: <what was decided>
Alternatives considered and rejected: [<alt 1: why rejected>, <alt 2: why rejected>, ...]
Rationale: <why this one, tied back to competency questions / scope>
Confidence: <e.g., high | medium | low | provisional>
Accepted cost: <what this choice gives up, not just why it beat the alternatives>
Status: open | resolved | superseded
Supersedes / superseded by: <DEC-id or none>
```

## Ontology change request (schema-change instrument)

```
ID: OCR-<n>
Type of change: <new class | new relation | modify existing | deprecate | ...>
Target construct(s): <...>
Definition (genus-differentia — phrase the differentia as an answerable yes/no question, see hierarchy-and-structure.md): "<X> is a <parent>, distinguished by: <differentia, phrased as a question>"
Identity criteria (if a class): <how instances are told apart / re-identified>
Relations affected (typed): [<relation: domain -> range>, ...]
Motivating competency questions: [<CQ-ids that require this>]

Adequacy check (all four must pass before merge):
  1. Motivating CQs now answerable: <yes/no + evidence>
  2. Consistent with standing commitments: <yes/no + what was checked>
  3. Passes category-discipline checklist (is-a litmus, rigidity, subclass-vs-property): <yes/no>
  4. Does not license false inference: <yes/no + what was checked>

Migration / impact: <what breaks, what needs updating downstream, drift-check consumer list touched>
Action-candidate? <yes/no — if yes, see references/agent-actionability.md>
```

## Breaking-change register row

Recorded *as the change is made*, not reconstructed at the end. See `references/refactoring-and-evolution.md`.

```
ID: BC-<n>
Construct(s): <what changed>
Change: <old shape → new shape>
Severity: breaking | additive | editorial
Seam crossed: none (internal) | separate-ways | anti-corruption-layer | customer-supplier | conformist | shared-kernel
Consumers affected: [<from the enumerated consumer graph>]
Migration path: <what an adopter must do>
Deprecation window: <announced on / parallel-run until / removable after>
Decision ref: <DEC-id or OCR-id>
```

## Checklist: definition quality

Run per construct as it's minted. Full discipline in `references/definitions-and-documentation.md`.

- [ ] Stated as genus + differentia: "An X is a [parent] that [differentia]"
- [ ] The stated genus matches the class's actual asserted parent in the model
- [ ] Differentia distinguishes it from *every sibling*, and is phrased as an answerable question
- [ ] Passes the substitutability test (swap term for definition; meaning survives)
- [ ] Not circular — doesn't use the term, its derivatives, or a loop back through another definition
- [ ] States what it *is*, not what it isn't
- [ ] No "is when" / "is where" category errors
- [ ] Not defined by example alone (examples live in their own field)
- [ ] Doesn't restate properties already inherited from the parent
- [ ] One sense only — no "either… or…" covering two distinct meanings
- [ ] Readable by a domain expert who has never seen the model; construct names confined to a trace
- [ ] If genuinely primitive: marked as an **elucidation**, with positive and negative examples
- [ ] Label, definition, scope note, examples, and editor note are in separate fields, not one prose blob

## Checklist: attribute naming

Grounded in ISO/IEC 11179 metadata-registry naming conventions plus community practice (OBO naming principles, Palantir naming guidance).

- [ ] Name follows object-class + property + representation shape where useful (`personBirthDate`, not `dob`)
- [ ] Singular, concrete, one term per concept (no synonym drift — record aliases in the glossary, not as second names)
- [ ] No implementation/type encoding in the name (no `strAmount`, no `personTable`)
- [ ] Generic terms disambiguated (`monetaryValue`, not `value`; `effectiveDate` says *which* date — see the valid-vs-transaction-time rule in `references/temporality-and-change.md`)
- [ ] Booleans phrased as affirmative predicates (`isActive`, `hasChildren`) — never negative (`isNotCancelled`)
- [ ] Quantities carry explicit units (a unit property or one documented suffix convention, applied consistently — see the measurements pattern in `references/hierarchy-and-structure.md`)
- [ ] Named for the most general case, not the first example (`references/hierarchy-and-structure.md` naming rule)
- [ ] Relations read naturally in both directions (`worksFor` / `employs`), and their algebraic properties are declared (`references/evaluation-and-anti-patterns.md`, incomplete-relation-declaration)
- [ ] One casing/format convention across the whole model

## Checklist: attribute discovery at a node

Prompts to run against each candidate entity — assembled from Ontology 101's property categories, ORM's fact-based elicitation, and Kimball's needs-driven attribute selection.

- [ ] Classify each candidate: intrinsic / extrinsic-relational / part-whole / derived
- [ ] Verbalize each as a full fact sentence and read it back to a domain expert (ORM check)
- [ ] Lifecycle probe: what event creates this entity? what can change each attribute (→ action-candidate)? what ends or archives it (→ state, see `references/temporality-and-change.md`)?
- [ ] Needs-driven, not availability-driven: which CQ, report, or consuming application actually reads this attribute? (No motivating consumer → don't add it)
- [ ] Epistemic status of each: stipulated by us, or reported by a source? Any whose value could differ by source or be disputed → tag **statement-candidate** (`references/statement-and-provenance.md`)
- [ ] Quantity attributes: unit and quantity kind explicit
- [ ] Temporal rung chosen per attribute (static / current-only / effective-dated / bitemporal — `references/temporality-and-change.md`)
- [ ] Derivable attributes computed, not stored (core principle 3)
- [ ] Placement check: does this belong here, or on the parent/seat (placement-by-stability)?
- [ ] Identity contribution: part of the natural key? (Keep as property with uniqueness check — `references/formalism-and-semantics.md`)

## Checklist: per-entity category and relation sweep

Run inline as constructs are minted (ask only what changes a decision), or as a periodic pass over a region. Plain-language questions only — the formal crosswalk is in `references/categories-and-relations.md` and is for alignment work, not conversation.

For each entity in scope:

- [ ] **Is it a thing, or something that happens?** If it happens: grain declared, and participants named
- [ ] **What are the ways it *is*?** Attributes vs. anything needing its own history, measurement provenance, or identity
- [ ] **What can it do, or get treated as, without doing it now?** And which flavour — capability (goes away only if the thing changes), purpose (what it's *for*; survives malfunction), or role (contextual; goes away with no change to the thing)
- [ ] **When those get exercised, is there an event worth modelling?** If it changes the world → tag as action-candidate
- [ ] **Where is it?** Place modelled or labelled; located-in vs. part-of not conflated; part-of not overloaded across component / member / portion / stage / material
- [ ] **When is it true?** Temporal rung chosen; valid vs. transaction time stated
- [ ] **Is it *about* something?** Plain aboutness relation, or a full statement layer — don't reach for the heavier one by default

Log gaps rather than fixing inline during a sweep; order and group them before changing anything (`references/refactoring-and-evolution.md`).

## Checklist: reify or not

Consolidates the W3C n-ary-relations criteria, UFO's relator, and this skill's tests into one pass. Reify when any of 1–4 holds; don't when only 5–7 apply.

- [ ] 1. More than two genuine participants? → reify (N-ary Relation pattern)
- [ ] 2. The relation itself needs its own state — provenance, confidence, resolution status, effective dates? → reify (relator / fluent)
- [ ] 3. You need to refer to the relation itself — dispute it, supersede it, annotate it? → reify
- [ ] 4. Time-bounded validity (holds during an interval)? → reify with the interval on the reified construct, never timestamps on the endpoints
- [ ] 5. Only preserving history, and a general history/versioning mechanism already covers it? → don't
- [ ] 6. Only "conceptually separate" or colloquially named? → decomposition test; don't reify for a name
- [ ] 7. Your substrate supports edge properties (property graph)? → that may change the *encoding*, not the conceptual call — decide at the knowledge level first

## Checklist: Build mode

- [ ] Scope decided: consumers, bounded contexts, application-independence, agent consumption
- [ ] CQs and schema requirements elicited from stakeholders (not invented for them) and graded
- [ ] Reuse checked — adopt / map / decline recorded, borrow-first for base machinery
- [ ] Every class/relation passed: is-a litmus, sibling generality, subclass-vs-property, decomposition
- [ ] Every construct has a definition passing the definition-quality checklist
- [ ] Action-candidates and statement-candidates tagged; grain declared for event-like classes
- [ ] Temporal rung and OWA/CWA posture decided where relevant
- [ ] Instances populated; CQs executed as tests, not asserted
- [ ] Anti-pattern sweep run in catalogue order
- [ ] Decisions recorded with rejected alternatives and accepted costs

## Checklist: Extend mode (impact-and-overlap review)

- [ ] Precedent check: does the model already demonstrate the answer?
- [ ] Decomposition: does the candidate compose from existing constructs?
- [ ] Overlap: duplicative, intersecting, or overlapping scope, effect, or utility vs. existing elements — including sibling contexts (orthogonality)
- [ ] Blast radius classified (additive-optional / cardinality-touching / cross-context)
- [ ] OCR raised with the four-part adequacy check
- [ ] Consumer drift-check run, including consumers outside the ontology's own directory
- [ ] Version bumped at document/module granularity only

## Checklist: Review/audit mode

- [ ] Inventory: classes, relations, hierarchies, undocumented conventions
- [ ] Intent recovered: implicit CQs reconstructed from consumers/queries/docs; answerability graded
- [ ] Mechanical taxonomy pass: is-a litmus, rigidity, cycles, sibling generality, orphans, missing domains/ranges/disjointness
- [ ] Definition audit: undefined terms, circular/negative/"is when" defects, genus-vs-asserted-parent mismatches; consumer documentation present for each audience
- [ ] Anti-pattern sweep in catalogue order (taxonomic → structural → process → LLM-specific if applicable)
- [ ] Temporal/semantics audit: which date properties mean valid vs. transaction time; where closed-world assumptions are silent
- [ ] Findings report: severity-ranked, each mapped to a named test/anti-pattern, with remediation and blast radius

## Checklist: Refactor mode

- [ ] Unit scoped: sub-tree / region / bounded context / seam — the smallest that contains the deficiency
- [ ] Ontology is under source/version control (prerequisite — no diff without it)
- [ ] Triggers gathered from all three channels: seeded deficiency, region sweep (errors *and* omissions), connective-tissue review against adopted base ontologies
- [ ] Cross-context apparent duplication tested against the mapped/unmapped discriminator before consolidating anything
- [ ] Deficiencies ordered (logical defects first, then blast radius, then what each unblocks)
- [ ] Candidate refactorings named per deficiency, with costs
- [ ] Changes grouped into shippable units that leave the model coherent
- [ ] Groups worked sequentially — only one in flight per region
- [ ] Consistency-and-coherence pass after each group: mechanical checks on touched sub-tree *and neighbours*, affected CQs re-run, consumer drift-check
- [ ] Breaking changes recorded continuously in the register, classified by seam relationship
- [ ] Deprecations marked with forward pointers; no identifier reused for a new meaning
- [ ] Version bumped to the highest severity in the diff
- [ ] Both change descriptions produced: mechanical diff, and rationale narrative assembled from in-file notes
- [ ] Consolidated breaking-change report delivered at the end
