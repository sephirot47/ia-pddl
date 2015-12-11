(define (problem prblm)
  (:domain reading_plan)
  (:objects HarryPotter1 HarryPotter2 HarryPotter3  Crepusculo1 Crepusculo2 Crepusculo3 Crepusculo4 - book
	    january february march april may june july august september october november december - month
  )
  
  (:init
    (before january february)
    
    (want HarryPotter1)
    (want HarryPotter2)
  )
  
  (:goal 
    (forall (?b - book)
      (when (want ?b))
	(read ?b)
    )
  )
)
