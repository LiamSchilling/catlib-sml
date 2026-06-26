(*An implementation of the composition of functors and
  horizontal composite of natural transformations. *)
functor FunctorComposition (C : CATEGORY) (D : CATEGORY) (E : CATEGORY) =
struct
  (*References to categories of functors. *)
  structure CtoD = FunctorCategory(C)(D)
  structure DtoE = FunctorCategory(D)(E)
  structure CtoE = FunctorCategory(C)(E)

  (*A reference to the relevant category of bifunctors *)
  structure B = FunctorCategory(ProductCategory(DtoE)(CtoD))(CtoE)

  (*Because our design does not annotate natural transformations (morphisms)
    with their source and destination functors (objects),
    it is impossible to express the horizontal composite of
    (a.k.a. the action of functor composition on) natural transformations
    given only references to the transformations themselves. *)
  exception UnimplementedUnexpressible

  (*The composition of functors,
    as a bifunctor on the categories of functors. *)
  val comp : B.obj = {
      mapobj = fn (f, g) => {
        mapobj = (#mapobj f) o (#mapobj g),
        mapmorph = (#mapmorph f) o (#mapmorph g) },
      mapmorph = fn (n, m) => raise UnimplementedUnexpressible }

  (*The horizontal composite of natural transformations `n, m`,
    given the source functor of `n` and the destination functor of `m`.
  val horizontalCompOfSrcAndDest :
      forall (f, g') -> nattrans[f, f'] * nattrans[g, g'] ->
      nattrans[#mapobj comp (f, g), #mapobj comp (f', g')] *)
  val horizontalCompOfDestAndSrc :
      DtoE.obj * CtoD.obj -> DtoE.morph * CtoD.morph -> CtoE.morph =
    fn (f, g) => fn (n, m) => {
      component = fn x =>
        E.comp (#component n (#mapobj g x)) (#mapmorph f (#component m x)) }

  (*The horizontal composite of natural transformations `n, m`,
    given the destination functor of `n` and the source functor of `m`.
  val horizontalCompOfDestAndSrc :
      forall (f', g) -> nattrans[f, f'] * nattrans[g, g'] ->
      nattrans[#mapobj comp (f, g), #mapobj comp (f', g')] *)
  val horizontalCompOfDestAndSrc :
      DtoE.obj * CtoD.obj -> DtoE.morph * CtoD.morph -> CtoE.morph =
    fn (f, g) => fn (n, m) => {
      component = fn x =>
        E.comp (#mapmorph f (#component m x)) (#component n (#mapobj g x)) }
end
