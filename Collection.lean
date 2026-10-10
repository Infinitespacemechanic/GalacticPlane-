-- Collection.lean — lock — holding 1 until exact — no zero — greater than zero
-- bottom floor — inner iron, middle slot, gas field, dry space — all green

structure MyMass where
  count : Nat
  h_pos : 0 < count
  area : Nat
  h_area_pos : 0 < area
deriving DecidableEq

-- any point is still one — projected or exists — simulating existence
def PointOnStick : MyMass where
  count := 1
  h_pos := by omega
  area := 1
  h_area_pos := by omega

def PointOnPlane : MyMass where
  count := 1
  h_pos := by omega
  area := 1
  h_area_pos := by omega

structure Magnet where
  north : MyMass
  south : MyMass
  body : MyMass

-- inner — iron — solid mass — heavy count small area
def MercuryIron : MyMass where
  count := 10
  h_pos := by omega
  area := 1
  h_area_pos := by omega

-- gas giant — very little solid mass — tiny core huge area — still one
def JupiterField : MyMass where
  count := 1
  h_pos := by omega
  area := 1000
  h_area_pos := by omega

def SaturnField : MyMass where
  count := 1
  h_pos := by omega
  area := 900
  h_area_pos := by omega

def JupiterMagnet : Magnet where
  north := JupiterField
  south := JupiterField
  body := JupiterField

-- middle — between Mars and Jupiter — Van Allen = asteroid belt middle
def VanAllenSlot : MyMass where
  count := 1
  h_pos := by omega
  area := 1
  h_area_pos := by omega

def AsteroidBeltMiddle : Magnet where
  north := MercuryIron
  south := JupiterField
  body := VanAllenSlot

-- space is dry — getting together space — sea below wet, space above dry
def SpaceIsDry : MyMass where
  count := 1
  h_pos := by omega
  area := 1
  h_area_pos := by omega

def WetSea : MyMass where
  count := 1
  h_pos := by omega
  area := 1
  h_area_pos := by omega

structure DryTest where
  space : MyMass
  sea : MyMass

def VanAllenDry : DryTest where
  space := SpaceIsDry
  sea := WetSea

def AsteroidBeltDry : DryTest where
  space := SpaceIsDry
  sea := WetSea

-- profound — holding 1 until exact or approx entered — no zero
theorem holdingOneUntilExact (p : MyMass) : p.count > 0 := p.h_pos
theorem holdingAreaUntilExact (p : MyMass) : p.area > 0 := p.h_area_pos
theorem middleIsOneNotZero (m : Magnet) : m.body.count > 0 := m.body.h_pos
theorem noZeroDry (d : DryTest) : d.space.count > 0 := d.space.h_pos
theorem spaceIsDryNotZero (d : DryTest) : d.space.area > 0 := d.space.h_area_pos
theorem anyPointIsOne (p : MyMass) : p.count ≥ 1 := by
  have h := p.h_pos
  omega

#check PointOnStick
#check MercuryIron
#check JupiterField
#check AsteroidBeltMiddle
#check VanAllenDry
