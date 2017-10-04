# CS424  Lecture 05
##### scribe - Deirdre Hegarty

---

### Things that are annoying:
###### (starting with code from last lecture)

- Repeated code (this is an opportunity for abstraction)
	  * repeated mofits: `lae +` , `lae *` , `lae \`

<br/>

>
> "It should be noted that no ethically - trained software engineer would ever consent to write a DestroyBaghdad procedure. Basic professional ethics would instead require him to write a DestroyCity procedure, to which Baghdad could be given a parameter"
> -  Nathaniel S. Borenstein
>

<br/>

- TRY: Make something that is table-driven, where the table contains code that can be evoked (natural in Scheme).

- SOLUTION: abstraction & use a table

<br/>

  1. Define a table (list of entries - association list / alist is a form:
	  ```
	  ((key1 value1 ...)
	   (key2 value2 ...)
	   ...
	  )
	  ```
The key is the operator ( `+` , `/` , `*` )

<br/>

  2. Predefined alist look-up `assoc` return the whole row ( `assoc` is used for searching lists). `assoc` will return what is associated with the given key or returns `#f` if nothing was found.

- Search through previous code replacing `if` with `cond` 

`(cond (guard) (value))`

`cond` has special synthax `=>` . When used, the thing in the right is a function and it is evoked on whatever the guard had.

```scheme
(cond ((assoc op diff-table)
		    => (λ (dtr)
			 (apply (caddr dtr)
				... ))))
```


Test with `(diff '(* (+ x 5) (+ x 7)))`

<br/>

**Code** : `+` and `*` have identity elements (need to think about this) -> should simplify before you construct anything (generate good code first instead of trying to optomise later).

<br/>


  3. Add sine and cosine ... `sin` , `cos` , `exp` : These are unary, whereas the previous were not unary.

So far we have `u` and `du` so at the moment the code won't work...
  * We could have two different tables - one for binary (this is ugly)
  * Use function that for whatever number: function called `apply`, that takes procedure & a list of args. Alternatively can write own function.

`(apply + '(2 3 4))`


```scheme
(define my-apply
   (λ (f args)
     (let ((nargs (length args)))
       (cond ((= nargs 0) (f))
 	    ((= nargs 1) (f (car args)))
 	    ((= nargs 2) (f (car args) (cadr args)))
 	    ((= nargs 3) (f (car args) (cadr args) (caddr args)))
 	    ...))))
```

`nargs` = using it to count the number of args.


<br/>

Build list of args:
```scheme
(cond ((assoc op diff-table)
		    => (λ (dtr)
			 (apply (caddr dtr)
				(append args (map diff args)))))
```


`map` = Takes function & list and returns list with function applied to every element in that list
`(map odd? '(1 2 3))` will return `'(#t #f #t)`


<br/>

Trick for testing long outputs = plug in a partuicular value for x

```scheme
(define lae-eval
   (λ (e x)			 ; takes e <lae> and
     (cond ((number? e)  e)	 ; x, the value for x
	   ((equal? e 'x) x)
	   (else
	    (let ((op (car e))
		  (args (cdr e)))
	     (cond ((assoc op diff-table)
		    => (λ (dtr)
			 (apply (cadr dtr)
				(map (λ (e) (lae-eval e x))
				     args))))
		   (else (error "invalid lae:" e))))))))
```


`lae-eval (diff '(+ (* (sin x) (sin x)) (* (cos x) (cos x)))) 1.2)`

output `0.0`

<br/>

