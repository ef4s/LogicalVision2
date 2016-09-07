:-['metagol_ai'].
:-[common].
metagol:functional.

%metarule([P,Q],([P,A,B]:-[[Q,A,B]])).
%metarule([P,Q,R],([P,A,B]:-[[Q,A,C],[R,C,B]])).
metarule(map,[P,Q,F],([P,A,B]:-[[Q,A,B,F]]),PS):-
  Q=map,
  member(F/2,PS).

metarule(until,[P,Q,Cond,F],([P,A,B]:-[[Q,A,B,Cond,F]]),PS):-
  Q=until,
  member(Cond/2,PS),
  user:prim(Cond/2),
  member(F/2,PS).

%prim(same_type/2).
prim(stay_still/2).
%prim(move_up_left/2).
%prim(move_up_right/2).
%prim(move_down_left/2).
%prim(move_down_right/2).
%prim(move_left/2).
%prim(move_down_left/2).
prim(move_right/2).
%prim(move_up/2).
%prim(move_down/2).

term_gt(A,B):-
    member(shape(_,_,T),A),
    member(shape(_,_,T),B).

same_type(A,B):-
    shape(_,_,T) = A,
    shape(_,_,T) = B.
    
move_up_left(A,B):-
    move_up(A,B),
    move_left(A,B).

move_up_right(A,B):-
    move_up(A,B),
    move_right(A,B).

move_down_left(A,B):-
    move_down(A,B),
    move_left(A,B).

move_down_right(A,B):-
    move_down(A,B),
    move_right(A,B).

move_left(A,B):-
    ground(A),%ground(B),
%    same_type(A,B),
    shape(X,Y,T) = A,
    X1 is X - 1,
    shape(X1,Y,T) = B.
    
move_right(A,B):-
    ground(A),%ground(B),
%    same_type(A,B),
    shape(X,Y,T) = A,
    X1 is X + 1,
    shape(X1,Y,T) = B.

move_up(A,B):-
    ground(A),%ground(B),
    same_type(A,B),
    shape(X,Y,T) = A,
    Y1 is Y + 1,
    shape(X,Y1,T) = B.
    
move_down(A,B):-
    ground(A),%ground(B),
    same_type(A,B),
    shape(X,Y,T) = A,
    Y1 is Y - 1,
    shape(X,Y1,T) = B.
    
stay_still(A,B):-
    same_type(A,B),
    shape(X,Y,T) = A,
    shape(X,Y,T) = B.
    

% Given that the background is filled with frame(N,X) objects
% Grab two frames
% Find a shape in common
% Hypothesize a path for the shape in between
% Validate this against another example

get_two_frames(F1,F2):-
    F1 = frame(X1,Y1),
    F2 = frame(X2,Y2),
    X2 > X1.
    
% Find a shape in common
shape_in_common(F1,F2,S):-  
    frame(_,L1) = F1,
    frame(_,L2) = F2,
    %randomise(L1,L1)
    %randomise(L2,L2)
    find_shapes_in_common(L1,L2,[],[],S).
   
find_shapes_in_common([],_,_,_,[]).   

find_shapes_in_common([H1|L1],[H2|L2],R1,R2,S):-
    (similar_shape(H1,H2)->
        S is H1;
        append([H1],R1,NewR1),
        append([H2],R2,NewR2),
        find_shapes_in_common([H1|L1],L2,NewR1,NewR2,S)).
        
find_shapes_in_common([H1|L1],[],R1,R2,S):-
    find_shapes_in_common(L1,R2,R1,[],S).
   
find_shape(List,Shape,New_Shape, New_List):-
    find_shape(List,[],Shape, New_Shape, New_List).
    
find_shape([H|T],S,Shape,New_Shape,New_List):-
    (similar_shape(H,Shape)->
        New_Shape = H,
        append(S,T,New_List);
        append(S,[H],S2),
        find_shape(T,S2,Shape,New_Shape,New_List)).   

similar_shape(shape([X1,Y1,A1,W1,H1]),shape([X2,Y2,A2,W2,H2])):-
    similar_size([W1,H1],[W2,H2]).        

similar_size([W1,H1],[W2,H2]):-
    area(W1,H1,A1),
    area(W2,H2,A2),
    A1 * 0.05 > abs(A1 - A2).
    
area(W,H,A):- A is W * H.

% Hypothesize a path for the shape in between
%path(shape(X1,Y1,_,_,_),shape(X2,Y2,_,_,_),Path):-   
    
% Validate this against another example

c:-
    writeln('INITIALISING'),
    Pos = [shape(1,1,1),shape(1,1,1),shape(1,1,1)],
    Qos = [shape(4,1,1),shape(2,1,1),shape(3,1,1)],
%    Pos = [f(shape(1,1,1),shape(4,1,1)),
%            f(shape(1,1,1),shape(4,1,1)),
%            f(shape(1,1,1),shape(4,1,1)),
%            f(shape(1,1,1),shape(4,1,1))],
    
%    Pos = [f(shape(1,1,1),shape(1,1,1)),f(shape(1,1,1),shape(2,1,1)),f(shape(1,1,1),shape(2,1,1)),f(shape(1,1,1),shape(3,1,1)),f(shape(1,1,1),shape(4,1,1))],
    


    writeln('STARTING'),
    %Target is to learn f(A,B):-until(A,B,stay_still,move_right)
%    learn(Pos,[],G),
    learn([f(Pos,Qos)],[],G),
    writeln('DONE'),
    writeln('---'), 
    pprint(G).  

