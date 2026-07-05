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
end
