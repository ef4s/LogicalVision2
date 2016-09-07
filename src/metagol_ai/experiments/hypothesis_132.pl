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
f2(A,B):-mv_forward(A,C),mv_backward(C,B).
f1(A,B):-mv_backward(A,C),mv_right(C,B).
test([(1,1,1/1),(2,1,1/0),(3,1,1/0),(4,1,1/0),(5,1,2/0)]).