(*The types of monoidal and cartesian structures on a category `C`. *)
functor Monoidal (C : CATEGORY) =
struct
  (*A reference to the category of bifunctors on `C`,
    with natural isomorphisms as morphisms. *)
  structure CCtoC = FunctorIsoGroupoid(ProductCategory(C)(C))(C)

  (*The type of monoidal structures.
  type monoidal = {
    unit: C.obj,
    tensor: functor[C * C, C] } *)
  type monoidal = {
    unit: C.obj,
    tensor: CCtoC.obj }

  (*The type of symmetric monoidal structures.
  type symmetricmonoidal = {
    unit: C.obj,
    tensor: functor[C * C, C],
    swapmap: natiso[tensor, swap tensor] } *)
  type symmetricmonoidal = {
    unit: C.obj,
    tensor: CCtoC.obj,
    swapmap: CCtoC.morph }

  (*The type of cartesian structures.
    The behavior of `pair` is undefined when the input morphisms are ill-typed.
  type cartesian = {
    unit: C.obj,
    product: functor[C * C, C],
    swapmap: natiso[tensor, swap tensor],
    leftproj: forall x y -> C.morph[#mapobj product (x, y), x],
    rightproj: forall x y -> C.morph[#mapobj product (x, y), y],
    pair:
      C.morph[x, y] -> C.morph[x, z] ->
      C.morph[x, #mapobj product (y, z)] } *)
  type cartesian = {
    unit: C.obj,
    product: CCtoC.obj,
    swapmap: CCtoC.morph,
    leftproj: C.obj -> C.obj -> C.morph,
    rightproj: C.obj -> C.obj -> C.morph,
    pair: C.morph -> C.morph -> C.morph }

  (*A symmetric monoidal category is trivially a monoidal category. *)
  val symmetricMonoidalIntoMonoidal : symmetricmonoidal -> monoidal = fn s => {
    unit = #unit s,
    tensor = #tensor s }

  (*A cartesian category is trivially a symmetric monoidal category. *)
  val cartesianIntoSymmetricMonoidal : cartesian -> symmetricmonoidal = fn c => {
    unit = #unit c,
    tensor = #product c,
    swapmap = #swapmap c }
end
