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
f3(A,B):-f2(A,C),f2(C,B).
f2(A,B):-f1(A,C),mv_forward(C,B).
f1(A,B):-mv_backward(A,C),mv_backward(C,B).
test([(1,1,1/1),(2,1,1/0),(3,1,1/1),(4,1,1/0),(5,1,1/ -1),(6,1,1/0),(7,1,1/ -1)]).