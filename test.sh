#!/bin/bash


# ./pddlGen numLlibres numPreds numParals numWants

MAXNBOOKS=$1


for (( nBooks = 1; nBooks <= MAXNBOOKS; nBooks++ ))
do
	echo == $nBooks 
	./pddlGen $nBooks 5 4 $nBooks > tmp
        ./ff -o reading_plan.pddl -f tmp | tail -2 | head -1	
done
