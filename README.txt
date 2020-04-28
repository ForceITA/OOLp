# OOLp

A object oriented language written in LISP

## Documentation
The main functions are:

create-a-list:	Creates an associative-list. The function calls another one to build the methods.

check-slot:	Given a class object, and a list of slot-value elements, check that all the slots exists in the class. It uses get-slot-class.

get-slot-class:	Given the name of a class, and the name of the slot it checks that the slot exists in the class. If the slot dosn't exists, the function recursively check the parent, until it finds it or the parent is nil

Check the code for all the functions and their documentation.

## Contributors

Work done with:
* Sas Cezar Angelo - UniMiB ID 781563
* Salvagnin Andrea - UniMiB ID 761857
* Marana Nicolo -UniMiB ID 786180
