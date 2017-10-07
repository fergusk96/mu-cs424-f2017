# CS424  Lecture 08
##### scribe - Helena Rothwell

---

### Tail Recursion:

<br/>

>
> 'Non-tail' recursion uses the stack frame to store a result and returns to it after the recursive call is finished, as every recursive call has to complete before the work of calculating the call is done the stack frame will grow accordingly. This can be costly not only in terms of memory, but it will be slower to run too.
>

<br/>

>
> 'Tail' recursion is where the recursive call is at the end (tail) of the function. The result of the recursive call is passed directly through to the function without employing stack space. Tail recursion calls are also faster than non tail calls. 
Non tail recursive calls can be rewritten as tail recursive calls. 
>

<br/>

- Recap: Defined a data structure in terms of lambda.

- General Form: Lambda is the ultimate declarative data structure

- Today we are talking about lambda, the ultimate goto

<br/>

> This is really useful to understand. You may think that goto is a low level thing such as a machine code level instruction. (think assembly language) Whereas a procedure call seems like a complex thing. 
>
<br/>

>BUT.... It's JUST as inexpensive as a goto!! 
> 
<br/>

>What's happening when you call a subroutine? A Shift of control is a branch <=> is a goto. 
>
> When goto is finished, optionally, we have to get back to the start. Stashing the next address is not optional. 
>  
>  
> Arguments
>   
>  
> Subroutines don't always take arguments. Often they have to calculate them. It can be arranged that these arguments end up where they will be needed at time of calculating them.
> 
<br/>

> Please see the factorial function created in C then translated into a scheme function in this lectures .scm file. 
> 
<br/>

> Firstly, to translate the c function into a low level 'thing' we considered a label to be the target of a machine call. 
>  
>  
> Every program point will call a procedure, and arguments will all be live variables. 
> 
<br/>

- The following is a loose transcript of (a representation of) some machine code from the board with comments.

- (Please refer to the .scm file when it becomes available for accurate transcript:)

<br/>
 	1. 
	
	fact (n): 		;;Label taking in a live variable n.
	L0 (n):			;;Calls label 1 with a value of n & 1
	L1 (n, a):		;;Goes to top of the loop, calls L2 with initial value of 1
	L2 (i, n, a):	
		if(i<=n)
		L3(i, n, a*i)
		else L4(a)
		L3(i, n, a):
	L2 (i+1, n, a)	;;end of loop so increment i
	L4 (a): 		;;only a is alive now.
	
	2.	Next, this is translated into scheme. See .scm file
	
> 
<br/>
	
>Notes:
>	Each procedure names a label  
>	Each label is a hunk of code  
>	Each hunk of code calls a procedure  
>   
>  	
>	Think in terms of two alternatives:  
>		Alt 1: Return pops a balance from the return stack & puts it into the program.  
>		Alt 2: Why not just reutrn to where it's needed?   
>     
>    
>	Think of Alt 2 as an optimisation.   
>	In large programs this is very beneficial because we can avoid exhausting the stack.  
>  
>	"Tail call is a result that's returned which will immediately be returned by the caller."  
>  
>	Notion related to tail calls: Sometimes recursive. (calls itself).  
>	When recursion is finished, if recursion has a tail call, you call it a tail recursive definition
	
	
	