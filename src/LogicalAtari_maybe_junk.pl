
find_line(Bounds,Z,Mag_seq_add,Dir_seq_add,Line):-
    writeln("Entering find_line"),
    random_line_sample(Bounds,Z,Mag_seq_add,Dir_seq_add,P1),
    writeln("First line sample"),
    find_line(P1,Bounds,Z,Mag_seq_add,Dir_seq_add,Line).

find_line(P1,Bounds,Z,Mag_seq_add,Dir_seq_add,Line):-
    writeln("Entering find_line_2"),
    random_line_sample(Bounds,Z,Mag_seq_add,Dir_seq_add,P2),
    writeln("Second line sample"),
    (line(P1,P2,Mag_seq_add,Dir_seq_add) ->  
        writeln("TRUE"),
        line_extend(P1,P2,Bounds,Mag_seq_add,Dir_seq_add,Q1,Q2),
        Line = [Q1,Q2];
%        Line = [P1,P2];
        writeln("FALSE"),
        find_line(Bounds,Z,Mag_seq_add,Dir_seq_add,Line)).


%find_square(Pts,Mag_add,Dir_add,Square):-
%    [P1,P2,P3,P4] = Pts,
%    line(P1,P2,Mag_add,Dir_add),
%    line(P1,P4,Mag_add,Dir_add),
%    corner(P1,P2,P4,Mag_add,Dir_add),
%    line(P2,P3,Mag_add,Dir_add),
%    corner(P2,P1,P3,Mag_add,Dir_add),
%    line(P3,P4,Mag_add,Dir_add),
%    corner(P3,P2,P4,Mag_add,Dir_add),
%    corner(P4,P1,P3,Mag_add,Dir_add),
%    Square = [P1,P2,P3,P4].
    
%find_square(Bounds,Z,Mag_seq_add,Dir_seq_add,Square):-
%    find_line(Bounds,Z,Mag_seq_add,Dir_seq_add,[P1,P2]),
%    find_line(P1,Bounds,Z,Mag_seq_add,Dir_seq_add,[P1,P3]),
%    find_line(P2,Bounds,Z,Mag_seq_add,Dir_seq_add,[P2,P4]),
%    line(P3,P4,Mag_seq_add,Dir_seq_add),
%    Square = [P1,P2,P3,P4].

find_square(Bounds,Z,Mag_seq_add,Dir_seq_add,Square):-
    mindist(MinDist),
    find_line(Bounds,Z,Mag_seq_add,Dir_seq_add,[P1,P2]),
    find_line(Bounds,Z,Mag_seq_add,Dir_seq_add,[Q1,Q3]),
    adjacent(P1,Q1,MinDist),
    find_line(Bounds,Z,Mag_seq_add,Dir_seq_add,[R2,R4]),
    adjacent(P2,R2,MinDist),
    find_line(Bounds,Z,Mag_seq_add,Dir_seq_add,[S3,S4]),
    adjacent(Q3,S3,MinDist),
    adjacent(R4,S4,MinDist),
    Square = [P1,P2,Q1,Q3,R2,R4,S3,S4].

corner(C,C1,C2,Mag_add,Dir_add):-
    C \= C1, C \= C2, C1 \= C2, 
    line(C,C1,Mag_add,Dir_add),
    line(C,C2,Mag_add,Dir_add).    

%line(Start,End,Mag_add,Dir_add):-
%    line(Start,End).

line(Start,End,Mag_add,Dir_add):-
    Start \= End,
    mindist(MinDist),
    adjacent(Start,End,MinDist),
    similar_grad(Start,End,Mag_add,Dir_add,0.1).
    
line(Start,End,Mag_add,Dir_add):-
    Start \= End,
    distance(Start,End,Dist),
    mindist(MinDist),
    Dist >= MinDist,
    sample_between(Start,End,C), 
    line(Start,C,Mag_add,Dir_add), 
    line(C,End,Mag_add,Dir_add).

line(Start,End,Mag_add,Dir_add):-
    Start \= End,
    distance(Start,End,Dist),
    mindist(MinDist),
    Dist >= MinDist,
    noisy_line(Start,End,Mag_add,Dir_add,5).
    
line_extend(Start,End,Bounds,Mag_add,Dir_add,NewStart,NewEnd):-
    line_extend_e(Start,End,Bounds,Mag_add,Dir_add,NewEnd),
    line_extend_s(Start,NewEnd,Bounds,Mag_add,Dir_add,NewStart).
    
line_extend_e(Start,End,Bounds,Mag_add,Dir_add,NewEnd):-
    writeln("Entering extend end"),
    sample_extend(Start,End,Bounds,NewEnd2),
    (line(End,NewEnd2,Mag_add,Dir_add)->
        writeln("Extended end"),
        line_extend_e(Start,NewEnd2,Bounds,Mag_add,Dir_add,NewEnd);
        writeln("Stopped extending end"),writeln([Start,NewEnd2]),
        NewEnd = End).

line_extend_s(Start,End,Bounds,Mag_add,Dir_add,NewStart):-
    writeln("Entering extend start"),
    sample_extend(End,Start,Bounds,NewStart2),
    writeln('**********************'),
    (line(NewStart2,Start,Mag_add,Dir_add)->
        writeln("Extended start"),
        line_extend_s(NewStart2,End,Bounds,Mag_add,Dir_add,NewStart);
        writeln("Stopped extending start"),writeln([NewStart2,End]),
        NewStart = Start).

shape_center(Pts,Center):-
    sum_list_3d(Pts, [A1,B1,C1]),
    length(Pts,L),
    P1 is round(A1 / L),
    P2 is round(B1 / L),
    P3 is round(C1 / L),
    Center = [P1,P2,P3].
    
sum_list_3d([[A,B,C]],[A,B,C]). 
sum_list_3d([[A,B,C]|L],[SA,SB,SC]):-
    sum_list_3d(L, [A1,B1,C1]),
    SA is A + A1,
    SB is B + B1,
    SC is C + C1.
    
similar_grad_image(P1,P2,Mag_add,Dir_add,Threshold):-
    sample_point_image(P1,Mag_add,Dir_add,[_,X_dir]),
    sample_point_image(P2,Mag_add,Dir_add,[Y_mag,Y_dir]),
    Mag is abs(Y_mag),
    angle_diff(X_dir,Y_dir,Dir),  
    Mag >  Threshold,
    Dir =<  3.1415 / 2.

similar_grad(P1,P2,Mag_add,Dir_add,Threshold):-
    sample_point(P1,Mag_add,Dir_add,[_,X_dir]),
    sample_point(P2,Mag_add,Dir_add,[Y_mag,Y_dir]),
    Mag is abs(Y_mag),
    angle_diff(X_dir,Y_dir,Dir),  
    Mag >  Threshold,
    Dir =<  3.1415 / 2.
    
    
normalise_vector([A,B,C],[X,Y,Z]):-
    distance([A,B,C],[0,0,0],L),
    X is A / L,
    Y is B / L,
    Z is C / L.

sample_extend(Start,End,Bounds,[X,Y,Z]):-
    coord_diff(End,Start,Diff),
    [Sx, Sy, Sz] = End,
    normalise_vector(Diff,[Dx,Dy,Dz]),
    mindist(MinDist),
    X is round(Sx + (MinDist * Dx)),
    Y is round(Sy + (MinDist * Dy)),
    Z is round(Sz + (MinDist * Dz)),
    point_within_bounds([X,Y,Z],Bounds).

adjacent(P1,P2,Dist):-
    distance(P1,P2,D1),
    Dist >= D1.
    
sample_between([Sx,Sy,Sz],[Ex,Ey,Ez],[X,Y,Z]):-
    sample_between([Sx,Sy,Sz],[Ex,Ey,Ez], 0.5,[X,Y,Z]),
    % Conditions ensure we don't get stuck
    not((X = Sx, Y = Sy, Z = Sz)),
    not((X = Ex, Y = Ey, Z = Ez)).
    
sample_between([Sx,Sy,Sz],[Ex,Ey,Ez], Pct,[X,Y,Z]):-
    X is round(Sx + ((Ex - Sx) * Pct)),
    Y is round(Sy + ((Ey - Sy) * Pct)),
    Z is round(Sz + ((Ez - Sz) * Pct)).

angle_diff(A1,A2,Diff):-
    C1 is (sin(A1) - sin(A2))**2,
    C2 is (cos(A1) - cos(A2))**2,
    Diff is acos((2.0 - C1 - C2)/2.0).

coord_diff([X1,Y1,Z1],[X2,Y2,Z2],[X,Y,Z]):-
    X is X1 - X2,
    Y is Y1 - Y2,
    Z is Z1 - Z2.

distance([Ax, Ay, Az],[Bx, By, Bz],Dist):-
    X is (Ax - Bx) ** 2,
    Y is (Ay - By) ** 2,
    Z is (Az - Bz) ** 2,
    Dist is sqrt(X + Y + Z).
    
calc_coords(L,A1,A2, [X,Y,Z]):-
    Z is integer(L * sin(A1)),
    L2 is (L * cos(A1)),
    X is integer(L2 * sin(A2)),
    Y is integer(L2 * cos(A2)).

random_point([X,Y,Z],[MaxX, MaxY, MaxZ],Len,[Nx,Ny,Nz]):-
    % Random point with enforcing bounds
    % Enforcement done by limiting - could be better.
    random_point([X,Y,Z],Len,[Tx,Ty,Tz]),
    Nx is min(max(Tx,0),MaxX),
    Ny is min(max(Ty,0),MaxY),
    Nz is min(max(Tz,0),MaxZ).
    
