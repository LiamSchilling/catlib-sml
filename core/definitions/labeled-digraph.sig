(* A labeled di-graph is a collection of nodes `node` and,
   for any pair of nodes `x, y`, a collection of edges `edge[x, y]`. *)
signature LABELEDDIGRAPH =
sig
  type node
  type edge

  type edgeerror
  exception EdgeType of edgeerror

  (* The equivalence judgment on nodes. *)
  val nodeequiv : node * node -> bool

  (* The equivalence judgment on morphisms.
     The behavior is undefined when the input edges are ill-typed.
  val edgeequiv : edge[x, y] * edge[x, y] -> bool *)
  val edgeequiv : edge * edge -> bool

  (* Type checks an edge against its source and destination nodes.
     `check a (x, y)` should succeed when `a : edge[x, y]`,
     and otherwise raise `EdgeType`. *)
  val check : edge -> node * node -> unit
end
