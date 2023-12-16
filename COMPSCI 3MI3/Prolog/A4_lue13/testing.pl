:- [typing].
%% Comments will not be explained as in depth as the code. This is because they are VERY self explanatory
%% I have worked on this assigment for too long and documented every code element, how the code runs, along
%% with how recursion method for the predicates. I have four lines of comments for one line of code. 
%% 
%% Some of the given code WILL NOT BE TESTED 
%% I would have too many test cases

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Expressions
%% All of them just test if an expression is valid
%% Main sources of error can include not having a string for the 
%% atom input
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
:- expr(true).
:- expr(false).
:- expr(atom("poop")).
:- \+expr(atom(9)).
:- expr(pair(atom("t"), pair(atom("m"), atom("d")))).
:- \+expr(fst(atom("t"), pair(atom("m"), atom("d")))). %% first must have a pair type in order for it to be valid
:- expr(fst(pair(atom("w"), pair(atom("x"), atom("s"))))). %% first works with pair
:- \+expr(snd(false, true)). %% second must have a pair type in order for it to be valid
:- expr(snd(pair(atom("w"), pair(atom("x"), atom("s"))))). %% second works with pair
:- expr(if_then_else(atom("....."), true, false)). %% Does not matter right now what the first variable of if is (only in type checking it does according to the original typing.pl)
:- expr(lam(atom("MY"), bool, atom("MY"))). %% Does not matter right now what the first variable of if is (only in type checking it does according to the original typing.pl)
:- \+expr(lam(true, bool, false)). %% First input must be an atom for lambda calculus to work
:- expr(let(atom("X"), pair(false, false), atom("X"))).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Typed
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% basic tests for booleans
:- typed(true, [], bool).
:- typed(false, [], bool).
:- typed(false, [(atom("please help me"), bool)], bool). %% the context does not impact

%% typed and tests
:- typed(and(true, false), [], bool).
:- \+typed(and(atom("A"), true), [], bool). %% because A is not well typed
:- \+typed(and(atom("A"), true), [(atom("A"), funct_type(bool, bool))], bool). %% Since A is not a bool type
:- typed(and(atom("A"), true), [(atom("A"), bool)], bool). %% Since A is bool type, it works

%% typing for pairs, first, and second
:- \+typed(pair(atom("ligma"), atom("balls")), [], pair_type(bool, bool)). %% because ligma and balls are not well defined in the context
:- typed(pair(atom("ligma"), atom("balls")), [(atom("ligma"), pair_type(bool, bool)), (atom("balls"), bool)], pair_type(pair_type(bool, bool), bool)). %% because ligma and balls are well defined in the context, it can be typed
:- \+typed(fst(pair(true, atom("UWU"))), [], pair_type(bool, bool)). %% since atom is not well typed
:- typed(fst(pair(true, atom("UWU"))), [(atom("UWU"), bool)], pair_type(bool, bool)). %% since atom is defined in the context as a bool
:- \+typed(snd(pair(true, atom("UWU"))), [], pair_type(bool, bool)). %% since atom is not well typed
:- typed(snd(pair(true, atom("UWU"))), [(atom("UWU"), bool)], pair_type(bool, bool)). %% since atom is defined in the context as a bool

%% typed tests for lambda
:- typed(lam(atom("A"), bool, atom("A")), [], funct_type(bool, bool)).
:- \+typed(lam(atom("A"), bool, atom("B")), [], funct_type(bool, bool)). %% because B is not well typed
:- typed(lam(atom("A"), funct_type(bool, pair_type(bool, bool)), atom("A")), [], funct_type(funct_type(bool, pair_type(bool, bool)), funct_type(bool, pair_type(bool, bool)))).

%% typed tests for app
:- typed(app(lam(atom("A"), bool, atom("A")), true), [], bool).
:- \+typed(app(lam(atom("A"), bool, atom("a")), true), [], bool). %% atom("a") not well typed
:- typed(app(lam(atom("A"), funct_type(bool, bool), atom("A")), lam(atom("A"), bool, atom("A"))), [], funct_type(bool, bool)).

%% typed tests for let
:- typed(let(atom("X"), lam(atom("A"), bool, atom("A")), atom("X")), [], funct_type(bool, bool)).
:- typed(let(atom("X"), lam(atom("A"), bool, atom("A")), pair(atom("X"), atom("X"))), [], pair_type(funct_type(bool, bool), funct_type(bool, bool))).




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% sstep
%% single step call by value
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
:- \+sstep(atom("uwu"), atom("uwu")). %% No steps since atoms are most reduced step
:- \+sstep(true, _). %% Same with true
:- \+sstep(false, _). %% Same with false
:- \+sstep(lam(atom("A"), bool, atom("A")), _). %% Shows that lambda function is at its most simplest form and no next step

%% and tests
:- sstep(and(and(and(true, true), false), true), and(and(true, false), true)). %% Testing out nested ands with true
:- sstep(and(and(and(false, true), false), true), and(and(false, false), true)). %% Testing out nested ands with false
:- \+sstep(and(and(and(atom("Uh oh"), true), false), true), _). %% Testing out nested ands with false

%% if_them_else tests
%% REMEMBER, TYPING DOES NOT MATTER, SO I CAN WRITE ATOMS THAT ARE NOT WELL TYPED!!!! >:)
:- sstep(if_then_else(and(false, true), atom("Uwu"), atom("O No")), if_then_else(false, atom("Uwu"), atom("O No"))).
:- sstep(if_then_else(false, atom("Uwu"), atom("O No")), atom("O No")).

%% first, second, and pair test cases 
:- \+sstep(pair(true, true), _). %% final step
:- sstep(pair(and(true, false), true), pair(false, true)). 
:- sstep(fst(pair(and(true, false), true)), fst(pair(false, true))).
:- sstep(fst(pair(and(true, false), and(false, false))), fst(pair(false, and(false, false)))).
:- sstep(fst(pair(let(atom("A"), atom("B"), lam(atom("B"), bool, atom("A"))), true)), fst(pair(lam(atom("B*"), bool, atom("B")), true))).
:- sstep(snd(pair(and(false, true), and(false, false))), snd(pair(false, and(false, false)))).
:- sstep(snd(pair(true, and(false, false))), snd(pair(true, false))).
:- sstep(snd(pair(if_then_else(true, false, true), and(false, false))), snd(pair(false, and(false, false)))).

%% app tests
:- sstep(app(app(lam(atom("Ur mom"), bool, lam(atom("Ur Mom"), bool, atom("Ur Mom"))), true), false), app(lam(atom("Ur Mom"), bool, atom("Ur Mom")), false)).
:- sstep(app(lam(atom("Ur mom"), bool, atom("Ur mom")), false), false).

%% let tests
:- sstep(let(atom("P"), and(true, true), atom("P")), let(atom("P"), true, atom("P"))). %% See if the simplification of the second part works
:- sstep(let(atom("P"), true, atom("P")), true). %% simple let substitution
:- sstep(let(atom("X"), atom("Y"), lam(atom("Y"), bool, atom("X"))), lam(atom("Y*"), bool, atom("Y"))). %% Tests the name changing ability
:- sstep(let(atom("X"), atom("Y"), fst(pair(atom("Y"), atom("X")))), fst(pair(atom("Y"), atom("Y")))). %% Should be able to sub into pair, fst, and snd


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% mstep
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% These should ALL return the same thing
:- mstep(true, true).
:- mstep(false, false).
:- mstep(atom("uwu"), atom("uwu")).
:- mstep(lam(atom("A"), pair_type(bool, bool), and(atom("A"), atom("A"))), lam(atom("A"), pair_type(bool, bool), and(atom("A"), atom("A")))).

%% mstep tests for if_then_else
:- mstep(if_then_else(true, false, true), false).
:- mstep(if_then_else(true, pair(true, false), pair(false, true)), pair(true, false)).
:- mstep(if_then_else(true, and(true, false), and(false, true)), false).
:- mstep(if_then_else(true, lam(atom("X"), bool, app(atom("X"), atom("X"))), lam(atom("X"), bool, app(atom("X"), atom("X")))), lam(atom("X"), bool, app(atom("X"), atom("X")))).

%% mstep for pair, first, and second
:- mstep(pair(true, true), pair(true, true)). %% final step
:- mstep(pair(and(true, false), true), pair(false, true)). 
:- mstep(fst(pair(and(true, false), true)), false).
:- mstep(fst(pair(and(true, false), and(false, false))), false).
:- mstep(snd(pair(and(false, true), and(false, false))), false).
:- mstep(snd(pair(true, and(true, true))), true).
:- mstep(snd(pair(if_then_else(true, false, true), and(false, false))), false).

%% mstep tests for app, which account for applied issues
:- mstep(app(if_then_else(true, false, true), false), app(false, false)). %% App does not work OTHER than lambda calc, BUT IT SHOULD STILL WORK BECAUSE TYPING DOES NOT MATTERx
:- mstep(app(app(lam(atom("Ur mom"), bool, lam(atom("Ur Mom"), bool, atom("Ur Mom"))), true), false), false).
:- mstep(app(if_then_else(true, lam(atom("X"), bool, app(atom("X"), atom("X"))), lam(atom("X"), bool, atom("X"))), false), app(false, false)). %% Same with this

%% mstep tests for let
:- mstep(let(atom("A"), false, lam(atom("A"), bool, app(atom("A"), atom("B")))), lam(atom("A"), bool, app(atom("A"), atom("B")))).
:- mstep(let(atom("B"), true, lam(atom("A"), bool, app(atom("A"), atom("B")))), lam(atom("A"), bool, app(atom("A"), true))).
:- mstep(let(atom("A"), atom("Y"), lam(atom("Y"), bool, atom("A"))), lam(atom("Y*"), bool, atom("Y"))). %% tests for name changing and also if the variables will be bounded after a substitution
:- mstep(let(atom("X"), atom("Y"), fst(pair(atom("Y"), atom("X")))), atom("Y")).
:- mstep(let(atom("X"), true, snd(pair(atom("Y"), atom("X")))), true).
:- mstep(let(atom("X"), atom("X"), snd(pair(atom("Y"), atom("X")))), atom("X")).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% tsstep
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
:- \+tsstep(true, _, _). %% No step identity after true
:- \+tsstep(false, _, _). %% No step identity after false
:- tsstep(and(true, false), false, e_AndTrue).
:- tsstep(and(false, true), false, e_AndFalse).

%% tsstep for if_then_else
:- tsstep(if_then_else(and(and(false, true), true), false, true), if_then_else(and(false, true), false, true), e_If(e_And(e_AndFalse))).
:- tsstep(if_then_else(and(and(true, true), true), false, true), if_then_else(and(true, true), false, true), e_If(e_And(e_AndTrue))).

%% tsstep for pair, fst, and snd
:- tsstep(pair(and(false, true), false), pair(false, false), e_pairFirst(e_AndFalse)).
:- \+tsstep(pair(and(atom("A"), true), false), _, _). %% No more steps can be done to this
:- tsstep(fst(pair(and(true, true), true)), fst(pair(true, true)), e_FstPair(e_pairFirst(e_AndTrue))).
:- tsstep(snd(pair(and(true, true), true)), snd(pair(true, true)), e_SndPair(e_pairFirst(e_AndTrue))).
:- tsstep(snd(pair(and(true, true), and(false, true))), snd(pair(true, and(false, true))), e_SndPair(e_pairFirst(e_AndTrue))).
:- tsstep(snd(pair(true, and(false, true))), snd(pair(true, false)), e_SndPair(e_pairSecond(e_AndFalse))).


%% Name changing and apply
:- tsstep(app(lam(atom("X"), bool, lam(atom("Y"), funct_type(bool), atom("X"))), atom("Y")), lam(atom("Y*"), funct_type(bool), atom("Y")), e_LambdaSubstitution).
:- tsstep(app(lam(atom("X"), bool, lam(atom("Y"), funct_type(bool), atom("X"))), atom("X")), lam(atom("Y"), funct_type(bool), atom("X")), e_LambdaSubstitution).


%% tsstep for let to check for letSimplications and letSubstitution
:- tsstep(let(atom("....."), and(true, true), atom(".....")), let(atom("....."), true, atom(".....")), e_letSimplification(e_AndTrue)).
:- tsstep(let(atom("uwu"), true, atom("uwu")), true, e_letSubstitution).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% typederiv
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% type derivaton for true and false
:- typederiv(true, bool, [], t_True).
:- typederiv(false, bool, [], t_False).
:- \+typederiv(true, funct_type(bool, bool), [], t_True).

%% type derivation for and
:- typederiv(and(true, true), bool, [], t_And(t_True, t_True)).
:- typederiv(and(true, false), bool, [], t_And(t_True, t_False)).
:- typederiv(and(false, true), bool, [], t_And(t_False, t_True)).
:- typederiv(and(false, false), bool, [], t_And(t_False, t_False)).
:- typederiv(and(and(true, true), true), bool, [], t_And(t_And(t_True, t_True), t_True)).
:- typederiv(and(and(true, true), and(true, false)), bool, [], t_And(t_And(t_True, t_True), t_And(t_True, t_False))).

%% type derivation of pair, first, and second
:- typederiv(pair(true, false), pair_type(bool, bool), [], t_Pair(t_True, t_False)).
:- typederiv(pair(pair(false, true), false), pair_type(pair_type(bool, bool), bool), [], t_Pair(t_Pair(t_False, t_True), t_False)).
:- typederiv(pair(pair(false, true), and(false, true)), pair_type(pair_type(bool, bool), bool), [], t_Pair(t_Pair(t_False, t_True), t_And(t_False, t_True))).
:- typederiv(fst(pair(true, true)), bool, [], t_pair_first(t_Pair(t_True, t_True))).
:- typederiv(fst(pair(true, false)), bool, [], t_pair_first(t_Pair(t_True, t_False))).
:- typederiv(fst(pair(false, true)), bool, [], t_pair_first(t_Pair(t_False, t_True))).
:- typederiv(fst(pair(false, false)), bool, [], t_pair_first(t_Pair(t_False, t_False))).
:- typederiv(fst(pair(fst(pair(false, true)), false)), bool, [], t_pair_first(t_Pair(t_pair_first(t_Pair(t_False, t_True)), t_False))).
:- typederiv(snd(pair(true, true)), bool, [], t_pair_second(t_Pair(t_True, t_True))).
:- typederiv(snd(pair(true, false)), bool, [], t_pair_second(t_Pair(t_True, t_False))).
:- typederiv(snd(pair(false, true)), bool, [], t_pair_second(t_Pair(t_False, t_True))).
:- typederiv(snd(pair(false, false)), bool, [], t_pair_second(t_Pair(t_False, t_False))).
:- typederiv(snd(pair(false, and(and(true, true), and(true, atom("nope"))))), bool, [(atom("nope"), bool)], t_pair_second(t_Pair(t_False, t_And(t_And(t_True, t_True), t_And(t_True, t_Var("nope")))))).
:- \+typederiv(snd(pair(false, and(and(true, true), and(true, atom("nope"))))), bool, [], t_pair_second(t_Pair(t_False, t_And(t_And(t_True, t_True), t_And(t_True, t_Var("nope")))))). %% Not well typed

%% type derivation of lambda
%% Tests if the context works
:- \+typederiv(lam(atom("Your mom"), bool, atom("Your Mom")), funct_type(bool, bool), [], t_lam_type(t_Var("Your mom"), t_Var("Your Mom"))). %% empty context so the variable is not well typed
:- typederiv(lam(atom("Your mom"), bool, atom("Your Mom")), funct_type(bool, bool), [(atom("Your Mom"), bool)], t_lam_type(t_Var("Your mom"), t_Var("Your Mom"))).

%% type derivation for apply
:- typederiv(app(lam(atom("A"), bool, atom("A")), true), bool, [], t_app_elim(t_lam_type(t_Var("A"), t_Var("A")), t_True)).
:- \+typederiv(app(lam(atom("A"), bool, atom("A")), atom("A")), bool, [], t_app_elim(t_lam_type(t_Var("A"), t_Var("A")), t_Var("A"))). %% Does not work becuase of the free variable A
:- typederiv(app(lam(atom("A"), pair_type(bool, bool), atom("A")), atom("A")), pair_type(bool, bool), [(atom("A"), pair_type(bool, bool))], t_app_elim(t_lam_type(t_Var("A"), t_Var("A")), t_Var("A"))). 

%% type derivation for let
:- typederiv(let(atom("A"), true, atom("A")), bool, [], t_let(t_True, t_Var("A"))).
:- typederiv(let(atom("A"), true, atom("B")), func_type(bool, bool), [(atom("B"), func_type(bool, bool))], t_let(t_True, t_Var("B"))).
:- \+typederiv(let(atom("A"), true, atom("B")), _, [], t_let(t_True, t_Var("B"))). %% Because B is not well typed