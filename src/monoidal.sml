structure Monoidal =
struct
  (*The type of (strict) monoidal structures.
  type monoidal[C] = {
    unit: C.obj,
    tensor: functor[C * C, C] } *)
  type ('Cobj, 'Cmorph) monoidal = {
    unit: 'Cobj,
    tensor: ('Cobj * 'Cobj, 'Cmorph * 'Cmorph, 'Cobj, 'Cmorph) Funct.funct }

  (*The type of symmetric monoidal structures,
    where the associativity and unit laws are strict,
    but symmetry is given by an isomorphism `swapmap`.
  type symmetricmonoidal[C] = {
    unit: C.obj,
    tensor: functor[C * C, C],
    swapmap: natiso[tensor, swap tensor] } *)
  type ('Cobj, 'Cmorph) symmetricmonoidal = {
    unit: 'Cobj,
    tensor: ('Cobj * 'Cobj, 'Cmorph * 'Cmorph, 'Cobj, 'Cmorph) Funct.funct,
    swapmap: ('Cobj * 'Cobj, 'Cmorph) Funct.nattrans }

  (*The type of cartesian structures,
    where the associativity and unit laws are strict,
    but symmetry is given by an isomorphism `swapmap`.
    The behavior of `pair` is undefined when the input morphisms are ill-typed.
  type cartesian[C] = {
    unit: C.obj,
    product: functor[C * C, C],
    swapmap: natiso[tensor, swap tensor],
    leftproj: forall x y -> C.morph[#mapobj product (x, y), x],
    rightproj: forall x y -> C.morph[#mapobj product (x, y), y],
    pair:
      C.morph[x, y] -> C.morph[x, z] ->
      C.morph[x, #mapobj product (y, z)] } *)
  type ('Cobj, 'Cmorph) cartesian = {
    unit:'Cobj,
    product: ('Cobj * 'Cobj, 'Cmorph * 'Cmorph, 'Cobj, 'Cmorph) Funct.funct,
    swapmap: ('Cobj * 'Cobj, 'Cmorph) Funct.nattrans,
    leftproj: 'Cobj -> 'Cobj -> 'Cmorph,
    rightproj: 'Cobj -> 'Cobj -> 'Cmorph,
    pair: 'Cmorph -> 'Cmorph -> 'Cmorph }
end

(*The types of monoidal and cartesian structures on a category `C`. *)
functor MonoidalOf (C : CATEGORY) =
struct
  type monoidal = (C.obj, C.morph) Monoidal.monoidal
  type symmetricmonoidal = (C.obj, C.morph) Monoidal.symmetricmonoidal
  type cartesian = (C.obj, C.morph) Monoidal.cartesian

  (*A symmetric monoidal category is trivially a monoidal category. *)
  val symmetricMonoidalIntoMonoidal :
      symmetricmonoidal -> monoidal = fn s => {
    unit = #unit s,
    tensor = #tensor s }

  (*A cartesian category is trivially a symmetric monoidal category. *)
  val cartesianIntoSymmetricMonoidal :
      cartesian -> symmetricmonoidal = fn c => {
    unit = #unit c,
    tensor = #product c,
    swapmap = #swapmap c }
end
