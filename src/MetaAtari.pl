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

%% METARULES
%metarule([P,Q],([P,A]:-[[Q,A]])).
metarule([P,Q],([P,A]:-[[Q,A,B]])).
%metarule([P,Q,R],([P,A]:-[[Q,C],[R,A,C]])).
%metarule([P,Q,R],([P,A]:-[[Q,A,C],[R,C,B]])).

%metarule([P,Q],([P,A,B]:-[[Q,A]])).
%metarule([P,Q],([P,A,B]:-[[Q,A,B]])).
%metarule([P,Q,B],([P,A,B]:-[[Q,A,B]])).
%metarule([P,Q,A],([P,A,B]:-[[Q,A,B]])).
%metarule([P,Q,A,B],([P,A,B]:-[[Q,A,B]])).

% Chain Rule
%metarule([P,Q,R],([P,A,B]:-[[Q,C],[R,A,C]])).
%metarule([P,Q,R],([P,A,B]:-[[Q,A],[R,A,C]])).
%metarule([P,Q,R],([P,A,B]:-[[Q,A,C],[R,C,B]])).
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
shape(0,1,1).

S = [_,_,_,630,300].
a :-
  Pos = [t(Input,S)],
  Neg = [],
  learn(Pos,Neg,H),
  pprint(H).

move_left([X1,_,_,_,_],[X2,_,_,_,_]):-
    X1 > X2.

move_right([X1,_,_,_,_],[X2,_,_,_,_]):-
    X1 < X2.

move_up([_,Y1,_,_,_],[_,Y2,_,_,_]):-
    Y1 > Y2.

move_down([_,Y1,_,_,_],[_,Y2,_,_,_]):-
    Y1 < Y2.

new_shape(Shape):-
    shape(A1,W1,H1),
    similar_shape(Shape,[_,_,A1,W1,H1]).

new_shape(Shape):-assert(A1,W1,H1).

find_shape([H|T],Shape):-
    (similar_shape(H,Shape)->true;find_shape(T,Shape)).   
    
similar_shape([_,_,A1,W1,H1],[_,_,A2,W2,H2]):-
    similar_angle(A1,A2),
    similar_size([W1,H1],[W2,H2]).        
    
similar_angle(A1,A2):-
    30 > abs(A1 - A2). 
    
similar_size([W1,H1],[W2,H2]):-
    area(W1,H1,A1),
    area(W2,H2,A2),
    5 > abs(A1 - A2).
    
area(W,H,A):- A is W * H.



