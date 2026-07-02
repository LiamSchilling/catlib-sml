(* The opposite groupoid of `G`. *)
functor OppositeGroupoid (G : GROUPOID) : GROUPOID =
struct
  structure C = OppositeCategory(G)
  open C

  fun inv a = G.inv a
end
