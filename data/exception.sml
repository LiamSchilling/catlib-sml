structure Exceptions =
struct
  (* Raise to signal that a function cannot be implemented
     according to its theoretical specification. *)
  exception UnimplementedUnexpressible

  (* Assert that a predicate holds on a point,
     and otherwise raise an exception
     with the offending point as the message. *)
  fun assert (pred: 'a -> bool) (err: 'a -> exn) (a: 'a) : unit =
    if pred a then
      ()
    else
      raise err a
end
