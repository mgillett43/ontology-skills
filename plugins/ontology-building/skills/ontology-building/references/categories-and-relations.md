# Categories and relations

A small set of questions that catch the modelling mistakes people make most often — asked in plain language, about one entity at a time.

Underneath, these questions come from the top-level distinctions used by foundational ontologies (BFO in particular). **You do not need that vocabulary to use this file, and neither does the person you're working with.** The formal names are in the crosswalk at the end, for when you're aligning to an upper ontology and need them. Everywhere else, ask the plain question.

## How to coach with this

**Two rhythms, both valid:**

- **Inline** — as each construct is minted (core process step 4). Ask only the questions that would change what you build. Most entities need two or three, not all seven.
- **As a periodic pass** — a sweep over a region or sub-tree, asking all seven of each entity and logging the gaps. Good as part of Review mode, or after a burst of accretive growth. Checklist in `templates.md`.

**Rules for the conversation:**

- Ask the plain question. Never make someone learn a term of art to answer you.
- Ask because the answer changes a decision — not to be thorough. An unanswered question that changes nothing is noise.
- If the person you're working with uses the formal vocabulary first, match them; they've told you they want that register.
- Where a case is genuinely ambiguous, say so, recommend one, record why, and move on. Some of these boundaries are contested in the literature — burning an afternoon on one is a worse outcome than a recorded, revisable call.

## The seven questions

### 1. Is this a way the thing *is*?

Its mass, its colour, its temperature, its credit rating. Something that can't float free of the thing it belongs to.

Usually this is a plain attribute — don't over-build. Give it its own construct only when you need to track it *independently*: its history over time, who measured it and how, or its own identity apart from the thing. If it's measured, model value + unit + kind explicitly (see `hierarchy-and-structure.md`).

### 2. Is this something the thing *can do*, or *is treated as*, without doing it right now?

A latent capability, a purpose, or a hat it wears. Three flavours, and the difference matters because they behave differently over time:

- **Could it stop being true only if the thing itself physically changed?** → a capability or tendency. Fragile, soluble, load-bearing.
- **Is it what the thing is *for* — by design, or by how it came to be?** → a purpose. Note that a purpose survives failure: a broken pump is still *for* pumping. If your model needs to say something is malfunctioning, you need this separate from the capability.
- **Is it true only because of a situation, agreement, or context — and could stop without the thing changing at all?** → a role. Customer, trustee, escalation owner.

Roles are the common case and the common error: they get modelled as permanent subtypes of the thing that plays them. Use a role-assignment construct instead (`hierarchy-and-structure.md`). The capability/purpose/role boundary is genuinely contested in the literature — if a case sits on the line, pick, record, move on.

### 3. Is this a *thing*, or something that *happens*?

The single most useful question in the set, and the one most often skipped. Things persist and change; happenings unfold over time and have parts in time. Mixing them in one hierarchy — an "Order" that is sometimes the document and sometimes the ordering — is a reliable source of confusion downstream.

If it happens: say precisely what one instance covers, at the most atomic level useful (declare the grain, `hierarchy-and-structure.md`), and ask **who or what takes part in it, and in what capacity**. Participants are usually the interesting query path, and they're easy to leave implicit.

### 4. When that capability or role is actually exercised, is there an event worth modelling?

The bridge from question 2 to question 3. A role held is one thing; the role being *acted on* is another. If the exercise has consequences you need to query, audit, or govern, it's an event — and if it changes state in the world, it's an **action-candidate** (`SKILL.md` step 4, `agent-actionability.md`).

### 5. Where is it — and is "where" a real thing in your model, or just a label?

Places are frequently under-modelled: a text field that should be a construct, or a construct minted where a label would do.

Then the distinction people get wrong: **being located somewhere is not the same as being part of something.** A patient in a ward is located in it; a ward in a hospital is part of it. Conflating them produces false inferences — most obviously, location doesn't reliably pass upward the way parthood does.

While you're here, check how parts actually work for this thing, because "part of" hides several different relations: a component in an assembly, a member in a collection, a portion of a mass, a stage in a process, material something is made of. They behave differently — component-of chains through several levels, member-of usually doesn't. If you're using one relation for more than one of these, split it (`evaluation-and-anti-patterns.md`, overloaded relations).

### 6. When is this true?

Always, or only over some stretch? Pick the lightest temporal treatment that answers a real question, and be explicit about whether a date means *when it was true in the world* or *when you recorded it* — see the four-rung ladder in `temporality-and-change.md`.

### 7. Is this *about* something else?

A record, a report, a measurement, a rating — things whose whole point is to refer to something beyond themselves.

Two separate questions hide here, and conflating them is common:

- **Aboutness** — what is this a record *of*? Often just a relation to the subject, and often all you need.
- **Assertion** — who claimed it, when, how confidently, and can rival claims coexist? That's the statement layer, and it's a heavier commitment (`statement-and-provenance.md`).

A document can be about a patient with nothing contested and no provenance question at all. Don't reach for the statement layer when a plain aboutness relation is what's needed.

## Crosswalk to formal vocabulary

For alignment work only. If you're adopting BFO or a BFO-aligned ontology (`reuse-and-alignment.md`), these are the terms the questions correspond to.

| Question | Formal relation | Categories connected |
|---|---|---|
| 1. A way the thing is | `inheres in` / `bearer of` | quality → independent continuant |
| 2. Can do / treated as | `inheres in` | realizable (role, disposition, function) → independent continuant |
| 3. Thing vs. happening | `participates in` / `has participant` | continuant ↔ occurrent |
| 4. Exercised | `realizes` / `is realized in` | realizable → process |
| 5. Where | `located in`, `occupies spatial region`; `has continuant part` | material entity → site / spatial region |
| 6. When | `exists at` | entity → temporal region |
| 7. About | `is about` (IAO) | information content entity → entity |

Terminology notes: BFO 2020 treats **function** as a kind of **disposition** (both internally grounded in the bearer's physical make-up), with **role** externally grounded in context — a bearer can lose a role without changing physically. Some authors argue functions are better treated as externally grounded too, since a malfunctioning thing keeps its function while losing the corresponding disposition; and the role/disposition line has been argued to collapse in some domains. Treat the trichotomy as a useful working distinction, not a settled one.
