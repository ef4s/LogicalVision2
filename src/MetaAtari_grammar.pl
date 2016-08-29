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
  pos(Pos),  
  learn(Pos,[],H),
  pprint(H).

b:-
    ans(Pos),
    findall(X,(member(Pos,X),t(X)),Y),
    length(Y,L1),
    length(Pos,L2),
    write(L1),write(" of "),write(L2).
    

