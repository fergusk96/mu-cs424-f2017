# Lecture 4 – 28/09/2017

Note: If there are any errors, or any improvements that could be made in general, feel free to edit these notes. Also there may be some overlap with the comments in lecture-04.scm.

In this lecture, Barak focuses on a subset of Scheme called Little Arith Expression (LAE).

Syntax of LAE: operator + two arithmetic expressions.

Barak defines a new function called `lae-eval` (lines 8 - 21), which takes in two numbers and an operator. The function will perform an operation (+, -,/ etc.) on the numbers based on the inputted operator.
An updated version (29-44) of the function is written which aims to improve on the repetition that exists in the original. `cond` is used in the function and a division operator is added.

A new version is required however. The subexpression, (car e), appears three times and the subexpressions; `op`, `arg1` and `arg2` are not named.
This can be improved using the `λ` expression (Updated version at lines 54-65).

However, the updated version of the function creates new issues:
-	There is no “syntactic enforcement”.
-	The body seperates the variables and the values.

Syntactic sugar is used to solve this.

Use let followed by the variable, value and body (Updated version at 72-82).
The `cond` statements which were originally outside the scope of the function are now placed as values after the variables.

Barak subsequently introduced the variable `x` as an “evaluation expression” (89-100).
This is added to the function as an extra argument.

A new function, called `diff` (103-123), will now find derivatives of inputted variables/numbers.
The new function will also make use of statements from `lae-eval`.

For example, if `e` (the input) is a number, the derivative is 0.
If `e` is x, the derivative is 1.

In this version of the function, `e1` and `e2` (inputs) are changed to `u` and `v` respectively, in accordance with the Quotient Rule.
An issue with this function, however, is the repeated use of `diff u` and `diff v`.

Barak subsequently builds an LAE API (129-139) as a new function. The API (called `lae+`) takes in two arguments and returns a list for each operator.

# Additional Content:
`;;;` - block comments (used at the left side of page)

`;;` - idents with code

`;` - used at the right hand side of page

# References:
lecture-04.scm by Dr. Barak Pearlmutter
