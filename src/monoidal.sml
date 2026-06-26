(*The types of monoidal and cartesian structures on a category `C`. *)
functor Monoidal (C : CATEGORY) =
struct
  (*A reference to the category of bifunctors on `C`. *)
  structure CCtoC = FunctorCategory(ProductCategory(C)(C))(C)

  (*The type of monoidal structures.
  type monoidal = {
    unit: C.obj,
    tensor: functor[C * C, C] } *)
  type monoidal = {
    unit: C.obj,
    tensor: CCtoC.obj }

  (*The type of cartesian structures.
    The behavior of `pair` is undefined when the input morphisms are ill-typed.
  type cartesian = {
    unit: C.obj,
    product: functor[C * C, C],
    leftproj: forall x y -> C.morph[#mapobj product (x, y), x],
    rightproj: forall x y -> C.morph[#mapobj product (x, y), y],
    pair:
      C.morph[x, y] -> C.morph[x, z] ->
      C.morph[x, #mapobj product (y, z)] } *)
  type cartesian = {
    unit: C.obj,
    product: CCtoC.obj,
    leftproj: C.obj -> C.obj -> C.morph,
    rightproj: C.obj -> C.obj -> C.morph,
    pair: C.morph -> C.morph -> C.morph }

  (*A cartesian category is trivially a monoidal category *)
  val cartesianIntoMonoidal : cartesian -> monoidal = fn c => {
    unit = #unit c,
    tensor = #product c }
end
