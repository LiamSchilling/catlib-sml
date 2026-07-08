(* The canonical setoid on an equality type. *)
functor StrictSetoid (T : sig eqtype t end) =
struct
  type t = T.t

  fun eq (x: t, y: t) = (x = y)
end
