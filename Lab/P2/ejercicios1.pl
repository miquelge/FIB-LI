%suma_elements_llista
suma([], 0).
suma([X|L], Sum):- suma(L, S), Sum is X+S.

%producte_elements_llista
prod([], 1).
prod([X|L], P):- prod(L, R), P is X*R.

%producte_escalar
pescalar([], [], 0).
pescalar([X|L1],[Y|L2],P):- pescalar(L1, L2, R), P is (X*Y)+R.

%concatenacio_llistes
concat([], L, L).
concat([X|L1], L2, [X|L]):- concat(L1, L2, L).

%ultim_llista
ultimo(L, R):- concat(_,[R],L).

%llista_inversa
inverso([], []).
inverso([X|L1], L2):- inverso(L1, L3), concat(L3, [X], L2).

%fibonacci
fib(1, 1).
fib(2, 1).
fib(N, R):- N>2, N1 is N-1, N2 is N-2,
			fib(N1, R1), fib(N2, R2), R is R1+R2.

%pertany_a_llista
pert(X, [X|_]).
pert(X, [_|L]):- pert(X, L).

%unio_dos_conjunts
union([], L, L).
union([X|L1], L2, U):- pert(X, L2), !, union(L1, L2, U).
union([X|L1], L2, [X|U]):- union(L1, L2, U).

%interseccio_dos_conjunts
interseccion([], _, []).
interseccion([X|L1], L2, [X|I]):- pert(X, L2), !, interseccion(L1, L2, I).
interseccion([_|L1], L2, I):- interseccion(L1, L2, I).

%factorial
%per evitar errors usem N>0 o el tall (!)
fact(0,1):- !.
fact(N, F):- N>0, N1 is N-1, fact(N1, F1), F is N*F1.

%pertenece con resto , per cada element a de L, ens dona X = a i 
%R es la llista original menys lelementa
pert_con_resto(X, L, R):- concat(L1, [X|L2], L), concat(L1, L2, R).

%suma_demas
suma_demas(L):- pert_con_resto(X,L,_), suma(L, Sum), Sum is X+X, !.

%separacio_llista
separacio(X, L, S):- concat(L1, [X|_], L), suma(L1, S).

%suma_ants
suma_ants(L):- separacio(X, L, S), S is X, !.

%permutacion
permutacion([],[]).
permutacion(L,[X|P]):- pert_con_resto(X,L,R), permutacion(R,P).

%aparicions_de_cada_element_cardinal
card(L):- card_2(L,Llista), write(Llista).
card_2([], []):- !.
card_2([X|L], Llista):- aparicions(X, [X|L], Resta, A), concat([[X, A]], L1, Llista), card_2(Resta, L1).

aparicions(_, [], [], 0):- !.
aparicions(X, [X|L], L1, A):- !, aparicions(X, L, L1, A1), A is 1+A1.
aparicions(X, [Y|L], L1, A):- aparicions(X, L, L2, A), concat([Y], L2, L1).

%llista_ordenada
esta_ordenada([]).
esta_ordenada([X, Y|L]):- X =< Y, esta_ordenada([Y|L]).

%ordenacio_forca_bruta
ordenacion(L1,L2) :- permutacion(L1,L2), esta_ordenada(L2).

%dados
dados(0,0,[]).
dados(P,N,[X|L]) :-
	N>0,
	pert(X,[1,2,3,4,5,6]),
	Q is P-X,
	M is N-1, dados(Q,M,L).

%ordenacio_per_insercio
ord_insercio([], []).
ord_insercio([X|L], L1):- ord_insercio(L, L2), insercion(X, L2, L1).
insercion(X, [], [X]).
insercion(X, [Y|L], [X,Y|L]):- X=<Y.
insercion(X, [Y|L], [Y|N]):- X>Y, insercion(X, L, N).

%merge_sort
merge_sort([], []):- !.
merge_sort([X], [X]):- !.
merge_sort([X,Y|L], Llista):- divide([X,Y|L], Part1, Part2),
	merge_sort(Part1, L1), merge_sort(Part2, L2),
	merge(L1, L2, Llista).
merge([], L, L).
merge(L, [], L).
merge([X|L1], [Y|L2], [X|Llista]):- X=<Y, merge(L1, [Y|L2], Llista).
merge([X|L1], [Y|L2], [Y|Llista]):- X>Y, merge([X|L1], L2, Llista).

divide(L, L1, L2) :- length(L, N), Half is N // 2,
	length(L1, Half), concat(L1, L2, L).

%diccionari
diccionario(A,N):- nmembers(A,N,L), escriure(L).
nmembers(_,0,[]):- !.
nmembers(A,N,[X|L]):- pert(X, A), N1 is N-1, nmembers(A, N1, L).
escriure([]):- !, write(' '), nl.
escriure([X|L]):- write(X), escriure(L).

%palindroms
palindromos(L):- setof(P,(permutation(L,P), es_palindrom(P)),S),
	write(S), nl.
es_palindrom(L):- inverso(L, L).

%SEND_MORE_MONEY
suma_money([X1, X2, X3, X4], [Y1, Y2, Y3, Y4], [Z1, Z2, Z3, Z4, Z5]):-
	S1 is (X1*10^3 + X2*10^2 + X3*10 + X4),
	S2 is (Y1*10^3 + Y2*10^2 + Y3*10 + Y4),
	S3 is (Z1*10^4 + Z2*10^3 + Z3*10^2 + Z4*10 + Z5),
	S12 is (S2 + S1),
	S12 =:= S3.
send_more_money:-
	L = [S, E, N, D, M, O, R, Y, _, _],
	permutacion(L, [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]),
	suma_money([S, E, N, D], [M, O, R, E], [M, O, N, E, Y]),
	write('S = '), write(S), nl,
	write('E = '), write(E), nl,
	write('N = '), write(N), nl,
	write('D = '), write(D), nl,
	write('M = '), write(M), nl,
	write('O = '), write(O), nl,
	write('R = '), write(R), nl,
	write('Y = '), write(Y), nl,
	write('  '), write([S,E,N,D]), nl,
	write('  '), write([M,O,R,E]), nl,
	write('-------------------'), nl,
	write([M,O,N,E,Y]), nl.















