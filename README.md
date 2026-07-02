# Category Theory Library of SML

A development of categorical structures and their transformations, with applications in programming language semantics, compilers and code transformations, effect simulation, symbolic algebra and rewriting systems...

## Project Structure

#### Fundemental definitions

- [`category.sig`](https://github.com/LiamSchilling/catlib-sml/blob/main/src/category.sig): Defines a category.
- [`groupoid.sig`](https://github.com/LiamSchilling/catlib-sml/blob/main/src/groupoid.sig): Defines a groupoid.
- [`presheaf.sig`](https://github.com/LiamSchilling/catlib-sml/blob/main/src/presheaf.sig): Defines a presheaf.
- [`labeled-digraph.sig`](https://github.com/LiamSchilling/catlib-sml/blob/main/src/labeled-digraph.sig): Defines a labeled directed graph (essentially a category not equipped with identities or composition).

#### Implementations of categories and groupoids

- [`opposite-category.sml`](https://github.com/LiamSchilling/catlib-sml/blob/main/src/opposite-category.sml), [`opposite-groupoid.sml`](https://github.com/LiamSchilling/catlib-sml/blob/main/src/opposite-groupoid.sml): The opposite category/groupoid.
- [`product-category.sml`](https://github.com/LiamSchilling/catlib-sml/blob/main/src/product-category.sml), [`product-groupoid.sml`](https://github.com/LiamSchilling/catlib-sml/blob/main/src/product-groupoid.sml): The product construction category/groupoid.
- [`list-category.sml`](https://github.com/LiamSchilling/catlib-sml/blob/main/src/list-category.sml), [`list-groupoid.sml`](https://github.com/LiamSchilling/catlib-sml/blob/main/src/list-groupoid.sml): The free finite product category/groupoid.
- [`functor-category.sml`](https://github.com/LiamSchilling/catlib-sml/blob/main/src/functor-category.sml), [`functor-groupoid.sml`](https://github.com/LiamSchilling/catlib-sml/blob/main/src/functor-groupoid.sml), [`functor-iso-groupoid.sml`](https://github.com/LiamSchilling/catlib-sml/blob/main/src/functor-iso-groupoid.sml): Categories/groupoids of functors. Defines functors and natural transformations/isomorphisms, with component-wise identity, composition, and inversion of natural transformations/isomorphisms.
- [`discrete-category.sml`](https://github.com/LiamSchilling/catlib-sml/blob/main/src/discrete-category.sml), [`discrete-groupoid.sml`](https://github.com/LiamSchilling/catlib-sml/blob/main/src/discrete-groupoid.sml): The discrete category/groupoid on a type of objects.
- [`category-into-labeled-digraph.sml`](https://github.com/LiamSchilling/catlib-sml/blob/main/src/category-into-labeled-digraph.sml), [`free-category.sml`](https://github.com/LiamSchilling/catlib-sml/blob/main/src/free-category.sml): The canonical embedding of categories into labeled digraphs, and the free category on a generating labeled digraph.

#### Definitions of structures in categories

- [`monoidal.sml`](https://github.com/LiamSchilling/catlib-sml/blob/main/src/monoidal.sml): Monoidal, symmetric monoidal, and cartesian categories.
- [`pointed.sml`](https://github.com/LiamSchilling/catlib-sml/blob/main/src/pointed.sml): Initial, terminal, and zero objects.

#### Implementations of structures in categories

- [`functor-composition.sml`](https://github.com/LiamSchilling/catlib-sml/blob/main/src/functor-composition.sml): Composition of functors and horizontal composite of natural transformations.
- [`endofunctor-monoidal.sml`](https://github.com/LiamSchilling/catlib-sml/blob/main/src/endofunctor-monoidal.sml): The monoidal structure given by composition of endofunctors.
- [`cartesian-into-terminal.sml`](https://github.com/LiamSchilling/catlib-sml/blob/main/src/cartesian-into-terminal.sml): The terminal structure on the unit of a cartesian category.

#### Applications in programming languages

- [`term-language-template.sig`](https://github.com/LiamSchilling/catlib-sml/blob/main/src/programming-languages/term-language-template.sig), [`term-language.sig`](https://github.com/LiamSchilling/catlib-sml/blob/main/src/programming-languages/term-language.sig), [`make-term-language.sml`](https://github.com/LiamSchilling/catlib-sml/blob/main/src/programming-languages/make-term-language.sml): Defines a term language as a category of types, a cartesian category of contexts and substitutions, and a set-valued functor from contexts `ctx` and types `t` into sets of terms `tm[ctx, t]`. The variance is so that `tm[-, t]` is a presheaf on the context category, as usual. Additionally, provides the transformation from the minimal specification of a term language into its full categorical interface, which results in an implementation of the context and substitution category.
- (TODO) [`lambda-calculus.sml`](https://github.com/LiamSchilling/catlib-sml/blob/main/src/programming-languages/lambda-calculus.sml): Implements the simply typed lambda calculus with products and primitive functions between base types as a term language. This includes a type checker for lambda terms, reduction-based $\beta\eta$-normalization, and the free cartesian closed category on the category of base types (a.k.a. the category with simple types as objects and closed lambda terms up to $\beta\eta$-equivalence as morphisms).

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
