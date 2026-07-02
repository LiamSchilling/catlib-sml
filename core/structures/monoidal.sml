structure Monoidal =
struct
  (* The type of (strict) monoidal structures.
  Equational laws:
    - `tensor` is associative
    - `unit` is unit for `tensor`
  type monoidal[C] = {
    unit: C.obj,
    tensor: functor[C * C, C] } *)
  type ('Cobj, 'Cmorph) monoidal = {
    unit: 'Cobj,
    tensor: ('Cobj * 'Cobj, 'Cmorph * 'Cmorph, 'Cobj, 'Cmorph) Funct.funct }

  (* The type of symmetric monoidal structures,
     where the associativity and unit laws are strict,
     but symmetry is given by an isomorphism `swapmap`.
  Equational laws:
    - `tensor` is associative
    - `unit` is unit for `tensor`
    - `swapmap` is involutive
    - the hexagon law (`swapmap` coherence with associativity)
  type symmetricmonoidal[C] = {
    unit: C.obj,
    tensor: functor[C * C, C],
    swapmap: nattrans[tensor, swap tensor] } *)
  type ('Cobj, 'Cmorph) symmetricmonoidal = {
    unit: 'Cobj,
    tensor: ('Cobj * 'Cobj, 'Cmorph * 'Cmorph, 'Cobj, 'Cmorph) Funct.funct,
    swapmap: ('Cobj * 'Cobj, 'Cmorph) Funct.nattrans }

  (* The type of cartesian structures,
     where the associativity and unit laws are strict,
     and symmetry can be derived as an isomorphism `swapmap`.
     The behavior of `pair` is undefined
     when the input morphisms are ill-typed.
  Equational laws:
    - `comp (leftproj x y) (pair a b)` is equiv to `a`
    - `comp (rightproj x y) (pair a b)` is equiv to `b`
    - `pair (comp (leftproj x y) a) (comp (rightproj x y) a)` is equiv to `a`
    - `pair` is uniquely determined by `leftproj` and `rightproj`
  type cartesian[C] = {
    unit: C.obj,
    product: functor[C * C, C],
    leftproj: forall (x, y) -> C.morph[#mapobj product (x, y), x],
    rightproj: forall (x, y) -> C.morph[#mapobj product (x, y), y],
    pair:
      C.morph[x, y] * C.morph[x, z] ->
      C.morph[x, #mapobj product (y, z)] } *)
  type ('Cobj, 'Cmorph) cartesian = {
    unit: 'Cobj,
    product: ('Cobj * 'Cobj, 'Cmorph * 'Cmorph, 'Cobj, 'Cmorph) Funct.funct,
    leftproj: 'Cobj * 'Cobj -> 'Cmorph,
    rightproj: 'Cobj * 'Cobj -> 'Cmorph,
    pair: 'Cmorph * 'Cmorph -> 'Cmorph }
end

(* The types of monoidal and cartesian structures on a category `C`. *)
functor MonoidalOf (C : CATEGORY) =
struct
  type monoidal = (C.obj, C.morph) Monoidal.monoidal
  type symmetricmonoidal = (C.obj, C.morph) Monoidal.symmetricmonoidal
  type cartesian = (C.obj, C.morph) Monoidal.cartesian

  (* A symmetric monoidal category is trivially a monoidal category. *)
  val symmetricMonoidalIntoMonoidal :
      symmetricmonoidal -> monoidal = fn s => {
    unit = #unit s,
    tensor = #tensor s }

  (* A cartesian category is trivially a symmetric monoidal category. *)
  val cartesianIntoSymmetricMonoidal :
      cartesian -> symmetricmonoidal = fn c => {
    unit = #unit c,
    tensor = #product c,
    swapmap = {
      component = fn (x, y) =>
        #pair c (#rightproj c (x, y), #leftproj c (x, y)) } }
end
