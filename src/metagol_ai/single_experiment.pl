:-['metagol_ai'].
:-['transitions'].
:-[common].

metagol:functional.
max_time(10000). % 10 seconds

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
    assert(last_frame((13,_,_))),
    A = [(1,1,1/1)],
    B = [(13,1,13/1)],
    writeln(A),writeln('----'),writeln(B),writeln('----'),last_frame(X),writeln(X),
    learn([f(A,B)],[],G),
    writeln('----'),
    pprint(G),
    retract(last_frame((13,_,_))).

b:-
    assert(last_frame((13,_,_))),
    A = [(1,1,1/1),(5,2,5/1),(10,3,10/1)],
    B = [(13,1,10/1),(13,2,10/1),(13,3,10/1)],
    writeln(A),writeln('----'),writeln(B),writeln('----'),last_frame(X),writeln(last_frame(X)),
    learn([f(A,B)],[],G),
    writeln('----'),
    pprint(G),
    retract(last_frame((13,_,_))).

f:-(e;true),halt.

e:-
    set_rand,
    create_example(E,P),
    create_destinations(E,D),
    last(E,Last),
    assert(last_frame(Last)),   
    E = [A|_],
    last(D,B),
    learn([f([A],[B])],[],G),

    pprint(G),
    format('test(~w).',[E]),
    
    retract(last_frame(Last)).
    
create_destinations(E,D):-
    last(E,Dest),
    length(E,N),
    repeat_list(Dest,N,D).

repeat_list(D,1,[D]).
repeat_list(Dest,N,D):-
    N2 is N - 1, 
    repeat_list(Dest,N2,D2),
    append(D2,[Dest],D).

create_example(E,P):- 
    random(1,5,L),
    create_pattern(L,P),
    random(1,5,N),
    M is L * N,
    create_examples(M,P,E).

create_examples(N,P,E):-
    create_examples(N,P,[],E).
create_examples(0,_,_,[(1,1,1/1)]).
create_examples(N,[],R,E):-
    create_examples(N,R,[],E).
create_examples(N,[H|P],R,E):-
    N2 is N - 1,
    append(R,[H],R2),
    create_examples(N2,P,R2,E2),
    last(E2,Eh),
    call(H,Eh,En),
    append(E2,[En],E).
    
create_pattern(0,[]).
create_pattern(N,P):-
    N2 is N - 1,
    create_pattern(N2,P2),
    random(1,10,R),
    (R = 1 ->
        M = mv_forward_r;
        (R = 2 ->
            M = mv_backward_r;
            (R = 3 ->
                M = mv_left_r;
                (R = 4 ->
                    M = mv_right_r;
                    M = mv_none_r
                )
            )
        )
    ),
    append([M],P2,P).

mv_forward((F1,Id,X/Y1),(F2,Id,X/Y2)):-
    mv_forward_q((F1,Id,X/Y1),(F2,Id,X/Y2)).
    
mv_backward((F1,Id,X/Y1),(F2,Id,X/Y2)):-
    mv_backward_q((F1,Id,X/Y1),(F2,Id,X/Y2)).
    
mv_right((F1,Id,X1/Y),(F2,Id,X2/Y)):-
    mv_right_q((F1,Id,X1/Y),(F2,Id,X2/Y)).
    
mv_left((F1,Id,X1/Y),(F2,Id,X2/Y)):-
    mv_left_q((F1,Id,X1/Y),(F2,Id,X2/Y)).
    
mv_none((F1,Id,X/Y),(F2,Id,X/Y)):-
    mv_none_q((F1,Id,X/Y),(F2,Id,X/Y)).

    
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

        
