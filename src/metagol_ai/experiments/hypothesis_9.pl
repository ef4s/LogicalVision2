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
f2(A,B):-mv_backward(A,C),mv_left(C,B).
f1(A,B):-mv_left(A,C),mv_none(C,B).
test([(1,1,1/1),(2,1,0/1),(3,1,0/1),(4,1,-1/1),(5,1,-1/0),(6,1,-2/0),(7,1,-2/0),(8,1,-3/0),(9,1,-3/ -1),(10,1,-4/ -1),(11,1,-4/ -1),(12,1,-5/ -1),(13,1,-5/ -2),(14,1,-6/ -2),(15,1,-6/ -2),(16,1,-7/ -2),(17,1,-7/ -3)]).