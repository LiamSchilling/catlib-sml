structure LambdaCalculus =
struct
  (* The nodes of the graph are lambda terms,
     which may have products and primitive functions from `'f`.
     Eliminators are annotated with members of `'n`,
     which gives sufficient information for type checking
     if the members of `'n` are simple types. *)
  datatype ('n, 'f) tm =
      Var of int
    | BaseFun of 'f
    | Triv
    | Pair of ('n, 'f) tm * ('n, 'f) tm
    | Left of 'n * ('n, 'f) tm
    | Right of 'n * ('n, 'f) tm
    | Lam of ('n, 'f) tm
    | App of 'n * ('n, 'f) tm * ('n, 'f) tm

  (* The edges of the graph are rewriting steps,
     which may be beta reductions, eta reductions,
     or reduction of identity or composition of base functions. *)
  datatype rw =
      BetaLeft
    | BetaRight
    | BetaApp
    | EtaPair
    | EtaLam
    | BaseId
    | BaseComp
    | PairCongrLeft of rw
    | PairCongrRight of rw
    | LeftCongr of rw
    | RightCongr of rw
    | LamCongr of rw
    | AppCongrLeft of rw
    | AppCongrRight of rw

  (* Substitutes the `i`-level variables in a term
     for the result of evaluating the thunk `e'`,
     and decrements the level of all variables above `i`. *)
  fun subst i e' (Var j) =
      if i = j then
        e' ()
      else
        Var (if j < i then j else j - 1)
    | subst i e' (BaseFun f) = BaseFun f
    | subst i e' Triv = Triv
    | subst i e' (Pair (e1, e2)) = Pair (subst i e' e1, subst i e' e2)
    | subst i e' (Left (t2, e)) = Left (t2, subst i e' e)
    | subst i e' (Right (t1, e)) = Right (t1, subst i e' e)
    | subst i e' (Lam e) = Lam (subst (i + 1) e' e)
    | subst i e' (App (t1, e2, e1)) = App (t1, subst i e' e2, subst i e' e1)
end

(* The beta/eta reduction graph of lambda terms
   with type annotations given by `Note` and base functions given by `Base`. *)
functor LambdaCalculusGraph (Note : SETOID) (Base : MONOID) : LABELEDDIGRAPH =
struct
  open LambdaCalculus

  structure Node =
  struct
    type t = (Note.t, Base.Elem.t) tm

    fun eq (Var i, Var j) = (i = j)
      | eq (BaseFun f, BaseFun g) =
        Base.Elem.eq (f, g)
      | eq (Pair (e1, e2), Pair (e1', e2')) =
        eq (e1, e1') andalso eq (e2, e2')
      | eq (Left (t2, e), Left (t2', e')) =
        Note.eq (t2, t2') andalso eq (e, e')
      | eq (Right (t1, e), Right (t1', e')) =
        Note.eq (t1, t1') andalso eq (e, e')
      | eq (Lam e, Lam e') =
        eq (e, e')
      | eq (App (t1, e2, e1), App (t1', e2', e1')) =
        Note.eq (t1, t1') andalso eq (e2, e2') andalso eq (e1, e1')
      | eq (_, _) = false
  end

  structure Edge = StrictSetoid(struct type t = rw end)

  datatype edgeerror =
      IllFormed of Edge.t * Node.t * Node.t
    | VarInEtaTarget of Node.t
    | NodeMismatch of Node.t * Node.t
    | NoteMismatch of Note.t * Note.t
    | BaseMismatch of Base.Elem.t * Base.Elem.t
    | NotId of Base.Elem.t

  exception EdgeType of edgeerror

  (* Assert equality of terms, annotations, and base functions. *)
  val checktmeq = Exception.assert Node.eq (EdgeType o NodeMismatch)
  val checknoteeq = Exception.assert Note.eq (EdgeType o NoteMismatch)
  val checkbaseeq = Exception.assert Base.Elem.eq (EdgeType o BaseMismatch)
  val checkisid = Exception.assert Base.isid (EdgeType o NotId)

  fun check BetaLeft (Left (t2, Pair (e1, e2)), e1') =
      checktmeq (e1, e1')
    | check BetaRight (Right (t1, Pair (e1, e2)), e2') =
      checktmeq (e2, e2')
    | check BetaApp (App (t1, Lam e2, e1), e2') =
      checktmeq (subst 0 (fn () => e1) e2, e2')
    | check EtaPair (Pair (Left (t2, e), Right (t1, e')), e'') = (
      checktmeq (e, e');
      checktmeq (e, e'') )
    | check EtaLam (Lam (App (t, e, Var 0)), e') =
      checktmeq (subst 0 (fn () => raise EdgeType (VarInEtaTarget e)) e, e')
    | check BaseId (BaseFun f, Lam (Var 0)) =
      checkisid f
    | check BaseComp (App (t2, BaseFun f, App (t1, BaseFun g, e)), App (t1', BaseFun h, e')) = (
      checknoteeq (t1, t1');
      checktmeq (e, e');
      checkbaseeq (Base.mul (f, g), h) )
    | check (PairCongrLeft a) (Pair (e1, e2), Pair (e1', e2')) = (
      check a (e1, e1');
      checktmeq (e2, e2') )
    | check (PairCongrRight a) (Pair (e1, e2), Pair (e1', e2')) = (
      checktmeq (e1, e1');
      check a (e2, e2') )
    | check (LeftCongr a) (Left (t2, e), Left (t2', e')) = (
      checknoteeq (t2, t2');
      check a (e, e') )
    | check (RightCongr a) (Right (t1, e), Right (t1', e')) = (
      checknoteeq (t1, t1');
      check a (e, e') )
    | check (LamCongr a) (Lam e, Lam e') =
      check a (e, e')
    | check (AppCongrLeft a) (App (t1, e2, e1), App (t1', e2', e1')) = (
      checknoteeq (t1, t1');
      check a (e2, e2');
      checktmeq (e1, e1') )
    | check (AppCongrRight a) (App (t1, e2, e1), App (t1', e2', e1')) = (
      checknoteeq (t1, t1');
      checktmeq (e2, e2');
      check a (e1, e1') )
    | check a (e, e') =
      raise EdgeType (IllFormed (a, e, e'))
end

(* The beta/eta reduction category of lambda terms
   with type annotations given by `Note` and base functions given by `Base`,
   which is the reflexive and transitive closure of the reduction graph. *)
functor LambdaCalculusCategory (Note : SETOID) (Base : MONOID) : CATEGORY =
  FreeCategory(LambdaCalculusGraph(Note)(Base))
