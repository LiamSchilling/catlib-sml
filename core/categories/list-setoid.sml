(* The free finite product setoid on `S`. *)
functor ListSetoid (S : SETOID) : SETOID =
struct
  type t = S.t list

  fun eq ([], []) = true
    | eq (x :: X, y :: Y) = S.eq (x, y) andalso eq (X, Y)
    | eq (_, _) = false
end
