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
f1(A,B):-mv_left(A,C),mv_none(C,B).
test([(1,1,1/1),(2,1,1/2),(3,1,0/2),(4,1,0/2),(5,1,0/3),(6,1,-1/3),(7,1,-1/3),(8,1,-1/4),(9,1,-2/4),(10,1,-2/4),(11,1,-2/5),(12,1,-3/5),(13,1,-3/5)]).