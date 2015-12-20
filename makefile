all:
	g++ --std=c++11 pddlGen.cpp -o pddlGen

clean:
	rm -f tmp*
	rm -f error.log
	clear
