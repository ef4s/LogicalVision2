:-['../eval_experiment'].
% clauses: 1 invented predicates: 0
% clauses: 2 invented predicates: 0
% clauses: 2 invented predicates: 1
% clauses: 3 invented predicates: 0
% clauses: 3 invented predicates: 1
% clauses: 3 invented predicates: 2
f(A,B):-map(A,B,f2).
f2(A,B):-mv_right(A,C),f1(C,B).
f1(A,B):-until(A,B,last_frame,mv_none).
test([(1,1,1/1),(2,1,1/2),(3,1,2/2),(4,1,2/2),(5,1,2/1)]).