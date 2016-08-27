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
metarule([P,Q],([P,A]:-[[Q,A,_]])).
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

% EXTRACT OUT SIMILAR SHAPES
    % WHAT SIZE IS SPACE INVADERS?

% GIVE THEM TO METAGOL

% SEE WHAT HAPPENS?

named_shape(alien_rectangle,[_,_,0,160,400]).
%a :-
%  Pos = [t(Input,S)],
%  Neg = [],
%  learn(Pos,Neg,H),
%  pprint(H).

move_left(shape([X1,_,_,_,_]),shape([X2,_,_,_,_])):-
    X1 > X2.

move_right(shape([X1,_,_,_,_]),shape([X2,_,_,_,_])):-
    X1 < X2.

move_up(shape([_,Y1,_,_,_]),shape([_,Y2,_,_,_])):-
    Y1 > Y2.

move_down(shape([_,Y1,_,_,_]),shape([_,Y2,_,_,_])):-
    Y1 < Y2.

find_shape([H|T],Shape,New_Shape):-
    (similar_shape(H,Shape)->New_Shape = H;find_shape(T,Shape,New_Shape)).   
    
similar_shape(shape([_,_,A1,W1,H1]),named_shape(_,[_,_,A2,W2,H2])):-
    writeln("TESTING"),
    similar_angle(A1,A2),writeln("SIMILAR ANGLE"),
    similar_size([W1,H1],[W2,H2]),writeln("SIMILAR SIZE").        
    
similar_angle(A1,A2):-
    write(A1),write(" vs "),write(A2),
    30 > abs(A1 - A2). 
    
similar_size([W1,H1],[W2,H2]):-
    area(W1,H1,A1),
    area(W2,H2,A2),
    5 > abs(A1 - A2).
    
area(W,H,A):- A is W * H.

shape_areas([]).
shape_areas([shape([_,_,_,W,H])|T]):-
    area(W,H,A),
    writeln(A),
    shape_areas(T).


