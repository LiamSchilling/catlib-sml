(* A monoid is a collection of elements `elem` and,
   with identity and multiplication of elements as defined below.
   The identity is "hidden" in that we can only check for identity,
   but not construct it from nothing. *)
signature HIDDENIDMONOID =
sig
  structure Elem : SETOID

  (* Multiplication of elements. *)
  val mul : Elem.t * Elem.t -> Elem.t

  (* Checks whether an element is the identity. *)
  val isid : Elem.t -> bool
end
