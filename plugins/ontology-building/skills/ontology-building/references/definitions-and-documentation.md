# Definitions and documentation

Writing the definition is where most of an ontology's real work happens: a class is only as useful as the boundary its definition draws, and Gruber's clarity criterion (`evaluation-and-anti-patterns.md`) lives or dies here. This is also the direct remedy to the **Center-of-Excellence Ontology** anti-pattern (`scale-and-governance.md`) — a model non-specialists can't use without an ontologist as translator usually has structurally fine classes and unusable definitions.

## The standard form: genus and differentia

Define a term by naming its **genus** (the parent it specializes) and its **differentia** (what distinguishes it from every sibling under that parent):

> *An X is a [parent] that [differentia].*

Two disciplines make this work:

- **Match the definition to the asserted hierarchy.** If the definition's genus isn't the class's actual parent in the model, one of the two is wrong. This is a cheap, mechanical consistency check worth running across the whole model.
- **Phrase the differentia as an answerable question** (`hierarchy-and-structure.md`), so it doubles as the operational test for classifying a new candidate or deciding whether two variants should merge.

## Necessary vs. sufficient conditions

Be explicit about which you're stating:

- **Necessary** — everything of this kind has this property ("every Invoice has an issuer"). Supports validation and inference *from* membership.
- **Sufficient** — anything with this property is of this kind. Supports automatic classification *into* the class.
- **Necessary and sufficient** — both, which is what a full genus-differentia definition asserts, and what a reasoner needs to classify instances automatically.

Most working definitions state necessary conditions only. That's fine — but don't let a necessary-conditions-only definition be mistaken for a complete one; if two sibling classes have definitions that are both satisfied by the same instance, the differentia isn't doing its job.

## Rules for a usable definition

- **The substitutability test.** You should be able to replace the term with its definition in a sentence and preserve the meaning. If the result is nonsense or circular, the definition isn't one.
- **No circularity.** Don't define a term using itself, its own derivatives, or a chain that loops back (A via B via A). This is the circularity anti-pattern caught at the definition layer rather than the axiom layer.
- **Define what it is, not what it isn't.** Negative definitions ("a non-billable activity is one that isn't billable") carry no information and reopen the open-world problem — see the derived-complement rule in `hierarchy-and-structure.md`.
- **Avoid "is when" and "is where."** These smuggle in a category error: a class is rarely a time or a place. "A Default is when a borrower misses a payment" should be "A Default is a contractual state in which…".
- **Don't define by example alone.** Examples belong in their own field (below); a list of instances is not a boundary.
- **Don't restate the parent's properties.** The differentia should carry only what distinguishes this class from its *siblings* — inherited properties are already stated upstream (this is placement-by-stability applied to prose).
- **One sense per term.** If a definition needs "either… or…" to cover distinct meanings, you have two terms wearing one label — see the misnomer and overloaded-relation anti-patterns.
- **Readable without the model's internals.** A domain expert who has never seen the ontology should recognize the definition as describing the thing they know. Internal construct names belong in an appended trace, not the definition text — the same recognition test used for competency questions (`competency-questions.md`).

## Primitives and elucidations

Some terms genuinely cannot be defined without circularity — the root categories of any model bottom out somewhere. Don't fake a definition for these. Provide an **elucidation** instead: a clarifying description plus positive and negative examples, explicitly marked as an elucidation rather than a definition, so a reader knows the term is primitive by design and not by oversight.

## Separate the fields; don't collapse them into one prose blob

Each carries a different obligation, and mixing them is why documentation rots:

| Field | Holds | Changes when |
|---|---|---|
| **Label** | The human-readable name (see the naming checklist in `templates.md`) | The preferred term changes |
| **Definition** | The genus-differentia statement (or elucidation, for primitives) | The concept's boundary changes — a gated schema change |
| **Scope note / comment** | Usage guidance, boundary cases, what's deliberately excluded | Practice clarifies, without the boundary moving |
| **Examples** | Instances clearly in, and near-misses clearly out | New edge cases are encountered |
| **Editor note** | Internal reasoning, open questions, provenance of the decision | Anytime — it's working material, not consumer-facing |

Aim for a textual definition on the large majority of terms, not just the contested ones (the OBO Foundry's practice) — an undefined term is where two teams' divergent readings quietly take root.

## Documentation for consumers, not just for the builders

The internal artifacts in `process-and-governance.md` (rationale, requirements, decision register, corrections log) serve the people *building* the ontology. Consumers need their own, and they are not the same audience:

- **Domain experts** need definitions in their own vocabulary, worked examples, and a plain statement of what the model does and doesn't cover.
- **Developers/integrators** need the formal schema, identifier conventions, cardinality and constraint expectations, and versioning/deprecation policy.
- **AI agents** need retrievable, self-contained definitions per construct — an agent fetching a schema subset (`agent-actionability.md`) sees the definition and little else, so a definition that only makes sense alongside its neighbours will be misread.

At the model level, publish: a scope statement (in-scope, out-of-scope, deferred), entry points for a newcomer, and worked examples (`examples.md`). Treat the absence of these as an adoption risk, not a documentation chore — it is the mechanism by which the Center-of-Excellence failure actually happens.

## Definitions as an evaluation surface

Run the pragmatic-quality check (`evaluation-and-anti-patterns.md`) against definitions specifically: give a domain expert who didn't build the model a handful of definitions and a handful of instances, and ask them to classify. Misclassifications point at a weak differentia, not a slow reader.
