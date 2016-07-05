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
prim(touched/2).
%prim(pix/1).
%prim(space_filler/1).
prim(colour/2).
prim(colour_match/2).
prim(x_adjacent/2).
prim(y_adjacent/2).

%% METARULES
%metarule([P,Q],([P,A]:-[[Q,A]])).
metarule([P,Q],([P,A]:-[[Q,A,B]])).
%metarule([P,Q,R],([P,A]:-[[Q,C],[R,A,C]])).
%metarule([P,Q,R],([P,A]:-[[Q,A,C],[R,C,B]])).

metarule([P,Q],([P,A,B]:-[[Q,A]])).
metarule([P,Q],([P,A,B]:-[[Q,A,B]])).
%metarule([P,Q,B],([P,A,B]:-[[Q,A,B]])).
%metarule([P,Q,A],([P,A,B]:-[[Q,A,B]])).
%metarule([P,Q,A,B],([P,A,B]:-[[Q,A,B]])).

% Chain Rule
metarule([P,Q,R],([P,A,B]:-[[Q,C],[R,A,C]])).
metarule([P,Q,R],([P,A,B]:-[[Q,A],[R,A,C]])).
metarule([P,Q,R],([P,A,B]:-[[Q,A,C],[R,C,B]])).
%metarule([P,Q,R],([P,A,B]:-[[Q,A,C],[R,B,C]])).
%metarule([P,Q,R,B],([P,A,B]:-[[Q,A,C],[R,C,B]])).
%metarule([P,Q,R,A],([P,A,B]:-[[Q,A,C],[R,C,B]])).
%metarule([P,Q,R,A,B],([P,A,B]:-[[Q,A,C],[R,C,B]])).

/*
% Tail Recursion
metarule([P,Q],([P,A,B]:-[[Q,A,C],@term_gt(A,C),[P,C,B],@term_gt(C,B)])). 
metarule([P,Q,A],([P,A,B]:-[[Q,A,C],@term_gt(A,C),[P,C,B],@term_gt(C,B)])). 
metarule([P,Q,B],([P,A,B]:-[[Q,A,C],@term_gt(A,C),[P,C,B],@term_gt(C,B)])). 
metarule([P,Q,A,B],([P,A,B]:-[[Q,A,C],@term_gt(A,C),[P,C,B],@term_gt(C,B)])). 
%metarule([P,Q,A,B],([P,[A|B]]:-[[Q,A,C],@term_gt(A,C),[P,C,B],@term_gt(C,B)])). 
*/
a :-
  Pos = [linked(p1_1,p1_2)],
  Neg = [],
  learn(Pos,Neg,H),
  pprint(H).


%% FIRST-ORDER BACKGROUND KNOWLEDGE
frame([colour(p1_1, red),   colour(p1_2, black), colour(p1_3, black),
    colour(p2_1, black), colour(p2_2, black), colour(p2_3, black),
    colour(p3_1, black), colour(p3_2, black), colour(p3_3, black)], 1).

frame([colour(p1_1, black), colour(p1_2, red),   colour(p1_3, black),
   colour(p2_1, black), colour(p2_2, black), colour(p2_3, black),
   colour(p3_1, black), colour(p3_2, black), colour(p3_3, black)], 2).

frame([colour(p1_1, black), colour(p1_2, black),   colour(p1_3, red),
   colour(p2_1, black), colour(p2_2, black), colour(p2_3, black),
   colour(p3_1, black), colour(p3_2, black), colour(p3_3, black)], 3).

frame([colour(p1_1, black), colour(p1_2, red),   colour(p1_3, black),
   colour(p2_1, black), colour(p2_2, black), colour(p2_3, black),
   colour(p3_1, black), colour(p3_2, black), colour(p3_3, black)], 4).

frame([colour(p1_1, red),   colour(p1_2, black), colour(p1_3, black),
    colour(p2_1, black), colour(p2_2, black), colour(p2_3, black),
    colour(p3_1, black), colour(p3_2, black), colour(p3_3, black)], 5).


pix(p1_1).
x_loc(p1_1,1).
y_loc(p1_1,1).
pix(p1_2).
x_loc(p1_2,2).
y_loc(p1_2,1).
pix(p1_3).
x_loc(p1_3,3).
y_loc(p1_3,1).

pix(p2_1).
x_loc(p2_1,1).
y_loc(p2_1,2).
pix(p2_2).
x_loc(p2_2,2).
y_loc(p2_2,2).
pix(p2_3).
x_loc(p2_3,3).
y_loc(p2_3,2).

pix(p3_1).
x_loc(p3_1,1).
y_loc(p3_1,3).
pix(p3_2).
x_loc(p3_2,2).
y_loc(p3_2,3).
pix(p3_3).
x_loc(p3_3,3).
y_loc(p3_3,3).

max_right(4).
max_up(4).

colour_match(X,Y):-
	frame(S1,1),
	frame(S2,2),
	member(colour(X,C),S1),
	member(colour(Y,C),S2).

x_adjacent(X,Y):-
	y_loc(X,Z),
	y_loc(Y,Z),
	x_loc(X,XX),
	x_loc(Y,YX),
	X \= Y,
	1 is abs(XX - YX).

y_adjacent(X,Y):-
	x_loc(X,Z),
	x_loc(Y,Z),
	y_loc(X,XY),
	y_loc(Y,YY),
	X \= Y,
	1 is abs(XY - YY).
	

