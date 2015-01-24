;;;; Sas Cezar Angelo 781563
;;;; Salvagnin Andrea 761857
;;;; Marana Nicolo 786180


Nel seguente documento verranno brevemente descritte tutte le funzioni che non sono state esplicitamente richieste nella traccia del
progetto. In ogni caso le funzioni nel codice sono commentate.

create-a-list:	Data una lista costruisce una associative-list, la funzione richiama
		la funzione che costruisce i metodi.

check-slot:	Data una classe e una list di slot-value verifica che ogni slot esiste
		nella classe e nei parent, utilizza get-slot-class.

get-slot-class:	Data una classe e il nome di uno slot ricerca lo slot nella classe, se
		non esiste nella classe cerca nel parent della classe, finche non trova
		lo slot o il parent è nil.
