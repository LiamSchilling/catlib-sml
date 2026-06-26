functor CartesianIntoTerminal (C : CATEGORY) =
struct
  (*References to the types of various structures on `C`. *)
  structure M = Monoidal(C)
  structure P = Pointed(C)

  (*The left-projections of a cartesian category
    induce a terminal structure on its unit. *)
  val cartesianIntoTerminalLeft : M.cartesian -> P.terminal = fn c => {
    obj = #unit c,
    to = fn x => #leftproj c (#unit c) x }

  (*The right-projections of a cartesian category
    induce a terminal structure on its unit. *)
  val cartesianIntoTerminalRight : M.cartesian -> P.terminal = fn c => {
    obj = #unit c,
    to = fn x => #rightproj c x (#unit c) }
end
