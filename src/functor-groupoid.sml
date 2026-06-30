(* The groupoid of functors from a category `C` to a groupoid `G`. *)
functor FunctorGroupoid (D : CATEGORY) (G : GROUPOID) : GROUPOID =
struct
  structure C = FunctorCategory(D)(G)
  open C

  fun inv (n: morph) = {
    component = fn x => G.inv (#component n x) }
end
