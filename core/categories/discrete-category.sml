(* The discrete category on a generating set of objects. *)
functor DiscreteCategory (S : SETOID) : CATEGORY =
struct
  (* The type of objects is provided. *)
  structure Obj = S

  (* The only morphisms are the trivial identity morphisms. *)
  structure Morph = UnitSetoid

  datatype morpherror = ObjMismatch of Obj.t * Obj.t
  exception MorphType of morpherror

  fun check () (x, y) =
    if Obj.eq (x, y) then
      ()
    else
      raise MorphType (ObjMismatch (x, y))

  fun id _ = ()

  fun comp ((), ()) = ()
end
