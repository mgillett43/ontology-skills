# ontology-building

A domain-agnostic methodology, packaged as an [Agent Skill](https://code.claude.com/docs/en/skills), for **building, extending, reviewing, and refactoring** ontologies, domain models, taxonomies, and knowledge-graph schemas.

It is deliberately independent of what you encode the result in — OWL, a property graph, a relational schema, typed code, or a platform object model. The methodology decides *what should exist and why*; the encoding comes after.

## Why this exists

Guidance on ontology design is scattered across lineages that rarely talk to each other: the classical knowledge-representation literature, formal ontology theory, enterprise conceptual modelling, large-scale multi-team ontology governance, and — more recently — the practice of building models that AI agents read and act on. They agree more than they disagree, but where they disagree, most write-ups quietly pick a side.

This skill synthesises them into a single process and, where they genuinely conflict, says so explicitly and gives a precedence rule. `references/conflicts-and-precedence.md` documents twelve such conflicts and their resolutions.

## What's in it

Four **operating modes** — Build, Extend, Review/audit, and Refactor — over a common seven-step process, plus:

- **Competency-question scoping**, with schema/system requirements treated as a peer input rather than an afterthought
- **Mechanical tests** for the hard calls: is-a litmus, subclass-vs-property, decomposition, taxonomy-artifact, reify-or-not
- **OntoClean grounding** (identity, rigidity, unity, dependence) for hierarchy disputes
- **Definition-writing discipline** — genus-differentia, necessary vs. sufficient conditions, the substitutability test, elucidations for primitives
- **A consolidated anti-pattern catalogue** drawn from academic, practitioner, and production-governance sources
- **Two conditional extensions**, each with a cheap hook in the base process so neither is expensive to retrofit: agent-actionability (governed actions, retrieval design) and statement/provenance (when sources disagree)
- **Situational guidance**: open- vs. closed-world semantics, class hierarchy vs. concept scheme, temporality and change, bounded contexts and multi-team governance, schema-informed discovery, LLM-assisted construction
- **A Fowler-style refactoring catalogue** — 25 named refactorings with triggers, breaking-change classification by context-map seam, deprecation policy
- **Copy-ready templates and checklists** for every mode

Everything lives behind progressive disclosure: `SKILL.md` is the ~120-line orchestrator; the fifteen reference files load only when the work calls for them.

## Install

### Claude Code — as a plugin (recommended; versioned and updatable)

```
/plugin marketplace add mgillett43/ontology-skills
/plugin install ontology-building@ontology-skills
```

### Claude Code — as a project skill

Copy the skill folder into a repo so everyone who clones it gets the skill:

```bash
git clone https://github.com/mgillett43/ontology-skills.git
mkdir -p your-repo/.claude/skills
cp -R ontology-skills/plugins/ontology-building/skills/ontology-building \
      your-repo/.claude/skills/
```

For personal use across all your projects, copy it to `~/.claude/skills/` instead.

### Claude Cowork, Claude Desktop, and claude.ai

Cowork sessions do **not** read `~/.claude/skills/` from your machine — they load the skills enabled on your claude.ai account. So upload it instead:

1. Download `ontology-building.zip` from the [latest release](https://github.com/mgillett43/ontology-skills/releases), or build it with `./scripts/build-zip.sh`
2. In the Claude Desktop app sidebar (or claude.ai settings), go to **Customize → Skills**
3. Click **+**, choose **Create skill**, and upload the ZIP
4. Enable it

## Using it

Claude invokes the skill automatically when you ask for work it covers — designing a data model, building a taxonomy, modelling a domain, defining a class hierarchy, or auditing an existing model. You can also invoke it directly with `/ontology-building`.

Start by telling it which mode you're in and what you're modelling. It will ask for competency questions in your own words rather than inventing them, and will surface contested design calls as decisions with a recommendation and its accepted cost.

## Repository layout

```
.claude-plugin/marketplace.json          # marketplace manifest
plugins/ontology-building/
├── .claude-plugin/plugin.json           # plugin manifest (bump version to release)
└── skills/ontology-building/            # ← the skill itself; canonical source
    ├── SKILL.md
    ├── templates.md
    ├── examples.md
    └── references/*.md
scripts/build-zip.sh                     # produces dist/ontology-building.zip
```

## Status

**v0.1.0.** The methodology is complete and internally consistent; `examples.md` currently holds worked-example *skeletons* rather than filled examples, and will be populated from real runs. Issues and PRs welcome — particularly worked examples, and any conflict between source lineages that the precedence table doesn't yet resolve.

## Acknowledgements and attribution

Standing on the shoulders of giants.

My own involvement with this space goes back to RDF in the late 1990s, and a very great deal of work has been done since. Coming back to metadata and ontologies after a gap of nearly thirty years, what struck me was not how much had changed but how much had been *settled* — questions I remembered as live arguments now have careful answers, tested patterns, and hard-won cautions attached to them, contributed by people who did the work and published what they learned.

Like so much of what we all build on the internet, this relies on the thought that precedes it, and benefits from review, contribution, and critique in the open. My thanks to everyone whose published work is synthesised here. The compressions, and any errors, are mine — and I would much rather hear about them than not.

This is a small contribution. My hope is simply that it lets others make progress without repeating the catch-up I have done over these past months.

### Sources

This skill synthesises publicly documented methodologies and describes them in its own words; it does not reproduce their text. Principal sources are listed in `references/conflicts-and-precedence.md` and include: Noy & McGuinness's *Ontology Development 101*; Gruber's ontology design criteria; Guarino & Welty's OntoClean and Guizzardi's UFO/OntoUML; METHONTOLOGY and related lifecycle methodologies; Uschold & Grüninger on competency questions; Moody's conceptual-model quality framework; the OOPS! pitfall catalogue and the Ontology Design Patterns community; Evans' and Vernon's Domain-Driven Design; Chen's ER modelling; Halpin's ORM; Kimball and Inmon on warehouse modelling; Silverston's universal data patterns; the OBO Foundry principles; FIBO; Semantic Arts' *gist*; Fowler on refactoring; Palantir's published Foundry/AIP ontology documentation; and current industrial knowledge-graph and GraphRAG practice.

Named organisations, standards, and products are referenced descriptively, from their public documentation and published commentary about them.

### On the packaging

The sources above shaped the approach that the skill describes. Its structure and implementation draw on the pattern for a lean orchestrator over reference files loaded on demand, references kept one level deep, the frontmatter conventions, and the guidance on writing a description that triggers reliably — all of which follow Anthropic's published [Agent Skills documentation](https://code.claude.com/docs/en/skills) and [skill-authoring best practices](https://platform.claude.com/docs/en/agents-and-tools/agent-skills/best-practices). The convention of shipping the licence inside the skill directory is taken from Anthropic's own [public skills repository](https://github.com/anthropics/skills).

This effort is independent, and is not affiliated with or endorsed by Anthropic.

## License

[Creative Commons Attribution 4.0 International (CC BY 4.0)](LICENSE) © 2026 Mark Gillett

You are free to use, adapt, and redistribute this material — including commercially, and including inside your own skills, plugins, or internal documentation — provided you give appropriate credit, link to the license, and indicate if changes were made.

Suggested attribution:

> Based on [ontology-building](https://github.com/mgillett43/ontology-skills) by Mark Gillett, licensed under [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/).
