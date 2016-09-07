:-['../eval_experiment'].
% clauses: 1 invented predicates: 0
% clauses: 2 invented predicates: 0
% clauses: 2 invented predicates: 1
f(A,B):-map(A,B,f1).
f1(A,B):-mv_backward(A,C),mv_none(C,B).
test([(1,1,1/1),(2,1,1/0),(3,1,1/0)]).