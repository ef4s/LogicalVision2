:- use_module('../metagol/metagol').

%prim(member/2).
prim(similar_position/2).
prim(similar_angle/2).
prim(similar_size/2).
prim(left_of/2).
prim(right_of/2).
prim(above/2).
prim(below/2).



metarule([P,Q,B],([P,A,B]:-[@member(C,[0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1,2,3,4,5,10,25,50,75,100]),[Q,A,C]])). % chain
metarule([P,Q,R],([P,A,B]:-[@member(C,[0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1,2,3,4,5,10,25,50,75,100]),[Q,A,C],@member(B,[0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1,2,3,4,5,10,25,50,75,100]),[R,A,B]])). % chain
%metarule([P,Q,B],([P,A,B]:-[@member(B,[0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1,2,3,4,5,10,25,50,75,100]),[Q,A,B],[P,A,B]])). % tail rec

% Evaluate accuracy of learned rules

a :-
  Pos = [
            t([
                shape([86.74996185302734,104.84999084472656,0.0,9.299955368041992,5.29990291595459]),
                shape([85.82365417480469,104.75289154052734,-26.56427001953125,11.027507781982422,3.755342960357666])
            ],l),
            t([
                shape([137.64976501464844,8.899992942810059,-90.0,12.299957275390625,6.999965667724609]),
                shape([137.59988403320312,7.949998378753662,-90.0,12.599973678588867,6.899971961975098])
            ],d),
            t([
                shape([137.44985961914062,7.849997043609619,0.0,6.899971008300781,12.499967575073242]),
                shape([137.69976806640625,8.799991607666016,-90.0,12.199951171875,7.399965286254883])
            ],u),
            t([
                shape([50.149898529052734,186.15005493164062,-90.0,33.89995574951172,13.899566650390625]),
                shape([50.299869537353516,186.69998168945312,-90.0,33.199928283691406,13.59967041015625])
            ],n)
        ],  
  Neg = [t([
                shape([86.74996185302734,104.84999084472656,0.0,9.299955368041992,5.29990291595459]),
                shape([85.82365417480469,104.75289154052734,-26.56427001953125,11.027507781982422,3.755342960357666])
            ],r)],%[similar_shape(shape([63.67340850830078,36.375648498535156,-74.64968872070312,11.44216251373291,65.75463104248047]),shape([50.299869537353516,186.69998168945312,-90.0,33.199928283691406,13.59967041015625]))],
  learn(Pos,Neg,H),
  pprint(H).



% TELL ME SOMETHING ABOUT HOW THE SHAPE CHANGED
    
%similar_shape(shape([X1,Y1,A1,W1,H1]),shape([X2,Y2,A2,W2,H2])):-
%    similar_position([X1,Y1],[X2,Y2]),
%    similar_angle(A1,A2),
%    similar_size([W1,H1],[W2,H2]).        


% MOVEMENTS
left_of([shape([X1,_,_,_,_]),shape([X2,_,_,_,_])],DIST):-
    X is X1 - X2,
    X > 0, 
    DIST > X.
    
right_of([shape([X1,_,_,_,_]),shape([X2,_,_,_,_])],DIST):-
    X is X2 - X1,
    X > 0, 
    DIST > X.

above([shape([_,Y1,_,_,_]),shape([_,Y2,_,_,_])],DIST):-
    Y is Y2 - Y1,
    Y > 0, 
    DIST > Y.

below([shape([_,Y1,_,_,_]),shape([_,Y2,_,_,_])],DIST):-
    Y is Y1 - Y2,
    Y > 0, 
    DIST > Y.


% SIMILAR SHAPE IF NEAR BY AND SAME SIZE AND ORIENTATION
similar_position([shape([X1,Y1,_,_,_]),shape([X2,Y2,_,_,_])],DIST):-
    X is (X1 - X2)^2,
    Y is (Y1 - Y2)^2,
    sqrt(X + Y, C),
    C < DIST.
        
similar_angle([shape([_,_,A1,_,_]),shape([_,_,A2,_,_])],ANGLE):-
    ANGLE > abs(A1 - A2). 
    
similar_size([shape([_,_,_,W1,H1]),shape([_,_,_,W2,H2])],AREA):-
    area(W1,H1,A1),
    area(W2,H2,A2),
    A1 * AREA > abs(A1 - A2).
    
area(W,H,A):- A is W * H.





