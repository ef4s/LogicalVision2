:-['metagol_ai'].
:-[common].

%% METAGOL SETTINGS
%target(chess).
metagol:functional.

prim(last_frame/1).
prim(mv_forward/2).
prim(mv_backward/2).
prim(mv_right/2).
prim(mv_left/2).
prim(mv_none/2).

metarule(map,[P,Q,F],([P,A,B]:-[[Q,A,B,F]]),PS):-
  Q=map,
  member(F/2,PS).

metarule(until,[P,Q,Cond,F],([P,A,B]:-[[Q,A,B,Cond,F]]),PS):-
  Q=until,
  member(Cond/1,PS),
  user:prim(Cond/1),
  member(F/2,PS).
  
metarule(chain,[P,Q,R],([P,A,B]:-[[Q,A,C],[R,C,B]])).

a:-
    last_frame((F,_,_)),
    A = [(1,1,1/1)],
    B = [(F,1,13/1)],
    writeln(A),writeln('----'),writeln(B),
    learn([f(A,B)],[],G),
    writeln('----'),
    pprint(G).

b:-
    last_frame((F,_,_)),
    A = [(1,1,1/1),(5,2,5/1),(10,3,10/1)],
    B = [(F,1,10/1),(F,2,10/1),(F,3,10/1)],
    writeln(A),writeln('----'),writeln(B),
    learn([f(A,B)],[],G),
    writeln('----'),
    pprint(G).



%% COMPILED FIRST-ORDER BACKGROUND KNOWLEDGE
last_frame((13,_,_)).


test_maxframes(F1):-
    last_frame((Max_frames,_,_)),
    F1 < Max_frames.
    
mv_forward((F1,Id,X/Y1),(F2,Id,X/Y2)):-
    test_maxframes(F1),
    mv_forward_r((F1,Id,X/Y1),(F2,Id,X/Y2)).
    
mv_forward_r((F1,Id,X/Y1),(F2,Id,X/Y2)):-
    F2 is F1+1,   
    Y2 is Y1+1.
    
mv_backward((F1,Id,X/Y1),(F2,Id,X/Y2)):-
    test_maxframes(F1),
    mv_backward_r((F1,Id,X/Y1),(F2,Id,X/Y2)).
    
mv_backward_r((F1,Id,X/Y1),(F2,Id,X/Y2)):-
    F2 is F1 + 1,   
    Y2 is Y1-1.

mv_right((F1,Id,X1/Y),(F2,Id,X2/Y)):-
    test_maxframes(F1),
    mv_right_r((F1,Id,X1/Y),(F2,Id,X2/Y)).
    
mv_right_r((F1,Id,X1/Y),(F2,Id,X2/Y)):-
    F2 is F1 + 1,
    X2 is X1+1.
    
mv_left((F1,Id,X1/Y),(F2,Id,X2/Y)):-
    test_maxframes(F1),
    mv_left_r((F1,Id,X1/Y),(F2,Id,X2/Y)).

mv_left_r((F1,Id,X1/Y),(F2,Id,X2/Y)):-
    F2 is F1 + 1,
    X2 is X1-1.
    
%mv_forward((F1,Id,X/Y1),(F2,Id,X/Y2)):-
%    last_frame((Max_frames,_,_)),
%    F1 < Max_frames,
%    F2 is F1 + 1,   
%    Y2 is Y1+1.
%    
%mv_backward((F1,Id,X/Y1),(F2,Id,X/Y2)):-
%    last_frame((Max_frames,_,_)),
%    F1 < Max_frames,
%    F2 is F1 + 1,   
%    Y2 is Y1-1.
  
%mv_right((F1,Id,X1/Y),(F2,Id,X2/Y)):-
%    last_frame((Max_frames,_,_)),
%    F1 < Max_frames,
%    F2 is F1 + 1,
%    X2 is X1+1.
    
%mv_left((F1,Id,X1/Y),(F2,Id,X2/Y)):-
%    last_frame((Max_frames,_,_)),
%    F1 < Max_frames,
%    F2 is F1 + 1,
%    X2 is X1-1.
    
mv_none((F1,Id,X/Y),(F2,Id,X/Y)):-
    last_frame((Max_frames,_,_)),
    F1 < Max_frames,
    F2 is F1 + 1.
 
term_gt(A,B):-  
   mv_forward(A,B).
   
term_gt(A,B):-  
   mv_backward(A,B).

term_gt(A,B):-  
   mv_right(A,B).
   
term_gt(A,B):-  
   mv_left(A,B).
   
term_gt(A,B):-  
   mv_none(A,B).

%term_gt((F1,Id,X/Y),(F2,Id,X/Y)):-
%    F2 is F1 + 1.   
%    
%term_gt((F1,Id,X1/Y),(F2,Id,X2/Y)):-
%    F2 is F1 + 1,
%    X2 is X1 + 1.   

%term_gt((F1,Id,X/Y1),(F2,Id,X/Y2)):-
%    F2 is F1 + 1,
%    Y2 is Y1 + 1.  
%    
%term_gt((F1,Id,X1/Y1),(F2,Id,X2/Y2)):-
%    F2 is F1 + 1,
%    X2 is X1 + 1,
%    Y2 is Y1 + 1.  
%    
% 

