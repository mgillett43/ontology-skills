# Reuse and alignment

When and how to build on existing standards/vocabularies rather than inventing from scratch — and how to avoid the two failure modes that dominate this area: importing too much, and asserting false equivalence.

## Borrow before invent — but adoption is consequential

Default to reusing a mature standard's class when one genuinely covers the concept. Treat divergence as the argued exception, decided class-by-class, never adopted-or-rejected wholesale for an entire external ontology.

The key discipline: **once you adopt an external class, you adopt its actual definition — not a cherry-picked subset of it.** If you only want part of what a class means, that's a sign you should be mapping to it (see below), not adopting it.

## Minimal-import discipline (MIREOT-style)

Reuse does not mean importing an entire external ontology. Import only:
- the specific terms actually used, and
- the minimal ancestry needed for those terms to remain well-formed in isolation.

This is what prevents the "Kitchen Sink" anti-pattern (see `evaluation-and-anti-patterns.md`) from re-entering through the back door of reuse — a full import of a large external standard tends to drag in structure and properties that have no motivating competency question in your ontology.

## Mapping vs. adopting

When a concept in your domain is *related to but not identical with* a class in an external standard, map it — don't assert equivalence.

- Use graded match relations (e.g., broad-match, narrow-match, close-match — SKOS-style), never a blanket "same-as," when there's any acknowledged divergence.
- **Never assert identity across a granularity mismatch.** If an external taxonomy's category spans several genuinely distinct categories in your domain (or vice versa), forcing a 1:1 correspondence either loses real distinctions or imports false precision. Route the actual comparison through an explicit crosswalk that records the mismatch, rather than pretending the tiers line up.
- Reused *labels* (the words) are fine to reuse freely. Reused *identifiers* (asserting this-is-that) are not, unless the definitions genuinely coincide.

## Why this matters more than "reuse is generally good"

The literature is right that reuse eases interoperability, but it understates a real cost: alignment between even two of the most prominent, well-maintained foundational ontologies (BFO and DOLCE) achieves only partial clean mapping in one direction and is sparse, and mappings go stale as source ontologies version forward. Treat any adopted or mapped external reference as something that will need maintenance, not a one-time decision:

- Record every reuse/mapping decision explicitly (in the imports/mapping register — see `process-and-governance.md`), including which class was adopted vs. merely mapped, and why.
- Expect to revisit mappings when either side of the mapping changes version.
- Budget for this maintenance cost when deciding whether to reuse a large, actively-evolving external standard versus a small, stable one.

## Pattern-level reuse — a lighter-weight tier

Reusing a small, well-established modeling pattern is a different, lighter decision than adopting or mapping to a whole external ontology/standard (the sections above) — there's no external identifier space to keep synchronized, so it doesn't carry the alignment-debt risk described above. Two credible sources:

- **Content Ontology Design Patterns** (ontologydesignpatterns.org) — small, logically-sound fragments solving one recurring problem each (participation, role assignment, part-whole, n-ary relations, information object vs. its carrier — a content/medium distinction, distinct from core principle 4's stipulated-vs-reported distinction, though both separate "the thing" from something else about it). See `hierarchy-and-structure.md`'s reification/role-assignment section for the specific patterns most relevant here (N-ary Relation, AgentRole/ObjectRole, UFO's Relator, Silverston's effective-dated assignment pattern).
- **Silverston's universal enterprise data patterns** (the Data Model Resource Book) — proven conceptual shapes for common business concepts (Party-Role, Product, Order), reusable as a modeling idiom rather than a shared identifier space. Its effective-dated classification/assignment pattern is covered in `hierarchy-and-structure.md`'s reification section, alongside the other named patterns.

Pattern-level reuse is still gated by the decomposition test (`hierarchy-and-structure.md`) — a pattern earns its use by fitting a real competency question, not by being well-known. Applied reflexively rather than because the decomposition test actually calls for it, this tier can still become a backdoor Kitchen Sink.

## Borrow-first for base machinery

For upper-level/base needs that nearly every ontology has, the bias should be strongly toward adoption over invention — these are solved problems with maintained W3C/community vocabularies, and inventing here is almost always waste: **time** (OWL-Time: instants, intervals, Allen's interval relations), **provenance** (PROV-O), **quantities and units** (QUDT, OM), **observations/measurements** (SOSA/SSN), **organizations and membership** (W3C ORG), **concept schemes and mappings** (SKOS). The minimal-import discipline above still applies — adopt the terms you actually use plus minimal ancestry, never the whole vocabulary. See `temporality-and-change.md` for the time vocabularies and `statement-and-provenance.md` for the provenance ones — noting that PROV is only needed if that extension applies at all.

## Framework pluralism: model the axis once, treat named frameworks as lenses

When multiple named external frameworks each carve up the same underlying phenomenon differently, don't mint a class per framework. Find the common underlying axis, model it once, and treat each named framework as a mapping or lens onto that one vocabulary — this avoids a combinatorial explosion of near-duplicate classes that all really mean the same small set of things.

## Reconcile, don't just let coexist, when two adopted frameworks dual-type the same construct

Adopting more than one external framework (each independently idiomatic and independently adopted) can leave a single construct legitimately typed by both, when the frameworks weren't designed to align with each other. Don't let this sit as silent, assumed compatibility — state the intended reconciliation explicitly on the construct itself (what each typing means here, and how they relate), rather than leaving readers to assume the two frameworks agree.

## The three-part reuse-rejection checklist

When rejecting an external standard's class as a candidate for reuse, name which of three mismatches caused the rejection: a **category** mismatch (it's not really the same kind of thing), a **differentia** mismatch (it's distinguished from its siblings on a different basis than your domain needs), or a **granularity** mismatch (see above — its tiers don't correspond level-for-level to yours). Naming which one applies makes the rejection reviewable later, rather than a bare "doesn't fit."

## When bespoke beats reuse

Build your own construct instead of reusing/mapping when:
- No existing standard's definition survives the decomposition test (see `hierarchy-and-structure.md`) for your actual competency questions.
- The available external candidates differ from your domain's real distinctions at a granularity that can't be honestly bridged with graded mapping relations.
- The external standard is unmaintained or has no realistic path to staying aligned over the ontology's expected lifetime.
