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
prim(linked/2).
prim(destroyed/1).

%% METARULES
metarule([P,Q],([P,A]:-[[Q,A]])).
metarule([P,Q],([P,A,B]:-[[Q,A]])).
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
%metarule([P,Q,A,B],([P,[A|B]]:-[[Q,A,C],@term_gt(A,C),[P,C,B],@term_gt(C,B)])). 
*/
a :-
  Pos = [f(destroyed(a))],
  Neg = [],
  learn(Pos,Neg,H),
  pprint(H).


%% FIRST-ORDER BACKGROUND KNOWLEDGE
pix(a). pix(b). missile(c). touched(b, c).
destroyed(X):-pix(X),missile(Y),touched(X,Y).
destroyed(X):-pix(X),destroyed(Y),linked(X,Y).

% The transition function f, given the new background information, should output the new that a has also been destroyed.
%f(destroyed(a)):-linked(a,b).


%% FIXES YAP RANDOM BUG
set_rand:-
  datime(datime(_,_Month,_Day,_H,Minute,Second)),
  X is Minute * Second,Y=X,Z=X,
  setrand(rand(X,Y,Z)).


