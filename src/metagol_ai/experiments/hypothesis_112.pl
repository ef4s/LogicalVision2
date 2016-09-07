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
f3(A,B):-f2(A,C),f1(C,B).
f2(A,B):-f1(A,C),f1(C,B).
f1(A,B):-mv_forward(A,C),mv_none(C,B).
test([(1,1,1/1),(2,1,1/2),(3,1,1/2),(4,1,1/2),(5,1,1/3),(6,1,1/4),(7,1,1/4),(8,1,1/4),(9,1,1/5),(10,1,1/6),(11,1,1/6),(12,1,1/6),(13,1,1/7)]).