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
f1(A,B):-mv_left(A,C),mv_left(C,B).
f2(A,B):-until(A,B,last_frame,mv_none).
test([(1,1,1/1),(2,1,1/0),(3,1,0/0),(4,1,0/0),(5,1,0/1),(6,1,0/0),(7,1,-1/0),(8,1,-1/0),(9,1,-1/1),(10,1,-1/0),(11,1,-2/0),(12,1,-2/0),(13,1,-2/1),(14,1,-2/0),(15,1,-3/0),(16,1,-3/0),(17,1,-3/1)]).