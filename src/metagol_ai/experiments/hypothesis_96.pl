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
f(A,B):-map(A,B,f4).
f4(A,B):-f3(A,C),f3(C,B).
f3(A,B):-f2(A,C),f2(C,B).
f2(A,B):-f1(A,C),mv_forward(C,B).
f1(A,B):-mv_backward(A,C),mv_backward(C,B).
test([(1,1,1/1),(2,1,1/0),(3,1,1/0),(4,1,1/0),(5,1,1/ -1),(6,1,1/ -1),(7,1,1/ -1),(8,1,1/ -2),(9,1,1/ -2),(10,1,1/ -2),(11,1,1/ -3),(12,1,1/ -3),(13,1,1/ -3)]).