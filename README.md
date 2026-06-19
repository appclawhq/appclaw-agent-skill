# AppClaw Agent Skill

A [Claude Code](https://claude.com/claude-code) skill for driving and inspecting
mobile apps interactively through the [`appclaw-agent`](https://www.npmjs.com/package/appclaw-agent)
CLI — open apps, press/fill UI elements, scroll, and verify on-screen state with
screenshots, all without writing a YAML flow.

## Prerequisites

The skill drives the `appclaw-agent` binary. Install it first:

```bash
npm install -g appclaw-agent
appclaw-agent help workflow   # sanity check
```

`appclaw-agent` needs an Appium-backed device/emulator session, as documented in
the [AppClaw](https://github.com/AppiumTestDistribution/AppClaw) project.

## Install the skill

### Option A — Plugin marketplace (recommended)

In Claude Code:

```
/plugin marketplace add agentfarmhq/appclaw-agent-skill
/plugin install appclaw@appclaw-agent-skill
```

Then invoke it with:

```
/appclaw:use-appclaw-agent-cli
```

…or just ask Claude to "open such-and-such app and tap X" — the skill
auto-triggers from its description.

Manage it later with `/plugin list`, `/plugin disable appclaw@appclaw-agent-skill`, etc.

### Option B — Manual install

Copy the skill folder into your Claude config:

```bash
# personal (all projects)
cp -r skills/use-appclaw-agent-cli ~/.claude/skills/

# or project-scoped (committed alongside a repo)
cp -r skills/use-appclaw-agent-cli .claude/skills/
```

It loads on the next session — invoke with `/use-appclaw-agent-cli`.

## What it does

Once active, the skill guides Claude to:

- Open a named device session and inspect actionable UI (`snapshot -i --json`)
- Interact via stable `@eN` refs / selectors (`press`, `fill`, `longpress`, `scroll`)
- Always use `scroll` (never the ambiguous `swipe`)
- Verify assertions **visually via screenshots**, never DOM presence alone
- Close the session when done

See [`skills/use-appclaw-agent-cli/SKILL.md`](skills/use-appclaw-agent-cli/SKILL.md)
for the full command reference and behavioral rules.

## License

MIT
