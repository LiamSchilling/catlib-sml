(* The free category on a generating labeled di-graph. *)
functor FreeCategory
  (G : LABELEDDIGRAPH)
  (Stream : STREAMMONOID where type elem = G.Edge.t * G.Node.t)
  : CATEGORY =
struct
  (* The objects of the category are the nodes of the graph. *)
  structure Obj = G.Node

  (* The morphisms are the reflecive and transitive closure
     of the edges of the graph, a.k.a. finite sequences of edges.
     A stream representation is preferred to explicit lists
     to reduce the space overhead of long edge lists.
  type morph[x, y] =
    (G.edge[x, z] * (z : G.node)) * (G.edge[z, w] * (w : G.node)) * ...
    (G.edge[u, v] * (v : G.node)) * (G.edge[v, y] * (y : G.node)) *)
  structure Morph = StreamSetoid(ProductSetoid(G.Edge)(G.Node))(Stream)

  datatype morpherror =
      ObjMismatch of Obj.t * Obj.t
    | ErrorAt of int * G.edgeerror

  exception MorphType of morpherror

  fun checkFrom i A (x, y) =
    case Stream.step A of
      NONE => (
      if Obj.eq (x, y) then
        ()
      else
        raise MorphType (ObjMismatch (x, y)) )
    | SOME ((a, z), A') => (
      G.check a (x, z) handle
        G.EdgeType e => raise MorphType (ErrorAt (i, e));
      checkFrom (i + 1) A (z, y) )

  val check = checkFrom 0

  fun id x = Stream.empty

  fun comp (A, B) = Stream.append (A, B)
end
