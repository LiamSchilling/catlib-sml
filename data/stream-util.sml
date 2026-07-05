(* Stream utilities. *)
functor StreamUtil (Stream : STREAM) =
struct
  (* Retrieve the last element of a stream if it exists. *)
  fun last (s: Stream.stream) : Stream.elem option =
    case Stream.step s of
      NONE => NONE
    | SOME (e, s') => SOME (
      case last s' of
        NONE => e
      | SOME e' => e' )
end
