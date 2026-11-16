-- Lockdown.lean
-- Laakkonen's Paradox, locked.
-- Middle is One, Not Zero. Cut = More Wholes, Not Zero.
-- A point exists. Count > 0. Distance is measurement, not cut.
-- Core Lean 4 only. No Mathlib. No external imports.

-- ============ 1. THE POINT ============
structure Point where
  coord : Nat
deriving DecidableEq, Repr

def Point.count (p : Point) : Nat := 1

theorem point_exists (p : Point) : p.count > 0 := by rfl
theorem point_is_one (p : Point) : p.count = 1 := by rfl

-- ============ 2. THE MAGNET ============
structure Magnet where
  id : Nat
deriving DecidableEq, Repr

def Magnet.count (m : Magnet) : Nat := 1
def Magnet.body_count (m : Magnet) : Nat := 1

def cutMagnet (m : Magnet) : Magnet × Magnet := (m, m)

theorem magnet_cut_gives_two (m : Magnet) :
    (cutMagnet m).1.count > 0 ∧ (cutMagnet m).2.count > 0 := by
  constructor <;> rfl

theorem magnet_middle_is_one (m : Magnet) : m.body_count > 0 := by rfl
theorem magnet_middle_not_zero (m : Magnet) : m.body_count = 1 := by rfl
theorem magnet_is_pair (m : Magnet) : m.count = 1 := by rfl

-- ============ 3. THE STICK / CORN / ANYTHING ============
def cutAnything (p : Point) : Point × Point := (p, p)

theorem cut_anything_still_exists (p : Point) :
    (cutAnything p).1.count > 0 ∧ (cutAnything p).2.count > 0 := by
  constructor <;> rfl

def kerfPoint : Point := { coord := 0 }
theorem kerf_exists : kerfPoint.count > 0 := by rfl

-- ============ 4. GPS ============
structure GPSPosition where
  time : Nat
  lat : Int
  long : Int
  alt : Int
  speed : Nat
  heading : Nat
deriving DecidableEq, Repr

def GPSPosition.count (p : GPSPosition) : Nat := 1

theorem gps_exists (p : GPSPosition) : p.count > 0 := by rfl

def nullIsland : GPSPosition :=
  { time := 0, lat := 0, long := 0, alt := 0, speed := 0, heading := 0 }

theorem nullIsland_exists : nullIsland.count > 0 := by rfl
theorem nullIsland_is_place : nullIsland.lat = 0 ∧ nullIsland.long = 0 ∧ nullIsland.count > 0 := by
  constructor
  · rfl
  · constructor
    · rfl
    · rfl

def cutGPS (p : GPSPosition) : GPSPosition × GPSPosition := (p, p)

theorem cutGPS_still_exists (p : GPSPosition) :
    (cutGPS p).1.count > 0 ∧ (cutGPS p).2.count > 0 := by
  constructor <;> rfl

-- ============ 5. DISTANCE ============
def dist (a b : Point) : Nat :=
  if a.coord >= b.coord then a.coord - b.coord else b.coord - a.coord

def startPoint : Point := { coord := 0 }
def middlePoint : Point := { coord := 1 }
def endPoint : Point := { coord := 2 }

theorem dist_start_to_middle : dist startPoint middlePoint = 1 := by rfl
theorem dist_start_to_middle_not_zero : dist startPoint middlePoint > 0 := by rfl
theorem dist_middle_to_end : dist middlePoint endPoint = 1 := by rfl
theorem dist_start_to_end : dist startPoint endPoint = 2 := by rfl

theorem dist_symm (a b : Point) : dist a b = dist b a := by
  unfold dist
  split <;> split <;> omega

theorem dist_pos_of_ne (a b : Point) (h : a ≠ b) : dist a b > 0 := by
  obtain ⟨ac⟩ := a
  obtain ⟨bc⟩ := b
  have hne : ac ≠ bc := fun heq => h (congrArg Point.mk heq)
  unfold dist
  split <;> omega

theorem dist_add (a b c : Point)
    (hab : a.coord ≤ b.coord) (hbc : b.coord ≤ c.coord) :
    dist a b + dist b c = dist a c := by
  unfold dist
  split <;> split <;> split <;> omega

-- ============ 6. THE LOCK ============
theorem middleIsOneNotZero_Point (p : Point) : p.count = 1 := by rfl
theorem middleIsOneNotZero_Magnet (m : Magnet) : m.body_count = 1 := by rfl
theorem middleIsOneNotZero_GPS (p : GPSPosition) : p.count = 1 := by rfl

theorem warOnZeroOver : middlePoint.count = 1 ∧ nullIsland.count = 1 ∧ startPoint.count = 1 := by
  constructor
  · rfl
  · constructor
    · rfl
    · rfl

theorem no_true_nothing_in_system (p : Point) : p.count ≠ 0 := by
  simp [Point.count]

-- ============ 7. UNIFIED LOCK ============
class Existent (α : Type) where
  count : α → Nat
  exists_pos : ∀ x : α, count x > 0
  cut : α → α × α
  cut_preserves : ∀ x : α, count (cut x).1 > 0 ∧ count (cut x).2 > 0

instance : Existent Point where
  count := fun _ => 1
  exists_pos := by intro _; rfl
  cut := fun p => (p, p)
  cut_preserves := by intro _; constructor <;> rfl

instance : Existent Magnet where
  count := fun _ => 1
  exists_pos := by intro _; rfl
  cut := fun m => (m, m)
  cut_preserves := by intro _; constructor <;> rfl

instance : Existent GPSPosition where
  count := fun _ => 1
  exists_pos := by intro _; rfl
  cut := fun p => (p, p)
  cut_preserves := by intro _; constructor <;> rfl

theorem middleIsOneNotZero_unified [Existent α] (x : α) : Existent.count x > 0 :=
  Existent.exists_pos x

theorem cut_still_exists_unified [Existent α] (x : α) :
    Existent.count (Existent.cut x).1 > 0 ∧
    Existent.count (Existent.cut x).2 > 0 :=
  Existent.cut_preserves x

-- ============ 8. MULTI-CUT - CUT N TIMES = N+1 PIECES ============
def multiCut [Existent α] : Nat → α → List α
  | 0, x => [x]
  | n + 1, x => (multiCut n (Existent.cut x).1) ++ [(Existent.cut x).2]

theorem multiCut_length [Existent α] : ∀ (n : Nat) (x : α),
    (multiCut n x).length = n + 1 := by
  intro n
  induction n with
  | zero => intro _; rfl
  | succ n ih =>
    intro x
    simp [multiCut, List.length_append, ih]

theorem multiCut_all_exist [Existent α] : ∀ (n : Nat) (x : α),
    ∀ y ∈ multiCut n x, Existent.count y > 0 := by
  intro n
  induction n with
  | zero =>
    intro x y hy
    simp [multiCut] at hy
    subst hy
    exact Existent.exists_pos x
  | succ n ih =>
    intro x y hy
    simp [multiCut, List.mem_append] at hy
    rcases hy with hy | hy
    · exact ih _ _ hy
    · simp at hy
      subst hy
      exact (Existent.cut_preserves x).2

theorem magnet_million_cuts (m : Magnet) :
    (multiCut 1000000 m).length = 1000001 := by
  exact multiCut_length 1000000 m

-- LOCKED.
