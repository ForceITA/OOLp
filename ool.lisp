;;;; -*- Mode: Lisp -*-
;;;; ool.lisp

;; Creo una hash-table
(defparameter *classes-specs* (make-hash-table))

;; ADD-CLASS-SPEC aggiunge un elemento alla
;; hash-table
(defun add-class-spec (name class-spec)
  (setf (gethash name *classes-specs*) class-spec))

;; GET-CLASS-SPEC data una chiave è una hash-table
;; restituisce il valore
(defun get-class-spec (name)
  (gethash name *classes-specs*))

;; PROCESS-SLOT-VALUE data una lista, costruisce una 
;; "a-list" e in caso di metodi chiama la costruzione
;; del metodo
(defun process-slot-value (list)
  (if (oddp (length list)) (error "Slot-Values not balanced, expected even found odd"))
  (cond ((null list) ()) 
        (t (if (and (listp (second list)) 
                    (eql (first (second list)) 'METHOD)) 
               (process-method (first list) (second list)))
           (append (list (cons (first list) (list(second list)))) 
                   (process-slot-value (rest (rest list)))))))

#|
 (defun process-method (method-name method-spec)
   #| TO-DO Miracle |#
   (eval (rewrite-method-code method-name method-spec)))
 |#

#| STUB FUNCTION - USE TOP |#
(defun process-method (method-name method-spec)
  (print method-spec)) 

;; DEFINE-CLASS costruisce una classe, associa al nome 
;; della classe una "a-list" siffatta 
;; ((*PARENT* PARENT) (SLOT-NAME VALUE)*)
(defun define-class (class-name parent &rest slot-value)
  (if (symbolp class-name)
      (if (symbolp parent)
          (if (or
               (null parent)
               (not (null (get-class-spec parent))))
              (add-class-spec class-name (list (cons "PARENT"  parent) (process-slot-value slot-value)))
            (error "Could't find parent"))
        (error "Parent is not a Symbol"))
    (error "Class name is not a Symbol"))
  class-name)

#| TO-DO Andrea |#
(defun get-slot (instance slot-name)) 
  

;;;; End of file ool.lisp
