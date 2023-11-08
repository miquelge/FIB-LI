
all: sudoku antennas groups tsp

sudoku: sudoku.pl 
	swipl -quiet -O -g main --stand_alone=true -o sudoku -c sudoku.pl

antennas: antennas.pl 
	swipl -quiet -O -g main --stand_alone=true -o antennas -c antennas.pl

groups: groups.pl 
	swipl -quiet -O -g main --stand_alone=true -o groups -c groups.pl

tsp: tsp.pl 
	swipl -quiet -O -g main --stand_alone=true -o tsp -c tsp.pl	

clean:
	rm sudoku antennas groups tsp infile.cnf header model clauses
