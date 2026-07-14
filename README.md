# Category Theory Library of SML

A development of categorical structures and their transformations, with applications in programming language semantics, compilers and code transformations, effect simulation, symbolic algebra and rewriting systems...

## Project Structure

#### Fundemental definitions

- [`category.sig`](https://github.com/LiamSchilling/catlib-sml/blob/main/core/definitions/category.sig): Defines a category.
- [`groupoid.sig`](https://github.com/LiamSchilling/catlib-sml/blob/main/core/definitions/groupoid.sig): Defines a groupoid.
- [`labeled-digraph.sig`](https://github.com/LiamSchilling/catlib-sml/blob/main/core/definitions/labeled-digraph.sig): Defines a labeled directed graph (essentially a category not equipped with identities or composition).
- [`monoid.sig`](https://github.com/LiamSchilling/catlib-sml/blob/main/core/definitions/monoid.sig): Defines a monoid.
- [`setoid.sig`](https://github.com/LiamSchilling/catlib-sml/blob/main/core/definitions/setoid.sig): Defines a setoid as a type equipped with an equivalence relation.
- [`presheaf.sig`](https://github.com/LiamSchilling/catlib-sml/blob/main/core/definitions/presheaf.sig): Defines a presheaf, or more generally, a set-valued functor.

#### Implementations of categories and groupoids

- [`opposite-category.sml`](https://github.com/LiamSchilling/catlib-sml/blob/main/core/categories/opposite-category.sml), [`opposite-groupoid.sml`](https://github.com/LiamSchilling/catlib-sml/blob/main/core/categories/opposite-groupoid.sml): The opposite category/groupoid.
- [`product-setoid.sml`](https://github.com/LiamSchilling/catlib-sml/blob/main/core/categories/product-setoid.sml), [`product-category.sml`](https://github.com/LiamSchilling/catlib-sml/blob/main/core/categories/product-category.sml), [`product-groupoid.sml`](https://github.com/LiamSchilling/catlib-sml/blob/main/core/categories/product-groupoid.sml): The product construction setoid/category/groupoid.
- [`list-setoid.sml`](https://github.com/LiamSchilling/catlib-sml/blob/main/core/categories/list-setoid.sml), [`list-category.sml`](https://github.com/LiamSchilling/catlib-sml/blob/main/core/categories/list-category.sml), [`list-groupoid.sml`](https://github.com/LiamSchilling/catlib-sml/blob/main/core/categories/list-groupoid.sml): The free finite product setoid/category/groupoid.
- [`functor-category.sml`](https://github.com/LiamSchilling/catlib-sml/blob/main/core/categories/functor-category.sml), [`functor-groupoid.sml`](https://github.com/LiamSchilling/catlib-sml/blob/main/core/categories/functor-groupoid.sml): Categories/groupoids of functors. Defines functors and natural transformations, with point-wise identity, composition, and inversion of natural transformations.
- [`discrete-category.sml`](https://github.com/LiamSchilling/catlib-sml/blob/main/core/categories/discrete-category.sml), [`discrete-groupoid.sml`](https://github.com/LiamSchilling/catlib-sml/blob/main/core/categories/discrete-groupoid.sml): The discrete category/groupoid on a type of objects.
- [`free-category.sml`](https://github.com/LiamSchilling/catlib-sml/blob/main/core/categories/free-category.sml): The free category on a generating labeled digraph.

#### Definitions of structures in categories

- [`monoidal.sml`](https://github.com/LiamSchilling/catlib-sml/blob/main/core/structures/monoidal.sml): Monoidal, symmetric monoidal, and cartesian categories.
- [`pointed.sml`](https://github.com/LiamSchilling/catlib-sml/blob/main/core/structures/pointed.sml): Initial, terminal, and zero objects.

#### Implementations of structures in categories

- [`functor-composition.sml`](https://github.com/LiamSchilling/catlib-sml/blob/main/core/lemmas/functor-composition.sml): Composition of functors and horizontal composite of natural transformations.
- [`endofunctor-monoidal.sml`](https://github.com/LiamSchilling/catlib-sml/blob/main/core/lemmas/endofunctor-monoidal.sml): The monoidal structure given by composition of endofunctors.
- [`cartesian-into-terminal.sml`](https://github.com/LiamSchilling/catlib-sml/blob/main/core/lemmas/cartesian-into-terminal.sml): The terminal structure on the unit of a cartesian category.

#### Applications in rewriting systems

- [`reduction-graph.sml`](https://github.com/LiamSchilling/catlib-sml/blob/main/domains/rewriting-systems/reduction-graph.sml): Defines an adequate reduction graph as a stepping function that either finds a non-trivial rewrite on a form, or signals that the form is normal.
- [`iterate-reduction-graph.sml`](https://github.com/LiamSchilling/catlib-sml/blob/main/domains/rewriting-systems/iterate-reduction-graph.sml): Implements the lift from a reduction graph that finds individual rewrites (edges in a labeled directed graph `G`) into a reduction graph that finds full normalization paths (morphisms in the free category on `G`).

#### Applications in programming languages

- [`term-language-template.sig`](https://github.com/LiamSchilling/catlib-sml/blob/main/domains/programming-languages/term-language-template.sig), [`term-language.sig`](https://github.com/LiamSchilling/catlib-sml/blob/main/domains/programming-languages/term-language.sig), [`make-term-language.sml`](https://github.com/LiamSchilling/catlib-sml/blob/main/domains/programming-languages/make-term-language.sml): Defines a term language as a category of types, a cartesian category of contexts and substitutions, and a set-valued functor from contexts `ctx` and types `t` into sets of terms `tm[ctx, t]`. The variance is so that `tm[-, t]` is a presheaf on the context category, as usual. Additionally, provides the transformation from the minimal specification of a term language into its full categorical interface, which results in an implementation of the context and substitution category.

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
