(*The product of categories `C, D`. *)
functor ProductCategory (C : CATEGORY) (D : CATEGORY) : CATEGORY =
struct
  (*The objects of the product category are pairs. *)
  type obj = C.obj * D.obj

  (*The product morphisms are also pairs.
  type morph[(x, y), (z, w)] = morph[x, z] * morph[y, w] *)
  type morph = C.morph * D.morph

  datatype morpherror = LeftError of C.morpherror | RightError of D.morpherror
  exception MorphType of morpherror

  (*Run a thunk, forwarding `C.MorphType` errors as `MorphType` errors. *)
  fun liftLeftError (f : unit -> 'a) =
    f () handle C.MorphType e => raise MorphType (LeftError e)

  (*Run a thunk, forwarding `D.MorphType` errors as `MorphType` errors. *)
  fun liftRightError (f : unit -> 'a) =
    f () handle D.MorphType e => raise MorphType (RightError e)

  fun check (a, b) (x, y) (z, w) = (
    liftLeftError (fn () => C.check a x z);
    liftRightError (fn () => D.check b y w) )

  fun id (x, y) = (C.id x, D.id y)

  fun comp (a, b) (c, d) = (C.comp a c, D.comp b d)
end
