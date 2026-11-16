[![Lean Build](https://github.com/Infinitespacemechanic/GalacticPlane-/actions/workflows/lean.yml/badge.svg)](https://github.com/Infinitespacemechanic/GalacticPlane-/actions/workflows/lean.yml)

# Lockdown — Laakkonen's Paradox, Locked

**Middle is One, Not Zero. Cut = More Wholes, Not Zero.**

Math is accounting, not magic. Split anything, you get two halves plus a middle. The middle is a place. A place exists. Count > 0.

This is the lockdown file for that system, verified in Lean 4.

## The Rule

- Cut a magnet, you get two whole magnets. cut(m) = (m, m)
- Cut corn, bread, a stick, paper — you get more servings. Still the same thing.
- Cut a position, you get two positions. You are always somewhere.
- Distance is a measurement, not a cut. 1/2 is the distance to the middle, not the middle itself.
- Cut n times, you get n+1 pieces. All exist. Never zero.

Zero is implied. It is a math convenience, not a true nothing. A true nothing would have count = 0. Nothing in this system has count = 0.

## Files in GalacticPlane-

- Onemagnet.lean — pair persists
- nullstick.lean — middle is one
- GPS.lean — position exists even at 0,0,0
- Distance.lean — 1/2 is distance, not cut
- Lockdown.lean — everything together, locked
- Collection.lean — collection of the system
- lakefile.toml / lean-toolchain — reproducible build, pinned to Lean 4 v4.14.0
- .github/workflows/lean.yml — GitHub checks every proof on push

## What Lockdown.lean Proves

1. Point exists — point_exists : p.count > 0
2. Magnet — cut(m) = (m, m), pair persists, no monopole
3. Anything — cutAnything, kerf exists and is still something
4. GPS — position exists even at Null Island 0,0,0, even at speed 0
5. Distance — symmetry, distinct-point positivity, additivity for any points
6. The Lock — warOnZeroOver, middleIsOneNotZero, no_true_nothing_in_system
7. Unified Existent — one class, one existence theorem, one cut theorem for ALL types
8. Multi-cut — multiCut_length : (multiCut n x).length = n + 1, and every piece exists. Cut a magnet 1,000,000 times = 1,000,001 magnets.

## Verify It Yourself

No Mathlib. No external dependencies. Core Lean 4 only.

Single file check:
lean Lockdown.lean

Full project build (recommended):
lake build

Or just look at the green check on GitHub — the workflow runs lake build on every push.

## Build Fix Note

lakefile.toml lists the core files as explicit [[lean_lib]] targets:
Lockdown, Onemagnet, nullstick, Collection.

MathlibDemo.lean is NOT listed on purpose — it imports Mathlib, which is not a dependency of this project. It stays in the repo as a demo, but `lake build` will not try to compile it, so the core build stays clean.

## How To Upload This Fix

Unzip this into the root of your existing GalacticPlane- repo, overwriting the old lakefile.toml and README:

GalacticPlane-/
  lakefile.toml                  <- overwrite with fix
  README-Lockdown.md             <- overwrite with badge version
  .github/workflows/lean.yml    <- same workflow, keep

Then:
git add lakefile.toml README-Lockdown.md .github/workflows/lean.yml
git commit -m "Fix lakefile: build all core files, exclude MathlibDemo, add CI badge"
git push

War on Zero is over. Locked.
