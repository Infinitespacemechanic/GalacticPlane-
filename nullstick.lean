-- A stick is one, not zero
def Stick : Type := Unit

-- Splitting it doesn't give you zero, it gives you a pair inside the one
def split : Stick → (Float × Float) := fun _ => (0.5, 0.5)

-- Zero as a location, not an amount
def middle : Float := 0  -- the flag where we start measuring

-- Null vs Zero
def countSticks (s : Option Stick) : Nat :=
  match s with
  | none => 0  -- wait, this is the lie - we said 0 but we mean null
  | some _ => 1

-- Better:
def countSticks' (s : Option Stick) : Option Nat :=
  match s with
  | none => none  -- null = no box to count in
  | some _ => some 1 -- one stick, really there
