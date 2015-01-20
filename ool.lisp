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

;;input:
;;class-name: nome della classe definita
;;slot value: value passate in ingresso
(defun new (class-name &rest slot-value)
  (cond ((null (get-class-spec class-name)) 
         (error "Class don't exist"))
        ((oddp (length slot-value));restituisce true se la lista ha un numero di elementi dispari
         (error "Slot-Values not balanced"))
        (t #|(check-slot class-name slot-value)|# 
         (append (list 'ool-instance class-name) (create-a-list slot-value))
         #|(error "Slot don't exist in the class")|#)))


#| estrazione valore da hash-table|#

#| instance = (ool-instance <class> (list <k v>*)) |#
#| ((PARENT <class>) (list <k v>*)) |#
;;estrae il valore di un campo da una classe
(defun get-slot (instance slot-name)
  (get-slot-class (append (list (cons 'PARENT 
                                      (second instance))) 
                          (list (rest (rest instance))))
                  slot-name
                  t))

(defun get-slot-class (class-list slot-name &optional (print-methodp nil))
  (let ((key-value (assoc slot-name (cadr class-list)));assegna a key-value la coppia chiave valore se esiste
        (class (cdr (first class-list))));assegna a class il parent della classe
    (print class-list)
    (print key-value)
    (print class)
    (cond ((and (null key-value)
                (null class))
           (error "Unable to find slot"))
          ((and (null key-value) class)
           (get-slot-class (get-class-spec class) slot-name))
          ((and key-value print-methodp) key-value)
          ((and key-value 
                print-methodp
                (listp (second key-value))
                (eql (first (second key-value)) 'METHOD))
           key-value))))


;;disordine/spazzatura

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

#| (defun process-method (method-name method-spec)
     #| TO-DO Miracle |#
     (eval (rewrite-method-code method-name method-spec)))|#

#| STUB FUNCTION - USE TOP |#
;(defun process-method (method-name method-spec)  (print method-spec))

;(defun check-slot (class-name slot-value)  )



;;class-list lista contenente il secondo valore della cons instance 
;;slot-name quote contenente la spec da richiamare


#|NON FUNZIONA 
(defun get-slot-class (class slot-name &optional (print-method nil))
  (let ((key-value (assoc slot-name (cdr class))))
    (cond ((and key-value print-method) key-value)
          ((and key-value (eql (cdar key-value) 'METHOD)) (error "Cannot override a method in an instance"))  
          ((null (cdr class))
           (error "Could not find slot"))
          (t (get-slot-class (get-class-spec (cdar class)) slot-name)))))
|#
;;;; End of file ool.lisp
