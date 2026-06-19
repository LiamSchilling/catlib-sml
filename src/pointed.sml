(*The types of initial, terminal, and zero objects in a category `C`. *)
functor Pointed (C : CATEGORY) =
struct
  (*The type of initial objects.
  type initial = {
    obj: C.obj,
    from: forall x -> morph[obj, x] } *)
  type initial = {
    obj: C.obj,
    from: C.obj -> C.morph }

  (*The type of terminal objects.
  type terminal = {
    obj: C.obj,
    to: forall x -> morph[x, obj] } *)
  type terminal = {
    obj: C.obj,
    to: C.obj -> C.morph }

  (*The type of zero objects.
  type zero = {
    obj: C.obj,
    from: forall x -> morph[obj, x],
    to: forall x -> morph[x, obj] } *)
  type zero = {
    obj: C.obj,
    from: C.obj -> C.morph,
    to: C.obj -> C.morph }

  (*A zero object is trivially an initial object. *)
  val zeroIntoInitial : zero -> initial = fn z => {
    obj = #obj z,
    from = #from z }

  (*A zero object is trivially a terminal object. *)
  val zeroIntoTerminal : zero -> terminal = fn z => {
    obj = #obj z,
    to = #to z }
end
