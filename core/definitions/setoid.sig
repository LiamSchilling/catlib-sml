(* A setoid is a type `t` equipped with an equivalence relation `eq`.
   In the meta-theory, `t` may be interpreted as an indexed family
   with members `t[x]` for values `x`. *)
signature SETOID =
sig
  type t

  (* The canonical equivalence relation.
     Equational laws should be up to, functions should cohere with,
     and typing judgments should convert with respect to `objequiv`,
     enabling sound quotient-style constructions.
     When `t` is interpreted as an indexed family,
     the rich type signature of `eq` is as below,
     with the behavior being undefined when the inputs are ill-typed.
  val eq : t[x] * t[x] -> bool *)
  val eq : t * t -> bool
end
