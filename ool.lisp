;;;; -*- Mode: Lisp -*-
;;;; ool.lisp


;; Creo una hash-table
(defparameter *classes-specs* (make-hash-table))


;; ADD-CLASS-SPEC aggiunge un elemento alla
;; hash-table
(defun add-class-spec (name class-spec)
  (setf (gethash name *class-specs*) class-spec))

;; GET-CLASS-SPEC data una chiave è una hash-table
;; restituisce il valore
(defun get-class-spec (name)
  (gethash name *classes-specs*))

(defun process-method (method-name method-spec)
  #| TO-DO Miracle |#
  (eval (rewrite-method-code method-name method-spec)))

;;;; End of file ool.lisp