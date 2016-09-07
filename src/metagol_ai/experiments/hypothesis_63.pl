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
% clauses: 5 invented predicates: 0
% clauses: 5 invented predicates: 1
% clauses: 5 invented predicates: 2
% clauses: 5 invented predicates: 3
% clauses: 5 invented predicates: 4
% clauses: 6 invented predicates: 0
% clauses: 6 invented predicates: 1
% clauses: 6 invented predicates: 2
% clauses: 6 invented predicates: 3
% clauses: 6 invented predicates: 4
f(A,B):-map(A,B,f4).
f4(A,B):-until(A,B,last_frame,f3).
f3(A,B):-f2(A,C),f2(C,B).
f2(A,B):-f1(A,C),f1(C,B).
f1(A,B):-mv_forward(A,C),mv_left(C,B).
f1(A,B):-until(A,B,last_frame,mv_backward).
test([(1,1,1/1),(2,1,0/1),(3,1,0/1),(4,1,0/1),(5,1,0/0),(6,1,-1/0),(7,1,-1/0),(8,1,-1/0),(9,1,-1/ -1),(10,1,-2/ -1),(11,1,-2/ -1),(12,1,-2/ -1),(13,1,-2/ -2)]).