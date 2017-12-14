;;; Write a unifier in Scheme.

;;; Q1. Representation for "things to be unified",
;;;     analogous to prolog term.

;;; A: s-expression, with logic variables
;;;    sprinkled inside.

;;; Q2. Representation for logic variables.

;;; A: (? <symbol>)

;;; Q3. How to represent logic variable binding?

;;; A: Could walk-and-substitute ... no.
;;;    Instead: keep a list of bindings.
;;;          Association list: ((LV1 val1)...)

;;;

;;; Unify takes: two terms, and a logic variable binding context.
;;;       returns: #f is they cannot be unified, and augmented lvv if they can be.

(define unify
  (λ (t1 t2 lvv)
    (cond ((not lvv) #f)
	  ((unbound-lv? t1 lvv) (cons (list t1 t2) lvv))
	  ((unbound-lv? t2 lvv) (cons (list t2 t1) lvv))
	  ((assoc t1 lvv) => (λ (bp) (unify (cadr bp) t2 lvv)))
	  ((assoc t2 lvv) => (λ (bp) (unify t1 (cadr bp) lvv)))
	  ((and (null? t1) (null? t2)) lvv)
	  ((and (symbol? t1) (symbol? t2) (equal? t1 t2)) lvv)
	  ((and (number? t1) (number? t2) (= t1 t2)) lvv)
	  ((and (pair? t1) (pair? t2))
	   (unify (cdr t1) (cdr t2) (unify (car t1) (car t2) lvv)))
	  (else #f))))

(define unbound-lv? (λ (s lvv) (and (lv? s) (not (assoc s lvv)))))

(define lv? (λ (s) (and (pair? s)
			(equal? (car s) '?)
			(pair? (cdr s)))))

;;; mem/2 in Prolog:
;;; mem(X,[X|_]).
;;; mem(X,[_|Xs]) :- mem(X,Xs).

;;; Returns "unifier", i.e., augmented lvv,
;;; that makes e a member of lis.
(define mem
  (λ (e lis lvv)
    (let ((lv-x `(? ,(gensym 'x)))
	  (lv-xs `(? ,(gensym 'xs)))
	  (lv-_ `(? ,(gensym '_))))
      (cond ((unify `(mem ,e ,lis)
		    `(mem ,lv-x (,lv-x . ,lv-_))
		    lvv)
	     ;; mem(X,[X|_]).
	     => identity)
	    ((unify `(mem ,e ,lis)
		    `(mem ,lv-x (,lv-_ . ,lv-xs))
		    lvv)
	     ;; mem(X,[_|Xs]) :- mem(X,Xs).
	     ;; could represent this rule as:
	     ;;    ((mem (? x) ((? _) . (? xs))) (mem (? x) (? xs)))
	     ;; could write Scheme code to interpret it properly...
	     => (λ (lvv1) (mem `,lv-x `,lv-xs lvv1)))
	    (else #f)))))
