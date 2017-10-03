;;; ANNOYANCE: repeated motifs
;;; SOLUTION: abstraction; table-driven

;;; API for construction of LAEs (gives place to simplify):

(define lae+
  (λ (e1 e2)
    (cond ((and (number? e1) (number? e2))
	   (+ e1 e2))
	  ((equal? e1 0) e2)
	  ((equal? e2 0) e1)
	  ((equal? e1 e2) (lae* 2 e1))
	  (else (list '+ e1 e2)))))

(define lae*
  (λ (e1 e2)
    (cond ((and (number? e1) (number? e2))
	   (* e1 e2))
	  ((equal? e1 0) 0)
	  ((equal? e2 0) 0)
	  ((equal? e1 1) e2)
	  ((equal? e2 1) e1)
	  (else (list '* e1 e2)))))

(define lae/
  (λ (e1 e2)
    (cond ((and (number? e1) (number? e2))
	   (/ e1 e2))
	  ((equal? e2 1) e1)
	  (else (list '/ e1 e2)))))

(define lae-sin (λ (e) (list 'sin e)))
(define lae-cos (λ (e) (list 'cos e)))
(define lae-exp (λ (e) (list 'exp e)))

;;; def: "association list" or alist is of the form:
;;; ((key1 val1a val1b ...)
;;;  (key2 val2a val2b ...)
;;;  ...)

(define diff-table
  (list (list '+ + (λ (u v du dv) (lae+ du dv)))
	(list '* * (λ (u v du dv) (lae+ (lae* u dv) (lae* du v))))
	(list '/ / (λ (u v du dv) (lae/ (lae+
				       (lae* u dv)
				       (lae* -1 (lae* du v)))
				      (lae* v v))))
	(list 'sin sin (λ (u du) (lae* (lae-cos u) du)))
	(list 'cos cos (λ (u du) (lae* (lae* -1 (lae-sin u)) du)))
	(list 'exp exp (λ (u du) (lae* (lae-exp u) du)))))

(define diff
  (λ (e)
    (cond ((number? e) 0)
	  ((equal? e 'x) 1)
	  (else
	   (let ((op (car e))
		 (args (cdr e)))
	     (cond ((assoc op diff-table)
		    => (λ (dtr)
			 (apply (caddr dtr)
				(append args (map diff args)))))
		   (else (error "invalid lae:" e))))))))

;; (define my-apply
;;   (λ (f args)
;;     (let ((nargs (length args)))
;;       (cond ((= nargs 0) (f))
;; 	    ((= nargs 1) (f (car args)))
;; 	    ((= nargs 2) (f (car args) (cadr args)))
;; 	    ((= nargs 3) (f (car args) (cadr args) (caddr args)))
;; 	    ...))))

;;; For testing, need:

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

;; Welcome to Racket v6.9.
;; > assoc
;; #<procedure:assoc>
;; > (assoc 'a '((a aye) (b bee) (c sea)))
;; (a aye)
;; > (assoc 'c '((a aye) (b bee) (c sea)))
;; (c sea)
;; > (assoc 'd '((a aye) (b bee) (c sea)))
;; #f
;; > (load "lecture-05.scm")
;; ; lecture-05.scm:17:0: read: expected a `)' to close `('
;; ;   possible cause: indentation suggests a missing `)' before line 19
;; ; [,bt for context]
;; > (load "lecture-05.scm")
;; > (diff '(+ x 5))
;; 1
;; > (diff '(* (+ x 5) (+ x 7)))
;; (+ (* (+ x 5) 1) (* 1 (+ x 7)))
;; > (load "lecture-05.scm")
;; > (diff '(* (+ x 5) (+ x 7)))
;; (+ (+ x 5) (+ x 7))
;; > (load "lecture-05.scm")
;; > diff-table
;; ((+ #<procedure:...4/lecture-05.scm:37:17>)
;;  (* #<procedure:...4/lecture-05.scm:38:17>)
;;  (/ #<procedure:...4/lecture-05.scm:39:17>)
;;  (sin #<procedure:...4/lecture-05.scm:43:19>)
;;  (cos #<procedure:...4/lecture-05.scm:44:19>)
;;  (exp #<procedure:...4/lecture-05.scm:45:19>))
;; > apply
;; #<procedure:apply>
;; > (apply sin '(2))
;; 0.9092974268256817
;; > (apply + '(2 3 4))
;; 9
;; > (append '(a b c) '(d e f))
;; (a b c d e f)
;; > (append '(a b c))
;; (a b c)
;; > (append '(a b c) '(d e f) '(g h i))
;; (a b c d e f g h i)
;; > (map sqrt '(1 2 3 4 5 6 7 8 9 10))
;; (1
;;  1.4142135623730951
;;  1.7320508075688772
;;  2
;;  2.23606797749979
;;  2.449489742783178
;;  2.6457513110645907
;;  2.8284271247461903
;;  3
;;  3.1622776601683795)
;; > (load "lecture-05.scm")
;; > (diff '(* (+ x 5) (+ x 7)))
;; (+ (+ x 5) (+ x 7))
;; > (diff '(+ (* (sin x) (sin x)) (* (cos x) (cos x))))
;; ; lae-cos: undefined;
;; ;  cannot reference undefined identifier
;; ; [,bt for context]
;; > (load "lecture-05.scm")
;; > (diff '(+ (* (sin x) (sin x)) (* (cos x) (cos x))))
;; (+
;;  (+ (* (sin x) (cos x)) (* (cos x) (sin x)))
;;  (+ (* (cos x) (* -1 (sin x))) (* (* -1 (sin x)) (cos x))))
;; > (define s2pc2 (λ (x) (+ (expt (sin x) 2) (expt (cos x) 2))))
;; > (s2pc2 0)
;; 1
;; > (s2pc2 pi)
;; 1.0
;; > (s2pc2 0.3748247289347)
;; 1.0
;; > (load "lecture-05.scm")
;; > (diff '(+ (* (sin x) (sin x)) (* (cos x) (cos x))))
;; (+
;;  (+ (* (sin x) (cos x)) (* (cos x) (sin x)))
;;  (+ (* (cos x) (* -1 (sin x))) (* (* -1 (sin x)) (cos x))))
;; > (lae-eval (diff '(+ (* (sin x) (sin x)) (* (cos x) (cos x)))) 1.2)
;; 0.0
