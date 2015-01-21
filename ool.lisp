;;;; -*- Mode: Lisp -*-
;;;; ool.lisp

;; Creo una hash-table
(defparameter *classes-specs* (make-hash-table))

#| definizione di una classe|#

;; GET-CLASS-SPEC data una chiave e una hash-table
;; restituisce il valore
(defun get-class-spec (name)
  (gethash name *classes-specs*))

;; ADD-CLASS-SPEC aggiunge un elemento alla
;; hash-table
(defun add-class-spec (name class-spec)
  (setf (gethash name *classes-specs*) class-spec))

;;crea una lista di coppie di valori
(defun create-a-list (n-list)
  (cond ((null n-list) '())
        ((oddp (length n-list)) (error "Slot-Vaules not balanced."))
        ((not (symbolp (first n-list))) (error "Value not a symbol")) 
        #|Fine controlli|#
        (t (append (list (cons
                          (first n-list)
                          (list (second n-list)))) 
                   (create-a-list (cddr n-list))))))

;; DEFINE-CLASS costruisce una classe, associa al nome 
;; della classe una "a-list" siffatta 
;; ((*PARENT* PARENT) (SLOT-NAME VALUE)*)
(defun define-class (class-name parent &rest slot-value)
  (cond ((null (symbolp class-name))
         (error "Class name is not a Symbol"))
        ((not (symbolp parent))
         (error "parent is not a Symbol"))
        ((not (or
               (null parent)
               (not (null (get-class-spec parent)))))
         (error "Could't find parent"))
        (t (add-class-spec class-name 
                           (list (cons 'PARENT  
                                       parent) 
                                 (create-a-list 
                                  slot-value)))))
  class-name)


#|Instanza di una classe|#


(defun new (class-name &rest slot-value)
  (cond ((null (get-class-spec class-name)) 
         (error "Class don't exist"))
        ((oddp (length slot-value));restituisce true se la lista ha un numero di elementi dispari
         (error "Slot-Values not balanced"))
        (t (check-slot class-name slot-value) 
           (append (list 'ool-instance class-name) (create-a-list slot-value)))))


;; GET-SLOT estrae il valore di un campo da un istanza
(defun get-slot (instance slot-name)
  (second (get-slot-class (append (list (cons 'PARENT 
                                             (second instance))) 
                                 (list (rest (rest instance))))
                         slot-name)))

(defun check-slot (class slot-value) 
  (cond ((null slot-value) t)
        ((and (= 2 (length slot-value))
              (let ((key-value (get-slot-class 
                                (list (cons 'PARENT class)) 
                                (first slot-value))))
                (if (and (listp (second key-value)) 
                         (eql (first (second key-value)) 
                              'METHOD))
                    (error "Unable to override a method"))))
         t)
        (t (check-slot class (cddr slot-value))))) 

;; GET-slot estrae il valore di un campo da un classe
(defun get-slot-class (class-list slot-name) 
  (let ((key-value (assoc slot-name (cadr class-list))) ;assegna a key-value la coppia chiave valore se esiste
        (parent (cdr (first class-list))));assegna a class il parent della classe
    (cond ((and (null key-value)
                (null parent))
           (error "Unable to find slot")); La chiave non esiste e non ha parent
          ((and (null key-value) parent)
           (get-slot-class (get-class-spec parent) 
                           slot-name));se non esiste la coppia chiave e valore e la classe e' diversa da nil chiama get slot class, passando class, e slot-name senza specificare print method
          (key-value key-value))))


(defun rewrite-method (method-spec)
  (list 'lambda (append (list 'this)  
                        (second method-spec))
        (cons 'progn (rest (rest method-spec)))))

(defun method-process (method-name method-spec)
  (setf (fdefinition method-name) 
        (lambda (this &rest args)
          (apply (get-slot this method-name)
                 (append (list this)
                         args))))
  (eval (rewrite-method method-spec)))

;;;; End of file ool.lisp
