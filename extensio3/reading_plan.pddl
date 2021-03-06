(define (domain reading_plan)
	(:requirements :adl :typing :fluents)
	(:types book - object
		month - object
	)

	(:predicates
		(pred ?b1 ?b2 - book) ; b1 is predecessor of b2
		(paral ?b1 ?b2 - book) ; b1 is parallel to b2
		(want ?b - book)
		(read ?b - book)
		(assigned ?b - book)
		(in ?b - book ?m - month) ; the book b is read in the month m
		(right_before ?m1 ?m2 - month)
		(current ?m - month)
	)
	
	(:functions 
		(pgb ?b - book)
		(pgm ?m - month)
	)

	(:action assign-book
	  :parameters (?b - book ?m - month)
	  :precondition (and 
	  					(current ?m)
	  					(<= (+ (pgm ?m) (pgb ?b)) 800)
	  					(not (assigned ?b))
	  					(not (read ?b))
	  					(forall (?b2 - book)
	  						(and 
	  							; Predecesores
	  							(imply (pred ?b2 ?b)
	  								(or 
										(read ?b2)
		  								(and
		  									(not (in ?b2 ?m))
		  									(assigned ?b2)
		  								)
		  							)
	  							)
	  							; Paralelos
	  							(imply (and (or (paral ?b2 ?b) (paral ?b ?b2)) (assigned ?b2))
						 			(or
							 			(in ?b2 ?m) ;mismo mes
							 			(exists (?m2 - month)
							 				(and
							 					(or (right_before ?m ?m2)(right_before ?m2 ?m))
							 					(in ?b2 ?m2)
							 				)
							 			)
							 		)
  								)
	  						)
	  					)
	  				)
	  :effect (and (in ?b ?m) (not (want ?b)) (assigned ?b) (increase (pgm ?m) (pgb ?b)))
	)

	(:action next-month
	  :parameters (?prevm ?nextm - month)
	  :precondition (and 
	  					(current ?prevm)
	  					(right_before ?prevm ?nextm)
	  				)
	  :effect (and (not (current ?prevm)) (current ?nextm))
	)
)
