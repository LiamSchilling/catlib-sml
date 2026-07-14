structure Exception =
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

  datatype direction = Negative | Unbound
  exception Subscript of direction

  (* Retrieve the `i`th element of a list for non-negative `i`. *)
  fun nthpos 0 (x :: X) = x
    | nthpos i (_ :: X) = nthpos (i - 1) X
    | nthpos i [] = raise Subscript Unbound

  (* Retrieve the `i`th element of a list. *)
  fun nth i X =
    if i < 0 then
      raise Subscript Negative
    else
      nthpos i X
end
