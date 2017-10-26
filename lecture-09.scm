;;; CONTINUATION PASSING STYLE aka CPS

;;; Nested procedure calls: activation records, stack, etc:

;; (car (cdr (cons 3 (cons (+ 5 6) (cons 9 null)))))

;;; when we write this the interpreter needs to keep track of the context
;;; usually represented with a stack
;;; we dont need any of that stuff
;;; we can do it with only tail calls
;;; we can remove nested calls from scheme

;;; GOAL: want to do complicated processing but dont want to use stack of activation records


;; IDEA:  Translate to "core" language with:
;;;   - λ (to be able to make function objects)
;;;   - tail calls
;;;   - variables

;;; when the + is called in
;; (car (cdr (cons 3 (cons (+ 5 6) (cons 9 null)))))
;;; it has 3 pieces of information 2 arguements and whats going to
;;; happen to it for the rest of the computation

;;; Def: a "continuation" is a function from result of call to result
;;; of entire computation it's embedded in.

;;; normal factorial
(define fact
  (λ (n)
    (if (zero? n)
	1
	(* n (fact (- n 1))))))

;;; we are constructiong a function thats functionally equivalent to a stack

(define Czero? (λ (c x) (c (zero? x))))
(define C- (λ (c x y) (c (- x y))))
(define C* (λ (c x y) (c (* x y))))

(define Cfact
  (λ (c n)
    (Czero? (λ (b)
	      (if b
		  (c 1)
		  (C- (λ (nm1)
			(Cfact (λ (fnm1)
				 (C* c n fnm1))
			       nm1))
		      n 1)))
	    n)))

;;; Properties of CPS:
;;; - all calls are tail calls
;;; - all functions take contintuation as extra argument
;;; - all temporaries have explicit names, stored in variables
;;; - order of evaluation is made explicit

;;; Consider expression:
;; (f (g x) (h y))
;;; Translate to CPS:
;;; Two alternatives:
;; (Cg (λ (gx) (Ch (λ (hy) (Cf c gx hy)) y)) x)    ; g called first
;;; vs
;; (Ch (λ (hy) (Cg (λ (gx) (Cf c gx hy)) x)) y)    ; h called first

;;; fib(0) = 1
;;; fib(1) = 1
;;; fib(n) = fib(n-1) + fib(n-2)   for n >= 2

(define fib
  (λ (n)
    (cond ((= n 0) 1)
	  ((= n 1) 1)
	  (else (+ (fib (- n 1))
		   (fib (- n 2)))))))

;;; Transcript

;; Welcome to Racket v6.9.
;; > (load "lecture-09.scm")
;; > (fact 9)
;; 362880
;; > (Cfact 9)
;; ; Cfact: arity mismatch;
;; ;  the expected number of arguments does not match the given number
;; ;   expected: 2
;; ;   given: 1
;; ; [,bt for context]
;; > ,bt
;; ; Cfact: arity mismatch;
;; ;  the expected number of arguments does not match the given number
;; ;   expected: 2
;; ;   given: 1
;; ;   arguments...:
;; ;    9
;; ;   context...:
;; ;    /usr/share/racket/pkgs/xrepl-lib/xrepl/xrepl.rkt:1448:0
;; ;    /usr/share/racket/collects/racket/private/misc.rkt:88:7
;; > (fact 9)
;; 362880
;; > (Cfact (λ (x) x) 9)
;; 362880
;; > id
;; ; id: undefined;
;; ;  cannot reference undefined identifier
;; ; [,bt for context]
;; > (define id (λ (x) x))
;; > (id 4)
;; 4
;; > (cfact sqrt 9)
;; ; cfact: undefined;
;; ;  cannot reference undefined identifier
;; ; [,bt for context]
;; > (Cfact sqrt 9)
;; 602.3952191045344
;; > (expt (Cfact sqrt 9) 2)
;; 362879.99999999994
;; > (load "lecture-09.scm")
;; ; n: undefined;
;; ;  cannot reference undefined identifier
;; ; [,bt for context]
;; > (load "lecture-09.scm")
;; ; n: undefined;
;; ;  cannot reference undefined identifier
;; ; [,bt for context]
;; > (load "lecture-09.scm")
;; > (fib 3)
;; 3
;; > (fib 4)
;; 5
;; > (fib 5)
;; 8
;; > (fib 15)
;; 987
;; > (fib 20)
;; 10946
;; > (fib 25)
;; 121393
;; > (fib 27)
;; 317811
;; > (exit)
