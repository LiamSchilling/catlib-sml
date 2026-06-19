functor CartesianIntoTerminal (C : CATEGORY) =
struct
  (*References to the types of various structures on `C`. *)
  structure M = Monoidal(C)
  structure P = Pointed(C)

  (*The projections of a cartesian category
    induce a terminal structure on its unit. *)
  val cartesianIntoTerminal : M.cartesian -> P.terminal = fn c => {
    obj = #unit c,
    to = #leftproj c (#unit c) }
end
