(* The minimal specification for
   a language of typed terms
   given by a presheaf on a cartesian category of contexts.
   See also `TERMLANGUAGE` and `MakeTermLanguage`. *)
signature TERMLANGUAGETEMPLATE =
sig
  (* The category of types. *)
  structure Ty : CATEGORY

  (* The collective type of terms `tm[ctx, t]`
     over all possible contexts `ctx` from `Ty.obj list`
     and types `t` from `Ty.obj`. *)
  type tm

  type termerror
  exception TermType of termerror

  (* The equivalence judgment on terms.
     Equational laws should be up to, functions should cohere with,
     and typing judgments should convert with respect to `equiv`,
     enabling sound quotient-style constructions.
     The behavior is undefined when the input terms are ill-typed.
  val tmequiv : tm[ctx, t] * tm[ctx, t] -> bool *)
  val tmequiv : tm * tm -> bool

  (* Type checks a term in a context.
     `check e (ctx, t)` should succeed when `e : tm[ctx, t]`,
     and otherwise raise `TermType`. *)
  val check : tm -> Ty.obj list * Ty.obj -> unit

  (* The variable introduction form.
  val var : forall i -> tm[ctx, ctx[i]] *)
  val var : int -> tm

  (* Substitute all the variables in a term.
     Categorically, this is the restriction map
     for morphisms in the context category.
  Equational laws:
    - functorial coherence with the identity and composition of substitutions
      (as defined in `MakeLanguageTemplate`)
  val subst :
    tm[ctx1, ctx2[0]] * ... tm[ctx1, ctx2[n]] ->
    tm[ctx2, t] -> tm[ctx1, t] *)
  val subst : tm list -> tm -> tm

  (* Map a term along a morphism in the type category.
  Equational laws:
    - functorial coherence with the identity and composition of morphisms
    - point-wise composition of `apply` and `subst` commute
  val apply : Ty.morph[t1, t2] -> tm[ctx, t1] -> tm[ctx, t2] *)
  val apply : Ty.morph -> tm -> tm
end
