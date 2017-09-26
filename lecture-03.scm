;;; Plan for today (and next few lectures): continue with Scheme.

;;; Scheme
;;;  - dialect of lisp, meaning:
;;;    - highly parenthesis rich syntax
;;;    - datatype: list and s-expression
;;;    - has lambda aka λ for making function objects
;;;    - DYNAMICALLY TYPED
;;;  - simple,
;;;  - good for teaching, writing compilers,
;;;  - easy to extend, etc
;;;  - eager evaluation

(define k (λ (x y) x))

;;; Church Encoded Pairs:

(define kons (λ (x y) (λ (z) (if z x y))))
(define fst (λ (p) (p #t)))
(define snd (λ (p) (p #f)))

;;; car, cdr
;;; (define caar (λ (x) (car (car x))))
;;; ...
;;; (define caddr (λ (x) (car (cdr (cdr x)))))
;;; ...
;;; (define cddddr (λ (x) (cdr (cdr (cdr (cdr x))))))

;;; length of empty list is zero.
;;; length of non-empty list is one plus length of its tail.

(define my-length
  (λ (xs)
    (if (null? xs)
	0
	(+ 1 (my-length (cdr xs))))))

;; Welcome to Racket v6.9.
;; > (+ (sin 1) (cos 2))
;; 0.4253241482607541
;; > (sqrt -3)
;; 0+1.7320508075688772i
;; > (/ 1 0)
;; ; /: division by zero [,bt for context]
;; > (load "lecture-03.scm")
;; > (k 2 3)
;; 2
;; > (k 2 (/ 1 0))
;; ; /: division by zero [,bt for context]
;; > (load "lecture-03.scm")
;; > (fst (kons 3 4))
;; 3
;; > (snd (kons 3 4))
;; 4
;; > ((fst (kons sin sqrt)) 4)
;; -0.7568024953079282
;; > (define eh (kons 3 (kons 4 (kons (kons 5 6) 7))))
;; > (fst eh)
;; 3
;; > (snd eh)
;; #<procedure:...4/lecture-03.scm:15:22>
;; > (fst (snd eh))
;; 4
;; > (fst (snd (snd (snd eh))))
;; ; application: not a procedure;
;; ;  expected a procedure that can be applied to arguments
;; ;   given: 7
;; ; [,bt for context]
;; > (snd (snd (snd eh)))
;; 7
;; > (fst (fst (snd (snd eh))))
;; 5
;; > sqrt
;; #<procedure:sqrt>
;; > (quote sqrt)
;; sqrt
;; > (quote ())
;; ()
;; > null
;; ()
;; > (cons 3 null)
;; (3)
;; > (cons (quote snd) (cons (quote eh) null))
;; (snd eh)
;; > (define baz (cons (quote snd) (cons (quote eh) null)))
;; > baz
;; (snd eh)
;; > (car baz)
;; snd
;; > (cdr baz)
;; (eh)
;; > (define zonk (cons (quote snd) (cons (quote eh) (cons (quote aye) (cons (quote bee) (cons (quote sea) null))))))
;; > zonk
;; (snd eh aye bee sea)
;; > (car (cdr (cdr zonk)))
;; aye
;; > (quote sqrt)
;; sqrt
;; > (quote ())
;; ()
;; > (quote (aye bee sea dee))
;; (aye bee sea dee)
;; > '(aye bee sea dee)
;; (aye bee sea dee)
;; > '(aye (bee sea dee eee))
;; (aye (bee sea dee eee))
;; > (+ 2 sin)
;; ; +: contract violation
;; ;   expected: number?
;; ;   given: #<procedure:sin>
;; ;   argument position: 2nd
;; ; [,bt for context]
;; > null?
;; #<procedure:null?>
;; > (null? 13)
;; #f
;; > (null? 'null)
;; #f
;; > (null? null)
;; #t
;; > (null? '())
;; #t
;; > (null? (quote ()))
;; #t
;; > eh
;; #<procedure:...4/lecture-03.scm:15:22>
;; > zonk
;; (snd eh aye bee sea)
;; > (null? zonk)
;; #f
;; > (null? (cdr (cddddr zonk)))
;; #t
;; > list?
;; #<procedure:list?>
;; > (list? 3)
;; #f
;; > (list? null)
;; #t
;; > (list? '(not a list))
;; #t
;; > (pair? '(not a list))
;; #t
;; > (pair? '())
;; #f
;; > (pair? 42)
;; #f
;; > (load "lecture-03.scm")
;; > (my-length zonk)
;; 5
;; > zonk
;; (snd eh aye bee sea)
;; > (my-length (cdr zonk))
;; 4
;; > 
