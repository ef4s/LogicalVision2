:-['../eval_experiment'].
% clauses: 1 invented predicates: 0
% clauses: 2 invented predicates: 0
% clauses: 2 invented predicates: 1
f(A,B):-map(A,B,f1).
f1(A,B):-until(A,B,last_frame,mv_none).
test([(1,1,1/1),(2,1,1/1),(3,1,2/1),(4,1,1/1),(5,1,1/1),(6,1,2/1),(7,1,1/1),(8,1,1/1),(9,1,2/1),(10,1,1/1)]).