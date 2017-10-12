;;; Meta-Circular Interpreter for Scheme

;;; def: Interpreter for A written in B
;;;       [A code] -> [B code which runs A code] -> [output of running the A code]

;;; Circular: A=B

;;; B = full (pure) Scheme, includes LET, COND, etc
;;; A = core pure Scheme, includes application, λ expressions, variables, some constants

;;; Representation of A values as B values:
;;;  - numbers, symbols, lists: same
;;;  - results of λ expressions: ?

(define eval_
  (λ (expr env)
    (cond ((number? expr) expr)
	  ((symbol? expr) (lookup expr env))
	  ;; special forms:
	  ((and (pair? expr) (equal? (car expr) 'quote))
	   (cadr expr))
	  ((and (pair? expr) (equal? (car expr) 'let))
	   (eval_ (expand-let-macro expr) env))
	  ((and (pair? expr) (equal? (car expr) 'λ))
	   (let ((params (cadr expr))
		 (body (caddr expr)))
	     (list '%closure params body env)))
	  ((and (pair? expr) (equal? (car expr) 'if))
	   (eval_ ((if (eval_ (cadr expr) env) caddr cadddr) expr) env))
	  ;; application aka function call aka procedure call:
	  (else
	   (let ((vals (map (λ (e) (eval_ e env)) expr)))
	     (apply_ (car vals) (cdr vals)))))))

(define apply_
  (λ (proc args)
    (cond ((and (pair? proc) (equal? (car proc) '%closure))
	   ;; result of λ expression, aka, a closure:
	   (let ((params (cadr proc))
		 (body (caddr proc))
		 (env (cadddr proc)))
	     (eval_ body (append (map list params args) env))))
	  (else (apply proc args)))))

(define globals
  (list (list 'pi (/ 22.0 7))
	(list '+ (λ (x y) (+ x y)))
	(list 'sin sin)
	(list 'exp exp)))

;;; represent env as alist: variables to values
(define lookup (λ (v env) (cadr (assoc v env))))

(define expand-let-macro
  (λ (expr)
    (let ((binds (cadr expr))
	  (body (caddr expr)))
      (let ((vars (map car binds))
	    (vals (map cadr binds)))
	(cons (list 'λ vars body) vals)))))

(define compose_ (λ (f g) (λ (x) (f (g x)))))

;; > (compose_ sin exp)
;; #<procedure>
;; > ((compose_ sin exp) 4)
;; -0.9287679362437861
;; > (define sinexp (compose_ sin exp))
;; > (sinexp 5)
;; -0.6876914116945115

;;; Transcript

;; Welcome to Racket v6.9.
;; > (load "lecture-10.scm")
;; > (eval_ '34 '())
;; 34
;; > (eval_ 'pi '())
;; ; cadr: contract violation
;; ;   expected: (cons/c any/c pair?)
;; ;   given: #f
;; ; [,bt for context]
;; > (load "lecture-10.scm")
;; > (eval_ 'pi '())
;; ; cadr: contract violation
;; ;   expected: (cons/c any/c pair?)
;; ;   given: #f
;; ; [,bt for context]
;; > (eval_ 'pi globals)
;; 3.142857142857143
;; > pi
;; 3.141592653589793
;; > (eval_ '(λ (x) pi) globals)
;; (%closure (x) pi)
;; > (eval_ '((λ (x) pi) 7) globals)
;; ; car: arity mismatch;
;; ;  the expected number of arguments does not match the given number
;; ;   expected: 1
;; ;   given: 2
;; ; [,bt for context]
;; > (load "lecture-10.scm")
;; > (eval_ '((λ (x) pi) 7) globals)
;; ; cadr: contract violation
;; ;   expected: (cons/c any/c pair?)
;; ;   given: #f
;; ; [,bt for context]
;; > (eval_ '((λ (x) 9) 7) globals)
;; 9
;; > (eval_ '((λ (x) x) 7) globals)
;; 7
;; > (eval_ 'pi globals)
;; 3.142857142857143
;; > (eval_ '((λ (x) pi) 7) globals)
;; ; cadr: contract violation
;; ;   expected: (cons/c any/c pair?)
;; ;   given: #f
;; ; [,bt for context]
;; > (eval_ '(λ (x) pi) globals)
;; (%closure (x) pi)
;; > (map list '(x) '(7))
;; ((x 7))
;; > (load "lecture-10.scm")
;; > (eval_ '((λ (x) pi) 7) globals)
;; 3.142857142857143
;; > (eval_ '((λ (x) x) 7) globals)
;; 7
;; > (define compose_ (λ (f g) (λ (x) (f (g x)))))
;; > (compose_ sin exp)
;; #<procedure>
;; > ((compose_ sin exp) 4)
;; -0.9287679362437861
;; > (define sinexp (compose_ sin exp))
;; > (sinexp 5)
;; -0.6876914116945115
;; > (load "lecture-10.scm")
;; > (eval_ '(λ (x) x) globals)
;; (%closure (x) x ((pi 3.142857142857143)))
;; > (eval_ '((λ (x) x) 7) globals)
;; 7
;; > (eval_ '((λ (x) pi) 7) globals)
;; 3.142857142857143
;; > (load "lecture-10.scm")
;; > (eval_ '+ globals)
;; #<procedure:...4/lecture-10.scm:43:17>
;; > (eval_ '((λ (f g) (λ (x) (f (g x)))) sin exp) globals)
;; (%closure
;;  (x)
;;  (f (g x))
;;  ((f #<procedure:sin>)
;;   (g #<procedure:exp>)
;;   (pi 3.142857142857143)
;;   (+ #<procedure:...4/lecture-10.scm:43:17>)
;;   (sin #<procedure:sin>)
;;   (exp #<procedure:exp>)))
;; > (eval_ '(((λ (f g) (λ (x) (f (g x)))) sin exp) 4) globals)
;; -0.9287679362437861
;; > (sinexp 4)
;; -0.9287679362437861
;; > (load "lecture-10.scm")
;; > (eval_ '(if '#f 1 2) globals)
;; 2
;; > (eval_ '(if 'seventween 1 2) globals)
;; 1
;; > (load "lecture-10.scm")
;; > (expand-let-macro '(let ((x 2) (y 3)) (f x x y)))
;; ((λ (x y) (f x x y)) 2 3)
