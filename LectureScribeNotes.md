Lecture: λ calculus 26/10/17 Derek Daly
=================================

2 Steps:

[1] Trying to use this to model regular programming languages.
>- Ways of representing  primitives (int, bools etc.)
>- Add this to our λ calculus (basis)

[2]Add  types to the λ calculus.
>- Many ways but  easy way **Simply Typed λ calculus**

So first we create a numeric basis and then we get simply typed λ calculus.

----------


Our Axioms
-------------

>- e:= v | ee | λv.e | b
>- b:= num| sin | cos| (+) | (*) | ....
>- num:= [-][0-9]'[.[0-9]']

where '=*

β reduction:

(λv.e1)e2 ------> [e2/v]e1

add more reductions:
(+) num1 num2 ------> num1 + num2

e1 + e2 -> (+) e1 e2 -> ((+) e1) e2

*Note: Think of  ((+)2) as a function that adds two to things *

>- **Currried**: f: α-> (β -> φ)
>- **Uncurrried**: f: (α x β) -> φ

*Note: You can translate curried to uncurried and vice versa. The is an Isomorphism (One to One mapping) between curried and uncurried.*

----------

Scheme
-------------------

    (define curry
			( λ (f)
				(λ (x)
					(λ (y)
						(f x y)))))

*curried* ((f x) y) ->  (f x y) *uncurried*

    (define uncurry
			( λ (f)
				(λ (x y)
					((f x) y))))
					

*We always write curried functions even when writing something like λ x y.e. We're really writing  λ x .(x y. e)*

We now have
(+) 1 (λ x y)

But sin cos etc. don't make sense yet.



Simply Typed λ Calculus
------------- 

We're going to introduce *types* and *type checking* but no *complex types*

*What is complex? Eg Map function. Map can take different types (polymorphism). We don't want this*

t will either be grounded type. We need to change definition.

>- t:= R| t --> t
>- e:= v | ee | λ(v:t).e | b
>- b:= num| sin | cos| (+) | (*) | ....
>- num:= [-][0-9]'[.[0-9]']

*t is now syntax for simply typed λ calculus*

Now introduce concepts of well typed.
What does it mean to be well typed? We'll show it,


See img 1

Infinite set of these things. eg. Every number in set.

See img 2

Now,

See img 3a

This  handles v|ee|b in .
We now only need to show   λ(v:t).e

See img 3b

### Example a: 1+2

1+2 ---> ((+) 1) 2
Prove type correctness of 1+2.

See img 4

### Example b:

See img 5


*Finish for exercise*

Simply Typed λ calculus is not Turing complete. If you keep doing the reduction it goes to normal form. **Can't reduce**

