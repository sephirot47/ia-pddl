(define (domain reading_plan)
	(:requirements :strips :adl :typing)
	(:types book - object
			month - object
	)

	(:predicates
		(pred ?b1 - book ?b2 - book) ; b1 is predecessor of b2
		(paral ?b1 - book ?b2 - book) ; b1 is parallel to b2
		(read ?b - book)
		(want ?b - book)
		(in ?b - book ?m - month) ; the book b is read in the month m
		(before ?m1 - month ?m2 - month)
		(hasbook ?m - month)
		(assigned ?b - book)
	)

	(:action assign-book-to-month
	  :parameters (?b - book ?m - month)
	  :precondition (and 
	  					(not (read ?b))
	  					(not (exists (?b2 - book)
	  								 (and 
	  								 	(pred ?b2 ?b) 
	  								    (assigned ?b2)
	  								 	(in ?b2 ?m)
	  								 )
	  						 )
	  					)
	  					(not (exists (?m2 - month)
	  							(and
	  								(before ?m2 ?m)
	  								(not (hasbook ?m))
	  							)
	  						 )
	  					)
	  				)

	  :effect (and (in ?b ?m) (read ?b) (not (want ?b)) (hasbook ?m) ( assigned ?b))
	)

)