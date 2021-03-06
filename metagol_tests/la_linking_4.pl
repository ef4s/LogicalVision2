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
%prim(linked/2).
prim(alien/1).
prim(missile/1).
prim(wall/1).
prim(not_wall/1).
prim(space_filler/1).
%prim(missile/1).
%prim(pix/1).
%prim(destroyed/2).
%prim(n_contained/2).

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
  Pos = [destroyed(b,z),destroyed(c,z)],
  Neg = [destroyed(a,z),destroyed(w,z)],
  learn(Pos,Neg,H),
  pprint(H).


%% FIRST-ORDER BACKGROUND KNOWLEDGE
space_filler(z).
alien(a). 
alien(b). 
alien(c). 
wall(w).
missile(m). 
touched(b,m).
touched(c,m).
touched(w,m).
touched(a,w).

not_wall(W):-not(wall(W)).
%linked(X,Y).
%touched(X,Y).
n_contained(X,Y):-
	bagof(Z, contains(X,Z), ZZ),
	length(ZZ,Y).

%% FIXES YAP RANDOM BUG
set_rand:-
  datime(datime(_,_Month,_Day,_H,Minute,Second)),
  X is Minute * Second,Y=X,Z=X,
  setrand(rand(X,Y,Z)).


