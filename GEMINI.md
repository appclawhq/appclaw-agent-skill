# AppClaw Agent CLI

When the user asks you to operate or inspect a mobile device interactively
(open an app, tap a button, check visibility, etc.) using terminal commands
rather than a YAML flow, drive the `appclaw-agent` CLI as follows.

1. Verify that `appclaw-agent` is installed (`command -v appclaw-agent`). If it
   is missing, tell the user to install it with `npm install -g appclaw-agent`.
   Then run `appclaw-agent help workflow` — the live help is the source of
   truth for supported commands.
2. Use a descriptive named session for the task.
3. Inspect with `snapshot -i --json` before choosing a target.
4. Prefer returned `@eN` references or durable selectors for interaction.
5. Request a new snapshot after each state-changing action — refs are
   invalidated by any change to the screen.
6. Use `--vision` only when explicitly requested or when visual targeting is
   required and configured.
7. Close the named session when the task is complete.

## Command reference

All commands take `appclaw-agent --session <name> <command>`. The tap verb is
**`press`**, not `tap`.

| Action                         | Command                                                       |
| ------------------------------ | ------------------------------------------------------------- |
| Open an app                    | `open <app-id> --platform android\|ios`                       |
| Inspect actionable UI          | `snapshot -i --json`                                          |
| Tap / press a target           | `press @eN --json`  (or `press 'id="login_button"' --json`)   |
| Type into a field              | `fill @eN "text" --json`                                       |
| Long press                     | `longpress @eN --json`                                         |
| Scroll the screen              | `scroll down --json` / `scroll up --json`                     |
| Hardware keys                  | `enter --json` / `back --json` / `home --json`                |
| Read a value                   | `get text @eN --json` / `get info --json`                     |
| DOM presence (NOT visual)      | `is visible 'text="Sign in"' --json`                          |
| Wait for state                 | `wait visible <target> --json` / `wait gone <target> --json`  |
| Screenshot (visual truth)      | `screenshot /tmp/<name>.png`                                  |
| List active sessions           | `session list`                                                |
| Close the session              | `close`                                                       |

## Scrolling — direction reference

**Always use `scroll`, never `swipe`.** `scroll` and `swipe` are aliases in the parser, but `scroll` reads unambiguously — `scroll down` means scroll down, `scroll up` means scroll up.

| Goal                                | Command                                                 |
| ----------------------------------- | ------------------------------------------------------- |
| See content **below** (scroll down) | `appclaw-agent --session <name> scroll down --json`     |
| See content **above** (scroll up)   | `appclaw-agent --session <name> scroll up --json`       |
| Scroll down within an element       | `appclaw-agent --session <name> scroll @eN down --json` |
| Scroll up within an element         | `appclaw-agent --session <name> scroll @eN up --json`   |

**Never use `swipe`** — `swipe up` is ambiguous (training data says it scrolls down; AppClaw treats it as scroll up). Using `scroll` eliminates the confusion entirely.

**Never use `swipe @eN direction`** — element-scoped swipe crashes (`swipeElement is not a function`). Use `scroll @eN direction` instead.

## Assertions must always be visual

**Never use DOM presence (`is visible`, snapshot element checks) as the sole assertion.** The DOM may contain elements that are off-screen, scrolled out of view, or clipped — DOM presence does not mean the user can see it.

For every assertion or verification step:

1. Take a screenshot: `appclaw-agent --session <name> screenshot /tmp/<name>.png`
2. Read the screenshot image and visually analyze what is actually rendered on screen.
3. Base your pass/fail verdict **only on what you can see in the screenshot**, not on DOM presence.
4. If the target content is not clearly visible in the screenshot, the assertion **fails** — even if a DOM element exists for it.

This applies to any check phrased as "verify X is present", "confirm X appears", "assert X is visible", or similar.

The installed CLI help (`appclaw-agent help workflow`) is the source of truth for supported commands.
