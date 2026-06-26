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

  fun check (a, b) ((x, y), (z, w)) = (
    C.check a (x, z) handle C.MorphType e => raise MorphType (LeftError e);
    D.check b (y, w) handle D.MorphType e => raise MorphType (RightError e) )

  fun id (x, y) = (C.id x, D.id y)

  fun comp ((a, b), (c, d)) = (C.comp (a, c), D.comp (b, d))
end
