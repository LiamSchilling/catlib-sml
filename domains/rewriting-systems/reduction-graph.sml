structure ReductionGraph =
struct
  (* An adequate reduction graph must be equipped with a stepping function
     that finds a non-self-directed rewrite on a form if it exists,
     and otherwise signals that the form is normal. *)
  type ('form, 'rw) reducer = {
    step: 'form -> ('rw * 'form) option }
end

functor ReductionGraphOf (G : LABELEDDIGRAPH) =
struct
  type reducer = (G.Node.t, G.Edge.t) ReductionGraph.reducer

  (* Evaluate a term according to a reducer,
     which simply returns the term stepped once,
     or the term itself it is already normal. *)
  fun eval (r: reducer) (x: G.Node.t) : G.Node.t =
    case #step r x of
      SOME (_, y) => y
    | NONE => x
end
