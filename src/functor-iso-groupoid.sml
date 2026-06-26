(*The groupoid of functors between categories `C, D`,
  with natural isomorphisms as morphisms. *)
functor FunctorIsoGroupoid (C : CATEGORY) (D : CATEGORY) : GROUPOID =
struct
  (*A reference to the category of functors. *)
  structure CtoD = FunctorCategory(C)(D)

  (*The objects are functors. *)
  type obj = CtoD.obj

  (*The morphisms are natural isomorphisms between functors `f, g`.
  type morph[f, g] = {
    to: nattrans[f, g],
    from: nattrans[g, f] } *)
  type morph = {
    to: CtoD.morph,
    from: CtoD.morph }

  datatype morpherror = UnimplementedUndecidable
  exception MorphType of morpherror

  fun check n (f, g) = raise MorphType UnimplementedUndecidable

  fun id (f: obj) = {
    to = CtoD.id f,
    from = CtoD.id f }

  fun comp (n: morph, m: morph) = {
    to = CtoD.comp (#to n, #to m),
    from = CtoD.comp (#from m, #from n) }

  fun inv (n: morph) = {
    to = #from n,
    from = #to n }
end
