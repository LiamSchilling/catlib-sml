(* A category is a collection of objects `obj` and,
   for any pair of objects `x, y`, a collection of morphisms `morph[x, y]`,
   with identity and composition of morphisms as defined below. *)
signature CATEGORY =
sig
  structure Obj : SETOID
  structure Morph : SETOID

  type morpherror
  exception MorphType of morpherror

  (* Type checks a morphism against its source and destination objects.
     `check a (x, y)` should succeed when `a : morph[x, y]`,
     and otherwise raise `MorphType`. *)
  val check : Morph.t -> Obj.t * Obj.t -> unit

  (* The identity morphism for an object.
  val id : forall x -> morph[x, x] *)
  val id : Obj.t -> Morph.t

  (* Composition of morphisms.
     The behavior is undefined when the input morphisms are ill-typed.
  Equational laws:
    - associativity
    - the identity is unit
  val comp : morph[y, z] * morph[x, y] -> morph[x, z] *)
  val comp : Morph.t * Morph.t -> Morph.t
end
