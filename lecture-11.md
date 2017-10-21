# $\lambda$ Calculus

Lecture from 19/10/17 notes by Ruth Ellen O'Connor 

### What's a Calculus?

A formal system containing:

* terms

  * some language of expression which is formally defined
  * e.g.   $\frac{x^3 + \sin{\sqrt{x}}}{\cos{2x}}$

* reduction rules

  * ways of transforming an expression

  * you don't have to know what it means, or the semantics to do this

  * e.g. differentiation $\frac{\mathrm {d}}{\mathrm {d}v}(e_{1}+e_{2}) \to \frac{\mathrm {d}}{\mathrm {d}v}e_1+\frac{\mathrm {d}}{\mathrm {d}v}e_2$

    $\sin{t}\frac{\mathrm {d}}{\mathrm {d}t}(\sqrt{t}+\cos{3t}) \to \sin{t} (\frac{\mathrm {d}}{\mathrm {d}t}\sqrt{t}+\frac{\mathrm {d}}{\mathrm {d}t}\cos{3t})$

examples: 

* differential calculus $\frac{\mathrm {d}}{\mathrm {d}x}$
* integral calculus $\int{}\mathrm{d}x$
* predicate logic

###Where did $\lambda$ Calculus come from?

In the 1930's **Alan Turing** and other mathematicians were looking at a list of unsolved problems, one of which was given a mathematical conjecture can it be proven mechanically. This lead to the the Turing Machine. At the time Turing did not have a PhD. He went to work with **Alonzo Church** in Princeton. Church had invented **$\lambda$ Calculus**. Turing and Church showed that $\lambda$ Calculus is **Turing Equivalent**.

**Turing Machine**

* clunky form of computation - oddly similar to biology
* used for proofs
* **but** you don't want to write code for this

**$\lambda$ Calculus**

* as small as the Turing Machine
* can code in it

## $\lambda$ Calculus

#### Term

$t::=$ $v \,\,\,\,\,\,\,\,\,\,\,\,\, \text{ a variable, where } v ::= x|y|z|x_{1}|x_{2}|x_{3} \\|tt \,\,\,\,\,\,\,\,\,\,\, \text{an application} \\| \lambda \,v.t \,\,\,\,\lambda \text{ expression}$  		

example of legal expressions:

* $z$


* $x\,y$
* $\lambda\,x . (\lambda\,y. (x\,y)((x\,x)\,y))$
* $\lambda\, x.y$

So far we just have a formal system with no semantics

###Reduction Rules for Pure, Untyped $\lambda$ Calculus

#### $\beta$ Reduction

This is the only reduction

It is defined as:

* $(\lambda\,v.t_1)t_2 \to [\frac{t_2}{v}]t_1$
* That is, $t_1$ where every occurrence off $v$ is replaced by $t_2$.

Formal definition of $[\frac{t}{v}]$:

* For $v$:
  * $[\frac{t}{v}]\to t$
  * $[\frac{t}{v_1}] \to v_2$
* For $tt$:
  * $[\frac{t_1}{v}](t_2t_3)\to[\frac{t_1}{v}]t_2[\frac{t_1}{v}]t_3$
* For $\lambda\,v.t$:
  * $[\frac{t_1}{v}](\lambda\,v.t_2) \to \lambda\,v.t_2$
  * $[\frac{t_1}{v_1}](\lambda\,v_2.t_2)\to\lambda\,v_2.[\frac{t_1}{v_1}]t_2,\,(v_1 \neq v_2)$
    * very subtle bug in this $\lambda\,v_2.[\frac{t_1}{v_1}]t_2\iff v_2 \notin FV(t_1)$, where $FV(t_1)$ is the set of free variables in $t_1$
    * this means that if $v_2\in FV(t_1)$ then we have to change variable names 

#### Change of Variable Reduction:

$\lambda\,v_1.t \to \lambda\,v_2.[\frac{v_2}{v_1}]t$ , where $v_2$ is fresh (a new variable name)

### Syntactic Sugar

example of syntactic sugar from maths:

* $xy+ab = (xy)+(ab)$

**In $\lambda$ Calculus:**

Application $tt$:

* $t_1t_2t_3 = (t_1t_2)t_3$ 
* think of application as an operator, it is left associative

$\lambda$ Expression:

* $\lambda\,v_1v_2\dots v_n.t = \lambda\,v_1.(\lambda\,v_2. (\dots(\lambda\,v_n.t)\dots))$
* $x\,\lambda\,y.xzx=x(\lambda\,y.(xz)x)$
* $\lambda$ binds as loosely as possible

### Shorthand Notation 

* $True =\lambda\,xy.x$
* $False =\lambda\,xy.y$
* If $=\lambda\,bxy.bxy$ , looks like the identity function

#####If 

If $True\, t_1\,t_2$

​	$(\lambda\,bxy.bxy)(\lambda\,xy.x)t_1t_2$

​	$=((\lambda\,b.(\lambda\,xy.bxy))(\lambda\,xy.x))t_1t_2$

​	$=[\frac{\lambda\,xyx}{b}](\lambda\,xy.bxy)t_1t_2$

​	$= (\lambda\,xy.(\lambda\,xy.x)xy)t_1t_2$

​	$=(\lambda\,x.\lambda\,y((\lambda\,xy.x)x)y)t_1t_2$

​	$=(\lambda\,x.\lambda\,y.(\lambda\,y.[\frac{x}{x}]x)y)t_1t_2$

​	$=(\lambda\,x.\lambda\,y.(\lambda\,y.x)y)t_1t_2$

​	$=(\lambda\, x.\lambda\,y.[\frac{y}{y}]x)t_1t_2$

​	$=((\lambda\,x.\lambda\,y.x)t_1)t_2$

​	$=([\frac{t_1}{x}]\lambda\,y.x)t_2$

​	$=(\lambda\,y.[\frac{t_1}{x}]x)t_2$

​	$=(\lambda\,y.t_1)t_2$

​	$=[\frac{t_2}{y}]t_1$

​	$\to t_1$

If $False\, t_1\,t_2 \to t_2$, use same method as above.

#####Encoding the Natural Numbers (non-negative integers)

$0=\lambda\,fx.x \\ 1=\lambda\,fx.fx \\ 2=\lambda\,fx.f(fx) \\ 3=\lambda\,fx.f(f(fx)) \\ \vdots \\ n = \lambda\,fx.\underbrace{f(f \dots (fx)}_{n\text{ times}} \dots)$

##### Successor ($+1$)

$\text{succ} \, n \to (n+1)$

$\text{succ} =  \begin{cases}\lambda\,z.\lambda\,fx. f(zfx) \text{ z times then once more}\\  \lambda\,z.\lambda\,fx.zf (fx) \text{ one time then z more}\end{cases}$ 

##### Next time

* Arithmetic
* Confluence

