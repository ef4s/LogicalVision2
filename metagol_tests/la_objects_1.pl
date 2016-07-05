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
prim(x_adjacent/2).
prim(y_adjacent/2).

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
:- dynamic pix/1.
:- dynamic x_loc/2.
:- dynamic y_loc/2.
space_filler(z).
pix(a). 
pix(b). 
pix(c). 
pix(d).
pix(e). 
pix(f). 
pix(g).  
pix(h).
pix(i).  
pix(j).  
pix(k).
pix(l).  

pix(m).  
pix(n).  
pix(o).  
pix(p).  

pix(q).  
pix(r).  
pix(s).  
pix(t).  
      
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
x_loc(i,3).
y_loc(i,6).
x_loc(j,4).
y_loc(j,6).
x_loc(k,5).
y_loc(k,6).
x_loc(l,6).
y_loc(l,6).

x_loc(m,8).
y_loc(m,7).
x_loc(n,8).
y_loc(n,6).
x_loc(o,8).
y_loc(o,5).
x_loc(p,9).
y_loc(p,6).

x_loc(q,2).
y_loc(q,9).
x_loc(r,2).
y_loc(r,8).
x_loc(s,1).
y_loc(s,8).
x_loc(t,1).
y_loc(t,7).

%  1,2,3,4,5,6,7,8 9
%9 . q . . . . . . .
%8 s r . . . . . . .
%7 t . . . . . . m .
%6 . . i j k l . n p
%5 . . . . . . . o .
%4 . . a b . . . . .
%3 . . d c . . . . .
%2 . . . . . e f g .
%1 . . . . . h . . .

l_shape(X):-y_adjacent(A,B),x_adjacent(B,C),x_adjacent(C,D), all_unique([A,B,C,D]), X = [A,B,C,D].
l_shape(X):-y_adjacent(A,B),y_adjacent(B,C),x_adjacent(C,D), all_unique([A,B,C,D]), X = [A,B,C,D].
line(X):-y_adjacent(A,B),y_adjacent(B,C),y_adjacent(C,D), all_unique([A,B,C,D]), X = [A,B,C,D].
line(X):-x_adjacent(A,B),x_adjacent(B,C),x_adjacent(C,D), all_unique([A,B,C,D]),  X = [A,B,C,D].
square(X):-x_adjacent(A,B),y_adjacent(A,C),x_adjacent(C,D), y_adjacent(B,D), all_unique([A,B,C,D]), X = [A,B,C,D].
t_shape(X):-x_adjacent(A,B),x_adjacent(B,C),y_adjacent(B,D), all_unique([A,B,C,D]), X = [A,B,C,D].
t_shape(X):-y_adjacent(A,B),y_adjacent(B,C),x_adjacent(B,D), all_unique([A,B,C,D]), X = [A,B,C,D].
z_shape(X):-y_adjacent(A,B),x_adjacent(B,C),y_adjacent(C,D), not(x_adjacent(A,D)), all_unique([A,B,C,D]), X = [A,B,C,D].
z_shape(X):-x_adjacent(A,B),y_adjacent(B,C),x_adjacent(C,D), not(y_adjacent(A,D)), all_unique([A,B,C,D]), X = [A,B,C,D].

object(Y):-l_shape(Y),assert(p_l_shape(Y)).%, retract_in(Y).
object(Y):-line(Y),assert(p_line(Y)).%, retract_in(Y).
object(Y):-square(Y),assert(p_square(Y)).%	, retract_in(Y).

retract_pix(H):-retract(pix(H)), retract(y_loc(H,_)), retract(x_loc(X,_)).
retract_in([H|T]):-retract_pix(H), retract_in(T).
retract_in([]).

all_unique([H|T]):-not(member(H,T)),all_unqiue(T).
all_unique([]).

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

b(Objs) :- findall(O, object(O), Objs).

%% FIXES YAP RANDOM BUG
set_rand:-
  datime(datime(_,_Month,_Day,_H,Minute,Second)),
  X is Minute * Second,Y=X,Z=X,
  setrand(rand(X,Y,Z)).


