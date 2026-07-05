(* The free (not-necessarily finite) product setoid on `S`. *)
functor StreamSetoid
  (S : SETOID)
  (Stream : STREAM where type elem = S.t)
  : SETOID =
struct
  type t = Stream.stream

  fun eq (X, Y) =
    case (Stream.step X, Stream.step Y) of
      (NONE, NONE) => true
    | (SOME (x, X'), SOME (y, Y')) => S.eq (x, y) andalso eq (X', Y')
    | (_, _) => false
end
