(* A category is trivially a labeled digraph. *)
functor CategoryIntoLabeledDigraph (C : CATEGORY) : LABELEDDIGRAPH =
struct
  structure Node = C.Obj
  structure Edge = C.Morph

  type edgeerror = C.morpherror
  exception EdgeType = C.MorphType

  val check = C.check
end
