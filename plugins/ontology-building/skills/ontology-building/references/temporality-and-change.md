# Temporality and change

When and how to model time, evolution, and state mutation. Temporal machinery is among the most expensive things to retrofit and the easiest to over-build — so this file is organized around choosing the *least* temporal structure each fact actually needs.

## Borrow the temporal substrate, don't invent it

Time is the most solved of all base-modeling problems. Default to the established vocabularies rather than inventing: **OWL-Time** for instants, intervals, and interval relations (Allen's interval algebra: before/meets/overlaps/during/etc.), **PROV-O** for the provenance of change (who changed what, when, derived from what). See `reuse-and-alignment.md`'s borrow-first shortlist. Minimal-import discipline still applies — adopt the terms used, not the whole vocabulary.

## The temporal decision ladder — per fact, not per model

Decide temporality fact-by-fact (property-by-property, relation-by-relation), choosing the lowest rung a competency question actually requires — this is minimal commitment applied to time:

1. **Static.** Genuinely immutable once asserted (a birth date, a founding date). No temporal machinery; corrections flow through the governance layer's append-and-supersede.
2. **Current-value-only.** Mutable, but no competency question needs history (a contact phone number). A plain property; the governance/audit layer already records who changed it and when.
3. **Effective-dated.** History matters: reify the fact with valid-from/valid-to (Silverston's effective-dated assignment pattern, `hierarchy-and-structure.md`). The default rung for assignments, prices, statuses whose past values answer real questions.
4. **Bitemporal.** You must answer both "what was true at time T" *and* "what did we believe at time T" — valid time and transaction time tracked independently (Snodgrass's temporal-database work; standardized in SQL:2011). Required where retroactive corrections must be auditable (regulatory, financial, legal domains). Note: append-and-supersede (`process-and-governance.md`) already gives you transaction time at the governance layer — bitemporality means *also* carrying valid time on the facts themselves.

## Valid time vs. transaction time — principle 4, applied to time

*When was it true in the world* (valid time) vs. *when did we record or believe it* (transaction time) is the temporal form of core principle 4's stipulated-vs-reported discipline. Never conflate them in one timestamp, and name which one every date property means — a bare property called "date" is the misnomer anti-pattern in its most common costume (`evaluation-and-anti-patterns.md`). Note that rung 4 (bitemporal) usually implies the statement-layer extension is in play; see `statement-and-provenance.md`.

## State mutation

- **Status attribute vs. first-class state machine.** A plain status enum suffices while transitions are unconstrained. The moment transitions carry rules ("only approved orders can ship"), side effects, or permissions, model the state machine explicitly: enumerate the states (a closed partition — a deliberate closed-world act, see `formalism-and-semantics.md`) and the allowed transitions. Each governed transition is precisely an **action-candidate** (`SKILL.md` step 4 hook) — in the agent-actionability extension, an Action *is* a governed state transition with validation and audit.
- **Event history vs. mutable state.** Where change itself is the signal, prefer an append-only event/observation log as the substrate with current state as a derived, materialized read-model (`schema-informed-discovery.md`'s substrate/read-model split) — deriving current state from events honors "one fact, one place"; storing both invites the stored value disagreeing with its own inputs.
- **Phases.** A thing moving through life-cycle phases (candidate → active → retired) is one individual whose anti-rigid phase changes — an OntoClean phase, not N classes for one thing and not N successive individuals (`hierarchy-and-structure.md`).

## Time-varying relationships (fluents)

A relationship that holds *during an interval* (employment, ownership, membership) is the standard case for reification: the reified relation carries the validity interval (the N-ary Relation pattern plus effective dates — rung 3 above). Do not instead timestamp the two endpoints and hope their dates correlate — the interval is a fact about the *relationship*, and it has exactly one home.

## What not to temporalize

- Any fact on rung 1 or 2 that gets rung-3/4 machinery "just in case" — temporal reification multiplies joins, constructs, and cognitive load; unneeded rungs are over-modeling.
- **The schema's own history.** Versioning the model is the governance layer's job (`process-and-governance.md`: version bumps, append-and-supersede, drift checks) — don't build schema-history constructs *inside* the domain model itself.
- Where a statement layer exists (`statement-and-provenance.md`), its timestamps duplicate nothing here: when-asserted/when-retracted lives on the statement (transaction-time-like), when-true-in-the-world lives on the subject (valid-time-like). Keep them on their own layers.
