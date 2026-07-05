functor CartesianIntoTerminal (C : CATEGORY) =
struct
  (* References to the types of various structures on `C`. *)
  structure M = MonoidalOf(C)
  structure P = PointedOf(C)

  (* The left-projections of a cartesian category
     induce a terminal structure on its unit. *)
  fun cartesianIntoTerminalLeft (c: M.cartesian) : P.terminal = {
    obj = #unit c,
    to = fn x => #leftproj c (#unit c, x) }

  (* The right-projections of a cartesian category
     induce a terminal structure on its unit. *)
  fun cartesianIntoTerminalRight (c: M.cartesian) : P.terminal = {
    obj = #unit c,
    to = fn x => #rightproj c (x, #unit c) }
end
