# Scheme Meta-Circular Interpreter

To understand what it is, you have to parse apart the terms:

### An interpreter 
An interpreter is something that takes a program, in some language – an interpreter of A written in B takes an A program and puts it into the interpreter, written in B code and gives you the output.

Generally, when you write an interpreter you want the language you are interpreting to be simple and small and the language you are writing the interpreter in to be powerful.  

### A meta-circular interpreter 
A meta-circular interpreter is when you are writing an interpreter for language A and the interpreter is written in language A.  When you are writing the interpreter you want A to be small, and B to be powerful so setting A = B can be a serious constraint.

The interpreter B will be written in full (pure Sheme)  has things like LET, COND, etc and language
A  will be the core pure Scheme, which doesn’t include Let, it just includes function calls, application, λ expressions, variables, some constants including library function (like +, which is a constant).. 

The Thing we are interpreting will not have many constants

### IDEA
Implement two functions:  
Define one as eval (using eval_ as eval is a built in function).  Eval will take a scheme expression and return the value evaluated
Define a second called apply.  Apply takes a procedure and list of args and returns the result of applying the procedure to the arguments

Start with some easy cases.  

### If the expression is a symbol
If it is a global variable there will be a list of global variables somewhere.  If it’s a local variable then we have to fetch it from some data structure that represents the mapping of local variables to values.  Also needed is a data structure that represents the mapping of global variables to values.  So we have the fetch the value of the symbol from some local environment.  When you evaluate an expression like (+ x 1),  + is a global variable so can get the + function from a list of global variable. It also as to evalute x, but the value of x depends on the context in which the expression is evaluated.  The environment is defined as a mapping of variables to values.

### If it is a function call
If it’s a function call like (+1 x), we have to evaluate every one of the subexpressions, ie the +, 1 and x.  That would be a map . It has to evaluate things in context	

### Lambda Special Form
When you evaluate it, it returns a procedure.  A procedure has to have code. When you evoke a procedure, you pass it some arguments and then some code gets evaluated.  The code is the body of the procedure.  

