%% Learning object containment relationships

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
/*prim(move_right/2).
prim(move_up/2).
prim(move_down/2).
prim(no_move/2).*/
prim(contains/2).

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

/*
% Tail Recursion
metarule([P,Q],([P,A,B]:-[[Q,A,C],@term_gt(A,C),[P,C,B],@term_gt(C,B)])). 
metarule([P,Q,A],([P,A,B]:-[[Q,A,C],@term_gt(A,C),[P,C,B],@term_gt(C,B)])). 
metarule([P,Q,B],([P,A,B]:-[[Q,A,C],@term_gt(A,C),[P,C,B],@term_gt(C,B)])). 
metarule([P,Q,A,B],([P,A,B]:-[[Q,A,C],@term_gt(A,C),[P,C,B],@term_gt(C,B)])). 
*/
a :-
  Pos=[equivalent(px1, px2)],
  Neg = [],
  learn(Pos,Neg,H),
  pprint(H).


%% FIRST-ORDER BACKGROUND KNOWLEDGE
max_right(4).
max_up(4).

world_check(X,A):-
  nonvar(A),
  member(X,A).

obj(px1).
obj_x(px1, 1). 
obj_y(px1, 4).
obj(px2).
obj_x(px2, 1).
obj_y(px2, 4).
obj(px3).
obj_x(px2, 2).
obj_y(px2, 4).



contains(A, B):-
  world_check(obj(O1), A),
  world_check(obj(O2), A),
  O1 \= O2,
  world_check(obj(O1), B),
  world_check(obj(O2), B),
  move_left(A,B,O1),
  move_left(A,B,O2).	
	


no_move(A, B):-
  world_check(obj(O), A),
  world_check(obj(O), B),
  world_check(obj_x(O, X),A),
  world_check(obj_x(O, X),B),
  world_check(obj_y(O, Y),A),
  world_check(obj_y(O, Y),B).

move_left(A, B):-
  world_check(obj(O), A),
  world_check(obj(O), B),
  move_left(A,B,O).

move_left(A,B,O):-
  world_check(dir_x(O, left), A),
  world_check(dir_x(O, left), B),
  world_check(obj_x(O, A_x),A),
  world_check(obj_x(O, B_x),B),
  A_x > 0,
  B_x is A_x-1.

move_right(A, B):-
  world_check(obj(O), A),
  world_check(obj(O), B),
  world_check(obj_x(O, A_x),A),
  world_check(obj_x(O, B_x),B),
  max_right(MAXRIGHT),
  A_x < MAXRIGHT,
  B_x is A_x+1.

move_down(A, B):-
  world_check(obj(O), A),
  world_check(obj(O), B),
  world_check(obj_y(O, A_y),A),
  world_check(obj_y(O, B_y),B),
  A_y > 0,
  B_y is A_y-1.

move_up(A, B):-
  world_check(obj(O), A),
  world_check(obj(O), B),
  world_check(obj_y(O, A_y),A),
  world_check(obj_y(O, B_y),B),
  max_up(MAXUP),
  A_y < MAXUP,
  B_y is A_y+1.

change_dir(A, B):-
  world_check(obj(O), A),
  world_check(obj(O), B),
  world_check(dir_x(O, D1),A),
  world_check(dir_x(O, D2),A),
  D1 \= D2,!.

%% FIXES YAP RANDOM BUG
set_rand:-
  datime(datime(_,_Month,_Day,_H,Minute,Second)),
  X is Minute * Second,Y=X,Z=X,
  setrand(rand(X,Y,Z)).


