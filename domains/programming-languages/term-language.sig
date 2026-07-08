(* A language of typed terms
   given by a presheaf on a cartesian category of contexts. *)
signature TERMLANGUAGE =
sig
  (* The categories of types and contexts. *)
  structure Ty : CATEGORY
  structure Ctx : CATEGORY

  (* The term language `tm[-, -]` is given by a set-valued functor
     whose domain `Tm.Dom` is `ProductCategory(OppositeCategory(Ctx))(Ty)`.
     That is, `tm[-, -]` is:
     - contravariant in the context category (first argument)
     - covariant in the type category (second argument) *)
  structure Tm : PRESHEAF
    where type Dom.Obj.t = Ctx.Obj.t * Ty.Obj.t
    where type Dom.Morph.t = Ctx.Morph.t * Ty.Morph.t

  (* Transport a type into a singleton context. *)
  val intoCtx : Ty.Obj.t -> Ctx.Obj.t

  (* Transport a term into a singleton substitution.
  val intoSubst : tm[ctx, t] -> Ctx.morph[ctx, intoCtx t] *)
  val intoSubst : Tm.Elem.t -> Ctx.Morph.t

  (* The context category is cartesian. *)
  val cartesian : (Ctx.Obj.t, Ctx.Morph.t) Monoidal.cartesian

  (* See `TERMLANGUAGETEMPLATE`. *)
  val var : int -> Tm.Elem.t
  val subst : Ctx.Morph.t -> Tm.Elem.t -> Tm.Elem.t
  val apply : Ty.Morph.t -> Tm.Elem.t -> Tm.Elem.t
end
