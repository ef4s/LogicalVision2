%%% Learning object motion strategies

:- use_module('../metagol/metagol').

%% METAGOL SETTINGS
metagol:functional. % force functional solution

%% CUSTOM FUNCTIONAL CHECK
func_test(Atom,PS,G):-
  Atom = [P,A,B],
  Actual = [P,A,Z],
  \+ (metagol:prove_deduce([Actual],PS,G),Z \= B).


%% PREDICATES TO BE USED IN THE LEARNING
%prim(contains/2).
prim(n_contained/2).
prim(adjacent/2).
prim(left_of/2).
prim(right_of/2).
prim(above/2).
prim(below/2).
prim(x_aligned/2).
prim(y_aligned/2).

%% METARULES
metarule([P,Q],([P,A]:-[[Q,A]])).
metarule([P,Q],([P,A]:-[[Q,A,B]])).
metarule([P,Q,B],([P,A]:-[[Q,A,B]])).
%metarule([P,Q,R],([P,A]:-[[Q,A,C],[R,C]])).

metarule([P,Q],([P,A,B]:-[[Q,A]])).
%metarule([P,Q],([P,A,B]:-[[Q,A,B]])).
metarule([P,Q],([P,A,B]:-[[Q,A,C]])).
metarule([P,Q,C],([P,A,B]:-[[Q,A,C]])).
%metarule([P,Q,B],([P,A,B]:-[[Q,A,B]])).
%metarule([P,Q,A],([P,A,B]:-[[Q,A,B]])).
%metarule([P,Q,A,B],([P,A,B]:-[[Q,A,B]])).

% Chain Rule
metarule([P,Q,R],([P,A,B]:-[[Q,A,C],[R,C,D]])).
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
  Pos = [square(s1, z)],
  Neg = [square(s2, z)],
  learn(Pos,Neg,H),
  pprint(H).

%% FIRST-ORDER BACKGROUND KNOWLEDGE
space_filler(z).
pix(a). 
pix(b). 
pix(c). 
pix(d).
pix(e). 
pix(f). 
pix(g).  
pix(h).  
contains(s1,a).
contains(s1,b).
contains(s1,c).
contains(s1,d).
contains(s2,e).
contains(s2,f).
contains(s2,g).
contains(s2,h).
x_loc(a,3).
y_loc(a,4).
x_loc(b,4).
y_loc(b,4).
x_loc(c,4).
y_loc(c,3).
x_loc(d,3).
y_loc(d,3).
x_loc(e,6).
y_loc(e,2).
x_loc(f,7).
y_loc(f,2).
x_loc(g,8).
y_loc(g,2).
x_loc(h,6).
y_loc(h,1).

%  1,2,3,4,5,6,7,8
%4 . . a,b . . . . 
%3 . . d,c . . . . 
%2 . . . . . e f g 
%1 . . . . . h . . 

n_adjacent(X,Y):-
	bagof(Z, adjacent(X,Z), ZZ),
	length(ZZ,Y).

n_contained(X,Y):-
	bagof(Z, contains(X,Z), ZZ),
	length(ZZ,Y).

adjacent(X,Y):-
	x_loc(X,XX),
	x_loc(Y,YX),
	X \= Y,
	1 is abs(XX - YX).

adjacent(X,Y):-
	y_loc(X,XY),
	y_loc(Y,YY),
	X \= Y,
	1 is abs(XY - YY).

left_of(X,Y):-
	x_loc(X,XX),
	x_loc(Y,YX),
	X \= Y,
	XX < YX.

right_of(X,Y):-
	x_loc(X,XX),
	x_loc(Y,YX),
	X \= Y,
	XX > YX.

x_aligned(X,Y):-
	x_loc(X,XX),
	x_loc(Y,YX),
	X \= Y,
	XX = YX.

below(X,Y):-
	y_loc(X,XY),
	y_loc(Y,YY),
	X \= Y,
	XY < YY.

above(X,Y):-
	y_loc(X,XY),
	y_loc(Y,YY),
	X \= Y,
	XY > YY.

y_aligned(X,Y):-
	y_loc(X,XY),
	y_loc(Y,YY),
	X \= Y,
	XY = YY.

%% FIXES YAP RANDOM BUG
set_rand:-
  datime(datime(_,_Month,_Day,_H,Minute,Second)),
  X is Minute * Second,Y=X,Z=X,
  setrand(rand(X,Y,Z)).


