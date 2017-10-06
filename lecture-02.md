# Introduction to Scheme (Racket) #

#### *using Racket v6.9 – a descendant of Scheme (a dialect of LISP) ####

-   Brackets are very important
-   Function calls deviate from typical java or C# syntax
-   Functions do not need to be given a name when declared as opposed to
    a method declaration in java
-   Scheme uses prefix notation
-   Follow the indentation standard developed

## Some General Syntax ##
- < identifier > ::= < id-char >+    (not interpretable as a number)
- < id-char > ::= 'a' | 'b' | ... | '0' | '-' | '_' | ...
- < number > ::= ...
- < expr > ::= < variable > | < number > | < function call > | < special form >
- < function call > ::= '(' < expr > < expr >* ')'
- < special form > ::= '(' < magic keyword > ... ')'
- < magic keyword > ::= 'define' | 'lambda' | 'λ' | 'if'

**Note:** _A number by itself is an expression, and the answer is just the number:_ 

```Scheme 
> 7
7

> 17.0
17.0

> 17.0e27
1.7e+28

> -4
-4

> 12/3         ;the rational number, not the operation of division
4
```

## Function Calls (Procedure Applications) ##

Racket uses parentheses to wrap larger expressions—almost any kind of
expression, other than simple constants.\
	`'(' < expr > < expr >* ')'`

```Scheme
> (sin 2)
0.9092974268256817

> (+ 2 3)
5

> (+ 2 3 4 5 6 7 8)
35

> (* 2 3)
6

> (/ 2 3.0)
0.6666666666666666

> (expt 2 1000)
1071508607186267320948425049060001810561404811705533…

> (/ (expt 2 1000) (expt 2 998))
4

```

**Note:**

```Scheme
> (+ 2)    
2

> (+)     ; the identity element
> 0
```

## Constants ##

An approximation of π, the ratio of a circle’s circumference to its
diameter:
```Scheme
> pi
3.141592653589793
```

## Definitions ##

Use the `define` keyword to define variables:

```Scheme
> tau
tau: undefined...

> (define tau (* 2 pi))
6.283185307179586

> tau
6.283185307179586
```

## Lamda (λ) expression ##

In comparison to other programming languages like C# and Java the
definition and name(identifier) are not set at the same time. They are
logically distinct operations.

In Racket, you can use a lambda expression
to produce a function directly.
The lambda form is followed by identifiers for the function’s arguments, and then the
function’s body expressions:

`< λ expr > ::= '( λ (' < id >+ ')' < expr > ')'`

```Scheme
> (λ (x) (+ x 1))
#<procedure>

> ( (λ (x) (+ x 1)) 7)
8
```

#### Hypotenuse ####

```Scheme
> hypot
hypot:undefined...

> (define hypot
    (λ (x y)
      (sqrt (+ (* x x)
        (* y y))))
        
> hypot
#<procedure:hypot>

> (hypot 3 4)
5
```
**Note:** _Procedures can take procedures also_

#### Composition ####

```Scheme
> (define comp
    (λ (f g)
      (λ (x)
        (f (g x)))))

> comp
#<procedure:comp>

> ((comp sqrt) 16)
2
```

## Conditionals ##
True and false are represented by
the values \#t and \#f, respectively, typically treat anything other than #f as true.

- `#t` - True
- `#f` - False

```Scheme
> (= 0 1)
#f
```

**The** `if` **form:**

`< if expr > ::= '(if' < expr > < expr > < expr >')'`


```Scheme
> (if (= 0 0) 23 36)
27

> (if #t 27 36)
27

> (if #f 27 36)
36
```

**Note:** _Anything not false is true_

```Scheme
> (if 0 27 36)
27
```

## Recursion ##

#### Factorial ####

```Scheme
>(define fact
    (λ (n)
      (if (= n 0)
      1
      (fact ((- n 1) (* a n))))))

> fact
#<procedure:fact>
```

#### Iterate ####

```Scheme
> (define iterate
  (λ (n f x)
    (if (= n 0)
    x
    (f (iterate (- n 1) f x))))
    
> iterate
#<procedure:iterate>
```

**Note:** _For greater efficiency use tail-recursion_ 

```Scheme 
> (define iterate
    (λ (n f x)
      (if (= n 0)
      x
      (iterate (- n 1) f(f x)))))

> iterate
#<procedure:iterate>
```

#### Square root ####

```Scheme
> (define my-sqrt
  (λ (x)
    (iterate 200
      (λ (y) (/ (+ y (/ x y)) 2))
        (/ x 2))))

> my-sqrt
#<procedure:my-sqrt>

> (my-sqrt 4.0)
2

> (my-sqrt 10.0)
3.162277660168379
```
## Loading a File ##
```Scheme
> (load "lecture-02.scm")
```
