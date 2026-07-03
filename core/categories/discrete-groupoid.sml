(* The discrete groupoid on a generating set of objects. *)
functor DiscreteGroupoid (S : SETOID) : CATEGORY =
struct
  structure C = DiscreteCategory(S)
  open C

  fun inv () = ()
end
