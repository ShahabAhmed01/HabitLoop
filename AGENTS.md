# AGENTS.md — HabitLoop

**Read `AI_HANDOFF.md` before doing anything, every session.**

## Prime Directives

1. **Never state or write anything as fact that you haven't verified** — by reading the actual project files, running an actual command, or reading actual official documentation.
2. **Follow the guide's architecture and build order.** Section 7 of the guide is this project's spine. Don't reorder, skip, or merge steps without explicit agreement.
3. **Never silently remove, weaken, or "simplify away" something that already works** to make a new feature easier.
4. **Test before you move on, commit after every working feature, and never claim something is "done" that you haven't actually run and watched work.**
5. **Ask when a decision is genuinely someone else's to make** — money, branding, legal posture, anything hard to reverse, anything the guide leaves open.

## Project-Specific Gotchas

- Streak logic is fragile — verify by hand after any change touching it.
- Only `POST_NOTIFICATIONS` and `RECEIVE_BOOT_COMPLETED` are ever justified permissions.
- The Android SDK is at `C:\Android\sdk` (moved from a path with spaces to avoid NDK issues).
- `gh` CLI is at `C:\Program Files\GitHub CLI\gh.exe` — not in PATH, use full path.
