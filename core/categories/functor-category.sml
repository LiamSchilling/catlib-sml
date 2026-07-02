structure Funct =
struct
  (* The objects are functors.
  Equational laws:
    - `mapmorph` preserves the identity morphism
    - `mapmorph` preserves composition of morphisms
  type functor[C, D] = {
    mapobj: C.obj -> D.obj,
    mapmorph: C.morph[x, y] -> D.morph[mapobj x, mapobj y] } *)
  type ('Cobj, 'Cmorph, 'Dobj, 'Dmorph) funct = {
    mapobj: 'Cobj -> 'Dobj,
    mapmorph: 'Cmorph -> 'Dmorph }

  (* The morphisms are natural transformations between functors `f, g`.
  Equational laws:
    - point-wise composition of `component` and `mapmorph` commute (naturality)
  type nattrans[f, g] = {
    component: forall x -> D.morph[#mapobj f x, #mapobj g x] } *)
  type ('Cobj, 'Dmorph) nattrans = {
    component: 'Cobj -> 'Dmorph }
end

(* The category of functors between categories `C, D`. *)
functor FunctorCategory (C : CATEGORY) (D : CATEGORY) : CATEGORY =
struct
  type obj = (C.obj, C.morph, D.obj, D.morph) Funct.funct
  type morph = (C.obj, D.morph) Funct.nattrans

  datatype morpherror = UnimplementedUndecidable
  exception MorphType of morpherror

  fun objequiv (f, g) = raise MorphType UnimplementedUndecidable

  fun morphequiv (n, m) = raise MorphType UnimplementedUndecidable

  fun check n (f, g) = raise MorphType UnimplementedUndecidable

  fun id (f: obj) = {
    component = fn x => D.id (#mapobj f x) }

  fun comp (n: morph, m: morph) = {
    component = fn x => D.comp (#component n x, #component m x) }
end
