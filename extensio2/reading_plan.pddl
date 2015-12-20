(define (domain reading_plan)
	(:requirements :adl :typing)
	(:types book - object
			month - object
	)

	(:predicates
		(pred ?b1 - book ?b2 - book) ; b1 is predecessor of b2
		(paral ?b1 - book ?b2 - book) ; b1 is parallel to b2
		(want ?b - book)
		(right_before ?m - month ?m2 - month)
		(in ?b - book ?m - month) ; the book b is read in the month m
		(before ?m1 - month ?m2 - month)
		(hasbook ?m - month)
		(assigned ?b - book)
	)

	(:action assign-book
	  :parameters (?b - book ?m - month)
	  :precondition (and 
	  					(not (assigned ?b))
  						(forall (?b2 - book)
							(and
  								;Comprobamos predecesores
								(imply (pred ?b2 ?b)
									(and
  								 		(assigned ?b2) ;sus predecesores ya estan asignados
								 		(forall (?m2 - month)
								 			(imply (in ?b2 ?m2)
								 				(before ?m2 ?m)
								 			)
								 		)
  								 	)
								)
								;Comprobamos paralelos
								(imply (and (or (paral ?b2 ?b) (paral ?b ?b2)) (assigned ?b2))
						 			(or
							 			(in ?b2 ?m) ;mismo mes
							 			(forall (?m2 - month)
							 				(imply (in ?b2 ?m2)
							 					(or (right_before ?m ?m2)(right_before ?m2 ?m))
							 				)
							 			)
							 		)
  								)
							)
						)
	  				)
	  :effect (and (in ?b ?m) (not (want ?b)) (assigned ?b))
	)


	(:action switch-book
	  :parameters (?b - book ?m1 ?m2 - month)
	  :precondition (and
						(in ?b ?m1)
						(or (before ?m1 ?m2) (before ?m2 ?m1)) ;meses diferentes
						(forall (?b2 - book)
							(and
								;Comprobamos predecesores 
								(and 
									;si b2 es predecesor de b, b2 debe estar asignado a un mes anterior
									(imply (pred ?b2 ?b)
										(forall (?m3 - month)
											(imply (in ?b2 ?m3)
												(before ?m3 ?m2)
											)
										)
									)

									;si b es predecesor de b2, b debe estar asignado a un mes anterior
									(imply (pred ?b ?b2)
										(forall (?m3 - month)
											(imply (in ?b2 ?m3) 
												(before ?m2 ?m3)
											)
										)
									)
								)

								;Comprobamos paralelos
								(imply (and (or (paral ?b2 ?b) (paral ?b ?b2)) (assigned ?b2))
									(or
							 			(in ?b2 ?m2) ;mismo mes
							 			(forall (?m3 - month)
							 				(imply (in ?b2 ?m3)
							 					(or (right_before ?m2 ?m3) (right_before ?m3 ?m2))
							 				)
							 			)
						 			)
								)
							)
	  					)
					)
	  :effect (and (not (in ?b ?m1)) (in ?b ?m2))
	)
)
