symbolicOutput(0). % set to 1 to see symbolic output only; 0 otherwise.

%% We want to do the weekly production planning for a factory that
%% produces plastic pieces for cars.  It has a number of tasks (each
%% task is to produce a lot of identical pieces).  Each task has to be
%% done on a machine, and machines cannot handle more than one task
%% simultaneously. We have a number of available hours to complete all
%% tasks, but we want to finish all tasks as soon as possible.

%% For the given examples tasks1, ..., tasks4 you should be able to find
%% good solutions quickly, proving optimality if possible.
:- include(tasks2).  % <----  use this to handle the examples.

%% The little toy example below has the following optimal solution:

%numMachines(3).
%availableHours(100).
%task(1, 15,  17,49, [1,3]).  % task number=1, duration=15h, earliestStart=17, latestFinish=49, usableMachines=[1,3]).
%task(2, 19,   6,66, [1,3]).
%task(3, 8,    5,54, [1,2,3]).
%task(4, 11,   2,51, [1  ]).
%task(5, 19,  15,50, [2,3]).

%% plan found that takes 33 hours 
%%
%%         10        20        30       
%% 1234567890123456789012345678901234567
%%
%% machine 1:
%%    444444444442222222222222222222                                                                   
%%      4           2                                                                                  
%%
%% machine 2:
%%               5555555555555555555                                                                   
%%                  5                                                                                  
%%
%% machine 3:
%%           33333333111111111111111                                                                   
%%              3       1                                                                              

%%%%%% Some helpful definitions to make the code cleaner:

task(T):-              task(T,_,_,_,_).
duration(T,D):-        task(T,D,_,_,_).
earliestStart(T,E):-   task(T,_,E,_,_).
latestFinish(T,L):-    task(T,_,_,L,_).
usableMachine(T,M):-   task(T,_,_,_,L), member(M,L).

machine(M):- numMachines(N), between(1,N,M).

possibleStart( T, AvailableHours, H ):-
    duration(T,D),
    earliestStart(T,EarliestStart),
    latestFinish(T,LatestF1), LatestFinish is min(AvailableHours,LatestF1),  LatestStart is LatestFinish-D+1,
    between(EarliestStart,LatestStart,H).


% Use the following types of symbolic propositional variables (you can add more):
%   1. start-T-H    means:  "task T starts at hour H"     (MANDATORY)
%   2. machine-T-M  means:  "task T uses machine M"          (MANDATORY)
%   3. used-T-M-H   means:  "task T used machine M at hour H"

writeClauses(AvailableHours):- 
    eachTaskStartsOnce(AvailableHours),
    eachTaskOneMachine(),
    ifStartAndMachineThenUsed(AvailableHours),
    oneTaskPerHourAndMachine(AvailableHours),
    true,!.


eachTaskStartsOnce(AvailableHours):-
    task(T), findall( start-T-H, possibleStart(T,AvailableHours,H), Lits ), exactly(1,Lits), fail.
eachTaskStartsOnce(_).

eachTaskOneMachine():-
	task(T), findall(machine-T-M, usableMachine(T,M), Lits), exactly(1, Lits), fail.
eachTaskOneMachine().

ifStartAndMachineThenUsed(AvailableHours):-
	task(T), duration(T, D), possibleStart(T, AvailableHours, Start), usableMachine(T,M), End is Start+D, between(Start,End,H),
	writeClause([\+start-T-Start, \+machine-T-M, used-T-M-H]), fail.
ifStartAndMachineThenUsed(_).

oneTaskPerHourAndMachine(AvailableHours):-
	between(0,AvailableHours,H), machine(M), findall(used-T-M-H, task(T), List), atMost(1, List), fail.
oneTaskPerHourAndMachine(_).

% =====================================================================
%DisplaySol. Do not modify:
displaySol(_):-
    write('        10        20        30        40        50        60        70        80'), 
    write('        90       100       110       120'),    nl,
    write('12345678901234567890123456789012345678901234567890123456789012345678901234567890'),
    write('1234567890123456789012345678901234567890'),    nl,fail.
displaySol(M):- machine(Mach), nl, write('machine '), write(Mach), write(':'), nl,  displayMachine(M,Mach), fail.
displaySol(_):- nl,nl,!.

displayMachine(M,Mach):-     availableHours(AH), between(1,AH,H),               writeX(H,M,Mach), fail.
displayMachine(M,Mach):- nl, availableHours(AH), between(1,AH,H), 0 is H mod 2, writeS(H,M,Mach), fail.
displayMachine(_,_):- nl.
    
writeX(H,M,Mach):- member(machine-T-Mach,M), member(start-T-S,M), duration(T,D), F is S+D-1, between(S,F,H),
		   X is T mod 10, write(X), !.
writeX(_,_,_):- write(' '),!. 

writeS(H,M,Mach):- member(machine-T-Mach,M), member(start-T-S,M), (H is S+3;H is S+2), writeNum2(T), !.
writeS(_,_,_):- write('  '),!. 

writeNum2(T):-T<10, write(' '), write(T), !.
writeNum2(T):-                  write(T), !.

%=====================================================

% This predicate computes the duration for each new solution, so we can look for better ones:
hoursUsed(M,K):- findall(F, (member(start-T-S,M),duration(T,D),F is S+D-1), L),    max_list(L,K),!.

%=====================================================

main:- symbolicOutput(1), !, availableHours(AH),
       initClauseGeneration, writeClauses(AH), halt.   % print the clauses in symbolic form and halt
main:- availableHours(AH), initClauseGeneration,
       tell(clauses), writeClauses(AH), told,     % generate the (numeric) SAT clauses and call the solver
       tell(header),  writeHeader,  told,
       numVars(N), numClauses(C), 
       write('Generated '), write(C), write(' clauses over '), write(N), write(' variables. '),nl,
       shell('cat header clauses > infile.cnf',_),
       nl,nl,write('Looking for initial planning taking at most '), write(AH), write(' hours.'), nl,
       write('Launching picosat...'), nl,
       shell('picosat -v -o model infile.cnf', Result),  % if sat: Result=10; if unsat: Result=20.
       treatResult(Result,[]),!.

treatResult(10,_):- 
    see(model), symbolicModel(M), seen, hoursUsed(M,K),
    write('plan found that takes '), write(K), write(' hours '),nl,nl, K1 is K-1,
    displaySol(M),     initClauseGeneration,
    nl,nl,write('Now looking for even better plannings....'), nl,
    tell(clauses), writeClauses(K1), told,
    tell(header),  writeHeader,  told,
    numVars(N),numClauses(C),
    write('Generated '), write(C), write(' clauses over '), write(N), write(' variables. '),nl,
    shell('cat header clauses > infile.cnf',_),
    write('Launching picosat...'), nl,
    shell('picosat -v -o model infile.cnf', Result),  % if sat: Result=10; if unsat: Result=20.
    treatResult(Result,M),!.
treatResult(20,[]       ):- write('No solution exists.'), nl, halt.
treatResult(20,BestModel):- nl,nl,write('Optimal solution: '),nl, displaySol(BestModel), halt.

    
%===========================================================
initClauseGeneration:-  %initialize all info about variables and clauses:
    retractall(numClauses(   _)), 
    retractall(numVars(      _)), 
    retractall(varNumber(_,_,_)),
    assert(numClauses( 0 )), 
    assert(numVars(    0 )),     !.

writeClause([]):- symbolicOutput(1),!, nl.
writeClause([]):- countClause, write(0), nl.
writeClause([Lit|C]):- w(Lit), writeClause(C),!.
w( Lit ):- symbolicOutput(1), write(Lit), write(' '),!.
w(\+Var):- var2num(Var,N), write(-), write(N), write(' '),!.
w(  Var):- var2num(Var,N),           write(N), write(' '),!.

% given the symbolic variable V, find its variable number N in the SAT solver:
:-dynamic(varNumber/3).
var2num(V,N):- hash_term(V,Key), existsOrCreate(V,Key,N),!.
existsOrCreate(V,Key,N):- varNumber(Key,V,N),!.                            % V already existed with num N
existsOrCreate(V,Key,N):- newVarNumber(N), assert(varNumber(Key,V,N)), !.  % otherwise, introduce new N for V

writeHeader:- numVars(N),numClauses(C), write('p cnf '),write(N), write(' '),write(C),nl.

countClause:-     retract( numClauses(N0) ), N is N0+1, assert( numClauses(N) ),!.
newVarNumber(N):- retract( numVars(   N0) ), N is N0+1, assert(    numVars(N) ),!.
 
% Getting the symbolic model M from the output file:
symbolicModel(M):- get_code(Char), readWord(Char,W), symbolicModel(M1), addIfPositiveInt(W,M1,M),!.
symbolicModel([]).
addIfPositiveInt(W,L,[Var|L]):- W = [C|_], between(48,57,C), number_codes(N,W), N>0, varNumber(_,Var,N),!.
addIfPositiveInt(_,L,L).
readWord( 99,W):- repeat, get_code(Ch), member(Ch,[-1,10]), !, get_code(Ch1), readWord(Ch1,W),!. % skip line starting w/ c
readWord(115,W):- repeat, get_code(Ch), member(Ch,[-1,10]), !, get_code(Ch1), readWord(Ch1,W),!. % skip line starting w/ s
readWord(-1,_):-!, fail. %end of file
readWord(C,[]):- member(C,[10,32]), !. % newline or white space marks end of word
readWord(Char,[Char|W]):- get_code(Char1), readWord(Char1,W), !.

%========================================================================================

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Everything below is given as a standard library, reusable for solving 
%    with SAT many different problems.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%% Cardinality constraints on arbitrary sets of literals Lits:
% For example the following generates the clauses expressing that 
%     exactly K literals of the list Lits are true:
exactly(K,Lits):- atLeast(K,Lits), atMost(K,Lits),!.

atMost(K,Lits):-   % l1+...+ln <= k:  in all subsets of size k+1, at least one is false:
    negateAll(Lits,NLits), 
    K1 is K+1,    subsetOfSize(K1,NLits,Clause), writeClause(Clause),fail.
atMost(_,_).

atLeast(K,Lits):-  % l1+...+ln >= k: in all subsets of size n-k+1, at least one is true:
    length(Lits,N),
    K1 is N-K+1,  subsetOfSize(K1, Lits,Clause), writeClause(Clause),fail.
atLeast(_,_).

negateAll( [], [] ).
negateAll( [Lit|Lits], [NLit|NLits] ):- negate(Lit,NLit), negateAll( Lits, NLits ),!.

negate(\+Lit,  Lit):-!.
negate(  Lit,\+Lit):-!.

subsetOfSize(0,_,[]):-!.
subsetOfSize(N,[X|L],[X|S]):- N1 is N-1, length(L,Leng), Leng>=N1, subsetOfSize(N1,L,S).
subsetOfSize(N,[_|L],   S ):-            length(L,Leng), Leng>=N,  subsetOfSize( N,L,S).

% Express that Var is equivalent to the disjunction of Lits:
expressOr( Var, Lits ):- member(Lit,Lits), negate(Lit,NLit), writeClause([ NLit, Var ]), fail.
expressOr( Var, Lits ):- negate(Var,NVar), writeClause([ NVar | Lits ]),!.

% Express that Var is equivalent to the conjunction of Lits:
expressAnd( Var, Lits ):- negate(Var,NVar), member(Lit,Lits),  writeClause([ NVar, Lit ]), fail.
expressAnd( Var, Lits ):- negateAll(Lits,NLits), writeClause([ Var | NLits ]),!.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

