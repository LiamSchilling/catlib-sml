structure Pointed =
struct
  (* The type of initial objects.
  Equational laws:
    - `from` is unique
  type initial[C] = {
    obj: C.obj,
    from: forall x -> morph[obj, x] } *)
  type ('Cobj, 'Cmorph) initial = {
    obj: 'Cobj,
    from: 'Cobj -> 'Cmorph }

  (* The type of terminal objects.
  Equational laws:
    - `to` is unique
  type terminal[C] = {
    obj: C.obj,
    to: forall x -> morph[x, obj] } *)
  type ('Cobj, 'Cmorph) terminal = {
    obj: 'Cobj,
    to: 'Cobj -> 'Cmorph }

  (* The type of zero objects.
  Equational laws:
    - `from` and `to` are unique
    - `from x` and `to x` are mutually inverse
  type zero[C] = {
    obj: C.obj,
    from: forall x -> morph[obj, x],
    to: forall x -> morph[x, obj] } *)
  type ('Cobj, 'Cmorph) zero = {
    obj: 'Cobj,
    from: 'Cobj -> 'Cmorph,
    to: 'Cobj -> 'Cmorph }
end

(* The types of initial, terminal, and zero objects in a category `C`. *)
functor PointedOf (C : CATEGORY) =
struct
  type initial = (C.obj, C.morph) Pointed.initial
  type terminal = (C.obj, C.morph) Pointed.terminal
  type zero = (C.obj, C.morph) Pointed.zero

  (* A zero object is trivially an initial object. *)
  val zeroIntoInitial : zero -> initial = fn z => {
    obj = #obj z,
    from = #from z }

  (* A zero object is trivially a terminal object. *)
  val zeroIntoTerminal : zero -> terminal = fn z => {
    obj = #obj z,
    to = #to z }
end
