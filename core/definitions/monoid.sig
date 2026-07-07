(* A monoid is a collection of elements `elem` and,
   with identity and multiplication of elements as defined below. *)
signature MONOID =
sig
  structure Elem : SETOID

  (* The identity element. *)
  val id : Elem.t

  (* Multiplication of elements. *)
  val mul : Elem.t * Elem.t -> Elem.t

  (* Checks whether an element is the identity. *)
  val isid : Elem.t -> bool
end
