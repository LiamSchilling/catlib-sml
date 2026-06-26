(*The free finite product groupoid on `G`. *)
functor ListGroupoid (G : GROUPOID) : GROUPOID =
struct
  structure C = ListCategory(G)
  open C

  fun inv [] = []
    | inv (a :: A) = G.inv a :: inv A
end
