(*The opposite category of `C`. *)
functor OppositeCategory (C : CATEGORY) : CATEGORY =
struct
  (*The objects of the opposite category are identical. *)
  type obj = C.obj

  (*The opposite morphisms
    have their source and destination objects reversed.
  type morph[x, y] = C.morph[y, x] *)
  type morph = C.morph

  type morpherror = C.morpherror
  exception MorphType = C.MorphType

  fun check a (x, y) = C.check a (y, x)

  fun id x = C.id x

  fun comp (a, b) = C.comp (b, a)
end
