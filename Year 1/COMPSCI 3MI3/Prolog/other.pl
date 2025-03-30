%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Evaluate (call by value) entire process
%% Var 1: Input
%% Var 2: Result
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% eval for base true, false, and atoms
eval(true, true).
eval(false, false).
eval(atom(A), atom(A)).

%% eval for if
%% if X evaluates as true, then evaluate Y and return the result
%% Otherwise, return the result of the evaluation of Z
eval(if_then_else(X, Y, _), W) :- eval(X, true), eval(Y, W).
eval(if_then_else(X, _, Z), W) :- eval(X, false), eval(Z, W).

%% eval for and
%% evaluates the first part to check if it is true or false
%% If true, then return the evaluation of Y
%% Otherwise, return false
eval(and(X, Y), T) :- eval(X, true), eval(Y, T).
eval(and(X, _), false) :- eval(X, false).

%% eval for pair, first, and second
%% Pair eval works by evaluating X first, then evalutes Y
%% fst evalutes X first, then Y, and returns the resultant of the evaluation of X
%% snd does the opposite
%% The reason both of the pair are evaluated is because of the rules along with is a case where
%% either the first or second part of the pair do not evaluate.
%% If I did not evaluate both, then it would go through when it should not. 
eval(pair(X, Y), pair(X2, Y2)) :- eval(X, X2), eval(Y, Y2).
eval(fst(pair(X, Y)), X2) :- eval(X, X2), eval(Y, _).
eval(snd(pair(X, Y)), Y2) :- eval(X, _), eval(Y, Y2).


%% eval for lambda
%% Just return the same thing
eval(lam(A, T, C), lam(A, T, C)).


eval(app(A, B), T) :- \+value(A), eval(A, A2), eval(B, B2), eval(app(A2, B2), T).
eval(app(A, B), T) :- value(A), \+value(B), eval(B, B2), eval(app(A, B2), T).
eval(app(lam(A, _, B), C), P) :- eval(C, C2), substitute(A, C2, B, P).
eval(app(A, B), app(A, B)) :- \+sstep(app(A, B), _).

%% eval for let
%% For let, first evaluate B, then put the evaluation of B into C, and then evalute
%% the resultant to verify it can not be simplified further. 
eval(let(A, B, C), C3) :- eval(B, B2), substitute(A, B2, C, C2), eval(C2, C3).




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% eval (Call by Value)
%% NOTE: NO ALPHA EQUIVALENCE. I WAS TOLD THIS BY REED
%% Also, I do not need to even write eval. I did this all accidentally
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% These should ALL return the same thing
:- eval(true, true).
:- eval(false, false).
:- eval(atom("uwu"), atom("uwu")).
:- eval(lam(atom("A"), pair_type(bool, bool), and(atom("A"), atom("A"))), lam(atom("A"), pair_type(bool, bool), and(atom("A"), atom("A")))).

%% eval tests for if_then_else
:- eval(if_then_else(true, false, true), false).
:- eval(if_then_else(true, pair(true, false), pair(false, true)), pair(true, false)).
:- eval(if_then_else(true, and(true, false), and(false, true)), false).
:- eval(if_then_else(true, lam(atom("X"), bool, app(atom("X"), atom("X"))), lam(atom("X"), bool, app(atom("X"), atom("X")))), lam(atom("X"), bool, app(atom("X"), atom("X")))).

%% eval for pair, first, and second
:- eval(pair(true, true), pair(true, true)). %% final step
:- eval(pair(and(true, false), true), pair(false, true)). 
:- eval(fst(pair(and(true, false), true)), false).
:- eval(fst(pair(and(true, false), and(false, false))), false).
:- eval(snd(pair(and(false, true), and(false, false))), false).
:- eval(snd(pair(true, and(true, true))), true).
:- eval(snd(pair(if_then_else(true, false, true), and(false, false))), false).

%% eval tests for app, which account for applied issues
%% Because typing does not matter, I have some weird ones such as app on a if statement and a boolean
%% That works with the call by value rules, BUT does not work under the rulings
:- eval(app(if_then_else(true, false, true), false), app(false, false)). %% Apply only works on lambda functions but because it is not mandatory for well typedness, it does not matter since it is following the rules
:- eval(app(app(lam(atom("Ur mom"), bool, lam(atom("Ur Mom"), bool, atom("Ur Mom"))), true), false), false).
:- eval(app(if_then_else(true, lam(atom("X"), bool, app(atom("X"), atom("X"))), lam(atom("X"), bool, atom("X"))), false), app(false, false)).

%% eval tests for let
:- eval(let(atom("A"), false, lam(atom("A"), bool, app(atom("A"), atom("B")))), lam(atom("A"), bool, app(atom("A"), atom("B")))).
:- eval(let(atom("B"), true, lam(atom("A"), bool, app(atom("A"), atom("B")))), lam(atom("A"), bool, app(atom("A"), true))).
:- eval(let(atom("A"), atom("Y"), lam(atom("Y"), bool, atom("A"))), lam(atom("Y*"), bool, atom("Y"))). %% tests for name changing and also if the variables will be bounded after a substitution


