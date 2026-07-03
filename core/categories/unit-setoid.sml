(* The setoid with only the trivial element. *)
structure UnitSetoid =
struct
  type t = unit

  fun eq ((), ()) = true
end
