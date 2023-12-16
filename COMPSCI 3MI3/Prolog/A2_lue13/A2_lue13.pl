:- use_module(library(clpb)).
:- use_module(library(clpfd)).

%% ASSSIGNMENT PART 1

%% elem predicate
elem(X, [X|_]).
elem(X, [_|L]) :- elem(X,L).

%% Provided cases for elem
:- elem(1, [1, 2, 3]). 

%% Self made cases for elem
:- \+ elem("", []).
:- \+ elem("idk", [1, 2, 3]).
:- \+ elem("", ["f", "u", "c", "k"]).
:- elem("the good succ", ["succ", "Gud", "the good succ", "the good succ"]).
:- elem("IDK", ["IDK", "IDK", "IDK"]).
:- \+elem("Janicki", ["Carette", "Maccio", "Smith", "Stoyanov"]).

%% pick predicate
pick(X, [X|XS], XS).
pick(X, [Y|XS], [Y|YS]) :- pick(X, XS, YS).

%% Provided cases for pick
:- pick(1, [1, 2, 3], [2, 3]). 
:- pick("Fire Emblem", ["Fire Emblem", "Dragalia Lost", "Final Fantasy"], ["Dragalia Lost", "Final Fantasy"]). 
:- pick(1, [2, 1, 1, 3], [2, 1, 3]). 
:- \+ pick(1, [2, 1, 1, 3], [2, 3]). 
:- \+ pick(69, [69, 69, 69, 3], [3]). 
:- pick("", ["", " ", "  "], [" ", "  "]). 

%% permute predicate
permute([],[]).
permute([X|XS],YS):- permute(XS, P), pick(X, YS, P).

%% Self made cases for permute
:- permute([], []). 
:- permute([1, 2, 3], [3, 2, 1]).
:- permute([1, 2, 3], [3, 1, 2]).
:- permute([1, 2, 3], [1, 2, 3]).
:- permute([1, 2, 3], [1, 3, 2]).
:- permute([1, 2, 3], [2, 3, 1]).
:- permute([1, 2, 3], [2, 1, 3]).
:- \+ permute([1, 2, 3], [3, 2, 1, 4]).
:- \+ permute(["Honoka", "Rin", "Nico", "Kotori", "Umi"], ["Hanayo", "Eli", "Nozomi", "Maki"]).

%% sorted predicate
sorted([]).
sorted([_]).
sorted([XS, YS|ZS]):- YS>=XS, sorted([YS|ZS]). 

%% Self made cases for sorted
:- sorted([]). 
:- sorted([1,2,3]). 
:- sorted([0,0,0,0,0,0,0,0,0,0,0]). 
:- \+ sorted([5,0,2]). 
:- sorted([12,22,99,100,1979,5000]). 

%% naive_sort predicate
naive_sort(XS, YS):- sorted(YS), permute(XS, YS).

%% Self made cases for naive_sort
:- naive_sort([], []).
:- \+ naive_sort([1, 2, 3], [1, 3, 2]). %% second list is not sorted
:- \+ naive_sort([12, 9, 3], [1, 1, 1]). %% different lists 
:- \+ naive_sort([9], [2, 9, 10]).
:- naive_sort([9, 3, 2, 9, 10], [2, 3, 9, 9, 10]).
:- naive_sort([8, 1, 2, 3, 5, 1], [1, 1, 2, 3, 5, 8]).

%% ASSSIGNMENT PART 2

%% clue provided
clue(Alice, Bob):- sat(Alice =:=  ~Alice * ~Bob).

%% From the clue, this means that 0 is for goblin and 1 is for gnomes. Alice is a goblin and Bob is a gnome
%% This is because if Alice was a gnome, then her saying that both her and Bob are goblins is contradictory
%% since she is a gnome. As a result, she has to be a goblin and since goblins lie, Bob must be a gnome. 

%% riddle1 predicate
riddle1(Alice, Bob):-
    A = (~Bob),
    B = (Alice * Bob),
    sat(Alice =:= A),
    sat(Bob =:= B).

%% Self made cases for riddle1 (tests all cases)
:- riddle1(1, 0). %% true case, where Alice is a gnome and Bob is a goblin

%% riddle2 predicate
riddle2(Alice, Bob, Carol, Dave):-
    A = (Dave),
    B = (~Carol * Alice),
    C = (Carol # ~Carol),
    D1 = Alice,
    D2 = ~Alice,
    D3 = ~Bob * ~Carol,
    D = (D1 * D2 * ~D3) # (D1 * ~D2 * D3) # (~D1 * D2 * D3),
    sat(Alice =:= A),
    sat(Bob =:= B), 
    sat(Carol =:= C), 
    sat(Dave =:= D).

:- riddle2(0, 0, 1, 0). %% true case, where only Carol is a gnome


%% Provided prolog predicates
is_creature(X) :- var(X).
is_statement(gnome(X)):- is_creature(X). 
is_statement(goblin(X)):- is_creature(X). 
is_statement(and(X,Y)):-
    is_statement(X),
    is_statement(Y).
is_statement(or(X,Y)):- 
    is_statement(X),
    is_statement(Y).
is_statement(xor(X,Y)):- 
    is_statement(X),
    is_statement(Y).
is_statement(implies(X,Y)):- 
    is_statement(X),
    is_statement(Y).
is_statement(neg(X)):- is_statement(X).

%% base cases for goblins_or_gnomes
goblins_or_gnomes([], []).
goblins_or_gnomes([_], []).

%% base calls for goblins_or_gnomes
goblins_or_gnomes([G|Gs], [E|Es]) :-
    relationship(E, F),
    sat(G =:= F),
    goblins_or_gnomes(Gs, Es).

%% relationship base cases
relationship(goblin(X), V):- V = ~X.
relationship(gnome(X), V):- V = X.

%% relationship for neg
relationship(neg(X), ~V) :-
    relationship(X, V).

%% relationship for and
relationship(and(X,Y), V1 * V2) :-
    relationship(X, V1),
    relationship(Y, V2).

%% relationship for or
relationship(or(X,Y), V1 + V2) :-
    relationship(X, V1),
    relationship(Y, V2).

%% relationship for xor
relationship(xor(X,Y), V1 # V2) :-
    relationship(X, V1),
    relationship(Y, V2).

%% relationship for implies
%% Using the definition of implication, which is using A -> B == ~ A v B
relationship(implies(X,Y), ~V1 + V2) :-
    relationship(X, V1),
    relationship(Y, V2).

%% case provided
:- goblins_or_gnomes([A,B], [and(goblin(A), goblin(B))]).
%% case from 2.1
:- goblins_or_gnomes([A,B], [goblin(B), and(gnome(A), gnome(B))]).
%% Self made cases
:- goblins_or_gnomes([A, B], [neg(gnome(B)), and(gnome(A), gnome(B))]). %% Same as 2.1 but testing out negations
:- goblins_or_gnomes([A, B, C, D], [gnome(B), gnome(C), gnome(A), and(goblin(A), goblin(D))]). %% A, B, C = 1 and D = 0
:- goblins_or_gnomes([A, B], [gnome(A), gnome(B)]). %% Unsolvable since both can either be a knight or knave, thus the answer is A=:=A, B=:=B
:- goblins_or_gnomes([A, B, C], [gnome(A), or(and(goblin(A), gnome(C)), goblin(B))]). %% A = 0 and B, C = 1
:- goblins_or_gnomes([A, B], [xor(goblin(A), gnome(B)), gnome(A)]). %% A, B = 1
:- goblins_or_gnomes([A, B, C], [implies(goblin(A), goblin(B)), xor(gnome(A), and(gnome(B), goblin(C))), or(goblin(A), gnome(A))]). %% A, B, C= 1

%% ASSIGNMENT PART 3

%% Provided prolog predicates
boolean( true ). 
boolean( false ).
is_expr(int(V)) :- V in inf..sup. %% Integers
is_expr(bool(B)):- boolean(B).
is_expr(add(X, Y)):- is_expr(X), is_expr(Y).
is_expr(mul(X, Y)):- is_expr(X), is_expr(Y).
is_expr(neg(X)):- is_expr(X).
is_expr(and(X, Y)) :- is_expr(X), is_expr(Y).
is_expr(xor(X, Y)) :- is_expr(X), is_expr(Y).
is_expr(if(B, X, Y)) :- is_expr(B), is_expr(X), is_expr(Y).
is_val(V):- boolean(V); V in inf..sup.

%% Answer
%% Note: some of the predicates were given in lab such as add, mul, and neg
eval_expr(int(V), V).
eval_expr(bool(V), V).
eval_expr(add(X, Y), V):-
    eval_expr(X, VX),
    eval_expr(Y, VY),
    V #= VX + VY.
eval_expr(mul(X, Y), V):-
    eval_expr(X, VX),
    eval_expr(Y, VY),
    V #= VX * VY.
eval_expr(neg(X), V) :-
    eval_expr(X,VX),
    V #= - VX.
eval_expr(and(X, Y), V):- 
    eval_expr(X, V1),
    eval_expr(Y, V2),
    and(V1, V2, V3),
    V = V3.
eval_expr(xor(X, Y), V):- 
    eval_expr(X, V1),
    eval_expr(Y, V2),
    xor(V1, V2, V3),
    V = V3.
eval_expr(if(B, X, Y), V) :-
    eval_expr(B, V1),
    eval_expr(X, V2),
    eval_expr(Y, V3),
    eval(V1, V2, V3, V4),
    V #= V4.


%% auxillary functions for and, xor
eval(true, X, _, V):- V #= X.
eval(false, _, Y, V):- V #= Y.
and(true, true, true).
and(true, false, false).
and(false, true, false).
and(false, false, false).
xor(true, true, false).
xor(true, false, true).
xor(false, true, true).
xor(false, false, false).

%% Self made test cases for part 3
%% Basic cases
:- eval_expr(neg(int(5)), -5).
:- eval_expr(neg(int(-69)), 69).
:- eval_expr(bool(true), true).
:- eval_expr(bool(false), false).

%% Basic boolean cases for and and xor
:- eval_expr(and(bool(true), bool(true)), true).
:- eval_expr(and(bool(true), bool(false)), false).
:- eval_expr(and(bool(false), bool(true)), false).
:- eval_expr(and(bool(false), bool(false)), false).

:- eval_expr(xor(bool(true), bool(true)), false).
:- eval_expr(xor(bool(true), bool(false)), true).
:- eval_expr(xor(bool(false), bool(true)), true).
:- eval_expr(xor(bool(false), bool(false)), false).

%% Basic if cases
:- eval_expr(if(bool(true), int(1), int(5)), 1).
:- eval_expr(if(bool(false), int(304), int(111)), 111).

%% Student ID cases with nested addition and multiplication
:- eval_expr(if(xor(bool(true), bool(false)), int(400364692), bool(false)), 400364692).
:- eval_expr(add(mul(int(4), int(100000000)), mul(int(3), int(121564))), 400364692).
:- eval_expr(mul(int(2), int(200182346)), 400364692).

%% Not many tests for integer operations because from tutorial, so more boolean ones
:- eval_expr(and(and(bool(true), bool(true)), bool(true)), true).
:- eval_expr(and(and(bool(true), bool(true)), xor(bool(true), bool(true))), false).
:- eval_expr(and(xor(bool(true), bool(true)), bool(true)), false).
:- eval_expr(and(xor(bool(true), bool(true)), xor(bool(true), bool(true))), false).