flatten([], []):- !.
flatten([L1|L2], Llista) :- !,
	flatten(L1, L1_nova),
	flatten(L2, L2_nova),
	append(L1_nova, L2_nova, Llista).
flatten(L, [L]).


flattenNoRepetitions([], []):- !.
flattenNoRepetitions([L1|L2], Llista) :- !,
	flattenNoRepetitions(L1, L1_nova),
	flattenNoRepetitions(L2, L2_nova),
	append(L1_nova, L2_nova, L_aux),
	comprimir(L_aux, Llista).
flattenNoRepetitions(L, [L]).

comprimir([], []):- !.
comprimir([X|L], L1):- member(X, L), !, 
	comprimir(L, L1).
comprimir([X|L], [X|L1]):- 
	comprimir(L, L1).




%_____________________________________________________________________

casas:-	Sol = [	[_, _, _, _, _, _],
		[_, _, _, _, _, _],
		[_, _, _, _, _, _],
		[_, _, _, _, _, _],
		[_, _, _, _, _, _] ],

        member([ _, 'Rojo', _, _, _, 'Peru'], Sol),

        member([ _, _, _, 'Perro', _, 'Francia'], Sol),
        
        member([ _, _, 'Pintor', _, _, 'Japon'], Sol),
        
        member([ _, _, _, _, 'Ron', 'Xina'], Sol),
        
        member([ 1, _, _, _, _, 'Hungria'], Sol),

        member([ _, 'Verde', _, _, 'Conyac', _], Sol),
        
        member([ N_verde, 'Verde', _, _, _, _], Sol),
        member([ N_blanca, 'Blanco', _, _, _, _], Sol),
        N_verde < N_blanca,
        
        member([ _, _, 'Escultor', 'Caracol', _, _], Sol),
        
        member([ _, 'Amarillo', 'Actor', _, _, _], Sol),
        
        member([ 3, _, _, _, 'Cava', _], Sol),
        
        member([ N_actor, _, 'Actor', _, _, _], Sol),
        member([ N_caballo, _, _, 'Caballo', _, _], Sol),
        al_lado(N_actor, N_caballo),

        member([ N_hungria, _, _, _, _, 'Hungria'], Sol),
        member([ N_azul, 'Azul', _, _, _, _], Sol),
        al_lado(N_hungria, N_azul),

        member([ _, _, 'Notario', _, 'Whisky', _], Sol),

        member([ N_medico, _, 'Médico', _, _, _], Sol),
        member([ N_ardilla, _, _, 'Ardilla', _, _], Sol),
        al_lado(N_medico, N_ardilla), 

	write(Sol), nl.

al_lado(N1, N2) :- N2 is N1+1, !.
al_lado(N1, N2) :- N2 is N1-1, !.

%_____________________________________________________________________

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
