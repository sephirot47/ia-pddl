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
		(right_before ?m - month ?m2 - month)
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
	  					;(not (exists (?b2 - book)
;  							(or
;  								;Comprobamos predecesores
;  								(and 
;  								 	(pred ?b2 ?b)
;  								 	(or
;  								 		(not (assigned ?b2))
; 								 			(exists (?m2 - month)
; 								 				(and (in ?b2 ?m2) (not (before ?m2 ?m)))
; 								 			)
;  								 	)
;  								)
;  								;Comprobamos paralelos
;  								(and 
;  								 	(or (paral ?b2 ?b) (paral ?b ?b2))
;  								 	(assigned ?b2)
; 								 		(and
; 								 			(not (in ?b2 ?m))
; 								 			(exists (?m2 - month)
; 								 				(not (and (in ?b2 ?m2) (or (right_before ?m ?m2)(right_before ?m2 ?m))))
; 								 			)
; 								 		)
;	  								)
;	  							)
;	  						)
;  						)
  						(forall (?b2 - book)
							(and
  								;Comprobamos predecesores
								(imply (pred ?b2 ?b)
									(and
  								 		(assigned ?b2)
								 		(not (exists (?m2 - month)
								 			(and (in ?b2 ?m2) (not (before ?m2 ?m)))
								 		))
  								 	)
								)
								;Comprobamos paralelos
								(imply (and (or (paral ?b2 ?b) (paral ?b ?b2)) (assigned ?b2))
						 			(or
							 			(in ?b2 ?m) ;mismo mes
							 			(forall (?m2 - month)
							 				(and (in ?b2 ?m2) (or (right_before ?m ?m2)(right_before ?m2 ?m)))
							 			)
							 		)
  								)
							)
						)
;						(forall (?b2 - book)
;  							(and
;  								;Comprobamos predecesores
;  								(imply (pred ?b2 ?b)
;					 				(exists (?m2 - month)
;						 				(and (in ?b2 ?m2) (before ?m2 ?m))
;						 			)
;  								)

;  								;Comprobamos paralelos
;  								(imply (and (or (paral ?b2 ?b) (paral ?b ?b2)) (assigned ?b2))
;  									(or
;  										(in ?b2 ?m) ;mismo mes
;  										(exists (?m2 - month)
;						 					(and (in ?b2 ?m2)  (or (right_before ?m ?m2)(right_before ?m2 ?m)) )
;						 				)
;  									)
;  								)
;  							)
;  						)
	  				)
	  :effect (and (in ?b ?m) (read ?b) (not (want ?b)) (assigned ?b))
	)


	(:action switch-book
	  :parameters (?b - book ?m1 ?m2 - month)
	  :precondition (and
						(in ?b ?m1)
						(or (before ?m1 ?m2) (before ?m2 ?m1)) ;meses diferentes
						(not (exists (?b2 - book)
								(or ;si falla en alguno de los dos, lo descartamos
									;Comprobamos que la condicion de predecesores se cumpla cuando se efectue el switch 
									(or 
										;si b2 es predecesor de b y al mover b, b2 esta after o igual de b, descartamos
										(and 
		  									(pred ?b2 ?b)
											(exists (?m3 - month)
												(and (in ?b2 ?m3) (not (before ?m3 ?m2)))
											)
  										)

										;si b es predecesor de b2 y al mover b, b esta after o igual de b2, descartamos
  										(and
  											(pred ?b ?b2)
  											(exists (?m3 - month)
												(and (in ?b2 ?m3) (not (before ?m2 ?m3)))
											)
  										)
									)

  									;Comprobamos que la condicion de paralelos se cumpla cuando se efectue el switch
  									(and
	  								 	(or (paral ?b2 ?b) (paral ?b ?b2)) ;si b es paralelo a b2
  										(assigned ?b2) ;y esta asignado
  								 		(and
  								 			(not (in ?b2 ?m2)) ;en el caso en que b2 este asignado al mes al que queremos mover b, descartamos
  								 			;en el caso en que b2 este asignado a un mes que no sea consecutivo al mes al que queremos mover b, descartamos
  								 			(exists (?m3 - month) 
  								 				(not (and (in ?b2 ?m3) (or (right_before ?m2 ?m3) (right_before ?m3 ?m2))))
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
