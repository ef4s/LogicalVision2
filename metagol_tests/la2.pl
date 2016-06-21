%% Learning object motion strategies

:- use_module('../metagol/metagol').

%% METAGOL SETTINGS
metagol:functional. % force functional solution

%% CUSTOM FUNCTIONAL CHECK
func_test(Atom,PS,G):-
  Atom = [P,A,B],
  Actual = [P,A,Z],
  \+ (metagol:prove_deduce([Actual],PS,G),Z \= B).


%% PREDICATES TO BE USED IN THE LEARNING
prim(move_left/2).
prim(move_right/2).
prim(move_up/2).
prim(move_down/2).
%prim(no_move/2).

%% METARULES
metarule([P,Q],([P,A,B]:-[[Q,A,B]])).
metarule([P,Q,B],([P,A,B]:-[[Q,A,B]])).
metarule([P,Q,A],([P,A,B]:-[[Q,A,B]])).
metarule([P,Q,A,B],([P,A,B]:-[[Q,A,B]])).

% Chain Rule
metarule([P,Q,R],([P,A,B]:-[[Q,A,C],[R,C,B]])).
metarule([P,Q,R,B],([P,A,B]:-[[Q,A,C],[R,C,B]])).
metarule([P,Q,R,A],([P,A,B]:-[[Q,A,C],[R,C,B]])).
metarule([P,Q,R,A,B],([P,A,B]:-[[Q,A,C],[R,C,B]])).

% Tail Recursion
metarule([P,Q],([P,A,B]:-[[Q,A,C],@term_gt(A,C),[P,C,B],@term_gt(C,B)])). 
metarule([P,Q,A],([P,A,B]:-[[Q,A,C],@term_gt(A,C),[P,C,B],@term_gt(C,B)])). 
metarule([P,Q,B],([P,A,B]:-[[Q,A,C],@term_gt(A,C),[P,C,B],@term_gt(C,B)])). 
metarule([P,Q,A,B],([P,A,B]:-[[Q,A,C],@term_gt(A,C),[P,C,B],@term_gt(C,B)])). 

a :-
/*Pos = [
f(pix(1,4), pix(2,4)),
f(pix(2,4), pix(3,4)),
f(pix(3,4), pix(4,4)),
f(pix(4,4), pix(4,3)),
f(pix(4,3), pix(3,3)),
f(pix(3,3), pix(2,3)),
f(pix(2,3), pix(1,3)),
f(pix(1,3), pix(1,2)),
f(pix(1,2), pix(2,2)),
f(pix(2,2), pix(3,2)),
f(pix(3,2), pix(4,2)),
f(pix(4,2), pix(4,1)),
f(pix(4,1), pix(3,1)),
f(pix(3,1), pix(2,1)),
f(pix(2,1), pix(1,1))
],*/

Pos = [
f(pix(1,4), pix(2,4)),
f(pix(2,4), pix(3,4)),
f(pix(3,4), pix(4,4)),
f(pix(4,4), pix(3,3)),
f(pix(3,3), pix(2,3))
],

Neg = [], %[f(pix(3,3),pix(3,4))], 

  learn(Pos,Neg,H),
  pprint(H).

%% FIRST-ORDER BACKGROUND KNOWLEDGE

max_right(4).
max_forwards(4).

move_left(pix(X1, Y1), pix(X2, Y1)):-
  X1 > 0,
  X2 is X1-1.

move_right(pix(X1, Y1), pix(X2, Y1)):-
  max_right(MAXRIGHT),
  X1 < MAXRIGHT,
  X2 is X1+1.

move_down(pix(X1, Y1), pix(X1, Y2)):-
  Y1 > 0,
  Y2 is Y1-1.

move_up(pix(X1, Y1), pix(X1, Y2)):-
  max_forwards(MAXFORWARDS),
  Y1 < MAXFORWARDS,
  Y2 is Y1+1.

%no_move(pix(X1, Y1), pix(X1, Y1)).
