# Worked examples (placeholders)

Worked examples are a first-class artifact of this methodology (see `references/process-and-governance.md`): each one serves simultaneously as a regression fixture, documentation, and a legibility aid explaining *why* a construct exists and *what error it prevents*. This file holds the skeleton each example should follow, plus slots to be filled with real (or realistic, anonymized) examples as the skill is used on actual projects.

## Skeleton — what a complete worked example contains

1. **Domain snapshot** — two or three sentences; enough context to read the rest, no more.
2. **Competency-question excerpt** — 3–5 CQs in stakeholders' own words, each with status (answerable-now / deferred / gap) and its executable check.
3. **Schema-requirement excerpt** — 1–2 binding requirements (materialization target, integration shape), graded the same way.
4. **Model sketch** — the handful of classes/relations involved, with the concept-scheme vs. class-hierarchy call made explicit where it arose.
5. **Decisions illustrated** — filled decision records (see `templates.md`) for at least: one subclass-vs-property call, one reify-or-not call, one borrow-vs-invent call, and one action-candidate tag — each including the accepted cost.
6. **Checks run** — which mechanical tests and anti-pattern sweeps were applied, and what (if anything) they caught.
7. **The error this example prevents** — the single most instructive wrong turn the example exists to inoculate against.

## Example slots

### Example 1: <small green-field build — placeholder>

*To be filled from a real Build-mode run: a compact domain (e.g., a lending library, a conference programme) taken through all seven process steps.*

### Example 2: <extension under constraint — placeholder>

*To be filled from a real Extend-mode run: adding a construct to an existing model, showing the impact-and-overlap review, the OCR with its four-part adequacy check, and a conflict between a CQ and a binding schema requirement being surfaced rather than silently resolved.*

### Example 3: <review/audit of an undocumented model — placeholder>

*To be filled from a real Review-mode run: recovering implicit competency questions from an existing schema, the mechanical taxonomy pass, and a severity-ranked findings report.*

### Example 4: <refactoring a live model — placeholder>

*To be filled from a real Refactor-mode run: a seeded deficiency expanded into a trigger set, deficiencies ordered and grouped, two or three named refactorings applied in sequence with a consistency pass between them, and a consolidated breaking-change report classified by seam relationship.*
