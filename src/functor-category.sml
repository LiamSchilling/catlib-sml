(*The category of functors between categories `C, D`. *)
functor FunctorCategory (C : CATEGORY) (D : CATEGORY) : CATEGORY =
struct
  (*The objects are functors.
  type obj = {
    mapobj: C.obj -> D.obj,
    mapmorph: C.morph[x, y] -> D.morph[mapobj x, mapobj y] } *)
  type obj = {
    mapobj: C.obj -> D.obj,
    mapmorph: C.morph -> D.morph }

  (*The morphisms are natural transformations between functors `f, g`.
  type morph[f, g] = {
    component: forall x -> D.morph[#mapobj f x, #mapobj g x] } *)
  type morph = {
    component: C.obj -> D.morph }

  datatype morpherror = UnimplementedUndecidable
  exception MorphType of morpherror

  fun check n f g = raise MorphType UnimplementedUndecidable

  fun id (f: obj) = {
    component = fn x => D.id (#mapobj f x) }

  fun comp (n: morph) (m: morph) = {
    component = fn x => D.comp (#component n x) (#component m x) }
end
