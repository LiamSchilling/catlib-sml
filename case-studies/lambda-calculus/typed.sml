structure SimpleTypes =
struct
  open LambdaCalculus

  (* The type of simple types with base types from `'b`. *)
  datatype 'b ty =
      BaseTy of 'b
    | Unit
    | Prod of 'b ty * 'b ty
    | Arrow of 'b ty * 'b ty

  (* Specialize the type of lambda terms with `ty` for the type annotations. *)
  type ('b, 'f) tm = ('b ty, 'f) tm

  (* Increment by `j` the index of all variables in a term
     whose index is above `i`. *)
  fun weakenFrom i j (Var k) =
      Var (if k < i then k else k + j)
    | weakenFrom i j (BaseFun f) =
      BaseFun f
    | weakenFrom i j Triv =
      Triv
    | weakenFrom i j (Pair (e1, e2)) =
      Pair (weakenFrom i j e1, weakenFrom i j e2)
    | weakenFrom i j (Left (t1, e)) =
      Left (t1, weakenFrom i j e)
    | weakenFrom i j (Right (t2, e)) =
      Right (t2, weakenFrom i j e)
    | weakenFrom i j (Lam e) =
      Lam (weakenFrom (i + 1) j e)
    | weakenFrom i j (App (t1, e2, e1)) =
      App (t1, weakenFrom i j e2, weakenFrom i j e1)

  (* Substitute all the variables in a term, starting at `i`-level variables,
     and weakening each substituted term by `i`. *)
  fun substFrom i sub (Var j) = (
      weakenFrom 0 i (Exception.nth (j - i) sub) handle
        Exception.Subscript Exception.Negative => Var j )
    | substFrom i sub (BaseFun f) =
      BaseFun f
    | substFrom i sub Triv =
      Triv
    | substFrom i sub (Pair (e1, e2)) =
      Pair (substFrom i sub e1, substFrom i sub e2)
    | substFrom i sub (Left (t2, e)) =
      Left (t2, substFrom i sub e)
    | substFrom i sub (Right (t1, e)) =
      Right (t1, substFrom i sub e)
    | substFrom i sub (Lam e) =
      Lam (substFrom (i + 1) sub e)
    | substFrom i sub (App (t1, e2, e1)) =
      App (t1, substFrom i sub e2, substFrom i sub e1)
end

(* The term language of simply typed lambda terms up to beta/eta conversion
   on a base category of types and primitive functions `Base`. *)
functor SimpleTypesTemplate (Base : CATEGORY) : TERMLANGUAGETEMPLATE =
struct
  open SimpleTypes

  structure TySetoid =
  struct
    type t = Base.Obj.t ty

    fun eq (BaseTy a, BaseTy b) =
        Base.Obj.eq (a, b)
      | eq (Unit, Unit) = true
      | eq (Prod (t1, t2), Prod (t1', t2')) =
        eq (t1, t1') andalso eq (t2, t2')
      | eq (Arrow (t1, t2), Arrow (t1', t2')) =
        eq (t1, t1') andalso eq (t2, t2')
      | eq (_, _) = false
  end

  (* References to the implementation of beta/eta normalization. *)
  structure BaseMonoid = CategoryIntoMonoid(Base)
  structure LambdaCalculusGraph = LambdaCalculusGraph(TySetoid)(BaseMonoid)
  structure LambdaCalculusReducer = LambdaCalculusReducer(TySetoid)(BaseMonoid)

  structure Tm =
  struct
    type t = (Base.Obj.t, Base.Morph.t) tm

    fun eq (e, e') =
      LambdaCalculusGraph.Node.eq (
        LambdaCalculusReducer.evalTerm e,
        LambdaCalculusReducer.evalTerm e' )
  end

  datatype termerror =
      NegativeVar
    | UnboundVar
    | IllFormed of Tm.t * TySetoid.t
    | TypeMismatch of TySetoid.t * TySetoid.t

  exception TermType of termerror

  (* Assert equality of types. *)
  val checktyeq = Exception.assert TySetoid.eq (TermType o TypeMismatch)

  fun check (Var i) (ctx, t) = (
      checktyeq (Exception.nth i ctx, t) handle
        Exception.Subscript Exception.Negative => raise TermType NegativeVar
      | Exception.Subscript Exception.Unbound => raise TermType UnboundVar )
    | check (BaseFun f) (ctx, Arrow (BaseTy a, BaseTy b)) =
      Base.check f (a, b)
    | check Triv (ctx, Unit) = ()
    | check (Pair (e1, e2)) (ctx, Prod (t1, t2)) = (
      check e1 (ctx, t1);
      check e2 (ctx, t2) )
    | check (Left (t2, e)) (ctx, t1) =
      check e (ctx, Prod (t1, t2))
    | check (Right (t1, e)) (ctx, t2) =
      check e (ctx, Prod (t1, t2))
    | check (Lam e) (ctx, Arrow (t1, t2)) =
      check e (t1 :: ctx, t2)
    | check (App (t1, e2, e1)) (ctx, t2) = (
      check e2 (ctx, Arrow (t1, t2));
      check e1 (ctx, t1) )
    | check e (ctx, t) =
      raise TermType (IllFormed (e, t))

  (* The category of simple types with closed function terms as morphisms
     (a.k.a. the free cartesian closed category on `Base`). *)
  structure Ty =
  struct
    (* The objects of the category are simple types *)
    structure Obj = TySetoid

    (* Morphisms are annotated with their source objects
       to make type checking expressible. *)
    structure Morph = ProductSetoid(Obj)(Tm)

    type morpherror = termerror
    exception MorphType = TermType

    fun checktm e t =
      check e ([], t)

    fun check (t1', e) (t1, t2) = (
      checktyeq (t1, t1');
      checktm e (Arrow (t1, t2)) )

    fun id t =
      (t, Lam (Var 0))

    fun comp ((t2, e2), (t1, e1)) =
      (t1, Lam (App (t2, e2, App (t1, e1, Var 0))))

    fun isid (t, e) =
      Tm.eq (e, Lam (Var 0))
  end

  val var = Var
  fun subst sub e = substFrom 0 sub e
  fun apply (t1, e2) e1 = App (t1, e2, e1)
end
