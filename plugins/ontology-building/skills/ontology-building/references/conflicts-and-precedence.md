# Conflicts and precedence

## Sources synthesized

- **Classical ontology engineering** — Stanford's "Ontology Development 101" (Noy & McGuinness) and the is-a/hierarchy discipline it popularized.
- **Formal theory** — Gruber's design criteria; Guarino & Welty's OntoClean and its UFO/OntoUML successors; METHONTOLOGY and related lifecycle methodologies; competency-question theory; Moody's conceptual-model quality framework; ontology design pattern libraries and pitfall catalogues such as OOPS!.
- **Enterprise/software conceptual modeling** — Domain-Driven Design; ER modeling; Halpin's ORM; Kimball/Inmon data-warehouse modeling; Silverston's universal data patterns.
- **Governance at scale** — the OBO Foundry; FIBO; Semantic Arts' gist.
- **Agent-facing platform practice** — Palantir's Foundry/AIP ontology model, the most mature public treatment of ontologies built for AI agents to read and act on; modern industrial-scale knowledge-graph and GraphRAG/LLM-agent practice.
- **A hard-won, production-tested governance process** — staged decision pipeline, artifact types, anti-pattern catalogue.

These converge on far more than they disagree on. Where they do appear to conflict, the rest of this document says whether it's a real conflict or just a framing/altitude difference, and which one to follow.

## 1. "No single correct ontology" (Gruber/Stanford) vs. objectively-named anti-patterns (OntoClean, Palantir)

**Apparent conflict:** Stanford 101 says the right model depends on the application, and there's no context-free correct answer. OntoClean and Palantir both name specific structures as simply wrong (a rigidity violation; a "God Object").

**Resolution — real, but not contradictory:** Logical/taxonomic correctness is **necessary but not sufficient**. It rules out a class of provably bad models (circularity, a role rigidly subclassed as a type, an enum smuggling two independent axes into one) regardless of the application. Among the models that pass that floor, purpose still decides which one to build. Treat correctness checks as a filter applied before the purpose-driven choice, not as competing advice.

**Priority:** Correctness first (non-negotiable), purpose second (the actual decision).

## 2. Deep is-a hierarchies (Stanford's hierarchy rigor) vs. Palantir's "composition over deep hierarchies"

**Apparent conflict:** Stanford 101 gives detailed rules for building valid, deep subclass trees. Palantir explicitly recommends against deep hierarchies in favor of interfaces/composition.

**Resolution — not actually opposed:** Palantir's guidance targets a specific failure mode that OntoClean explains formally: rigidly subclassing something that's actually a role or a phase (anti-rigid). Once you apply the rigidity test, "avoid deep hierarchy" and "hierarchy can be valid and deep" stop conflicting — they're answers to different questions ("is this specific is-a link valid" vs. "should is-a be your primary structuring device at all").

**Priority:** Run the is-a litmus test and rigidity check first. Where the concept is a role/phase, use composition/interfaces — the general engineering pattern Palantir also recommends, concretely instantiated by gist's Assignment pattern and UFO's Role/RoleMixin distinction (see `hierarchy-and-structure.md`) — instead of subclassing. Where it's a genuine rigid type, deep hierarchy following Stanford's rules is fine.

## 3. "Adopt a standard wholesale, never cherry-pick" (governance process) vs. "don't import everything a source offers" (Kitchen Sink, Palantir)

**Apparent conflict:** Looks contradictory on the surface — one says take the whole definition, the other warns against importing too much.

**Resolution — not a conflict, a combination:** Adopt-wholesale-within-scope (don't cherry-pick *fields off a class you've decided to adopt*, because that produces false partial equivalence) plus minimal-import discipline (don't import the *whole external ontology*, only the terms actually used plus minimal ancestry) are complementary, not competing. Cherry-picking is banned for a different reason (false equivalence) than over-importing (schema bloat). Do both disciplines together.

**Priority:** Neither overrides the other — apply both simultaneously (see `reuse-and-alignment.md`).

## 4. Reuse-is-good (Stanford's lightweight "consider reuse" step) vs. alignment-debt findings (academic literature) vs. strict adopt/map/decline discipline (governance process)

**Apparent conflict:** Stanford treats reuse as one light checklist item among seven. The literature documents real, ongoing costs (sparse mappings even between top-tier upper ontologies, version drift). The governance process treats every reuse decision as consequential and gated.

**Resolution — a maturity gradient, not a disagreement:** These read as three different levels of rigor applied to the same idea. The stricter treatment should win as the operational default — it's the one that's been stress-tested against real drift, not just theorized. The alignment-debt research supplies the *why* (and useful vocabulary: broad/narrow/close-match) rather than competing guidance. Stanford's lightweight version is best understood as the appropriate level of ceremony for a first pass, superseded once you actually commit to adopting something.

**Priority:** Governance-process discipline (strict, gated) as the default; academic alignment-debt findings as the justification; Stanford's "consider reuse" as the entry point, not the final word.

## 5. TypeScript/three-layer encoding alignment (seen in existing code-modeling skills) vs. minimal encoding bias (Gruber)

**Apparent conflict:** Aligning a concept across a type system, a runtime validator, and a storage schema simultaneously (useful for AI coding agents) looks like it locks the concept to a specific encoding, which Gruber's minimal-encoding-bias criterion warns against.

**Resolution — a scope question, not a real conflict, given this skill's chosen scope:** This skill is deliberately domain-agnostic (not tied to any one output format), so the conceptual model should be defined independent of any encoding, and *then* projected into whichever encodings are needed (types, runtime checks, storage constraints, OWL, a Palantir-style object model, etc.) — never the reverse. The risk Gruber's criterion flags is real whenever a project skips straight to one encoding and lets its shape become "the model." Multiple simultaneous encodings are fine; encoding-first modeling is not.

**Priority:** Define the concept first (knowledge level); derive every encoding from it; never let one encoding's constraints silently become the definition.

## 6. Schema-informed discovery (bottom-up evidence) vs. minimal encoding bias

**Apparent conflict:** Leading with an existing/target schema to discover candidate structure (`schema-informed-discovery.md`) looks like exactly what Gruber's minimal-encoding-bias criterion warns against — letting a physical encoding shape the concept.

**Resolution — not a conflict once the roles are kept distinct:** Minimal encoding bias is violated when a *chosen* encoding's incidental shape becomes the definition (encoding-first modeling — see conflict 5 above). Schema-informed discovery is different in kind: it treats an *existing* schema as empirical evidence about real-world structure (a bottom-up input, per Noy & McGuinness), which still has to pass through competency questions, the decomposition test, and a decision record before anything is accepted — exactly the same gates any other candidate passes through. The failure mode both share is the same one: accepting a physical constraint (e.g., `NOT NULL`) as proof of a conceptual fact without independent justification. Guard against that specifically, rather than avoiding schema evidence altogether.

**Priority:** Schema observations are always downgraded to hypotheses, never treated as conclusions, regardless of how authoritative the source system appears.

## 7. OBO Foundry orthogonality vs. "borrow before invent" (`reuse-and-alignment.md`)

**Apparent conflict:** none, really — orthogonality (don't re-model a concept a sibling ontology/team already covers) can sound like a separate rule from "borrow before invent," but it's the same instinct scaled from "reuse an external standard" to "reuse a sibling team's in-house sub-ontology." **Priority:** treat it as a corollary, not a competing rule. See `scale-and-governance.md`.

## 8. DDD bounded contexts vs. the single-pipeline governance assumption

**Real, but it's a missing decision point, not a contradiction to rank.** `process-and-governance.md`'s gate pipeline (one decision register, one enumerated consumer graph, one one-way authority flow) implicitly assumes a single ontology. DDD's claim: for large or multi-team domains, unifying everything into one model isn't feasible or cost-effective — several bounded, independently-coherent models connected by explicit translation is the right unit. **Resolution:** decide bounded-context boundaries first (`SKILL.md` step 1), then run the full process once per context, governed by a context-map artifact for the seams. See `scale-and-governance.md`.

## 9. GraphRAG's emergent, LLM-clustered schema vs. competency-questions-first design (core principle 1)

**Real conflict**, at the level of "how do you get a schema at all." GraphRAG-style construction (LLM extracts entities/relations from text, then clusters them with no predefined schema and no CQ grounding) produces a working schema without ever asking what questions it needs to answer. **Priority:** the CQ-first, gated design in this skill wins whenever the resulting model needs to be reused, governed by more than its original builder, or written back to. GraphRAG's emergent approach is legitimate but should be scoped narrowly — question-answering over a largely static, narrative corpus — not adopted as a general substitute. See `llm-assisted-construction.md`.

## 10. Deferred/runtime entity resolution vs. the System Silos anti-pattern

**Apparent, not real — different altitude.** System Silos (`evaluation-and-anti-patterns.md`) is a schema-*type*-level rule: don't mint a separate entity type per source system for the same real-world thing. Deferred entity resolution is an algorithmic/runtime rule: don't force a canonical *instance*-level identity assignment before enough context exists to do it correctly — an ambiguous mention can stay unresolved, or multiply-resolved, until query time. **Both hold simultaneously**: one entity type, resolved lazily at the instance level.

## 11. Orthogonality (don't duplicate across contexts) vs. bounded contexts (divergence is legitimate)

**Real conflict, and it bites hardest during refactoring.** OBO-style orthogonality (`scale-and-governance.md`) says: don't re-model a concept a sibling context already covers — reuse or extend theirs. DDD says the opposite is often correct: the same term legitimately means different things on either side of a boundary, and forcing unification isn't cost-effective. A refactoring pass hunting for "duplicative or overlapping scope" under the orthogonality rule alone will try to merge two contexts' divergent `Customer` classes — exactly the unification DDD warns against.

**Resolution — the boundary is where orthogonality stops applying.** Orthogonality governs *within* a single vocabulary space: one bounded context, or a shared kernel. It does not reach across a context seam. The discriminator is whether the divergence is **deliberate and mapped** (a named context-map relationship exists — leave the models alone; if anything is wrong, it's the map) or **accidental and unmapped** (nobody decided these should differ — a genuine defect, resolve it).

**Priority:** Within a context, orthogonality wins. Across a mapped seam, bounded-context autonomy wins. Where no map exists, that absence is the first defect to fix — decide the seam before touching either side. See `refactoring-and-evolution.md`.

## 12. A note on attribution, not methodology

Some existing packagings of Stanford 101 (e.g., code-modeling skills built on it) attribute Gruber's five design criteria directly to Noy & McGuinness's 2001 paper. That paper doesn't itself enumerate those five criteria — they come from a separate Gruber paper on ontology design (1993/95). This isn't a methodological conflict, just a citation to get right if referencing prior packagings of this material.
