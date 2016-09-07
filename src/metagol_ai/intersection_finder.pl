:-['metagol_ai'].
:-['transitions'].
:-['common'].

metagol:functional.
max_time(10000). % 10 seconds

last_frame((13,_,_)).
test([(1,1,1/1),(2,1,1/0),(3,1,1/0),(4,1,1/0),(5,1,1/ -1),(6,1,1/ -1),(7,1,1/ -1),(8,1,1/ -2),(9,1,1/ -2),(10,1,1/ -2),(11,1,1/ -3),(12,1,1/ -3),(13,1,1/ -3)]).

prim(test_hits/1).
prim(rotate_clockwise/2).
prim(rotate_anti_clockwise/2).
prim(do_nothing/2).

metarule(map,[P,Q,F],([P,A,B]:-[[Q,A,B,F]]),PS):-
  Q=map,
  member(F/2,PS).

metarule(until,[P,Q,Cond,F],([P,A,B]:-[[Q,A,B,Cond,F]]),PS):-
  Q=until,
  member(Cond/1,PS),
  user:prim(Cond/1),
  member(F/2,PS).
  
%metarule(until_2,[P,Q,Cond,F,R],([P,A,B]:-[[Q,A,C,Cond,F],[R,C,B]]),PS):-
%  Q=until,
%  member(Cond/1,PS),
%  user:prim(Cond/1),
%  member(F/2,PS).
  
metarule(chain,[P,Q,R],([P,A,B]:-[[Q,A,C],[R,C,B]])).

a:- 
    writeln('Starting'),
    fire_missile((1,1,1/1,0),P),
    writeln(P).

b:- 
    test_hits((4,1,1/3,4)).


f:-(e;true),halt.

e:-
    A = [(1,2,1/3,0),(1,2,1/(-3),4)],
    B = [(5,2,1/3,4),(5,2,1/(-3),0)],
    learn([f([A],[B])],[],G),
    %Target
%    f(A,B):-map(A,B,f1).
%    f1(A,B):-until(A,B,test_hits,rotate_clockwise).

    pprint(G).
c:- 
    A = (1,2,1/3,0),
    B = (5,2,1/3,4),
    learn([f([A],[B])],[],G),
    %Target
%    f(A,B):-map(A,B,f2).
%    f2(A,B):-f1(A,C),f1(C,B).
%    f1(A,B):-rotate_clockwise(A,C),rotate_clockwise(C,B).
    pprint(G).


test_hits((F,Id,X/Y,D)):-
    fire_missile((F,Id,X/Y,D),Path),
    test(TPath),
    intersects(Path,TPath).

intersects([],_):-false.
intersects([H|Path],Target_path):-
    approx_member(H,Target_path); intersects(Path,Target_path).

close_enough(X1/Y1,X2/Y2):-
    X is (X1 - X2)^2,
    Y is (Y1 - Y2)^2,
    Z is sqrt(X + Y),
    Z < 2.
    
approx_member((F1,_,L1), [(F2,_,L2)|T]):- 
    (F1 = F2, close_enough(L1,L2)); approx_member((F1,_,L1), T).

%Given a list of locations, whats the shortest path to intersection?
rotate_clockwise((F1,Id,X/Y,D1),(F2,Id,X/Y,D2)):-
    F2 is F1+1,
    D1 < 8,
    D2 is D1 +1.
%    D2 is mod(D1 + 1, 8).
    
rotate_anti_clockwise((F1,Id,X/Y,D1),(F2,Id,X/Y,D2)):-
    F2 is F1+1,
    D1 > 0,
    D2 is D1 - 1.
%    D2 is mod(D1 - 1, 8).
    
fire_missile((F,Id,X/Y,D),Path):-   
    (test_maxframes(F)->
        move_direction((F,Id,X/Y,D),(F2,Id,X2/Y2)),
        fire_missile((F2,Id,X2/Y2,D),Path2),
        append([(F2,Id,X2/Y2)],Path2,Path);
        Path = []).

do_nothing((F1,Id,X/Y,D),(F2,Id,X/Y,D)):-F2 is F1 + 1.

move_direction((F1,Id,X1/Y1,0),(F2,Id,X2/Y2)):-
    % Top
    F2 is F1 + 1,
    X2 is X1,
    Y2 is Y1 + 1.
    
move_direction((F1,Id,X1/Y1,1),(F2,Id,X2/Y2)):-
    % Top Right
    F2 is F1 + 1,
    X2 is X1 + 1,
    Y2 is Y1 + 1.
    
move_direction((F1,Id,X1/Y1,2),(F2,Id,X2/Y2)):-
    % Right
    F2 is F1 + 1,
    X2 is X1 + 1,
    Y2 is Y1.
    
move_direction((F1,Id,X1/Y1,3),(F2,Id,X2/Y2)):-
    % Bottom Right
    F2 is F1 + 1,
    X2 is X1 - 1,
    Y2 is Y1 + 1.
    
move_direction((F1,Id,X1/Y1,4),(F2,Id,X2/Y2)):-
    % Bottom
    F2 is F1 + 1,
    X2 is X1,
    Y2 is Y1 - 1.
    
move_direction((F1,Id,X1/Y1,5),(F2,Id,X2/Y2)):-
    % Bottom Left
    F2 is F1 + 1,
    X2 is X1 - 1,
    Y2 is Y1 - 1.
    
move_direction((F1,Id,X1/Y1,6),(F2,Id,X2/Y2)):-
    % Left
    F2 is F1 + 1,
    X2 is X1 - 1,
    Y2 is Y1.
    
move_direction((F1,Id,X1/Y1,7),(F2,Id,X2/Y2)):-
    % Top Left
    F2 is F1 + 1,
    X2 is X1 - 1,
    Y2 is Y1 + 1.

%term_gt(A,B):-  
%   do_nothing(A,B).
 
term_gt(A,B):-  
   rotate_clockwise(A,B).
   
%term_gt(A,B):-  
%   rotate_anti_clockwise(A,B).
