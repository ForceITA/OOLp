
;;;; -*- Mode: Lisp -*-
;;;; ool.lisp

(defparameter *classes-specs* (make-hash-table))

(defun add-class-spec (name class-spec)
  (setf (gethash name *class-specs*) class-spec))

(defun get-class-spec (name)
  (gethash name *classes-specs*))


(defun process-method (method-name method-spec)
  #| TO-DO Miracle |#
  (eval (rewrite-method-code method-name method-spec)))

;;;; End of file ool.lisp