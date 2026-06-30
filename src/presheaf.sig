(* A set-valued functor on the domain category `D`.
   It may be interpreted as either a presheaf (contravariant functor),
   or just a covariant set-valued functor,
   but the implementer should explicitly state
   which interpretation is being used. *)
signature PRESHEAF =
sig
  (* The domain category of the functor. *)
  structure D : CATEGORY

  (* The collective type of elements `t[x]`
     over all possible objects `x` of `D`. *)
  type t

  type elemerror
  exception ElemType of elemerror

  (* The equivalence judgment on elements.
     Equational laws should be up to, functions should cohere with,
     and typing judgments should convert with respect to `equiv`,
     enabling sound quotient-style constructions.
     The behavior is undefined when the input elements are ill-typed.
  val equiv : t[x] * t[x] -> bool *)
  val equiv : t * t -> bool

  (* Type checks an element against its index object in `D`.
     `check e x` should succeed when `e : t[x]`,
     and otherwise raise `ElemType`. *)
  val check : t -> D.obj -> unit

  (* The action of the functor on a morphism.
  Equational laws:
    - `mapmorph (id x)` is the identity function
    - `mapmorph (comp a b)` is the composition of `mapmorph a` and `mapmorph b`
  val mapmorph : D.morph[x, y] -> t[x] -> t[y]
    (for covariant set-valued functor)
  val mapmorph : D.morph[x, y] -> t[y] -> t[x]
    (for presheaf/contravariant functor) *)
  val mapmorph : D.morph -> t -> t
end
