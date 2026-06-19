(*The discrete groupoid on a type of objects. *)
functor DiscreteGroupoid (T : sig
  type t
  val equiv : t * t -> bool
end) : CATEGORY =
struct
  structure C = DiscreteCategory(T)
  open C

  fun inv () = ()
end
