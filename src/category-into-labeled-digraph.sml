(* A category is trivially a labeled digraph. *)
functor CategoryIntoLabeledDigraph (C : CATEGORY) : LABELEDDIGRAPH =
struct
  type node = C.obj
  type edge = C.morph

  type edgeerror = C.morpherror
  exception EdgeType = C.MorphType

  val nodeequiv = C.objequiv
  val edgeequiv = C.morphequiv
  val check = C.check
end
