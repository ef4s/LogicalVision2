%% Learning object motion strategies

:- use_module('../metagol/metagol').
:- use_module(library(charsio)).
:- use_module(library(lists)).

%% METAGOL SETTINGS
metagol:functional. % force functional solution

%% CUSTOM FUNCTIONAL CHECK
func_test(Atom,PS,G):-
  Atom = [P,A,B],
  Actual = [P,A,Z],
  \+ (metagol:prove_deduce([Actual],PS,G),Z \= B).

%% PREDICATES TO BE USED IN THE LEARNING
prim(colour/2).
prim(colour_linked/2).
prim(x_adjacent/2).
prim(y_adjacent/2).
prim(move_left/2).
prim(move_right/2).

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
  Pos = [move_left(p1_1,p1_2)],
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

transitions([change_colour(p1_1,black), change_colour(p1_2, red)],1,2).

frame([colour(p1_1, black), colour(p1_2, black),   colour(p1_3, red),
   colour(p2_1, black), colour(p2_2, black), colour(p2_3, black),
   colour(p3_1, black), colour(p3_2, black), colour(p3_3, black)], 3).

transitions([change_colour(p1_2,black), change_colour(p1_3, red)],2,3).

frame([colour(p1_1, black), colour(p1_2, red),   colour(p1_3, black),
   colour(p2_1, black), colour(p2_2, black), colour(p2_3, black),
   colour(p3_1, black), colour(p3_2, black), colour(p3_3, black)], 4).

transitions([change_colour(p1_2,red), change_colour(p1_3, black)],3,4).

frame([colour(p1_1, red),   colour(p1_2, black), colour(p1_3, black),
    colour(p2_1, black), colour(p2_2, black), colour(p2_3, black),
    colour(p3_1, black), colour(p3_2, black), colour(p3_3, black)], 5).

transitions([change_colour(p1_1,red), change_colour(p1_2, black)],4,5).

obj(p1_1).
pix(p1_1).
x_loc(p1_1,1).
y_loc(p1_1,1).
obj(p1_2).
pix(p1_2).
x_loc(p1_2,2).
y_loc(p1_2,1).
obj(p1_3).
pix(p1_3).
x_loc(p1_3,3).
y_loc(p1_3,1).

obj(p2_1).
pix(p2_1).
x_loc(p2_1,1).
y_loc(p2_1,2).
obj(p2_2).
pix(p2_2).
x_loc(p2_2,2).
y_loc(p2_2,2).
obj(p2_3).
pix(p2_3).
x_loc(p2_3,3).
y_loc(p2_3,2).

obj(p3_1).
pix(p3_1).
x_loc(p3_1,1).
y_loc(p3_1,3).
obj(p3_2).
pix(p3_2).
x_loc(p3_2,2).
y_loc(p3_2,3).
obj(p3_3).
pix(p3_3).
x_loc(p3_3,3).
y_loc(p3_3,3).

max_right(4).
max_up(4).


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

move_left(X,Y):-
	x_loc(X,XX),
	x_loc(Y,YX),
	X \= Y,
	XX < YX.

move_right(X,Y):-
	x_loc(X,XX),
	x_loc(Y,YX),
	X \= Y,
	XX > YX.
	
create_obj(X,Y):-
	obj(X),
	obj(Y),
	linked(X,Y),
	assert_new_object(X,Y).	

create_obj(X,Y):-
			

assert_new_object(X,Y):-
	x_loc(X,XX),
	x_loc(Y,YX),
	y_loc(X,XY),
	y_loc(Y,YY),	
	OX is (XX + YX) / 2,
	OY is (XY + YY) / 2,
	mangle_object_names(X,Y,OName),
	assert(obj(OName)),
	assert(x_loc(OName,OX)),
	assert(y_loc(OName,OY)).

mangle_object_names(X,Y,OName):-
	atom_to_chars(X,Xs),
	atom_to_chars(Y,Ys),
	list_concat([Xs,"_",Ys],O),
	atom_codes(OName,O),


% CHARACTERISTIC 1 - Members transition in the same way
trans_linked(O1,O2,F1,F2):-
	object(O1),
	move_left(O1,F1,F2),
	object(O2),
	move_left(O2,F1,F2).

trans_linked(O1,O2,F1,F2):-
	object(O1),
	move_right(O1,F1,F2),
	object(O2),
	move_right(O2,F1,F2).

		
% CHARACTERISTIC 2 - Members transition at the same time
trans_time_linked(O1,O2,F1,F2):-
	object(O1),
	move_left(O1,F1,F2),
	object(O2),
	move_right(O2,F1,F2).

% CHARACTERISTIC 2 - Members connected by visual similarity
colour_linked(O1,O2,F):-
	object(O1),
	object(O2),
	same_colour(O1,O2,F).

same_colour(O1,O2,F):-
	frame(S,F),
	member(colour(O1,C),S),
	member(colour(O2,C),S).
