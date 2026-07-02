(* The product of groupoids `G, H`. *)
functor ProductGroupoid (G : GROUPOID) (H : GROUPOID) : GROUPOID =
struct
  structure C = ProductCategory(G)(H)
  open C

  fun inv (a, b) = (G.inv a, H.inv b)
end
