:-['../eval_experiment'].
% clauses: 1 invented predicates: 0
% clauses: 2 invented predicates: 0
% clauses: 2 invented predicates: 1
% clauses: 3 invented predicates: 0
% clauses: 3 invented predicates: 1
% clauses: 3 invented predicates: 2
% clauses: 4 invented predicates: 0
% clauses: 4 invented predicates: 1
% clauses: 4 invented predicates: 2
% clauses: 4 invented predicates: 3
f(A,B):-map(A,B,f3).
f3(A,B):-f2(A,C),f1(C,B).
f2(A,B):-mv_left(A,C),mv_left(C,B).
f1(A,B):-until(A,B,last_frame,mv_none).
test([(1,1,1/1),(2,1,1/1),(3,1,1/1),(4,1,0/1),(5,1,0/1),(6,1,0/1),(7,1,0/1),(8,1,-1/1),(9,1,-1/1)]).