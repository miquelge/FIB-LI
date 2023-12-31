:- use_module(library(clpfd)).

%ejemplo(_, Big, [S1...SN]): how to fit all squares of sizes S1...SN in a square of size Big?
ejemplo(0,  3,[2,1,1,1,1,1]).
ejemplo(1,  4,[2,2,2,1,1,1,1]).
ejemplo(2,  5,[3,2,2,2,1,1,1,1]).
ejemplo(3, 19,[10,9,7,6,4,4,3,3,3,3,3,2,2,2,1,1,1,1,1,1]).
ejemplo(4,112,[50,42,37,35,33,29,27,25,24,19,18,17,16,15,11,9,8,7,6,4,2]).
ejemplo(5,175,[81,64,56,55,51,43,39,38,35,33,31,30,29,20,18,16,14,9,8,5,4,3,2,1]).

main:- 
    ejemplo(3,Big,Sides),
    nl, write('Fitting all squares of size '), write(Sides), write(' into big square of size '), write(Big), nl,nl,
    length(Sides,N), 
    length(RowVars,N), % get list of N prolog vars: Row coordinates of each small square
    length(ColVars,N),
	RowVars ins 1..Big,
	ColVars ins 1..Big,
    
    insideBigSquare(Big, Sides, RowVars),
    insideBigSquare(Big, Sides, ColVars),
    nonoverlapping(Sides, RowVars, ColVars),

    append(RowVars, ColVars, L),
    labeling([ff, up, bisect], L),
    
    displaySol(N,Sides,RowVars,ColVars), halt.

insideBigSquare(Big, [S|SS], [X|XS]):-
    Big #>= S+X-1,
    insideBigSquare(Big, SS, XS).
insideBigSquare(_, [], []).

nonoverlapping([S|SS],[R|RS], [C|CS]):-
    nonoverlap(S, R, C, SS, RS, CS),
    nonoverlapping(SS, RS, CS).
nonoverlapping([], [], []).

nonoverlap(S, R, C, [S2|SS], [R2|RS], [C2|CS]):-
    C2 #=< C - S2 #\/ C2 #>= C + S
    #\/
    R2 #=< R - S2 #\/ R2 #>= R + S, 
    nonoverlap(S, R, C, SS, RS, CS).
nonoverlap(_, _, _, [], [], []).

displaySol(N,Sides,RowVars,ColVars):- 
    between(1,N,Row), nl, between(1,N,Col),
    nth1(K,Sides,S),    
    nth1(K,RowVars,RV),    RVS is RV+S-1,     between(RV,RVS,Row),
    nth1(K,ColVars,CV),    CVS is CV+S-1,     between(CV,CVS,Col),
    writeSide(S), fail.
displaySol(_,_,_,_):- nl,nl,!.

writeSide(S):- S<10, write('  '),write(S),!.
writeSide(S):-       write(' ' ),write(S),!.
