;;; Duck types for object system in Scheme

(define make-rect
  (λ (re im)
    (λ (s . args)				; selector s, arg y
      (cond ((equal? s 'add)
	     (let ((y (car args)))
	       (make-rect (+ re (send-object y 'real-part))
			  (+ im (send-object y 'imag-part)))))
	    ((equal? s 'mul)
	     (let* ((y (car args))
		    (y-re (send-object y 'real-part))
		    (y-im (send-object y 'imag-part)))
	       (make-rect (- (* re y-re) (* im y-im))
			  (+ (* re y-im) (* im y-re)))))
	    ((equal? s 'real-part) re)
	    ((equal? s 'imag-part) im)
	    (else (error "unknown selector" s))))))

(define rect-list (λ (r)
		    (list 'rect
			  (send-object r 'real-part)
			  (send-object r 'imag-part))))

(define send-object (λ (obj s . args) (apply obj (cons s args))))
