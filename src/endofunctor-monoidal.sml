(*The category of endofunctors on `C` is monoidal
  under composition of functors. *)
functor EndofunctorMonoidal (C : CATEGORY) =
struct
  (*A reference to the type of monoidal structures. *)
  structure M = MonoidalOf(FunctorCategory(C)(C))
  
  (*A reference to the implementation of functor composition. *)
  structure Comp = FunctorComposition(C)(C)(C)

  (*The monoidal structure on the category of endofunctors. *)
  val endofunctorMonoidal : M.monoidal = {
    unit = {
      mapobj = fn x => x, 
      mapmorph = fn a => a },
    tensor = Comp.comp }
end
