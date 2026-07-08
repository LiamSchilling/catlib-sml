functor LambdaCalculusReducer (Note : SETOID) (Base : MONOID) =
struct
  open LambdaCalculus

  (* References to the lambda calculus equipped with a rewriting structure. *)
  structure LambdaCalculusGraph = LambdaCalculusGraph(Note)(Base)
  structure LambdaCalculusCategory = LambdaCalculusCategory(Note)(Base)

  (* References to the types of reduction graph structures. *)
  structure ReductionGraph =
    ReductionGraphOf(LambdaCalculusGraph)
  structure IteratedReductionGraph =
    ReductionGraphOf(CategoryIntoLabeledDigraph(LambdaCalculusCategory))

  (* A reference to the implementation of reduction graph iteration. *)
  structure Iter = IterateReductionGraph(LambdaCalculusGraph)

  exception EtaLamError

  (* Steps a term in the lambda calculus and provide justification,
     or returns `NONE` if the term is normal. *)
  fun stepTerm (Left (t2, Pair (e1, e2))) = SOME (BetaLeft, e1)
    | stepTerm (Right (t1, Pair (e1, e2))) = SOME (BetaRight, e2)
    | stepTerm (App (t1, Lam e2, e1)) = SOME (BetaApp, subst 0 (fn () => e1) e2)
    | stepTerm (BaseFun f) =
      if Base.isid f then SOME (BaseId, Lam (Var 0)) else NONE
    | stepTerm (App (t2, BaseFun f, App (t1, BaseFun g, e))) =
      SOME (BaseComp, App (t1, BaseFun (Base.mul (f, g)), e))
    | stepTerm (Var i) = NONE
    | stepTerm Triv = NONE
    | stepTerm (Pair (e1, e2)) = (
      case stepTerm e1 of
        SOME (a, e1') => SOME (PairCongrLeft a, Pair (e1', e2))
      | NONE =>
      case stepTerm e2 of
        SOME (b, e2') => SOME (PairCongrRight b, Pair (e1, e2'))
      | NONE =>
      case (e1, e2) of
        (Left (t2, e), Right (t1, e')) =>
        if LambdaCalculusGraph.Node.eq (e, e') then SOME (EtaPair, e) else NONE
      | (_, _) => NONE )
    | stepTerm (Left (t2, e)) = (
      case stepTerm e of
        SOME (a, e') => SOME (LeftCongr a, Left (t2, e'))
      | NONE => NONE )
    | stepTerm (Right (t1, e)) = (
      case stepTerm e of
        SOME (a, e') => SOME (RightCongr a, Right (t1, e'))
      | NONE => NONE )
    | stepTerm (Lam e) = (
      case stepTerm e of
        SOME (a, e') => SOME (LamCongr a, Lam e')
      | NONE =>
      case e of
        App (t, e', Var 0) => (
        SOME (EtaLam, subst 0 (fn () => raise EtaLamError) e') handle
          EtaLamError => NONE )
      | _ => NONE )
    | stepTerm (App (t1, e2, e1)) = (
      case stepTerm e2 of
        SOME (a, e2') => SOME (AppCongrLeft a, App (t1, e2', e1))
      | NONE =>
      case stepTerm e1 of
        SOME (b, e1') => SOME (AppCongrRight b, App (t1, e2, e1'))
      | NONE => NONE )

  (* The one-step reduction graph structure on the lambda calculus. *)
  val stepReducer : ReductionGraph.reducer = {
    step = stepTerm }

  (* Iterate the one-step graph to retrieve a full normalizer. *)
  val fullReducer : IteratedReductionGraph.reducer =
    Iter.iterate stepReducer
end
