:-['../eval_experiment'].
% clauses: 1 invented predicates: 0
% clauses: 2 invented predicates: 0
% clauses: 2 invented predicates: 1
% clauses: 3 invented predicates: 0
% clauses: 3 invented predicates: 1
% clauses: 3 invented predicates: 2
f(A,B):-map(A,B,f2).
f2(A,B):-f1(A,C),mv_forward(C,B).
f1(A,B):-mv_forward(A,C),mv_backward(C,B).
test([(1,1,1/1),(2,1,1/1),(3,1,1/1),(4,1,1/2)]).