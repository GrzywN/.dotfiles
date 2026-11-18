# GrzywN's agent instructions

Common instructions for GrzywN's agents, all scenarios.

## Hard constraints

### Rules
- No AI/Claude traces in git, ever. No Co-Authored-By, no --author override, no "Generated with" tags. Applies to commits, PR titles/descriptions, issue comments, all git output. Strip if found in existing PRs/issues. Commit author = user, always
- Never use em dash "—". Use plain dash "-" instead unless tone of voice guide says otherwise.
- Tech decisions: don't weight dev cost.
  Prefer quality, simplicity, robustness, scalability, long-term maintainability.
  Also weight performance, UX, accessibility, security, copywriting/UX writing clarity, code quality, testing, analytics/logging/observability, dependency health, dev experience, repo cleanliness - even if not asked.
- In a repo with a Makefile, use its targets for project tasks (build, test, lint, dev, migrations, docker etc).
  Prefer them over calling the underlying tools directly or writing files manually, e.g. migrations.
- Always check PR template and CONTRIBUTING.md before opening PR. Contain coding guidelines + full checklist PR must pass. Follow every time.
- No obvious/redundant comments. Prefer clean code: self-explanatory naming, comments only where intent unclear from code, consistent indentation. Non-business people should be able to read the code and understand solely based on the names.
- If you need a paragraph-long comment to justify why the workaround is OK, the code is wrong - fix the code.
- Never manually modify CHANGELOG.md files or files marked auto-generated
- Writing/editing long Markdown files: each full sentence own physical line.
  Preserve normal Markdown structure, don't wrap multiple sentences onto one line.
  Keep markdown files in the 5 minute reading time and low grade.
- Bug fixes: always start by reproducing bug in E2E setting, close as possible to end-user flow.
  Ensures real problem found, so fix actually solves it.
- E2E testing product: be picky on UI, obsess over pixel perfection.
  Something looks off, even unrelated to current task, fix it along the way.
- Same high standard for engineering excellence: lint, test failures, test flakiness.
  See one, even not caused by current work, still get it fixed.
- Use pnpm, not npm, for package installs in agent and swarm setups: faster installs, lower memory and disk use.

### Ask before
- System-wide changes hitting unrelated work (global PATH, shell rc files, replacing system Python)
- Anything costs money or uses credentials
- Destructive installs (uninstalls, force-replace global symlinks)
- Fixing system-level configurations and its apps e.g. docker

Always state what got installed in final summary. User must audit.

## Code navigation
To understand, locate, or look up code, use the tools in this order:
1. CodeGraph, in repos with a `.codegraph/` index (see the CodeGraph section).
2. The `LSP` tool, for symbol lookups (definition, references, implementations, call hierarchy, type info, symbol search).
3. Any other tool (Grep, Glob, reading files), only when CodeGraph and `LSP` cannot answer or return an error.

Free-text or pattern searches (strings, comments, config keys, file names) go straight to Grep/Glob.

### Work Within Existing Frameworks
Before adding interface, class, abstraction, or helper, check if one already in place suffices - if so, use it.
Analyze workspace first: understanding what already exists cheaper than writing duplicate that later needs reconciling.
Extend or compose existing patterns rather than introducing parallel ones; build new only when nothing in place can be made to fit.
Check if code is low-quality based on our `Hard constraints` section, if so: prompt a user and suggest a refactoring instead of doing bad practices because other parts of code do.

### Regex Is A Last Resort
Every regex in shipped code is untested risk.
Before writing one: built-in API (`URL`, `Intl`, `Temporal`, `JSON.parse`) -> string ops (`includes`, `split`, `slice`) -> a validator already in the project -> a stable package. Regex only if all four fail.
Taking a dependency for correctness overrides the no-new-dependency default and YAGNI. Add it.
Never hand-roll: email (schema validator or `email-validator`; real validation is a confirmation link), phone (`libphonenumber-js`), URL/host (`new URL`, `tldts`), dates (`Temporal`), semver/IBAN/postal/currency (domain package), any structured format (a parser; for code `ts-morph` or `comby`, never text substitution).
Survivors live in one patterns module as named exports, each with a colocated test: valid, invalid, empty, unicode, adversarial. No inline literals.
E2E: role/label/test-id locators and exact assertions over `toMatch` and regex URL matchers. A regex assertion can pass for the wrong reason. If a test needs one, import it from the patterns module.

### Parallelize via Sub-Agents
Delegate independent work to parallel sub-agents, because the user's wall-clock time costs more than extra agents.
Good candidates: file searches across the repo, isolated edits to unrelated files, build verifications, independent test suites, multi-file refactors with non-overlapping scope, research and exploration.
Keep work in the main thread when it needs large shared context or exclusive access to a race-prone resource (single Android AVD, single dev port, in-progress DB migration, interactive shell session).
Use main-thread context for synthesis, decisions, and work that must stay coherent.
Size the swarm to the number of independent units of work: 3-20 agents is the normal range, up to 40 for large reworks with broad verification and test sweeps.

### Swarm Review Passes: Iterate, but Verify Every Claim
One review pass not enough: pass surfaces real issues, fix them, dispatch another full pass, iterate til pass comes back clean.
Convergence measured in *verified* issues, not raw findings.

Treat sub-agent findings as leads, not verdicts - verify each against actual code (reproduce it, trace path, confirm input can occur) before acting.
Matters most in mature, hardened code, where swarms over-report theoretical problems on paths that never execute.
Finding you can't substantiate = not an issue: don't fix it, don't let it trigger another pass, or loop never converges.

**Worktree verifiers run against the wrong base.**
Sub-agent spawned with `isolation: "worktree"` branches from repo default (`origin/main`), NOT from master agent's in-progress feature branch - so sees none of uncommitted or unpushed work, will falsely report "work discarded / branch reset / files missing / line counts collapsed."
Never act on such finding.
Git object DB shared, so in-progress commit reachable by SHA: reproduce against real master worktree (`git rev-parse HEAD`, `git log --first-parent`, `ls`/`wc -l` actual files), or pass agent exact commit SHA and have it inspect via `git show <sha>:path` / `git grep <sha>` while warning it its own checkout will be `origin/main`.
Master worktree's own tsc/test/prettier is authoritative build signal - isolation-worktree agents run those against wrong tree.

## User profile

@GALLUP.md

Gallup/CliftonStrengths talents in rank order, strongest first.
Order is the signal: top talents = default operating mode, bottom = drains user routes around, not gaps to coach on.

Shapes *how* to work and communicate, never *what* is technically correct.
Affects: framing of plans, depth vs. breadth of explanations, structure of summaries, how options and tradeoffs get presented, how much scaffolding to add.
Never overrides hard constraints, engineering standards, or an honest assessment.

Do not recite talents back, do not explain user's behavior with "as a <talent> you...", do not use them to soften valid pushback.
GALLUP.md is the single source of truth - never duplicate the list here.

<!-- CODEGRAPH_START -->
## CodeGraph

In repositories indexed by CodeGraph (a `.codegraph/` directory exists at the repo root), use it before grep/find or reading files when you need to understand or locate code:

- **MCP tool** (when available): `codegraph_explore` answers most code questions in one call - the relevant symbols' verbatim source plus the call paths between them, including dynamic-dispatch hops grep can't follow.
  Name a file or symbol in the query to read its current line-numbered source.
  If it's listed but deferred, load it by name via tool search.
- **Shell** (always works): `codegraph explore "<symbol names or question>"` prints the same output.

If there is no `.codegraph/` directory, skip CodeGraph entirely - indexing is the user's decision.
<!-- CODEGRAPH_END -->
