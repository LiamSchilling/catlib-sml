(* The free (not-necessarily finite) product setoid on `S`. *)
functor LazyListSetoid (S : SETOID) : SETOID =
struct
  open LazyList

  type t = S.t lazylist

  fun eq (Nil, Nil) = true
    | eq (Cons (x, f), Cons (y, g)) = S.eq (x, y) andalso eq (f (), g ())
    | eq (_, _) = false
end
