(*A category is a collection of objects `obj` and,
  for any pair of objects `x, y`, a collection of morphisms `morph[x, y]`,
  with identity and composition of morphisms as defined below. *)
signature CATEGORY =
sig
  type obj
  type morph

  type morpherror
  exception MorphType of morpherror

  (*Type checks a morphism against its source and destination objects.
    `check a (x, y)` should succeed when `a : morph[x, y]`,
    and otherwise raise `MorphType`. *)
  val check : morph -> obj * obj -> unit

  (*The identity morphism for an object.
  val id : forall x -> morph[x, x] *)
  val id : obj -> morph

  (*Composition of morphisms.
    The behavior is undefined when the input morphisms are ill-typed.
  val comp : morph[y, z] * morph[x, y] -> morph[x, z] *)
  val comp : morph * morph -> morph
end
