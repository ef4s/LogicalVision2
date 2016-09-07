:-['example_objects'].
%[(1,1,1/1),(2,1,2/1),(3,1,2/1),(4,1,2/1),(5,1,3/1),(6,1,3/1),(7,1,3/1),(8,1,4/1),(9,1,4/1)]
%----
%[mv_none_r,mv_right_r,mv_none_r]
%----
%1,1,1/1
%----
%9,1,4/1
%----
%last_frame((9,1,4/1))
%% clauses: 1 invented predicates: 0
%% clauses: 2 invented predicates: 0
%% clauses: 2 invented predicates: 1
%% clauses: 3 invented predicates: 0
%% clauses: 3 invented predicates: 1
%% clauses: 3 invented predicates: 2
%% clauses: 4 invented predicates: 0
%% clauses: 4 invented predicates: 1
%% clauses: 4 invented predicates: 2
%% clauses: 4 invented predicates: 3
%----

f(A,B):-writeln(A),f3(A,C),writeln(C),f2(C,B),writeln(B).
f3(A,B):-f2(A,C),f1(C,B),writeln(C).
f2(A,B):-f1(A,C),mv_none(C,B),writeln(C).
f1(A,B):-mv_right(A,C),mv_none(C,B),writeln(C).

test([(1,1,1/1),(2,1,2/1),(3,1,2/1),(4,1,2/1),(5,1,3/1),(6,1,3/1),(7,1,3/1),(8,1,4/1),(9,1,4/1)]).

a:-  
    test(X),
    X = [H|_],
    last(X,L),
    assert(last_frame(L)),
    f(H,Y), 
    retract(last_frame(L)).

    
