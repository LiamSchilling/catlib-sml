(* A category can be cast as a monoid on its morphisms,
   taking the identity at a dedicated object `Point`.
   (with multiplication partially well-defined). *)
functor CategoryIntoMonoid
  (C : CATEGORY)
  (Point : sig val x : C.Obj.t end)
  : MONOID =
struct
  structure Elem = C.Morph

  val id = C.id Point.x
  val mul = C.comp
  val isid = C.isid
end
