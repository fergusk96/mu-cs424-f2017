;;; s-expr, "symbolic expression"
;;; <sexpr> ::= <symbol> | <number> | <list-of-sexprs> | #t | #f

;;; Little Arith Expressions = LAE
;;; <lae> ::= <number> | ( <op> <lae> <lae> )
;;; <op> ::= + | * | /

'(define lae-eval
   (λ (e)
     (if (number? e)
	 e
	 ;; ... op: (car e)
	 ;; ... arg1: (lae-eval (cadr e))
	 ;; ... arg2: (lae-eval (caddr e))
	 (if (equal? (car e) '+)
	     (+ (lae-eval (cadr e))
		(lae-eval (caddr e)))
	     (if (equal? (car e) '*)
		 (* (lae-eval (cadr e))
		    (lae-eval (caddr e)))
		 (error "invalid lae:" e))))))

;;; ANNOYANCE: IFs cascading to right
;;; SOLUTION: COND
;;; (cond (t1 r1) (t2 r2) ... (tn rn) (else ro))
;;; =>
;;; (if t1 r1 (if t2 r2 (if ... (if tn rn ro))))

'(define lae-eval
   (λ (e)
     (cond ((number? e)  e)
	   ;; ... op: (car e)
	   ;; ... arg1: (lae-eval (cadr e))
	   ;; ... arg2: (lae-eval (caddr e))
	   ((equal? (car e) '+)
	    (+ (lae-eval (cadr e))
	       (lae-eval (caddr e))))
	   ((equal? (car e) '*)
	    (* (lae-eval (cadr e))
	       (lae-eval (caddr e))))
	   ((equal? (car e) '/)		; add /
	    (/ (lae-eval (cadr e))
	       (lae-eval (caddr e))))
	   (else (error "invalid lae:" e)))))

;;; ANNOYANCE: repeated subexpressions
;;; ... op: (car e)
;;; ... arg1: (lae-eval (cadr e))
;;; ... arg2: (lae-eval (caddr e))
;;; ANNOYANCE: anonymous subexpressions
;;; SOLUTION: call λ-expression on values to be bound
;;;    with formal parameters as variables to bind

'(define lae-eval
   (λ (e)
     (cond ((number? e)  e)
	   (else
	    ((λ (op arg1 arg2)
	       (cond ((equal? op '+) (+ arg1 arg2))
		     ((equal? op '*) (* arg1 arg2))
		     ((equal? op '/) (/ arg1 arg2))
		     (else (error "invalid lae:" e))))
	     (car e)
	     (lae-eval (cadr e))
	     (lae-eval (caddr e)))))))

;;; ANNOYANCE: variables and their values are
;;;   separated by body
;;; SOLUTION: syntactic sugar, LET


'(define lae-eval
   (λ (e)
     (cond ((number? e)  e)
	   (else
	    (let ((op (car e))
		  (arg1 (lae-eval (cadr e)))
		  (arg2 (lae-eval (caddr e))))
	      (cond ((equal? op '+) (+ arg1 arg2))
		    ((equal? op '*) (* arg1 arg2))
		    ((equal? op '/) (/ arg1 arg2))
		    (else (error "invalid lae:" e))))))))

;;; extend language: expression "in x"
;;; Little Arith Expressions = LAE
;;; <lae> ::= <number> | ( <op> <lae> <lae> ) | x
;;; <op> ::= + | * | /

(define lae-eval
   (λ (e x)			 ; takes e <lae> and
     (cond ((number? e)  e)	 ; x, the value for x
	   ((equal? e 'x) x)
	   (else
	    (let ((op (car e))
		  (arg1 (lae-eval (cadr e) x))
		  (arg2 (lae-eval (caddr e) x)))
	      (cond ((equal? op '+) (+ arg1 arg2))
		    ((equal? op '*) (* arg1 arg2))
		    ((equal? op '/) (/ arg1 arg2))
		    (else (error "invalid lae:" e))))))))

;;; diff takes the derivative of an LAE in x, wrt x
'(define diff
  (λ (e)
    (cond ((number? e) 0)
	  ((equal? e 'x) 1)
	  (else
	   (let ((op (car e))
		 (u (cadr e))
		 (v (caddr e)))
	     (cond ((equal? op '+)
		    (list '+ (diff u) (diff v)))
		   ((equal? op '*)
		    (list '+
			  (list '* u (diff v))
			  (list '* (diff u) v)))
		   ((equal? op '/)
		    (list '/
			  (list '+
				(list '* u (diff v))
				(list '* -1 (list '* (diff u) v)))
			  (list '* v v)))
		   (else (error "invalid lae:" e))))))))

;;; ANNOYANCE: (diff u), want du

;;; ANNOYANCE: need LAE API including construction instead of (list '* ...)

(define lae+
  (λ (e1 e2)
    (cond ((and (number? e1) (number? e2))
	   (+ e1 e2))
	  (else (list '+ e1 e2)))))
(define lae*
  (λ (e1 e2)
    (cond ((and (number? e1) (number? e2))
	   (* e1 e2))
	  (else (list '* e1 e2)))))
(define lae/ (λ (e1 e2) (list '/ e1 e2)))

(define diff
  (λ (e)
    (cond ((number? e) 0)
	  ((equal? e 'x) 1)
	  (else
	   (let ((op (car e))
		 (u (cadr e))
		 (v (caddr e)))
	     (let ((du (diff u))
		   (dv (diff v)))
	       (cond ((equal? op '+)
		      (lae+ du dv))
		     ((equal? op '*)
		      (lae+ (lae* u dv) (lae* du v)))
		     ((equal? op '/)
		      (lae/
		       (lae+
			     (lae* v du)
			     (lae* -1 (lae* u dv)))
		       (lae* v v)))
		     (else (error "invalid lae:" e)))))))))

;; Welcome to Racket v6.9.
;; > (load "lecture-04.scm")
;; > lae-eval
;; #<procedure:lae-eval>
;; > (lae-eval 4)
;; 4
;; > (lae-eval '(+ 4 5))
;; ; eq: undefined;
;; ;  cannot reference undefined identifier
;; ; [,bt for context]
;; > (load "lecture-04.scm")
;; > (lae-eval '(+ 4 5))
;; 9
;; > (lae-eval '(+ (* 4 4) 5))
;; ; eq: undefined;
;; ;  cannot reference undefined identifier
;; ; [,bt for context]
;; > (load "lecture-04.scm")
;; > (lae-eval '(+ (* 4 4) 5))
;; 21
;; > (load "lecture-04.scm")
;; > (lae-eval '(+ (* 4 4) 5))
;; 21
;; > (lae-eval '(+ (/ 4 4) 5))
;; 6
;; > (load "lecture-04.scm")
;; > (lae-eval '(+ (/ 4 4) 5))
;; ; lae-eval: arity mismatch;
;; ;  the expected number of arguments does not match the given number
;; ;   expected: 2
;; ;   given: 1
;; ; [,bt for context]
;; > (lae-eval '(+ (/ 4 4) 5) 100)
;; 6
;; > (lae-eval '(+ (/ x 4) 5) 100)
;; 30
;; > (load "lecture-04.scm")
;; > (diff '7)
;; 0
;; > (diff 'x)
;; 1
;; > (diff '(* x 3))
;; (+ (* x 0) (* 1 3))
;; > (diff '(* x (+ 3 x)))
;; (+ (* x (+ 0 1)) (* 1 (+ 3 x)))
;; > (diff '(* x (+ (+ x 3) x)))
;; (+ (* x (+ (+ 1 0) 1)) (* 1 (+ (+ x 3) x)))
;; > (diff '(/ x 3))
;; (/ (+ (* x 0) (* -1 (* 1 3))) (* 3 3))
;; (/ -3 9) = -1/3
;; > (load "lecture-04.scm")
;; > (diff '(/ x 3))
;; (/ (+ (* x 0) -3) 9)
;; > (diff '(* x (+ (+ x 3) x)))
;; (+ (* x 2) (* 1 (+ (+ x 3) x)))
