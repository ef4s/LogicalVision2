:-['transitions'].
:-[common].

mv_forward((F1,Id,X/Y1),(F2,Id,X/Y2)):-
    writeln((F1,Id,X/Y1)),
    mv_forward_q((F1,Id,X/Y1),(F2,Id,X/Y2)).
    
mv_backward((F1,Id,X/Y1),(F2,Id,X/Y2)):-
    writeln((F1,Id,X/Y1)),
    mv_backward_q((F1,Id,X/Y1),(F2,Id,X/Y2)).
    
mv_right((F1,Id,X1/Y),(F2,Id,X2/Y)):-
    writeln((F1,Id,X1/Y)),
    mv_right_q((F1,Id,X1/Y),(F2,Id,X2/Y)).
    
mv_left((F1,Id,X1/Y),(F2,Id,X2/Y)):-
    writeln((F1,Id,X1/Y)),
    mv_left_q((F1,Id,X1/Y),(F2,Id,X2/Y)).
    
mv_none((F1,Id,X/Y),(F2,Id,X/Y)):-
    writeln((F1,Id,X/Y)),
    mv_none_q((F1,Id,X/Y),(F2,Id,X/Y)).
    
a:- 
    test(X),
    X = [H|_],
    last(X,L),
    assert(last_frame(L)),
    f([H],_),
    retract(last_frame(L)).


b:-(a;true),halt.
    
