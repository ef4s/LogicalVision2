test_maxframes(F1):-
    last_frame((Max_frames,_,_)),
    F1 < Max_frames.
    
mv_forward_q((F1,Id,X/Y1),(F2,Id,X/Y2)):-
    test_maxframes(F1),
    mv_forward_r((F1,Id,X/Y1),(F2,Id,X/Y2)).

    
mv_backward_q((F1,Id,X/Y1),(F2,Id,X/Y2)):-
    test_maxframes(F1),
    mv_backward_r((F1,Id,X/Y1),(F2,Id,X/Y2)).
    
mv_right_q((F1,Id,X1/Y),(F2,Id,X2/Y)):-
    test_maxframes(F1),
    mv_right_r((F1,Id,X1/Y),(F2,Id,X2/Y)).
    
mv_left_q((F1,Id,X1/Y),(F2,Id,X2/Y)):-
    test_maxframes(F1),
    mv_left_r((F1,Id,X1/Y),(F2,Id,X2/Y)).
    
mv_none_q((F1,Id,X/Y),(F2,Id,X/Y)):-
    test_maxframes(F1),
    mv_none_r((F1,Id,X/Y),(F2,Id,X/Y)).

mv_forward_r((F1,Id,X/Y1),(F2,Id,X/Y2)):-
    F2 is F1+1,   
    Y2 is Y1+1.
    
mv_backward_r((F1,Id,X/Y1),(F2,Id,X/Y2)):-
    F2 is F1 + 1,   
    Y2 is Y1-1.
    
mv_right_r((F1,Id,X1/Y),(F2,Id,X2/Y)):-
    F2 is F1 + 1,
    X2 is X1+1.
    
mv_left_r((F1,Id,X1/Y),(F2,Id,X2/Y)):-
    F2 is F1 + 1,
    X2 is X1-1.
    
mv_none_r((F1,Id,X/Y),(F2,Id,X/Y)):-
    F2 is F1 + 1.
