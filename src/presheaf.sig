(*We use the term "co-presheaf" to mean a set-valued functor on `D`.
  The SML approximation is a type `t[x]` for each object `x` of `D`,
  all coalesced into the combined type `t`.
  The typical definition of a presheaf on `C` is recovered
  by having `D` as the opposite category of `C`. *)
signature COPRESHEAF =
sig
  (*The domain category of the functor *)
  structure D : CATEGORY

  type t

  type elemerror
  exception ElemType of elemerror

  (*Type checks an element against its index object in `D`.
    `check e x` should succeed when `e : t[x]`,
    and otherwise raise `ElemType`. *)
  val check : t -> D.obj -> unit

  (*The action of the functor on a morphism.
  val mapmorph : D.morph[x, y] -> t[x] -> t[y] *)
  val mapmorph : D.morph -> t -> t
end
