(*A language of typed terms
  given by a presheaf on a cartesian category of contexts. *)
signature TERMLANGUAGE =
sig
  (*The categories of types and contexts. *)
  structure Ty : CATEGORY
  structure Ctx : CATEGORY

  (*The term language `tm[-, -]` is given by a set-valued functor
    whose domain `Tm.D` is `ProductCategory(OppositeCategory(Ctx))(Ty)`.
    That is, `tm[-, -]` is:
    - contravariant in the context category (first argument)
    - covariant in the type category (second argument) *)
  structure Tm : PRESHEAF
    where type D.obj = Ctx.obj * Ty.obj
    where type D.morph = Ctx.morph * Ty.morph

  (*Transport a type into a singleton context. *)
  val intoCtx : Ty.obj -> Ctx.obj

  (*Transport a term into a singleton substitution.
  val intoSubst : tm[ctx, t] -> Ctx.morph[ctx, intoCtx t] *)
  val intoSubst : Tm.t -> Ctx.morph

  (*The context category is cartesian. *)
  val cartesian : (Ctx.obj, Ctx.morph) Monoidal.cartesian

  (*See `TERMLANGUAGETEMPLATE`. *)
  val var : int -> Tm.t
  val subst : Ctx.morph -> Tm.t -> Tm.t
  val apply : Ty.morph -> Tm.t -> Tm.t
end
