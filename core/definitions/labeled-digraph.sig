(* A labeled di-graph is a collection of nodes `node` and,
   for any pair of nodes `x, y`, a collection of edges `edge[x, y]`. *)
signature LABELEDDIGRAPH =
sig
  structure Node : SETOID
  structure Edge : SETOID

  type edgeerror
  exception EdgeType of edgeerror

  (* Type checks an edge against its source and destination nodes.
     `check a (x, y)` should succeed when `a : edge[x, y]`,
     and otherwise raise `EdgeType`. *)
  val check : Edge.t -> Node.t * Node.t -> unit
end
