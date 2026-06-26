functor CartesianIntoTerminal (C : CATEGORY) =
struct
  (*References to the types of various structures on `C`. *)
  structure M = Monoidal(C)
  structure P = Pointed(C)

  (*The left-projections of a cartesian category
    induce a terminal structure on its unit. *)
  val cartesianIntoTerminalLeft : M.cartesian -> P.terminal = fn c => {
    obj = #unit c,
    to = #leftproj c (#unit c) }

  (*The right-projections of a cartesian category
    induce a terminal structure on its unit. *)
  val cartesianIntoTerminalRight : M.cartesian -> P.terminal = fn c => {
    obj = #unit c,
    to = #rightproj c (#unit c) }
end
