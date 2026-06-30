(* The free finite product category on `C`. *)
functor ListCategory (C : CATEGORY) : CATEGORY =
struct
  (* The objects of the category are lists. *)
  type obj = C.obj list

  (* The morphisms are also lists.
  type morph[[x, ... y], [z, ... w]] = morph[x, z] * ... morph[y, w] *)
  type morph = C.morph list

  datatype morpherror = IllFormed | ErrorAt of int * C.morpherror
  exception MorphType of morpherror

  fun objequiv ([], []) = true
    | objequiv (x :: X, y :: Y) =
      C.objequiv (x, y) andalso objequiv (X, Y)
    | objequiv (_, _) = raise MorphType IllFormed
  
  fun morphequiv ([], []) = true
    | morphequiv (a :: A, b :: B) =
      C.morphequiv (a, b) andalso morphequiv (A, B)
    | morphequiv (_, _) = raise MorphType IllFormed

  fun checkFrom i [] ([], []) = ()
    | checkFrom i (a :: A) (x :: X, y :: Y) = (
      C.check a (x, y) handle C.MorphType e =>
        raise MorphType (ErrorAt (i, e));
      checkFrom (i + 1) A (X, Y) )
    | checkFrom i _ (_, _) = raise MorphType IllFormed

  val check = checkFrom 0

  fun id [] = []
    | id (x :: X) = C.id x :: id X

  fun comp ([], []) = []
    | comp (a :: A, b :: B) = C.comp (a, b) :: comp (A, B)
    | comp (_, _) = raise MorphType IllFormed
end
