# Category Theory Library of SML

## Project Structure

#### Fundemental definitions

- [`category.sig`](https://github.com/LiamSchilling/catlib-sml/blob/main/src/category.sig): Defines a category.
- [`groupoid.sig`](https://github.com/LiamSchilling/catlib-sml/blob/main/src/groupoid.sig): Defines a groupoid.
- [`presheaf.sig`](https://github.com/LiamSchilling/catlib-sml/blob/main/src/presheaf.sig): Defines a presheaf as a contravariant functor into $\mathrm{Set}$.

#### Implementations of categories and groupoids

- [`opposite-category.sml`](https://github.com/LiamSchilling/catlib-sml/blob/main/src/opposite-category.sml), [`opposite-groupoid.sml`](https://github.com/LiamSchilling/catlib-sml/blob/main/src/opposite-groupoid.sml): The opposite category/groupoid.
- [`product-category.sml`](https://github.com/LiamSchilling/catlib-sml/blob/main/src/product-category.sml), [`product-groupoid.sml`](https://github.com/LiamSchilling/catlib-sml/blob/main/src/product-groupoid.sml): The product construction category/groupoid.
- [`functor-category.sml`](https://github.com/LiamSchilling/catlib-sml/blob/main/src/functor-category.sml), [`functor-groupoid.sml`](https://github.com/LiamSchilling/catlib-sml/blob/main/src/functor-groupoid.sml): The category/groupoid of functors. Defines functors and natural transformations, with component-wise identity, composition, and inversion of natural transformations.
- [`discrete-category.sml`](https://github.com/LiamSchilling/catlib-sml/blob/main/src/discrete-category.sml), [`discrete-groupoid.sml`](https://github.com/LiamSchilling/catlib-sml/blob/main/src/discrete-groupoid.sml): The discrete category/group on a type of objects.

#### Definitions of structures in categories

- [`monoidal.sml`](https://github.com/LiamSchilling/catlib-sml/blob/main/src/monoidal.sml): Monoidal and cartesian categories.
- [`pointed.sml`](https://github.com/LiamSchilling/catlib-sml/blob/main/src/pointed.sml): Initial, terminal, and zero objects.

#### Implementations of structures in categories

- [`functor-composition.sml`](https://github.com/LiamSchilling/catlib-sml/blob/main/src/functor-composition.sml): Composition of functors and horizontal composite of natural transformations.
- [`endofunctor-monoidal.sml`](https://github.com/LiamSchilling/catlib-sml/blob/main/src/endofunctor-monoidal.sml): The monoidal structure given by composition of endofunctors.
- [`cartesian-into-terminal.sml`](https://github.com/LiamSchilling/catlib-sml/blob/main/src/cartesian-into-terminal.sml): The terminal structure on the unit of a cartesian category.
