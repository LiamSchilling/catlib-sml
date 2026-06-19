(*The discrete category on a type of objects. *)
functor DiscreteCategory (T : sig
  type t
  val equiv : t * t -> bool
end) : CATEGORY =
struct
  (*The type of objects is provided. *)
  type obj = T.t

  (*The only morphisms are the trivial identity morphisms *)
  type morph = unit

  datatype morpherror = UnequalObjects of obj * obj
  exception MorphType of morpherror

  fun check () x y =
    if T.equiv (x, y) then
      ()
    else
      raise MorphType (UnequalObjects (x, y))

  fun id _ = ()

  fun comp () () = ()
end
