structure FunctIso =
struct
  (*The morphisms are natural isomorphisms between functors `f, g`.
  type natiso[f, g] = {
    to: nattrans[f, g],
    from: nattrans[g, f] } *)
  type ('Cobj, 'Dmorph) natiso = {
    to: ('Cobj, 'Dmorph) Funct.nattrans,
    from: ('Cobj, 'Dmorph) Funct.nattrans }
end

(*The groupoid of functors between categories `C, D`,
  with natural isomorphisms as morphisms. *)
functor FunctorIsoGroupoid (C : CATEGORY) (D : CATEGORY) : GROUPOID =
struct
  (*A reference to the category of functors. *)
  structure CtoD = FunctorCategory(C)(D)

  type obj = (C.obj, C.morph, D.obj, D.morph) Funct.funct
  type morph = (C.obj, D.morph) FunctIso.natiso

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
