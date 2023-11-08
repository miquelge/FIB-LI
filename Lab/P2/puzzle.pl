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

        member([ _, 'Verde', _, _, 'Coñac', _], Sol),
        
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
