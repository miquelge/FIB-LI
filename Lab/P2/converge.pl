converge(X):- inConverge(X, []).
	
inConverge(1, _):- !, write(1), write(' ').
inConverge(X, L):- member(X, L), !, write(X), write(' '), false.
inConverge(X, L):- write(X), write(' '), transformation(X, R),
	inConverge(R, [X|L]).

transformation(0, 0):- !.
transformation(X, R):-
	M is mod(X, 10),
	X1 is div(X, 10),
	transformation(X1, R1),
	R is R1 + M*M.
