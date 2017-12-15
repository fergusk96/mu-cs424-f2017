;;; Duck types for object system in Scheme
;;; with
;;;   - separation of concerns: dispatch vs method code
;;;   - API for objects & methods

;;; API for objects
;;;  - get alist selector->method
;;;  - API for method: call w/ selector, obj, args...

(define send-object
  (λ (obj s . args)
    (cond ((assoc s (get-method-alist obj))
	   => (λ (s-and-method)
		(apply (cadr s-and-method) (cons s (cons obj args)))))
	  (else (error "unknown selector" s "send to" obj "with args" args)))))

(define get-method-alist (λ (obj) (obj)))

(define make-rect
  (λ (re im)
    (λ ()
      (list (list 'add
		  (λ (s z1 z2)
		    (make-rect (+ (send-object z1 'real-part)
				  (send-object z2 'real-part))
			       (+ (send-object z1 'imag-part)
				  (send-object z2 'imag-part)))))
	    (list 'mul
		  (λ (s z1 z2)
		    (let ((x1 (send-object z1 'real-part))
			  (y1 (send-object z1 'imag-part))
			  (x2 (send-object z2 'real-part))
			  (y2 (send-object z2 'imag-part)))
		      (make-rect (- (* x1 x2) (* y1 y2))
				 (+ (* x1 y2) (* y1 x2))))))
	    (list 'real-part (λ (s x) re))
	    (list 'imag-part (λ (s x) im))))))

(define rect-list
  (λ (r)
    (list 'rect
	  (send-object r 'real-part)
	  (send-object r 'imag-part))))

;;; Sample:

;; > (define ii (make-rect 0 1))
;; > (send-object ii 'mul ii)
;; #<procedure:...eme-object-2.scm:21:4>
;; > (rect-list (send-object ii 'mul ii))
;; (rect -1 0)
