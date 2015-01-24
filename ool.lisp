;;;; -*- Mode: Lisp -*-
;;;; ool.lisp

;;;; Sas Cezar Angelo 781563
;;;; Salvagnin Andrea 761857
;;;; Marana Nicolo 786180


;; Creo una hash-table
(defparameter *classes-specs* (make-hash-table))

;; GET-CLASS-SPEC data una chiave e una hash-table
;; restituisce il valore
(defun get-class-spec (name)
  (gethash name *classes-specs*))

;; ADD-CLASS-SPEC aggiunge un elemento alla
;; hash-table
(defun add-class-spec (name class-spec)
  (setf (gethash name *classes-specs*) class-spec))

;; CREATE-A-LIST crea una lista di coppie di valori
(defun create-a-list (n-list)
  (cond ((null n-list) '())
        ((oddp (length n-list)) (error "Slot-Vaules not balanced."))
        ((not (symbolp (first n-list))) (error "Value not a symbol")) 
        ;; Fine controlli
        ;; Costruzione metodo, quando trovi un metodo
        ;; riscrivilo sotto forma di "funzione" Lisp.
        ;; Se invece e' una lista normale,
        ;; procedi normalmente.
        ((and (listp (second n-list)) (eql (first (second n-list)) 'METHOD))
         (append (list (cons (first n-list) 
                             (list (process-method (first n-list) (second n-list)))))
                 (create-a-list (cddr n-list))))
        (t (append (list (cons (first n-list)
                               (list (second n-list)))) 
                   (create-a-list (cddr n-list))))))

;; DEFINE-CLASS costruisce una classe, associa al nome 
;; della classe una "a-list" siffatta 
;; ((*PARENT* PARENT) (SLOT-NAME VALUE)*)
(defun define-class (class-name parent &rest slot-value)
  (cond ((not (symbolp class-name))
         (error "Class name is not a Symbol"))
        ((not (symbolp parent))
         (error "parent is not a Symbol"))
        ((not (or (null parent)
                  (not (null (get-class-spec parent)))))
         (error "Could't find parent"))
        ;; Fine Controlli
        ;; Aggiungo la classe alla hash-table
        (t (add-class-spec class-name 
                           (list (cons 'PARENT parent) 
                                 (create-a-list slot-value)))))
  class-name)

;; NEW Instanza una classe
(defun new (class-name &rest slot-value)
  (cond ((null (get-class-spec class-name)) 
         (error "Class don't exist"))
        ;; Costruisco l'istanza
        (t (check-slot class-name slot-value) 
           (append (list 'ool-instance class-name) (create-a-list slot-value)))))

;; GET-SLOT estrae il valore di un campo da un istanza
(defun get-slot (instance slot-name)
  ;; Converto l'istanza in una classe  e faccio la ricerca il get-slot-class
  (second (get-slot-class (append (list (cons 'PARENT
                                              (second instance))) 
                                  (list (rest (rest instance))))
                          slot-name)))

;; CHECK-SLOT verifica che gli slot definiti nell'istanza
;; esistano della classe o nei parent della classe
(defun check-slot (class slot-value) 
  (cond ((null slot-value) t)
        (t (get-slot-class (list (cons 'PARENT class))
                           (first slot-value))
           (check-slot class (cddr slot-value))))) 

;; GET-SLOT-CLASS estrae il valore di un campo da un classe
(defun get-slot-class (class-list slot-name)
  ;; Assegna a key-value la coppia chiave valore se esiste
  ;; Assegna a parent il parent della classe
  (let ((key-value (assoc slot-name (cadr class-list)))
        (parent (cdr (first class-list))))
    (cond ((and (null key-value)
                (null parent))
           (error "Unable to find slot"));; La chiave non esiste
          ((and (null key-value) parent)
           (get-slot-class (get-class-spec parent) 
                           slot-name))
          ;; Se non esiste la coppia chiave e valore e la classe
          ;; e' diversa da nil chiama get slot class, passando class, 
          ;; e slot-name senza specificare print method
          (key-value key-value))))

;; REWRITE-METHOD-CODE riscrive il metodo aggiungendo il
;; parametro per il this
(defun rewrite-method-code (method-name method-spec)
  (list 'lambda (append (list 'this)  
                        (second method-spec))
        (cons 'progn (rest (rest method-spec)))))

;; PROCESS-METHOD costruisce una funzione che esegue
;; il metodo
(defun process-method (method-name method-spec)
  (setf (fdefinition method-name) 
        (lambda (this &rest args)
          (apply (get-slot this method-name)
                 (append (list this) args))))
  (eval (rewrite-method-code method-name method-spec)))

;;;; End of file ool.lisp