%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
:- use_module(library(clpb)).
:- use_module(library(clpfd)).
:- use_module(library(lists)).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Code provided from the typing.pl file for true, false, if structures
%% Expression Language

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Expressions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% All the formatting is similar to provided code from before, so there will not be much for commenting in this section
expr(true).
expr(false).
expr(if_then_else(B,T,E)) :- expr(B), expr(T), expr(E).
%% Expressions for first and second and pair
expr(pair(A, B)) :- expr(A), expr(B).
expr(fst(pair(A, B))) :- expr(A), expr(B).
expr(snd(pair(A, B))) :- expr(A), expr(B).
%% Expression for and
expr(and(A, B)) :- expr(A), expr(B).
%% Expression for lambda calculus and let

%% For lambda calc, I will do the following:
%% Lam "STRING VARIABLES" ARGUMENTS where similar to the haskell implementation, I can have Lam "x" (Lam "y" STRING)
%% For the argument, I shall make it recursive where the insides is like "Value 1"("Value 2" ("Value 3"...))
expr(atom(A)) :- string(A).
expr(lam(atom(A), T, B)) :- string(A), type(T), expr(B). %% to ensure that the first varaible of this type is the variable
expr(app(A, B)) :- expr(A), expr(B).

%% Let expressions take in three things
%% Suppose I had let A = B in C
%% I would define it as let(A, B, C)
%% A must be a atom, B can be anything, C is an expression
expr(let(atom(_), B, C)) :- expr(B), expr(C).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Value NON REDUCIBLE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
value(true).
value(false).
value(atom(_)).
value(pair(A, B)) :- value(A), value(B).
value(lam(atom(A), T, _)) :- value(atom(A)), type(T).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% In order for everything to work
%% Below are all the necessary predicates for lambda substitution, 
%% let substitution, name changing, etc. 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


lookup(A, [], A).
lookup(A, [(A, A1)|_], A1).
lookup(A, [(B, _)|AX], Q) :- A \= B, lookup(A, AX, Q).

%% Element predicate from A2
elem(X, [X|_]).
elem(X, [_|L]) :- elem(X,L).

%% Freshen Variables
%% Checks if the name is in the list of names to avoid
%% If yes, then add a * to it, check again, and return
%% Otherwise, return the name
freshen(Name, Avoid, Name) :- \+elem(Name, Avoid). 
freshen(atom(Name), Avoid, Name3) :- elem(atom(Name), Avoid), string_concat(Name, "*", Name2), freshen(atom(Name2), Avoid, Name3). 

%% Rename Variables
%% Mostly referenced from the Lambda.hs file, so the variable names are very similar
%% Rn: The list of name -> name conversions
%% Avoid: Names to avoid (free variables)
rename(atom(A), Rn, _, Name) :- lookup(atom(A), Rn, Name).
rename(lam(atom(Name), T, E), Rn, Avoid, lam(atom(NewName), T, Q)) :- freshen(atom(Name), Avoid, atom(NewName)), append([(atom(Name), atom(NewName))], Rn, Rn2), rename(E, Rn2, Avoid, Q).
rename(app(E1, E2), Rn, Avoid, app(E1T, E2T)) :- rename(E1, Rn, Avoid, E1T), rename(E2, Rn, Avoid, E2T).    
rename(pair(E1, E2), Rn, Avoid, pair(E1T, E2T)) :- rename(E1, Rn, Avoid, E1T), rename(E2, Rn, Avoid, E2T).
rename(fst(E), Rn, Avoid, fst(ET)) :- rename(E, Rn, Avoid, ET).
rename(snd(E), Rn, Avoid, snd(ET)) :- rename(E, Rn, Avoid, ET).
rename(and(E1, E2), Rn, Avoid, and(E1T, E2T)) :- rename(E1, Rn, Avoid, E1T), rename(E2, Rn, Avoid, E2T).
rename(if_then_else(E1, E2, E3), Rn, Avoid, if_then_else(E1T, E2T, E3T)) :- rename(E1, Rn, Avoid, E1T), rename(E2, Rn, Avoid, E2T), rename(E3, Rn, Avoid, E3T).
rename(let(atom(Name), B, E), Rn, Avoid, let(atom(NewName), B2, Q)) :- freshen(atom(Name), Avoid, atom(NewName)), append([(atom(Name), atom(NewName))], Rn, Rn2), rename(B, Rn, Avoid, B2), rename(E, Rn2, Avoid, Q).
rename(true, _, _, true).
rename(false, _, _, false).

substitute(X, E1, E2, Q) :- freeVars(E1, E1Free), rename(E2, [], E1Free, T3), substRenamed(X, E1, T3, Q).
substRenamed(atom(_), _, true, true).
substRenamed(atom(_), _, false, false).
substRenamed(atom(X), E1, atom(X), E1).
substRenamed(atom(X), _, atom(X2), atom(X2)) :- X \= X2.
substRenamed(atom(X), _, lam(atom(X), T, E2), lam(atom(X), T, E2)).
substRenamed(atom(X), E1, fst(A), fst(A2)) :- substRenamed(atom(X), E1, A, A2).
substRenamed(atom(X), E1, snd(B), snd(B2)) :- substRenamed(atom(X), E1, B, B2).
substRenamed(atom(X), E1, pair(A, B), pair(A2, B2)) :- substRenamed(atom(X), E1, A, A2), substRenamed(atom(X), E1, B, B2).
substRenamed(atom(X), E1, lam(atom(Y), T, E2), lam(atom(Y), T, E3)) :- X \= Y, substRenamed(atom(X), E1, E2, E3).
substRenamed(atom(X), E1, app(E2, E3), app(E2T, E3T)) :- substRenamed(atom(X), E1, E2, E2T), substRenamed(atom(X), E1, E3, E3T).
substRenamed(atom(X), E1, let(atom(X), E2, E3), let(atom(X), E2T, E3)) :- substRenamed(atom(X), E1, E2, E2T).
substRenamed(atom(X), E1, let(atom(X), E2, E3), let(atom(V), E2T, T)) :- X \= V, substRenamed(atom(X), E1, E2, E2T), substRenamed(atom(X), E1, E3, T).


%% Remove and freeVars are all directly ported from the Lambda.hs file
%% Iterates through entire list and determines if there is anything to remove
remove(_, [], []).
remove(X, [X|XS], T) :- remove(X, XS, T).
remove(X, [Y|XS], [Y|T]) :- X\=Y, remove(X, XS, T).

%% Determines the free variables in a statement
%% Reduces down to an atom if possible
%% If it reaches a let or a lambda calculus statement, it will first compute the free variables, then will remove the lambda variable or
%% the substitution variable in a let statement
freeVars(atom(X), [atom(X)]).
freeVars(lam(X, _, E), P) :- freeVars(E, T1), remove(X, T1, P).
freeVars(app(E1, E2), L) :- freeVars(E1, T1), freeVars(E2, T2), append(T1, T2, L).
freeVars(pair(E1, E2), L) :- freeVars(E1, T1), freeVars(E2, T2), append(T1, T2, L).
freeVars(fst(E), T) :- freeVars(E, T).
freeVars(snd(E), T) :- freeVars(E, T).
freeVars(true, []).
freeVars(false, []).
freeVars(and(E1, E2), L) :- freeVars(E1, T1), freeVars(E2, T2), append(T1, T2, L).
freeVars(if_then_else(E1, E2, E3), L2) :- freeVars(E1, T1), freeVars(E2, T2), freeVars(E3, T3), append(T1, T2, L), append(L, T3, L2).
freeVars(let(X, E1, E2), L) :- freeVars(E1, T1), freeVars(E2, T2), remove(X, T2, T3), append(T1, T3, L).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Types
%% Type 1: bool
%% Type 2: B x B
%% Type 3: B -> B
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
type(bool).
type(funct_type(A, B)) :- type(A), type(B).
type(pair_type(A, B)) :- type(A), type(B).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Typed
%% Var 1: Expression
%% Var 2: Context
%% Var 3: Answer
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
typed(true, _, bool).
typed(false, _, bool).
typed(atom(A), [(atom(A), T)|_], T).
typed(atom(A), [(atom(B), _)|C2], T) :- A \= B, typed(atom(A), C2, T).

%% to verify something can be put in and, both A and B must be booleans
typed(and(A, B), L, bool) :- typed(A, L, bool), typed(B, L, bool). 

typed(pair(A, B), L, pair_type(AT, BT)) :- typed(A, L, AT), typed(B, L, BT).
%% Some type checkers require two types, thus will be parenthesized. T will be the type for A and T2 will be the type of B
typed(fst(pair(A, B)), L, pair_type(T, T2)) :- typed(A, L, T), typed(B, L, T2).
typed(snd(pair(A, B)), L, pair_type(T, T2)) :- typed(A, L, T), typed(B, L, T2).

%% Provided in lecture, but to verify that an if statement is valid, X must be type boolean with Y and Z being type T
typed(if_then_else(X,Y,Z), L, T) :- typed(X, L, bool), typed(Y, L, T), typed(Z, L, T).

%% Type checker for lambda calculus
%% Because I am not using atoms, I will verify that A is a var, B's values are all typed
%% Auxilliary relations will be used to verify that B is ONLY 
typed(lam(atom(A), T, B), L, funct_type(T, Y)) :- append([(atom(A), T)], L, L2), typed(B, L2, Y).

%% Type checker for an apply
%% First check the typing for A, then the typing of B
%% If B is the type of whatever A's input is, then return the output type of B
%% Otherwise, return false
typed(app(A, B), T, T2) :- typed(A, T, funct_type(T1, T2)), typed(B, T, T1).

%% Type checker for let
%% First check the typing of B, which returns BT
%% Then, add tuple (A, BT) to the context, which means that atom A has type BT
%% Finally, type check the rest of C with BTT as the context, which returns P
typed(let(atom(A), B, C), T, P):- typed(B, T, BT), append([(atom(A), BT)], T, BTT), typed(C, BTT, P).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Single Step
%% Assumes well typed already (ASKED REED AND GOING ACCORDINGLY TO THE DOC)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% sstep for pair
sstep(pair(A, B), pair(A2, B)) :- sstep(A, A2).
sstep(pair(A, B), pair(A, B2)) :- value(A), sstep(B, B2).

%% sstep for fst and snd. 
%% Both check if the pair inside can be evaluated.
%% If not, then perform a fst or a second
sstep(fst(A), fst(A2)) :- sstep(A, A2).
sstep(fst(pair(A, B)), A) :- value(pair(A, B)).
sstep(snd(A), snd(A2)) :- sstep(A, A2).
sstep(snd(pair(A, B)), B) :- value(pair(A, B)).


%% sstep code for and
%% Checks if the fist variable is true or false.
%% If not, then simplify it
%% If yes, then evaluate respectively
sstep(and(true, A), A).
sstep(and(false, _), false).
sstep(and(X, Y), and(X2, Y)) :- sstep(X, X2).

%% sstep code for if, then, else (PROVIDED IN CLASS)
%% First checks if the first variable is true or false, which performs the if conditiom
%% If the first variable is not simplified, the first step of the simplification will be provided
sstep(if_then_else(true, X, _), X).
sstep(if_then_else(false, _, Y), Y).
sstep(if_then_else(Z, X, Y), if_then_else(W, X, Y)) :- sstep(Z,W).

%% Applying rules for lambda calculus, where if the thing being applied to the lambda calculus is not simplified, simplify that first
%% Otherwise, perform the substitution
%% Going off of the rules for call by value
%% Before it does anything, it checks whether or not the type of the substituted variable works
sstep(app(A, B), app(A2, B)) :- sstep(A, A2).
sstep(app(A, B), app(A, B2)) :- value(A), sstep(B, B2).
sstep(app(lam(atom(A), _, B), C), C2) :- value(C), substitute(atom(A), C, B, C2).


%% let single step
%% First check if B can be simplified. If yes, simplify that first 
%% If it can not be simplified, then perform a let substitution
sstep(let(A, B, C), let(A, B2, C)) :- sstep(B, B2).
sstep(let(atom(A), B, C), C2) :- value(B), substitute(atom(A), B, C, C2).




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Multi-Step DO NOT TOUCH FROM PROF
%% Determines if the second input is the final step that can be
%% obtained from the first input. 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
mstep(X, X) :- \+sstep(X, _).
mstep(X, Y) :- sstep(X, Z), mstep(Z, Y).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Single Step tracer
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% if_then_else identity returns:
%% If the first variable is not evaluated, then invoke e_If() of the evaluated form of the inside (One step)
%% Otherwise, either the first variable is true or false, which would end up returning the identity for that
tsstep(if_then_else(true, X, _), X, e_IfTrue).
tsstep(if_then_else(false, _, Y), Y, e_IfFalse).
tsstep(if_then_else(Z, X, Y), if_then_else(W, X, Y), e_If(T)) :- tsstep(Z,W,T).

%% and identity returns:
%% Similar to if, if the first variable is not evaluted, then invoke e_And() of one step of the evaluated form of the inside
%% Otherwise, invoke e_andTrue or e_AndFalse
tsstep(and(true, A), A, e_AndTrue).
tsstep(and(false, _), false, e_AndFalse).
tsstep(and(X, Y), and(X2, Y), e_And(T)) :- tsstep(X, X2, T).

%% pair identity returns:
%% e_pairFirst(): If the first part of the pair can be evaluated
%% e_pairSecond(): If the second part can be evaluated WHEN THE FIRST PART CAN NOT
tsstep(pair(A, B), pair(A2, B), e_pairFirst(TA)) :- tsstep(A, A2, TA).
tsstep(pair(A, B), pair(A, B2), e_pairSecond(TB)) :- value(A), tsstep(B, B2, TB).

%% fst and snd are similar so both here:
%% Insert Fst or Snd for each case of *** 
%% e_***Pair: If the inside pair for *** is not fully simplified
%% e_***Elim: If the inside pair for *** is fully simplified, then perform *** on it
tsstep(fst(pair(A, B)), fst(P), e_FstPair(T)) :- tsstep(pair(A, B), P, T).
tsstep(snd(pair(A, B)), snd(P), e_SndPair(T)) :- tsstep(pair(A, B), P, T).
tsstep(fst(pair(A, B)), A, e_FstElim) :- value(pair(A, B)). 
tsstep(snd(pair(A, B)), A, e_SndElim) :- value(pair(A, B)). 

%% app is used for lambda calculus mainly:
%% First evaluate the first parameter of the app (e_callByValueA())
%% Then, evaluate the second done (e_callByValueB())
%% Finally, perform a substitution (e_LambdaSubstitution)
tsstep(app(A, B), app(A2, B), e_callByValueA(T)) :- tsstep(A, A2, T).
tsstep(app(A, B), app(A, B2), e_callByValueB(T)) :- value(A), tsstep(B, B2, T).
tsstep(app(lam(atom(A), _, B), C), C2, e_LambdaSubstitution) :- value(C), substitute(atom(A), C, B, C2).

%% let is similar to app
%% Check if B is evaluated first (e_letSimplification())
%% Then, proceed to perform a let substitution (e_letSubstitution)
tsstep(let(atom(A), B, C), let(atom(A), B2, C), e_letSimplification(T)) :- tsstep(B, B2, T).
tsstep(let(atom(A), B, C), C2, e_letSubstitution) :- value(B), substitute(atom(A), B, C, C2).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% t-multi DO NOT TOUCH FROM PROF
%% NOT EVEN ASKED FOR, JUST HERE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

tmstep(X, X, [e_Val(X)]) :- value(X).
tmstep(X, Y, [W | Ws]) :- tsstep(X, Z, W), tmstep(Z, Y, Ws).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Typing Derivation
%% Var 1: Expression
%% Var 2: Type
%% Var 3: Context
%% Var 4: Rule
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% basic type derivations for true and false
typederiv(true, bool, _, t_True).
typederiv(false, bool, _, t_False).

%% typing derivation for an atom, which is a variable
%% If it is not defined as a type in the context, then it will not go through
typederiv(atom(A), T, [(atom(A), T)|_], t_Var(A)).
typederiv(atom(A), P, [(atom(B), _)|C2], TX) :- A \= B, typederiv(atom(A), P, C2, TX).

%% typing derivation for if, where it types if X is a bool, then gets the derivation for Y and Z
typederiv(if_then_else(X, Y, Z), T, C, t_If(XD, YD, ZD)) :- typederiv(X, bool, C, XD), typederiv(Y, T, C, YD), typederiv(Z, T, C, ZD).

%% typing derivation for and, where both X and Y must be booleans
typederiv(and(X, Y), bool, C, t_And(XD, YD)) :- typederiv(X, bool, C, XD), typederiv(Y, bool, C, YD).

%% this takes a tuple of types since X and Y can be different types
%% because of this, the resultant answer is of type A x B, where A is the type of the first variable, B being type of 
%% second variable.
typederiv(pair(X, Y), pair_type(XT, YT), C, t_Pair(XD, YD)) :- typederiv(X, XT, C, XD), typederiv(Y, YT, C, YD).

%% first and second are only the type of whatever they return, thus not a tuple. 
%% However, I will check the type of the other variable () since it is mandatory in order to proceed
typederiv(fst(A), XT, C, t_pair_first(P)) :- typederiv(A, pair_type(XT, _), C, P).
typederiv(snd(A), YT, C, t_pair_second(P)) :- typederiv(A, pair_type(_, YT), C, P).

%% lambda identity is the type of the input and the output
%% input type with atom is appended to context, then expression B is evaluated
typederiv(lam(atom(A), T, B), funct_type(T, T2), C, t_lam_type(P, Q)) :- append([(atom(A), T)], C, C2), typederiv(atom(A), T, C2, P), typederiv(B, T2, C2, Q).

%% app type derivation works as follows
%% elimination is achieved from typing when A is a function type of P -> Q and T2 has the type of P
%% This must be the case because I have to put a the same type for the input!
typederiv(app(A, B), T2, C, t_app_elim(t_lam_type(P, Q), PP)) :- typederiv(A, funct_type(T, T2), C, t_lam_type(P, Q)), typederiv(B, T, C, PP). 

%% let type derivation works as follows
%% First type derives B to get the type of B
%% Then adds A with the type of B into the context
%% Using the new context, type derive E
%% Return the derivations of B and E to show that it is well typed

typederiv(let(atom(A), B, E), ET, C, t_let(Q1, P)) :- typederiv(B, BT, C, Q1), append([(atom(A), BT)], C, C2), typederiv(E, ET, C2, P). 
