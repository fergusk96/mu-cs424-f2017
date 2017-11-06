# Untyped $\lambda$ Calculus

Lecture from 24/10/17 notes by Ruth Ellen O'Connor 

From last time we have:

* terms $e$
* variables $x.v$
* applications $ee$
* $\lambda$ expressions $\lambda\,v.e$

The following reductions:

* $\beta$-reduction $(\lambda\,v.e_1)e_2 \overset{\beta}{\to} [\frac{e_2}{v}]e_1$ 
* $\alpha$-renaming $\lambda\,v_1.e\overset{\alpha}{\to}\lambda\,v_2.[\frac{v_2}{v_1}]e$ where $v_2$ is a fresh variable
  * identical up to $\alpha$-renaming: $e_1 \overset{\alpha}{\equiv} e_2 \iff e_1\overset{\alpha}{\to}\dots\overset{\alpha}{\to}e_2$
    * that is $e_1$ is $\alpha$-equivalent to $e_2$ if and only if after some number of alpha reductions it can become $e_2$

### Arithmetic 

If we can get arithmetic we are Turing equivalent.

Let:

$true = \lambda\,xy.x \\ false = \lambda\,xy.y \\ 0=\lambda\,fx.x \\ 1=\lambda\,fx.fx \\ 2=\lambda\,fx.f(fx) \\ 3=\lambda\,fx.f(f(fx)) \\ \vdots \\ n = \lambda\,fx.\underbrace{f(f \dots (fx)}_{n\text{ times}} \dots)$

Then define:

$\text{succ}=\lambda\,n.\lambda\,fx.f((nf)f) \\ \text{plus}= \lambda\,nm.\lambda\,fx.nf(mfx) , nf \text{ is that }f \text{ occurs } n \text{ times},mfx \,m\text{ occurs } m \text{ times to }x \\ \text{prod}=\lambda\,nm.\lambda\,fx.n(mf)x, \text{ the product} \\ \text{const}=\lambda\,xy.x,\text{ the constant}$

Now we want to define **predecessor** ($n-1$) in order to do subtraction. This is more difficult.

First let's rewrite some functions using **syntactic sugar**

$\text{prod }n\,m=\lambda\,fx.n(mf)x \\ \text{const }x\,y=x$

And define some new functions

$\text{zero }n=\lambda\,n(\text{cons }false)\,true \\ \text{not }b=b\,false\,true \\ \text{pair }x\,y=\lambda\,z.zxy,\text{ cons in Scheme} \\ \text{head } p = p\,true,\text{ car in Scheme} \\ \text{tail }p = p\,false,\text{ cdr in Scheme}$

Then we have:

$\text{pred }n = \lambda\,fx.n(\lambda\,p\,\text{if }(\text{car }p)\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,)(\text{cons }true\,x) \\ \,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,(\text{cons } false(\text{cdr }p)) \\ \,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,(\text{cons }false(f(\text{cdr})))$

Or alternatively:

$\text{pred }n = \lambda\,fx.n(\lambda\,p\,\text{cons }false\,\,\,\,\,\,\,\,\,\,\,\,)(\text{cons }true\,x) \\ \,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,(\text{if }(\text{car }p) \\ \,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,(\text{cdr }p ) \\ \,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,(f (\text{cdr }p))$

So we can finally define subtraction:

$\text{subtract }n\,m=m \text{ pred }n$

## Mathematical Properties:

1. Confluence
2. Termination

### Confluence

If I do some sequence of reductions on some $e$ there exists - no matter what reductions I've done - some set of reductions that I can return to $e$.

How can we prove this? Using induction and a certain property...

**Diamond Property**

We are trying to establish:

$\,\,\,\,\,e_1 \\ \,\,\,/ \,\,\,\backslash \\e_2 \,\,\,\,e_3 \\ \,\,\,\backslash \,\,\,/ \\ \,\,\,\,\,e_4$

**Proof Sketch** using case analysis

3 cases: both $\beta$, both $\alpha$, 2 different reductions

* $\alpha$ renaming

  $(\dots(\dots((\lambda\dots)e)\dots)\dots)$

  go through cases of renaming

* for big paths and different reductions

  $\,\,\,\,\,e_1 \\ \alpha/ \,\,\,\backslash \beta\\\,\,e_2 \,\,\,\,e_3 \\ \,\,/\backslash \,\,\,/ \backslash\\ \, \,\,\,\,\,\,e_4\\$

  etc.

  use induction on the size of the diamond

**In general**

In $\lambda$ Calculus all proofs involve case analysis.

Automatic systems exist for checking and generating this proof.

### Termination

If you start with some expression $e$ after a finite number of reductions you will end up with an irreducible term (that is, you can't perform any $\beta$ reductions).

$e\underbrace{\to\dots\to}_{\text{finite}} e_1$, where $e_1$ is irreducible

### Pure $\lambda$ Calculus

Has confluence - which is shown by the diamond property

Does not have termination, as shown below with an infinite loop using $\beta$ reduction

$(\lambda\,x.xx)(\lambda\,y.yy)\to[\frac{\lambda\,y.yy}{x}](xx) = (\lambda\,y.yy)(\lambda\,y.yy)$, which is the same up to $\alpha$ renaming 

#### Next time

* simple typed $\lambda$ Calculus



