structure Functor =
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
  structure Obj =
  struct
    type t = (C.Obj.t, C.Morph.t, D.Obj.t, D.Morph.t) Functor.funct

    fun eq (f, g) = raise Exceptions.UnimplementedUnexpressible
  end

  structure Morph =
  struct
    type t = (C.Obj.t, D.Morph.t) Functor.nattrans

    fun eq (n, m) = raise Exceptions.UnimplementedUnexpressible
  end

  type morpherror = unit
  exception MorphType of morpherror

  fun check n (f, g) = raise Exceptions.UnimplementedUnexpressible

  fun id (f: Obj.t) = {
    component = fn x => D.id (#mapobj f x) }

  fun comp (n: Morph.t, m: Morph.t) = {
    component = fn x => D.comp (#component n x, #component m x) }
end
