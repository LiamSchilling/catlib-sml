(*From a minimal specification of a term language,
  construct a robust term language interface. *)
functor MakeTermLanguage (L : TERMLANGUAGETEMPLATE) : TERMLANGUAGE =
struct
  (*The category of types. *)
  structure Ty = L.Ty

  (*The category of contexts. *)
  structure Ctx =
  struct
    (*The objects are collections of types. *)
    type obj = Ty.obj list

    (*The morphisms are substitutions,
      or implementations of one context in terms of another.
    type morph[ctx1, ctx2] = tm[ctx1, ctx2[0]] * ... tm[ctx1, ctx2[n]] *)
    type morph = L.tm list

    datatype morpherror = IllFormed | ErrorAt of int * L.termerror
    exception MorphType of morpherror

    (*Type checks a substitution `sub : morph[ctx1, ctx2]`
      by checking its terms against the types of `ctx2`
      in the context of `ctx1`. *)
    fun checkFrom i [] (ctx1, []) = ()
      | checkFrom i (e :: sub) (ctx1, t :: ctx2) = (
        L.check e (ctx1, t) handle L.TermType e =>
          raise MorphType (ErrorAt (i, e));
        checkFrom (i + 1) sub (ctx1, ctx2) )
      | checkFrom i _ (_, _) = raise MorphType IllFormed

    (*`idFrom 0` constructs the identity substitution,
      a list of self-indexed bound variables.
      Because `L.var` does not depend on the context argument
      of the resulting term element (see `TERMLANGUAGETEMPLATE`),
      the type of the resulting substitution is even more general
      than that of the identity substitution,
      as shown below with the argument `i` and the freely-varying `ctx2`.
    val idFrom :
      forall i ctx1 ->
      tm[ctx1 @ ctx2, ctx1[i]] * ... tm[ctx1 @ ctx2, ctx1[n+i]] *)
    fun idFrom i [] = []
      | idFrom i ((_ : Ty.obj) :: ctx) = L.var i :: idFrom (i + 1) ctx

    val check = checkFrom 0
    val id = idFrom 0

    (*Composes substitutions `sub1` and `sub2`
      by mapping the terms of `sub1` along `sub2`. *)
    fun comp ([], sub2) = []
      | comp (e :: sub1, sub2) = L.subst sub2 e :: comp (sub1, sub2)
  end

  (*The set-valued functor that gives the terms. *)
  structure Tm =
  struct
    structure D = ProductCategory(OppositeCategory(Ctx))(Ty)

    type t = L.tm

    type elemerror = L.termerror
    exception ElemType = L.TermType

    val check = L.check
    fun mapmorph (sub, f) = (L.apply f) o (L.subst sub)
  end

  (*The singleton contexts and singleton substitutions
    are given by singleton lists. *)
  fun intoCtx t = [t]
  fun intoSubst e = [e]

  (*A reference to the types of monoidal structures on `Ctx`. *)
  structure M = MonoidalOf(Ctx)

  (*Because our design does not annotate substitutions (morphisms)
    with their source contexts (objects), it is impossible to express
    the action of context appendage on substitutions
    given only references to the substitutions themselves. *)
  exception UnimplementedUnexpressible

  (*The context category is cartesian
    with the product operation given by context appendage. *)
  val cartesian : M.cartesian = {
    unit = [],
    product = {
      mapobj = fn (ctx1, ctx2) => ctx1 @ ctx2,
      mapmorph = raise UnimplementedUnexpressible },
    swapmap = {
      component = fn (ctx1, ctx2) =>
        Ctx.idFrom (length ctx1) ctx2 @ Ctx.idFrom 0 ctx1 },
    leftproj = fn (ctx1, ctx2) => Ctx.idFrom 0 ctx1,
    rightproj = fn (ctx1, ctx2) => Ctx.idFrom (length ctx1) ctx2,
    pair = fn (sub1, sub2) => sub1 @ sub2 }

  val var = L.var
  val subst = L.subst
  val apply = L.apply
end
