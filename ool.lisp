;;;; -*- Mode: Lisp -*-
;;;; ool.lisp

;; Creo una hash-table
(defparameter *classes-specs* (make-hash-table))

;; ADD-CLASS-SPEC aggiunge un elemento alla
;; hash-table
(defun add-class-spec (name class-spec)
  (setf (gethash name *classes-specs*) class-spec))

;; GET-CLASS-SPEC data una chiave e una hash-table
;; restituisce il valore
(defun get-class-spec (name)
  (gethash name *classes-specs*))

;; PROCESS-SLOT-VALUE data una lista, costruisce una 
;; "a-list" e in caso di metodi chiama la costruzione
;; del metodo
#|
 (defun process-slot-value (list)
   (if (oddp (length list)) (error "Slot-Values not balanced, expected even found odd"))
   (cond ((null list) ()) 
        (t (if (and (listp (second list)) 
                    (eql (first (second list)) 'METHOD)) 
               (process-method (first list) (second list)))
           (append (list (cons (first list) (list(second list)))) 
                   (process-slot-value (rest (rest list))))))) 
|#

(defun create-a-list (n-list)
  (cond ((null n-list) '())
        ((oddp (length n-list)) (error "Slot-Vaules not balanced."))
        ((not (symbolp (first n-list))) (error "Value not a symbol")) 
        (t (append (list (cons 
                          (first n-list) 
                          (list (second n-list)))) 
                   (create-a-list (cddr n-list))))))

#| (defun process-method (method-name method-spec)
     #| TO-DO Miracle |#
     (eval (rewrite-method-code method-name method-spec)))|#

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
              (add-class-spec class-name (list (cons "PARENT"  parent) (create-a-list slot-value)))
            (error "Could't find parent"))
        (error "Parent is not a Symbol"))
    (error "Class name is not a Symbol"))
  class-name)

(defun new (class-name &rest slot-value)
  (cond ((null (get-class-spec class-name)) (error "Class don't exist"))
        ((oddp (length slot-value)) (error "Slot-Values not balanced"))
        ((check-slots-p slot-value) 
         (append (list 'ool-instance class-name) (create-a-list slot-value))
         (error "Slot don't exist in the class"))))

#| TO-DO |#
(defun get-slot (instance slot-name))
;;;; End of file ool.lisp