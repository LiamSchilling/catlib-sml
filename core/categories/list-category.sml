(* The free finite product category on `C`. *)
functor ListCategory (C : CATEGORY) : CATEGORY =
struct
  (* The objects of the category are lists. *)
  structure Obj = ListSetoid(C.Obj)

  (* The morphisms are also lists.
  type morph[[x, ... y], [z, ... w]] = morph[x, z] * ... morph[y, w] *)
  structure Morph = ListSetoid(C.Morph)

  datatype morpherror =
      IllFormed of Morph.t * Obj.t * Obj.t
    | BadComp of Morph.t * Morph.t
    | ErrorAt of int * C.morpherror

  exception MorphType of morpherror

  fun checkFrom i [] ([], []) = ()
    | checkFrom i (a :: A) (x :: X, y :: Y) = (
      C.check a (x, y) handle
        C.MorphType e => raise MorphType (ErrorAt (i, e));
      checkFrom (i + 1) A (X, Y) )
    | checkFrom i A (X, Y) =
      raise MorphType (IllFormed (A, X, Y))

  val check = checkFrom 0

  fun id [] = []
    | id (x :: X) = C.id x :: id X

  fun comp ([], []) = []
    | comp (a :: A, b :: B) = C.comp (a, b) :: comp (A, B)
    | comp (A, B) = raise MorphType (BadComp (A, B))

  fun isid [] = true
    | isid (a :: A) = C.isid a andalso isid A
end
