(define (domain reading_plan)
	(:requirements :adl :typing)
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

	(:action assign-book
	  :parameters (?b - book ?m - month)
	  :precondition (and 
	  					(not (read ?b))
	  					(not (assigned ?b))
	  					(not (exists (?b2 - book)
	  								 (and 
	  								 	(pred ?b2 ?b)
	  								 	(or
	  								 		(not (assigned ?b2))
  								 			(exists (?m2 - month)
  								 				(and (in ?b2 ?m2) (not (before ?m2 ?m)))
  								 			)
	  								 	)
	  								 )
	  						 )
	  					)

;	  					(forall (?bant - book)
;	  						(imply (pred ?bant ?b)
;	  							(exists (?m2 - month)
;	  								(and (in ?b2 ?m2) (not (before ?m2 ?m)))
;	  							)
;	  						)
;	  					)

	  				)
	  :effect (and (in ?b ?m) (read ?b) (not (want ?b)) (assigned ?b))
	)

	(:action switch-book
	  :parameters (?b - book ?m1 ?m2 - month)
	  :precondition (and
						(in ?b ?m1)
						(not (exists (?b2 - book)
	  								 (and 
	  								 	(pred ?b2 ?b) 
  								 		(exists (?m3 - month)
  								 			(and (in ?b2 ?m3) (not (before ?m3 ?m2)))
  								 		)
	  								 )
	  						 )
	  					)
					)
	  :effect (and (not (in ?b ?m1)) (in ?b ?m2))
	)

)