:- use_module('../metagol/metagol').

prim(move_down/2).
prim(move_left/2).
prim(move_right/2).

move_down(['d'|T],T).
move_left(['l'|T],T).
move_right(['r'|T],T).

metarule([P,Q,R],([P,A,B]:-[[Q,A,C],[R,C,B]])). % chain
metarule([P,Q,R],([P,A,B]:-[[Q,A],[R,A,B]])). % precon
metarule([P,Q],([P,A,B]:-[[Q,A,C],[P,C,B]])). % tail rec

% Evaluate accuracy of learned rules


a :-
  Pos = [
    t(['l','l','l','d','r','r','r'],[]),
    t(['l','l','l','d','r','r','r','d','l','l','l','d','r','r','r'],[]),
    t(['r','r','r','d','l','l','l','d','r','r','r'],[])
  ],
  
  learn(Pos,[],H),
  pprint(H).


