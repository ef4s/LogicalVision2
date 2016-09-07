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
f4(A,B):-f3(A,C),f2(C,B).
f3(A,B):-f1(A,C),f1(C,B).
f1(A,B):-mv_forward(A,C),mv_forward(C,B).
f2(A,B):-until(A,B,last_frame,mv_none).
test([(1,1,1/1),(2,1,1/1),(3,1,1/1),(4,1,1/2),(5,1,1/2),(6,1,1/2),(7,1,1/2),(8,1,1/3),(9,1,1/3),(10,1,1/3),(11,1,1/3),(12,1,1/4),(13,1,1/4),(14,1,1/4),(15,1,1/4),(16,1,1/5),(17,1,1/5)]).