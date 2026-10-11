structure Magnet where
  north : Float
  south : Float

-- Cutting one magnet gives you two whole magnets, not two poles
def cut (m : Magnet) : Magnet × Magnet :=
  (m, m)
