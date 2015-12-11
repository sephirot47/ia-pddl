(define (domain reading_plan)
	(:requirements :strips :typing)
	(:types book month - object)

	(:predicates
		(pred ?b1 - book ?b2 - book) ; b1 is predecessor of b2
		(paral ?b1 - book ?b2 - book) ; b1 is parallel to b2
		(read ?b - book)
		(want ?b - book)
		(in ?b - book ?m - month) ; the book b is read in the month m
		(before ?m1 - month ?m2 - month)

	)

	(:action assign-book-to-month
	  :parameters (?b - book ?m - month)
	  :precondition (and (not (read ?b)) (want ?b))
	  :effect (and (read ?b))
	)

)