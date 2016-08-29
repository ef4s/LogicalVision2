
named_shape(alien_rectangle,[0,80,160]).

process_file:-
    list_of_moves(alien_rectangle,L),
    open("strings.txt",append,Stream),
    writeln(Stream,l).


%write_buckets([B|T],List,[InStream|U],[OutStream|V]):-
%    write(InStream,'['),
%    div(List,B,L1,L2),
%    write(InStream,'t('), write(InStream,L1), writeln(InStream,",[])"),
%    write(OutStream,'t('), write(OutStream,L2), writeln(OutStream,"),[]"),
%    write_buckets_n(T,List,U,V).    
%    
%write_buckets_n([],_,[InStream],[OutStream]):-
%    writeln(InStream,"]"),
%    writeln(OutStream,"]").
%    
%write_buckets_n([B|T],List,[InStream|U],[OutStream|V]):-
%    div(List,B,L1,L2),
%    write(InStream,',t('), write(InStream,L1), writeln(InStream,")"),
%    write(OutStream,'t('), write(OutStream,L2), writeln(OutStream,"),[]"),
%    write_buckets_n(T,List,U,V).    

%n_buckets(_,0,[]).
%n_buckets(Frac,N,Buckets):-
%    A is N * F,
%    N2 is N - 1,    
%    n_buckets(Frac,N2,B2),
%    append(B2,[A],Buckets).

%div(L, N, A, B) :-
%    append(A, B, L),
%    length(A, N).

list_of_moves(Shape_name,List):-
    findall(Z,(frame(N,X),named_shape(Shape_name,Y),find_shape(X,Y,Z),writeln(N)),A),
    write("List length: "),length(A,L), write(L),nl,
    eat_shapes(A,List).

eat_shapes([_],[]).
eat_shapes([H1,H2|T],List):-
    find_move(H1,H2,M),
    eat_shapes([H2|T],L2),
    writeln(M),
    append(L2,[M],List).

find_move(S1,S2,'l'):-move_left(S1,S2).
find_move(S1,S2,'r'):-move_right(S1,S2).
find_move(S1,S2,'u'):-move_up(S1,S2).
find_move(S1,S2,'d'):-move_down(S1,S2).
find_move(_,_,'n').

move_left(shape([X1,_,_,_,_]),shape([X2,_,_,_,_])):-
    X1 > X2,
    Z is X1 - X2, 
    abs(Z) > 10.

move_right(shape([X1,_,_,_,_]),shape([X2,_,_,_,_])):-
    X1 < X2,
    Z is X1 - X2, 
    abs(Z) > 10.

move_up(shape([_,Y1,_,_,_]),shape([_,Y2,_,_,_])):-
    Y1 > Y2,
    Z is Y1 - Y2,
    abs(Z) > 10.

move_down(shape([_,Y1,_,_,_]),shape([_,Y2,_,_,_])):-
    Y1 < Y2,
    Z is Y1 - Y2,
    abs(Z) > 10.
    

find_shape([H|T],Shape,New_Shape):-
    (similar_shape(H,Shape)->New_Shape = H;find_shape(T,Shape,New_Shape)).   
    
similar_shape(shape([_,_,A1,W1,H1]),[A2,W2,H2]):-
    similar_angle(A1,A2),
    similar_size([W1,H1],[W2,H2]).        
    
similar_angle(A1,A2):-
    30 > abs(A1 - A2). 
    
similar_size([W1,H1],[W2,H2]):-
    area(W1,H1,A1),
    area(W2,H2,A2),
    A1 * 0.05 > abs(A1 - A2).
    
area(W,H,A):- A is W * H.

shape_areas([]).
shape_areas([shape([_,_,_,W,H])|T]):-
    area(W,H,A),
    writeln(A),
    shape_areas(T).



