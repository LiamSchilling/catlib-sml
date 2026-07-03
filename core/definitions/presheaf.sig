(* A set-valued functor on the domain category `D`.
   It may be interpreted as either a presheaf (contravariant functor),
   or just a covariant set-valued functor,
   but the implementer should explicitly state
   which interpretation is being used. *)
signature PRESHEAF =
sig
  (* The domain category of the functor. *)
  structure D : CATEGORY

  (* The collective type of elements `elem[x]`
     over all possible objects `x` of `D`. *)
  structure Elem : SETOID

  type elemerror
  exception ElemType of elemerror

  (* Type checks an element against its index object in `D`.
     `check e x` should succeed when `e : elem[x]`,
     and otherwise raise `ElemType`. *)
  val check : Elem.t -> D.Obj.t -> unit

  (* The action of the functor on a morphism.
     The behavior is undefined when the inputs are ill-typed.
  Equational laws:
    - `mapmorph (id x)` is the identity function
    - `mapmorph (comp a b)` is the composition of `mapmorph a` and `mapmorph b`
  val mapmorph : D.morph[x, y] -> elem[x] -> elem[y]
    (for covariant set-valued functor)
  val mapmorph : D.morph[x, y] -> elem[y] -> elem[x]
    (for presheaf/contravariant functor) *)
  val mapmorph : D.Morph.t -> Elem.t -> Elem.t
end
