(*A groupoid is a category in which
  every morphism has an inverse, as defined below. *)
signature GROUPOID =
sig
  include CATEGORY

  (*The inverse of a morphism.
  val inv : morph[x, y] -> morph[y, x] *)
  val inv : morph -> morph
end
