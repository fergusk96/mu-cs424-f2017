
;;; LAMBDA: THE ULTIMATE XXX!

;;; Lambda: the ultimate declaritive / data structure"

;;; struct foo {void *a, void *b, void *c;}

;;; Represent as list:
;; (define make-foo
;;   (λ (a b c)
;;     (list a b c)))

;; (define foo-a (λ (f) (car f)))
;; (define foo-a car)
;; (define foo-b (λ (f) (cadr f)))
;; (define foo-b cadr)

(define make-foo
  (λ (a b c)
    (λ (s) (cond ((equal? s 'aye) a)
		 ((equal? s 'bee) b)
		 ((equal? s 'sea) c)))))

(define foo-a (λ (f) (f 'aye)))
(define foo-b (λ (f) (f 'bee)))
(define foo-c (λ (f) (f 'sea)))

;;; Lambda the ultimate GOTO!

;; int fact(int n)
;; {
;;      L0:
;;   int a=1;
;;      L1:
;;   for (int i=1; i<=n; i++) {
;;      L2:
;;     a = a*i;
;;      L3:
;;   }
;;      L4:
;;   return a;
;; }

;; L0(n):
;;   return L1(n,1)
;; L1(n, a):
;;   return L2(1, n, a)
;; L2(i, n, a):
;;   if (i<=n)
;;       return L3(i, n, a*i)
;;   else
;;       return L4(a)
;; L3(i, n, a):
;;   return L2(i+1, n, a)
;; L4(a):
;;   return a

(define fact1 (λ (n) (L0 n)))
(define L0 (λ (n)
	     (L1 n 1)))
(define L1 (λ (n a)
	     (L2 1 n a)))
(define L2 (λ (i n a)
	     (if (<= i n)
		 (L3 i n (* a i))
		 ;;  pushVS a_times_i
		 ;;  pushVS n
		 ;;  pushVS i

		 ;; ALTERNATIVE ONE:
		 ;;  pushRS L2-ret-point
		 ;;  JUMP L3
		 ;; L2-ret-point:
		 ;;  RETURN

		 ;; ALTERNATIVE TWO:
		 ;;  JUMP L3
		 (L4 a))))
(define L3 (λ (i n a)
	     (L2 (+ i 1) n a)))
(define L4 (λ (a)
	     a))

;;; Which calls are tail calls?    (f x)   (TC f x)
;;; Which calls are non-tail-calls? (f x)   (NTC f x)

'(define fact
  (λ (n)
    (if (NTC = n 0)
	1
	(TC * n (NTC fact (NTC - n 1))))))

;;; This is a NON-TAIL-RECURSIVE definition of fact

;;; axiomatic foundation of above definition:
;;;  0! = 1
;;;  n! = n * (n-1)!         (for n>0)

;;; DEF: fx(n,x) = n! * x = n*(n-1)!*x = (n-1)! * (n*x) = fx(n-1, x*n)
;;;  n! = fx(n,1)
;;;  fx(0,x) = x
;;;  fx(n,x) = fx(n-1, n*x)

(define fact2 (λ (n) (fx n 1)))
(define fx (λ (n x) (if (= n 0) x (fx (- n 1) (* n x)))))

;; Welcome to Racket v6.9.
;; > (load "lecture-06.scm")
;; > (/ (fact1 20) (fact1 19))
;; 20
;; > (/ (fact2 20) (fact2 19))
;; 20
