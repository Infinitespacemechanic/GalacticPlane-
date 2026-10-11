# Laakkonen's Paradox

> When dividing the one, the whole is contained in the parts — the one persists in each.

## The Paradox

A stick is one, not zero. Cut it at the middle and you get 0.5 + 0.5.

Textbooks write the middle as 0. But there are no zero sticks.

The middle is 1 not 0.

Same with magnets, same with a flat plane. We get the pairs that come from the one.

## In Nature

Nature does not make zero mass or zero area. Even "empty" is 1.

### 1. The Stick — Point is One
A point on a stick has location. It is not nothing. In Lean:
```lean
def PointOnStick : MyMass where
  count := 1
  h_pos := by omega
  area := 1
  h_area_pos := by omega
```
A point exists. Count > 0.

### 2. The Magnet — The One Contains the Pair
Cut one bar magnet and you do not get North and South separated.
You get two whole magnets, each North + South.

```lean
def cut (m : Magnet) : Magnet × Magnet := (m, m)
theorem middleIsOneNotZero (m : Magnet) : m.body.count > 0 := m.body.h_pos
```
The pair was already inside the one.

### 3. The Plane — Division Reveals, Not Creates
Draw a line on a plane. You get left and right. The line did not add left and right — they were latent in the one plane.

### 4. Bottom Floor — Inner Iron, Middle Slot, Gas Field, Dry Space — All Green

**Inner Iron — MercuryIron**
Mercury is ~75% iron core by radius. Even the smallest planet has >0 iron. No zero core.

**Middle Slot — VanAllenSlot / AsteroidBeltMiddle**
Van Allen belts are not gas. They are a magnetic bottle holding charged particles in dry vacuum. Asteroid belt is not zero between Mars and Jupiter — it is spread mass, still >0.

**Gas Field — JupiterField / SaturnField**
Jupiter's magnetosphere is the largest structure in the Solar System by area. Field area 1000, count 1. The field IS the body extended.

**Dry Space — SpaceIsDry / WetSea**
Space is dry vacuum (<1 atom/cm³). Sea is wet (10^23 molecules/cm³). Both have count >0 and area >0. Dryness is not zero — it's a different 1. Wetness is null for space, not zero.

```lean
structure DryTest where
  space : MyMass
  sea : MyMass

theorem noZeroDry (d : DryTest) : d.space.count > 0 := d.space.h_pos
theorem spaceIsDryNotZero (d : DryTest) : d.space.area > 0 := d.space.h_area_pos
```

### 5. Null vs Zero in Code
```lean
-- The lie:
def countSticks (s : Option Stick) : Nat :=
  | none => 0  -- we said 0 but we mean null
  | some _ => 1

-- The fix:
def countSticks' (s : Option Stick) : Option Nat :=
  | none => none  -- null = no box to count in
  | some _ => some 1
```

Zero is a location — the flag where we start measuring.
Null is no box at all.

## Collection.lean — Holding 1 Until Exact

```lean
structure MyMass where
  count : Nat
  h_pos : 0 < count
  area : Nat
  h_area_pos : 0 < area

theorem holdingOneUntilExact (p : MyMass) : p.count > 0 := p.h_pos
theorem holdingAreaUntilExact (p : MyMass) : p.area > 0 := p.h_area_pos
theorem anyPointIsOne (p : MyMass) : p.count >= 1 := by omega
```

Lean enforces it: you cannot construct a zero-mass or zero-area entity. If you want nothing, you must leave MyMass and go to `Option MyMass` = `none`.

**Middle is one not zero. The rest can stay.**

---
*Rob Laakkonen — 2026 — Collection.lean — lock — holding 1 until exact — no zero — greater than zero*
