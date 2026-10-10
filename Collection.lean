-- Collection.lean — lock — holding 1 until exact — no zero — greater than zero
-- bottom floor — inner iron, middle slot, gas field, dry space — all green

structure MyMass where
  count : Nat
  h_pos : 0 < count
  area : Nat
  h_area_pos : 0 < area
deriving DecidableEq

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

def MercuryIron : MyMass where
  count := 10
  h_pos := by omega
  area := 1
  h_area_pos := by omega

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

def VanAllenSlot : MyMass where
  count := 1
  h_pos := by omega
  area := 1
  h_area_pos := by omega

def AsteroidBeltMiddle : Magnet where
  north := MercuryIron
  south := JupiterField
  body := VanAllenSlot

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

theorem holdingOneUntilExact (p : MyMass) : p.count > 0 := p.h_pos
theorem holdingAreaUntilExact (p : MyMass) : p.area > 0 := p.h_area_pos
theorem middleIsOneNotZero (m : Magnet) : m.body.count > 0 := m.body.h_pos
theorem noZeroDry (d : DryTest) : d.space.count > 0 := d.space.h_pos
theorem spaceIsDryNotZero (d : DryTest) : d.space.area > 0 := d.space.h_area_pos
theorem anyPointIsOne (p : MyMass) : p.count >= 1 := by
  have h := p.h_pos
  omega
