# Category Theory Library of SML

A development of categorical structures and their transformations, with applications in programming language semantics, compilers and code transformations, effect simulation, symbolic algebra and rewriting systems...

### Project structure

```
data/                # ----- Utilities -----
├── exception.sml
└── lazy-list.sml

core/                # ----- Category theory library -----
├── definitions/     # Signature-level definitions: categories, groupoids, presheaves...
├── categories/      # Structure-level implementations: product category, functor category...
├── structures/      # Type-level definitions: monoidal/cartesian categories, initial objects...
└── lemmas/          # Lemma implementations: e.g. units of cartesian categories are terminal

domains/             # ----- Domain-specific libraries -----
├── rewriting-systems/         # as categories with "step" functions that find nontrivial morphisms
└── programming-languages/     # as presheaves on categories of contexts and substitutions

case-studies/        # ----- Applications and experiments -----
└── lambda-calculus/           # The simply typed lambda calculus
                               # with products and primitive functions between base types.
                               # This provides the free cartesian closed category
                               # on a category of base types.
```

## Design Notes

### Value-dependent typing rules and equational laws

In the type system of SML, it is impossible to formally enforce all the desired invariants and equational laws of the data structures we define. This greatly reduces the proof burden on the implementer of such data structures, but one must be weary of the absence of static guarantees. When relevant, we use an informal language of dependent types in our documentation, in which SML types (e.g. `morph`, the type of morphisms) are annotated with value-level refinements (e.g. `morph[x, y]`, the type of morphisms from the object `x` to the object `y`). For instance the function providing a category's identity morphisms might be declared as follows, with the documentation listing a rich, informal type signature.

```
(* The identity morphism for an object.
val id : forall x -> morph[x, x] *)
val id : obj -> morph
```

Though "types" such as `morph[x, y]` cannot be defined as formal types, the implementer is generally required to specify their meaning by providing a type checker. For instance, the implementer of a category is required to provide the following `check` function, with the specification that `check a (x, y)` succeeds if `a : morph[x, y]`, and otherwise raises a dedicated exception.

```
val check : morph -> obj * obj -> unit
```

The situation is similar for equational laws, which are mentioned in the documentation of the types on which they are expected to be invariant. The implementer is required to provide the equivalence relations up to which equational laws are considered. For instance, the equivalence on morphisms might be declared as follows. Of course, exposed functions (e.g. `check`) should cohere with the provided equivalences.

```
(* The equivalence judgment on morphisms.
   The behavior is undefined when the input morphisms are ill-typed.
val morphequiv : morph[x, y] * morph[x, y] -> bool *)
val morphequiv : morph * morph -> bool
```

### Type-level computation

Unlike value-level data structures, which might be *indexed* by a type (e.g. `'a list` for some type `'a`), a category is *identified* with its types of objects and morphisms. In SML, this situates categories at the module level, so that the "type" of categories (`CATEGORY`) is an SML `signature`, a category itself is an SML `structure`, and a transformation on categories is an SML `functor`. Very importantly, a category's types of objects and morphisms are certainly *concrete* rather than abstract, so the correct ascription kind is always transparent (`structure C : CATEGORY`), rather than opaque (`structure C :> CATEGORY`).
