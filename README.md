# AppClaw Agent Skill

A cross-agent skill for driving and inspecting mobile apps interactively through
the [`appclaw-agent`](https://www.npmjs.com/package/appclaw-agent) CLI — open
apps, press/fill UI elements, scroll, and verify on-screen state with
screenshots, all without writing a YAML flow.

Works with **Claude Code**, **Gemini CLI**, and **OpenAI Codex CLI**. The
behavioral instructions are identical across all three; only the install
location and invocation differ.

## Prerequisites

The skill drives the `appclaw-agent` binary. Install it first:

```bash
npm install -g appclaw-agent
appclaw-agent help workflow   # sanity check
```

`appclaw-agent` needs an Appium-backed device/emulator session, as documented in
the [AppClaw](https://github.com/AppiumTestDistribution/AppClaw) project.

---

## Claude Code

### Plugin marketplace (recommended)

```
/plugin marketplace add appclawhq/appclaw-agent-skill
/plugin install appclaw@appclaw-agent-skill
```

Invoke with `/appclaw:use-appclaw-agent-cli`, or just ask Claude to "open app X
and tap Y" — it auto-triggers from the skill description. Manage with
`/plugin list`, `/plugin disable appclaw@appclaw-agent-skill`, etc.

### Manual install

```bash
cp -r skills/use-appclaw-agent-cli ~/.claude/skills/        # personal
# or:  cp -r skills/use-appclaw-agent-cli .claude/skills/   # project-scoped
```

Invoke with `/use-appclaw-agent-cli`.

---

## OpenAI Codex CLI

Codex uses **Agent Skills** — the same `SKILL.md` (with `name`/`description`
frontmatter) as Claude Code. Copy the skill folder into the Codex skills dir:

```bash
mkdir -p ~/.agents/skills
cp -r skills/use-appclaw-agent-cli ~/.agents/skills/        # user-wide
# or:  cp -r skills/use-appclaw-agent-cli .agents/skills/   # repo-scoped
```

Restart Codex. It triggers implicitly from the description, or run it explicitly
via the `/skills` menu or `$use-appclaw-agent-cli`.

> Note: Codex's older `~/.codex/prompts/` custom prompts are deprecated — Agent
> Skills are the supported path.

---

## Gemini CLI

Gemini uses an **extension** (this repo's root `gemini-extension.json` +
`GEMINI.md`). Install straight from git:

```bash
gemini extensions install https://github.com/appclawhq/appclaw-agent-skill
```

Once installed, the `GEMINI.md` context is loaded automatically, so just ask
Gemini to operate the app. Manage with:

```bash
gemini extensions list
gemini extensions disable use-appclaw-agent-cli
gemini extensions uninstall use-appclaw-agent-cli
gemini extensions update use-appclaw-agent-cli
```

Prefer no install step? Drop the context file in manually:

```bash
cp GEMINI.md ~/.gemini/GEMINI.md        # global, all projects
# or:  cp GEMINI.md ./GEMINI.md         # project root
```

---

## What it does

Once active, the skill guides the agent to:

- Open a named device session and inspect actionable UI (`snapshot -i --json`)
- Interact via stable `@eN` refs / selectors (`press`, `fill`, `longpress`, `scroll`)
- Always use `scroll` (never the ambiguous `swipe`); the tap verb is `press`, not `tap`
- Verify assertions **visually via screenshots**, never DOM presence alone
- Close the session when done

The canonical instructions live in
[`skills/use-appclaw-agent-cli/SKILL.md`](skills/use-appclaw-agent-cli/SKILL.md)
(Claude + Codex). [`GEMINI.md`](GEMINI.md) is **generated** from it — edit
`SKILL.md`, then run:

```bash
awk 'NR==1&&$0=="---"{f=1;next} f&&$0=="---"{f=0;b=1;next} b' \
  skills/use-appclaw-agent-cli/SKILL.md | sed -e '/./,$!d' > GEMINI.md
```

(This strips the YAML frontmatter. The repo ships no scripts because the Claude
plugin directory only accepts Markdown, JSON, YAML, and image files.)

## Repository layout

```
appclaw-agent-skill/
├── .claude-plugin/            # Claude Code plugin + marketplace
│   ├── plugin.json
│   └── marketplace.json
├── skills/
│   └── use-appclaw-agent-cli/
│       └── SKILL.md           # Claude Code skill + Codex Agent Skill
├── gemini-extension.json      # Gemini CLI extension manifest
├── GEMINI.md                  # Gemini CLI context (generated from SKILL.md)
└── README.md
```

## License

MIT
