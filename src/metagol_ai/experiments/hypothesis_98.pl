:-['../eval_experiment'].
% clauses: 1 invented predicates: 0
% clauses: 2 invented predicates: 0
% clauses: 2 invented predicates: 1
% clauses: 3 invented predicates: 0
% clauses: 3 invented predicates: 1
% clauses: 3 invented predicates: 2
f(A,B):-map(A,B,f2).
f2(A,B):-f1(A,C),f1(C,B).
f1(A,B):-mv_backward(A,C),mv_left(C,B).
test([(1,1,1/1),(2,1,0/1),(3,1,0/0),(4,1,-1/0),(5,1,-1/ -1)]).