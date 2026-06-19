(*A presheaf is a contravariant functor from `C` into the category `Set`.
  The SML approximation is a type `t[x]` for each object `x` of `C`,
  all coalesced into the combined type `t`. *)
signature PRESHEAF =
sig
  (*The domain category of the presheaf *)
  structure D : CATEGORY

  type t

  type elemerror
  exception ElemType of elemerror

  (*Type checks an element against its index object in `D`.
    `check e x` should succeed when `e : t[x]`,
    and otherwise raise `ElemType`. *)
  val check : t -> D.obj -> unit

  (*The action of the presheaf on a morphism.
  val mapmorph : D.morph[x, y] -> t[y] -> t[x] *)
  val mapmorph : D.morph -> t -> t
end
