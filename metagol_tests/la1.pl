%% Learning object motion strategies

:- use_module('../metagol/metagol').

%% METAGOL SETTINGS
%metagol:functional. % force functional solution

%% PREDICATES TO BE USED IN THE LEARNING
prim(move_left/2).
prim(move_right/2).
prim(no_move/2).

%% METARULES
metarule([P,Q],([P,A,B]:-[[Q,A,B]])).
metarule([P,Q,A],([P,A,B]:-[[Q,A,B]])).
metarule([P,Q,B],([P,A,B]:-[[Q,A,B]])).
metarule([P,Q,A,B],([P,A,B]:-[[Q,A,B]])).

% Chain Rule
metarule([P,Q,R],([P,A,B]:-[[Q,A,C],[R,C,B]])).
metarule([P,Q,R,B],([P,A,B]:-[[Q,A,C],[R,C,B]])).
metarule([P,Q,R,A],([P,A,B]:-[[Q,A,C],[R,C,B]])).
metarule([P,Q,R,A,B],([P,A,B]:-[[Q,A,C],[R,C,B]])).

%% ROBOT LEARNING TO MOVE A BALL TO A SPECIFIC POSITION
a :-

Pos = [
	f(2, 3),
	f(3, 4),
	f(4, 3),
	f(3, 2),
	f(2, 4)
	],	

Neg = [f(1, 2),
	f(5, 4),
	f(4, 5)], 

  learn(Pos,Neg,H),
  pprint(H).

%% FIRST-ORDER BACKGROUND KNOWLEDGE


max_right(5).
max_forwards(5).

no_move(X,X).

move_left(X1, X2):-
  X1 > 0,
  X2 is X1-1.

move_right(X1, X2):-
  max_right(MAXRIGHT),
  X1 < MAXRIGHT,
  X2 is X1+1.


