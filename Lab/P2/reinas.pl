reinas():- permutacion([1, 2, 3, 4, 5, 6, 7, 8], L),
		safe(L), 
		write(L), nl,
		escriure(L).

safe([X|L]):- diagonal_1(X+1, L),
			diagonal_2(X-1, L),
			safe(L).
safe([]):- !.

diagonal_1(X, [Y|L]):- 1=<X, X=<8, X =\= Y,
			X1 is X+1, diagonal_1(X1, L).
diagonal_1(X, _):- X>8, !.
diagonal_1(X, _):- X<1, !.
diagonal_1(_, []):- !.

diagonal_2(X, [Y|L]):- 1=<X, X=<8, X =\= Y,
			X1 is X-1, diagonal_2(X1, L).
diagonal_2(X, _):- X>8, !.
diagonal_2(X, _):- X<1, !.
diagonal_2(_, []):- !.

escriure([X|L]):- X1 is X-1, escriure_n(X1),
			write('x '),
			X2 is 8-X, escriure_n(X2), nl,
			escriure(L).
escriure([]).
escriure_n(N):- N>0, write('. '), N1 is N-1, escriure_n(N1).
escriure_n(0).

%_____________________________________________________________________
pert_con_resto(X, L, R):- append(L1, [X|L2], L), append(L1, L2, R).
permutacion([],[]).
permutacion(L,[X|P]):- pert_con_resto(X,L,R), permutacion(R,P).
%_____________________________________________________________________
