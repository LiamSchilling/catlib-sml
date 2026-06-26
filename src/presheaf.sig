(*A set-valued functor on the domain category `D`.
  It may be interpreted as either a presheaf (contravariant functor),
  or just a covariant set-valued functor,
  but the implementer should explicitly state which interpretation is being used. *)
signature PRESHEAF =
sig
  (*The domain category of the functor. *)
  structure D : CATEGORY

  (*The collective type of elements `t[x]` over all possible objects `x` of `D`. *)
  type t

  type elemerror
  exception ElemType of elemerror

  (*Type checks an element against its index object in `D`.
    `check e x` should succeed when `e : t[x]`,
    and otherwise raise `ElemType`. *)
  val check : t -> D.obj -> unit

  (*The action of the functor on a morphism.
  val mapmorph : D.morph[x, y] -> t[x] -> t[y] (for covariant set-valued functor)
  val mapmorph : D.morph[x, y] -> t[y] -> t[x] (for presheaf/contravariant functor) *)
  val mapmorph : D.morph -> t -> t
end
