(* The free category on a generating labeled di-graph `G`. *)
functor FreeCategory (G : LABELEDDIGRAPH) : CATEGORY =
struct
  open LazyList

  (* The objects of the category are the nodes of the graph. *)
  structure Obj = G.Node

  (* The morphisms are the reflecive and transitive closure
     of the edges of the graph, a.k.a. finite sequences of edges.
     The lazy representation is preferred to explicit lists
     to reduce the space overhead of long edge lists.
  datatype morph =
      Nil : morph[x, x]
    | Cons : (G.edge[x, y] * (y : G.node)) * morph[y, z] -> morph[x, z] *)
  structure Morph = LazyListSetoid(ProductSetoid(G.Edge)(G.Node))

  datatype morpherror =
      ObjMismatch of Obj.t * Obj.t
    | ErrorAt of int * G.edgeerror

  exception MorphType of morpherror

  fun checkFrom i Nil (x, y) = (
      if Obj.eq (x, y) then
        ()
      else
        raise MorphType (ObjMismatch (x, y)) )
    | checkFrom i (Cons ((a, y), f)) (x, z) = (
      G.check a (x, y) handle
        G.EdgeType e => raise MorphType (ErrorAt (i, e));
      checkFrom (i + 1) (f ()) (y, z) )

  val check = checkFrom 0

  fun id x = Nil

  fun comp (A, B) = append (A, B)
end
