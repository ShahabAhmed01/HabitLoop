# AI_HANDOFF.md — HabitLoop Project State
Last updated: 2026-07-20 · Updated by: session ses_0857227a2ffe

## 0. Read Me First
HabitLoop is a free, open-source, local-first habit tracker built with Flutter for Android. Phase 0 is complete and Step 1 (scaffold) passes tests. Step 2 (data layer) is in progress — sqflite chosen as the database engine. Next: build the home screen (Step 3).

## 1. Project Identity
- **App name**: HabitLoop
- **Tagline**: (TBD)
- **Package ID**: com.habitloop.habitloop
- **GitHub repo**: https://github.com/ShahabAhmed01/HabitLoop
- **License**: MIT
- **Target platform**: Android only (for now)
- **Current version**: 0.0.0 (pre-development)
- **Definition of done for v1**: Every Phase 1-4 box checked, `flutter test` passes, app runs clean on a real device, security checklist fully green, production release live on Play Store.

## 2. Tech Stack & Key Decisions
- **Framework**: Flutter 3.44.6 (stable channel)
- **Language**: Dart
- **Local DB**: sqflite 2.4.3 (SQL-based, chosen for Step 2)
- **Notifications**: flutter_local_notifications (planned)
- **Ads**: google_mobile_ads (planned)
- **Billing**: in_app_purchase (planned)

**Decision log:**
2026-07-20 | App name: HabitLoop | HabitLoop, HabitForge, DailyPulse, Streakly | Matches project folder
2026-07-20 | License: MIT | MIT vs GPLv3 | Permissive, minimal obligations
2026-07-20 | Repo visibility: Public | Public vs Private | Matches open-source goal
2026-07-20 | Android SDK moved to C:\Android\sdk | Original path had spaces breaking NDK | Fixed during setup
2026-07-20 | DB engine: sqflite | sqflite vs Isar vs Hive | SQL-based, most tutorials reference it

## 3. Current Status Snapshot
- [x] **Phase 0 — Setup**: Environment confirmed, repo created, app scaffolded
- [ ] **Phase 1 — Core App** (Steps 1-10)
  - [x] Step 1: Scaffold — default app runs (flutter test passes)
  - [x] Step 2: Data layer — Habit + Completion models, sqflite DB, 4 tests passing
  - [ ] Step 3: Home screen (list + tap-to-complete)
  - [ ] Step 3: Home screen (list + tap-to-complete)
  - [ ] Step 4: Add/Edit habit screen
  - [ ] Step 5: Streaks (current + best)
  - [ ] Step 6: History view
  - [ ] Step 7: Stats screen
  - [ ] Step 8: Notifications
  - [ ] Step 9: Settings
  - [ ] Step 10: Polish pass
- [ ] **Phase 2 — Monetization** (Steps 11-12)
- [ ] **Phase 3 — Compliance & Release Prep**
- [ ] **Phase 4 — Publishing**

## 4. Feature Log
2026-07-20 | Step 1: Initial scaffold | Default Flutter app, flutter test passes | Commit 2da1c03
2026-07-20 | Step 2: Data layer | Habit model, Completion model, DatabaseHelper with sqflite, 4 tests passing | lib/models/, lib/database/, test/database_test.dart

## 5. Architecture Snapshot
- **Folder structure**: `lib/main.dart`, `lib/models/` (habit.dart, completion.dart), `lib/database/` (database_helper.dart)
- **Data schema**:
  - `habits`: id, name, icon, color, frequency, created_at
  - `completions`: id, habit_id, date (UNIQUE on habit_id+date)
- **State management**: Not yet chosen (Step 3+)

## 6. Security & Privacy Checklist State
- [ ] Never commit secrets (key.properties, *.jks, *.keystore, .env) — .gitignore updated
- [ ] Minimize permissions (only POST_NOTIFICATIONS and RECEIVE_BOOT_COMPLETED)
- [ ] Code obfuscation on release builds
- [ ] Audit file I/O and network calls
- [ ] Privacy policy drafted and hosted
- [ ] Play Console Data Safety questionnaire completed

## 7. Open Questions Awaiting the Human
(None currently — will be added as they arise)

## 8. Known Issues & Technical Debt
- Android SDK was copied to `C:\Android\sdk` to avoid path-with-spaces issue. The original SDK at `C:\Users\Shahab Ahmed\AppData\Local\Android\sdk` still exists — can be cleaned up later.
- `gh` CLI not in PATH — must use full path `C:\Program Files\GitHub CLI\gh.exe`

## 9. Changelog
2026-07-20 | Initial setup: Flutter scaffolded, GitHub repo created, AGENTS.md/AI_HANDOFF.md created
2026-07-20 | Data layer: sqflite DB with Habit/Completion models, 4 passing tests

## 10. Next Steps
1. **Immediate**: Build home screen with habit list and tap-to-complete (Phase 1, Step 3)
2. **Then**: Add/Edit habit screen (Step 4)
3. **After that**: Streak calculation (Step 5)

## 11. Operating Rules for Any AI Working on This Project

### Prime Directives
1. Never state or write anything as fact that you haven't verified.
2. Follow the guide's architecture and build order. Section 7 is the spine.
3. Never silently remove, weaken, or "simplify away" something that already works.
4. Test before you move on, commit after every working feature, and never claim something is "done" that you haven't actually run and watched work.
5. Ask when a decision is genuinely someone else's to make.

### Operating Principles
- Correct and stable beats fast.
- Follow the guide's documented choice unless you have a specific, articulable reason to deviate.
- Simple and boring beats clever.
- One feature per work session. Test after every change. Commit after every working feature.
- Read your own diff before committing — watch for unexpected network calls, new AndroidManifest entries, and file writes outside app storage.
