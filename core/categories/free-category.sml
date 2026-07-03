(* The free category on a generating labeled di-graph. *)
functor FreeCategory (G : LABELEDDIGRAPH) : CATEGORY =
struct
  (* The objects of the category are the nodes of the graph. *)
  structure Obj = G.Node

  (* The morphisms are the reflecive and transitive closure
     of the edges of the graph.
  datatype morph =
      Nil : morph[x, x]
    | Cons : (z : G.node) * G.edge[z, y] * morph[x, z] -> morph[x, y] *)
  structure Morph = ListSetoid(ProductSetoid(G.Node)(G.Edge))

  datatype morpherror =
      ObjMismatch of Obj.t * Obj.t
    | ErrorAt of int * G.edgeerror

  exception MorphType of morpherror

  fun checkFrom i [] (x, y) =
      if Obj.eq (x, y) then () else raise MorphType (ObjMismatch (x, y))
    | checkFrom i ((z, a) :: A) (x, y) = (
      G.check a (z, y) handle
        G.EdgeType e => raise MorphType (ErrorAt (i, e));
      checkFrom (i + 1) A (x, z) )

  val check = checkFrom 0

  fun id x = []

  fun comp (A, B) = A @ B
end
