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
% clauses: 6 invented predicates: 0
% clauses: 6 invented predicates: 1
% clauses: 6 invented predicates: 2
% clauses: 6 invented predicates: 3
% clauses: 6 invented predicates: 4
% clauses: 6 invented predicates: 5
f(A,B):-map(A,B,f5).
f5(A,B):-f4(A,C),f4(C,B).
f4(A,B):-f3(A,C),f3(C,B).
f3(A,B):-f2(A,C),f1(C,B).
f2(A,B):-mv_forward(A,C),mv_forward(C,B).
f1(A,B):-mv_backward(A,C),mv_left(C,B).
test([(1,1,1/1),(2,1,0/1),(3,1,0/1),(4,1,0/1),(5,1,0/2),(6,1,-1/2),(7,1,-1/2),(8,1,-1/2),(9,1,-1/3),(10,1,-2/3),(11,1,-2/3),(12,1,-2/3),(13,1,-2/4),(14,1,-3/4),(15,1,-3/4),(16,1,-3/4),(17,1,-3/5)]).