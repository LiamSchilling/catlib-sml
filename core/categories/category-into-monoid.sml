(* A category can be cast as a monoid on its morphisms,
   taking the identity at a dedicated object `Point`.
   (with multiplication partially well-defined). *)
functor CategoryIntoMonoid (C : CATEGORY) : HIDDENIDMONOID =
struct
  structure Elem = C.Morph

  val mul = C.comp
  val isid = C.isid
end
