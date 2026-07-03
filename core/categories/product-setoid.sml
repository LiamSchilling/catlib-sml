(* The product of setoids `S, T`. *)
functor ProductSetoid (S : SETOID) (T : SETOID) : SETOID =
struct
  type t = S.t * T.t

  fun eq ((x, y), (z, w)) = S.eq (x, z) andalso T.eq (y, w)
end
