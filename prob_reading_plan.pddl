
(define (problem problem01)
  (:domain reading_plan)
  (:objects b0 b1 b2 b3 b4 b5 b6 b7 b8 b9 b10 b11 b12 b13 b14 b15 b16 - book
  			    jan feb mar apr may jun jul aug sep oct nov dec - month
  )
  
  (:init
  	(before jan feb)
  	(before jan mar)
  	(before jan apr)
  	(before jan may)
  	(before jan jun)
  	(before jan jul)
  	(before jan aug)
  	(before jan sep)
  	(before jan oct)
  	(before jan nov)
  	(before jan dec)

  	(before feb mar)
  	(before feb apr)
  	(before feb may)
  	(before feb jun)
  	(before feb jul)
  	(before feb aug)
  	(before feb sep)
  	(before feb oct)
  	(before feb nov)
  	(before feb dec)

  	(before mar apr)
  	(before mar may)
  	(before mar jun)
  	(before mar jul)
  	(before mar aug)
  	(before mar sep)
  	(before mar oct)
  	(before mar nov)
  	(before mar dec)

  	(before apr may)
  	(before apr jun)
  	(before apr jul)
  	(before apr aug)
  	(before apr sep)
  	(before apr oct)
  	(before apr nov)
  	(before apr dec)

  	(before may jun)
  	(before may jul)
  	(before may aug)
  	(before may sep)
  	(before may oct)
  	(before may nov)
  	(before may dec)

  	(before jun jul)
  	(before jun aug)
  	(before jun sep)
  	(before jun oct)
  	(before jun nov)
  	(before jun dec)

  	(before jul aug)
  	(before jul sep)
  	(before jul oct)
  	(before jul nov)
  	(before jul dec)

  	(before aug sep)
  	(before aug oct)
  	(before aug nov)
  	(before aug dec)

  	(before sep oct)
  	(before sep nov)
  	(before sep dec)

  	(before oct nov)
  	(before oct dec)
  	
  	(before nov dec)


  	(pred b0 b1)
    (pred b0 b2)
    (pred b0 b3)
    (pred b0 b4)
    (pred b1 b2)
    (pred b1 b3)
    (pred b1 b4)
    (pred b2 b3)
    (pred b2 b4)
    (pred b3 b4)

    (want b0)
    (want b1)
  )
  
  (:goal
    (and
    	(forall (?b - book)
        	 (and (not (want ?b)) (assigned ?b))
    	)
	  )
  )
)

