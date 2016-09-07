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
test([(1,1,1/1),(2,1,1/1),(3,1,1/1),(4,1,1/1),(5,1,0/1),(6,1,0/1),(7,1,0/1),(8,1,0/1),(9,1,-1/1),(10,1,-1/1),(11,1,-1/1),(12,1,-1/1),(13,1,-2/1),(14,1,-2/1),(15,1,-2/1),(16,1,-2/1),(17,1,-3/1)]).