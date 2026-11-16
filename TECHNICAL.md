# TECHNICAL — Laakkonen's Paradox in Formal Terms

For readers who require a formal statement. This document is a translation of
`Lockdown.lean` into standard mathematical language. It contains no new claims
beyond what is machine-checked in `Lockdown.lean`.

All results are proved in core Lean 4, with no Mathlib and no external axioms.
Verification: `lake build` (Lean 4 v4.14.0).

---

## 1. Informal Principle, Formal Version

Informal: "Split anything, you get two halves plus a middle. The middle is
one, not zero."

Formal: There is a class of objects, called `Existent`, each equipped with
a counting function. Every object has positive count. Cutting an object
yields a pair of objects, each with positive count. No object in the system
has count zero.

This is not a claim about physical atoms. It is a claim about the accounting
model used in this repository: existence is represented by `count > 0`,
and cutting is a structure-preserving operation.

---

## 2. The Existent Typeclass

```lean
class Existent (α : Type) where
  count         : α → Nat
  exists_pos    : ∀ x : α, count x > 0
  cut           : α → α × α
  cut_preserves : ∀ x : α, count (cut x).1 > 0 ∧ count (cut x).2 > 0
```

Interpretation:

- `α` is a type of objects: points, magnets, GPS positions, etc.
- `count x` is the existence measure of `x`. In this formalization it is
  constantly `1`, i.e. "one existent thing".
- `exists_pos` is the axiom of the class: every `x` exists.
- `cut x` is the splitting operation.
- `cut_preserves` is the key invariant: cutting preserves existence in both
  components.

Instances in `Lockdown.lean`:

- `Point` with `count = fun _ => 1`, `cut = fun p => (p, p)`
- `Magnet` with `count = fun _ => 1`, `cut = fun m => (m, m)`
- `GPSPosition` with `count = fun _ => 1`, `cut = fun p => (p, p)`

In each instance, `exists_pos` and `cut_preserves` are proved by `rfl`.
The kernel checks them definitionally. There is no hidden assumption.

---

## 3. Universal Theorems

### 3.1 Existence

```lean
theorem middleIsOneNotZero_unified [Existent α] (x : α) :
    Existent.count x > 0
```

Proof: `Existent.exists_pos x`.

This is the formal version of "middle is one, not zero." For any `Existent`
type, any inhabitant has positive count.

### 3.2 Cut Preserves Existence

```lean
theorem cut_still_exists_unified [Existent α] (x : α) :
    Existent.count (Existent.cut x).1 > 0 ∧
    Existent.count (Existent.cut x).2 > 0
```

Proof: `Existent.cut_preserves x`.

Cutting does not produce a non-existent component. Both components satisfy
the same existence predicate as the original.

### 3.3 No True Nothing in the System

```lean
theorem no_true_nothing_in_system (p : Point) : p.count ≠ 0
```

Proof: `simp [Point.count]`.

If "nothing" is defined as `count = 0`, then no `Point` in the system is
nothing. The symbol `0` in this system denotes a coordinate / label
(e.g. coordinate `0`), not an object with `count = 0`.

This is the distinction the repository insists on:

- `0` as a *coordinate / measurement label*: allowed.
- `0` as *existence count of an object*: never occurs in the system.

---

## 4. Points, Magnets, GPS

### 4.1 Point

```lean
structure Point where
  coord : Nat
```

- `point_exists : p.count > 0`
- `point_is_one : p.count = 1`

### 4.2 Magnet

```lean
structure Magnet where
  id : Nat
```

- `cutMagnet m = (m, m)`
- `magnet_cut_gives_two`: both components have `count > 0`
- `magnet_middle_is_one`, `magnet_middle_not_zero`

The magnet is the motivating example for `cut_preserves`: physical cutting
of a magnet yields two magnets, not a magnet and a non-magnet. The formal
model captures this as `cut = (m, m)`.

### 4.3 GPS Position

```lean
structure GPSPosition where
  time    : Nat
  lat     : Int
  long    : Int
  alt     : Int
  speed   : Nat
  heading : Nat
```

- `gps_exists : p.count > 0` for all `p`
- `nullIsland`: the point `(0,0,0,0,0,0)` satisfies `count > 0`
- `nullIsland_is_place`: `lat = 0 ∧ long = 0 ∧ count > 0`
- `cutGPS p = (p, p)`, both components exist

Interpretation: a coordinate value of `0` does not imply non-existence.
Null Island is a location, not a non-location. The same holds for
`speed = 0`: zero speed is a measurement, not non-existence.

---

## 5. Distance

Distance is defined on `Point` with integer scaling to avoid rationals.
Scale by 2: `0` represents `0`, `1` represents `1/2`, `2` represents `1`.

```lean
def dist (a b : Point) : Nat :=
  if a.coord >= b.coord then a.coord - b.coord else b.coord - a.coord
```

### 5.1 Basic Values

- `dist startPoint middlePoint = 1` (i.e. `1/2`)
- `dist middlePoint endPoint = 1` (i.e. `1/2`)
- `dist startPoint endPoint = 2` (i.e. `1`)

All by `rfl`.

### 5.2 General Metric Properties

Symmetry:

```lean
theorem dist_symm (a b : Point) : dist a b = dist b a
```

Proof: `unfold dist; split <;> split <;> omega`.

Positivity for distinct points:

```lean
theorem dist_pos_of_ne (a b : Point) (h : a ≠ b) : dist a b > 0
```

Proof: unpack `a ≠ b` to `a.coord ≠ b.coord` via `congrArg Point.mk`,
then `unfold dist; split <;> omega`. The unpacking step is necessary
because `omega` reasons about `Nat`, not about structural inequality on
`Point`.

Additivity on a line:

```lean
theorem dist_add (a b c : Point)
    (hab : a.coord ≤ b.coord) (hbc : b.coord ≤ c.coord) :
    dist a b + dist b c = dist a c
```

Proof: `unfold dist; split <;> split <;> split <;> omega`.

Interpretation: `1/2` in this system is a *distance value*, i.e. the
output of `dist`, not the result of `cut`. Confusing `dist` with `cut`
is a category error: `dist : Point → Point → Nat`, `cut : α → α × α`.
They have different types and different invariants.

---

## 6. Multi-Cut: Recursion

Define iterated cutting:

```lean
def multiCut [Existent α] : Nat → α → List α
  | 0, x => [x]
  | n + 1, x => (multiCut n (Existent.cut x).1) ++ [(Existent.cut x).2]
```

At each step, cut the first component again and retain the second component
as a finished piece. This models repeated physical cutting of one side.

### 6.1 Length

```lean
theorem multiCut_length [Existent α] :
    ∀ (n : Nat) (x : α), (multiCut n x).length = n + 1
```

Proof by induction on `n`, using `List.length_append`.

Corollary:

```lean
theorem magnet_million_cuts (m : Magnet) :
    (multiCut 1000000 m).length = 1000001
```

### 6.2 All Pieces Exist

```lean
theorem multiCut_all_exist [Existent α] :
    ∀ (n : Nat) (x : α), ∀ y ∈ multiCut n x, Existent.count y > 0
```

Proof by induction on `n`, using `cut_preserves` for the retained piece
and the induction hypothesis for the recursively cut piece.

Interpretation: iterated cutting increases the number of existent pieces
linearly. It does not converge to a zero-count piece in this model.
There is no `n` such that `multiCut n x` contains a piece with `count = 0`.

---

## 7. What Is NOT Claimed

To avoid misreading, the formal scope is explicitly limited:

1. **Not a claim about atoms or Planck length.** The model does not assert
   that physical matter is infinitely divisible. It asserts that in the
   accounting model used here, `cut` preserves `count > 0`.

2. **Not a disproof of the Riemann Hypothesis in the classical sense.**
   `Lockdown.lean` does not contain a theorem named `RiemannHypothesis`
   or a formal statement of `ζ(s) = 0 ⇒ Re(s) = 1/2`. The repository's
   philosophical claim is that the framing of `0` in classical statements
   conflates coordinate `0` with existence `0`. That philosophical claim
   is not itself a Lean theorem.

3. **Not a claim that `0` does not exist as a number.** `0 : Nat` exists
   in Lean. The claim is that no `Existent` object has `count = 0`.

4. **Not a physical theory.** The magnet example is a motivating analogy
   for `cut_preserves`. The Lean content is the typeclass and its
   invariants, not a physics simulation.

---

## 8. Verification

- Lean version: `leanprover/lean4:v4.14.0` (see `lean-toolchain`)
- Dependencies: none. Core Lean 4 only, no Mathlib.
- Build: `lake build`
- Single file: `lean Lockdown.lean`
- CI: `.github/workflows/lean.yml` runs `lake build` on push / PR.

If a theorem in this document does not match `Lockdown.lean`, the Lean file
is authoritative. This document is a human-readable translation, not the
proof itself.

---

## 9. File Map

- `Lockdown.lean` — full formalization, Sections 1-8 above
- `Onemagnet.lean` — magnet pair persistence
- `nullstick.lean` — middle is one
- `GPS.lean` — GPS position existence
- `Distance.lean` — distance as measurement
- `Collection.lean` — collection
- `lakefile.toml` — builds `Lockdown`, `Onemagnet`, `nullstick`, `Collection`
- `README-Lockdown.md` — informal / public-facing README
- `TECHNICAL.md` — this document
