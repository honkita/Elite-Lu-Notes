%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Constraint Logic Programming

:- use_module(library(clpb)).
:- use_module(library(clpfd)).

%% This is how we use libraries in Prolog!
%% This particular library ships with SWI-Prolog,
%% So we don't need to install anything.

%% Prolog is non-deterministic! Use ; to keep showing answers in the REPL.
ta(cs3mi3, reedf).
ta(cs3mi3, jason).
ta(cs3mi3, akram).
ta(cs3mi3, zizeng).

test(Room1, Room2) :- 
    S1 = Room1 + Room2,
    S2 = ~ Room1,
    sat(S1 =:= S2).

:- false.

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% Expression Languages


% is_expr(int(V)) :- V in inf..sup.
% is_expr(add(X, Y)) :- is_expr(X), is_expr(Y).
% is_expr(mul(X, Y)) :- is_expr(X), is_expr(Y).
% is_expr(neg(X)) :- is_expr(X).

% is_val(V) :- V in inf..sup.

% :- is_expr(add(mul(int(2), int(2)), int(3))).

eval_expr(int(V), V).
eval_expr(add(X,Y), V) :-
    eval_expr(X,VX),
    eval_expr(Y,VY),
    V #= VX + VY.
eval_expr(mul(X,Y), V) :-
    eval_expr(X,VX),
    eval_expr(Y,VY),
    V #= VX * VY.
eval_expr(neg(X), V) :-
    eval_expr(X,VX),
    V #= - VX.

% steps(int(V), 0, V).
% steps(add(X,Y), Steps, V) :-
%     StepsX #>= 0,
%     StepsY #>= 0,
%     Steps #= 1 + StepsX + StepsY,
%     V #= VX + VY,
%     steps(X, StepsX, VX),
%     steps(Y, StepsY, VY).
% steps(mul(X,Y), Steps, V) :-
%     StepsX #>= 0,
%     StepsY #>= 0,
%     Steps #= 1 + StepsX + StepsY,
%     V #= VX * VY,
%     steps(X, StepsX, VX),
%     steps(Y, StepsY, VY).
% steps(neg(X), Steps, V) :-
%     StepsX #>= 0,
%     Steps #= 1 + StepsX,
%     V #= - VX,
%     steps(X, StepsX, VX).

% is_prop(0).
% is_prop(1).
% is_prop(and(A,B)) :- is_prop(A), is_prop(B).
% is_prop(or(A,B)) :- is_prop(A), is_prop(B).
% is_prop(implies(A,B)) :- is_prop(A), is_prop(B).
% is_prop(not(A)) :- is_prop(A).

% %% Write an evaluator + step relation for this language as a take-home exercise.
% %% Crowd-sourcing is ok (and encouraged!)

% %% Your code here!
% eval_prop(X,V) :- false.
% steps_prop(X,N,V) :- false.

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% Logic Puzzles
% %% (Problems adapted from "The Lady or the Tiger" by Raymond Smullyan)
% %%
% %% Suppose that you are placed in front of two doors,
% %% and told that behind both doors there is either a pot of
% %% gold, or a tiger. There could be gold behind both doors,
% %% gold behind one door and a tiger behind the other, or tigers
% %% in both.
% %%
% %% Each door has a sign on it, and you are told exactly one sign is true.
% %% Sign 1: In this room there is gold, and in the other a tiger.
% %% Sign 2: In one of these rooms there is gold, and in one of these rooms there is a tiger.
% %% What does each room contain?

% %% Modeling this in prolog:
% %% We will use 'clpb' to solve this.
% %% Let '1' denote gold, and '0' denote a tiger.

% riddle1(Room1, Room2) :- false.

% %% Each door has a sign on it, and you are told that both signs are true or both are false.
% %% Sign 1: At least one room contains gold.
% %% Sign 2: THere is a tiger in the other room.
% %% What does each room contain?



% %% Each door has a sign on it, and you are told that both signs are true or both are false.
% %% Sign 1: Either a tiger is in this room or gold in the other.
% %% Sign 2: There is gold in the other room.
% %% What does the second room contain? What about the first?

% riddle3(Room1, Room2) :- false.
    
% %% New Rules!
% %% If gold is in room 1, then the sign on the door is true, and vice versa if there is a tiger.
% %% If the gold is in room 2, then the sign on the door is false, and vice versa if there is a tiger.
% %% Sign 1: Both rooms contain gold
% %% Sign 2: Both rooms contain gold

% riddle4(Room1, Room2) :- false.

% %% Same rules as the last one.
% %% Sign 1: At least one room contains gold.
% %% Sign 2: The other room contains gold.

% riddle5(Room1, Room2) :- false.
%     %% sat((Room1 =:= Room1 + Room2) * (~ Room2 =:= Room1)).

% %% Same rules as the last one
% %% Sign 1: It makes no difference the room you pick.
% %% Sign 2: There is gold in the other room.

% riddle6(Room1, Room2) :- false.

% %% Same rules as the last one
% %% Sign 1: It does make difference the room you pick!
% %% Sign 2: You are better off chosing the other room.

% riddle7(Room1, Room2) :- false.
