:-	load_foreign_library(foreign('libs/cvio.so')),
	load_foreign_library(foreign('libs/cvsampler.so')),
	load_foreign_library(foreign('libs/cvdraw.so')),
	load_foreign_library(foreign('libs/cvatari.so')).
	
mindist(5).

test_video_source(IDX,BLUR,RESIZE):-
    format(atom(Vid_file), 'data/~w', ['space_invaders.mp4']),
    load_video(Vid_file, Vid_add),    
    video2imgseq(Vid_add, Img_seq_add),
    release_video(Vid_add),
    diff_seq(Img_seq_add, Diff_seq_add),
    release_imgseq(Img_seq_add),    
    resize_seq(Diff_seq_add,RESIZE,Blur_seq_add),    
    release_imgseq(Diff_seq_add),    
%    blur_seq(Resized_seq_add,BLUR,Blur_seq_add),
    gradient_seq(Blur_seq_add, Mag_seq_add, Dir_seq_add),
    seq_img_ptr(Blur_seq_add,IDX,Img_add),

    %% SAMPLE POINTS PER FRAME
    RESIZE2 is RESIZE - 1,
%    random_line_sample([RESIZE2,RESIZE2],IDX,Mag_seq_add,Dir_seq_add,P1),
%    random_line_sample([RESIZE2,RESIZE2],IDX,Mag_seq_add,Dir_seq_add,P2),
%    random_line_sample([RESIZE2,RESIZE2],IDX,Mag_seq_add,Dir_seq_add,P3),
%    random_line_sample([RESIZE2,RESIZE2],IDX,Mag_seq_add,Dir_seq_add,P4),

    %% FIT LINE 
    
%    find_line([RESIZE2,RESIZE2],IDX,Mag_seq_add,Dir_seq_add,Line),
    
    %% EXEND LINE
    
    %% FIND RECTANGLE
    find_square([RESIZE2,RESIZE2],IDX,Mag_seq_add,Dir_seq_add,Square),
    
    %% ADD CENTER TO BACKGROUND KNOWLEDGE
    
    %% FIND RULES TO FIT MOTION PATH OF RECTANGLE CENTER

%    P1 = [18,19,IDX], 
%    P2 = [88,19,IDX],
%    P3 = [88,81,IDX],
%    P4 = [18,81,IDX],
%    Pts = [P1,P2,P3,P4],
%    
%    PQ2 = [44,19,IDX],
%    
%%    line_extend(P1,PQ2,Mag_seq_add,Dir_seq_add,Q1,Q2),
%%    line(P1,P2,Mag_seq_add,Dir_seq_add), %~2/3 success
%%    line(P2,P3,Mag_seq_add,Dir_seq_add), %~1/3 success
%%    line(P3,P4,Mag_seq_add,Dir_seq_add), %~2/3 success
%%    line(P4,P1,Mag_seq_add,Dir_seq_add), %~2/3 success
%    draw_points_2d(Img_add, Pts, red),    
%    draw_points_2d(Img_add, Line, yellow),
    draw_points_2d(Img_add, Square, green),

    showimg_win(Img_add,debug),
%    showimg_win(Img_add,debug),
    release_imgseq_grad(Blur_seq_add),
    release_imgseq_grad(Mag_seq_add),
    release_imgseq_grad(Dir_seq_add).

find_line(Bounds,Z,Mag_seq_add,Dir_seq_add,Line):-
    random_line_sample(Bounds,Z,Mag_seq_add,Dir_seq_add,P1),
    find_line(P1,Bounds,Z,Mag_seq_add,Dir_seq_add,Line).

find_line(P1,Bounds,Z,Mag_seq_add,Dir_seq_add,Line):-
    random_line_sample(Bounds,Z,Mag_seq_add,Dir_seq_add,P2),
    (line(P1,P2,Mag_seq_add,Dir_seq_add) ->  
        line_extend(P1,P2,Mag_seq_add,Dir_seq_add,Q1,Q2),
        Line = [Q1,Q2];
%        Line = [P1,P2];
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
    
find_square(Bounds,Z,Mag_seq_add,Dir_seq_add,Square):-
    find_line(Bounds,Z,Mag_seq_add,Dir_seq_add,[P1,P2]),
    find_line(P1,Bounds,Z,Mag_seq_add,Dir_seq_add,[P1,P3]),
    find_line(P2,Bounds,Z,Mag_seq_add,Dir_seq_add,[P2,P4]),
    line(P3,P4,Mag_seq_add,Dir_seq_add),
    Square = [P1,P2,P3,P4].

%all_lines(Pts,Mag_add,Dir_add,Lines):-
%    findall(X,
%        (subsetZ(X,Pts), 
%        length(X,2),
%        [P1,P2] = X,
%        line(P1,P2,Mag_add,Dir_add)),
%        Lines).

%all_corners(C,Pts,Mag_add,Dir_add,Corners):-  
%    findall(X,
%        (subsetZ(X,Pts), 
%        length(X,2),
%        [C1,C2] = X,
%        corner(C,C1,C2,Mag_add,Dir_add)),
%        Corners).

corner(C,C1,C2,Mag_add,Dir_add):-
    C \= C1, C \= C2, C1 \= C2, 
    line(C,C1,Mag_add,Dir_add),
    line(C,C2,Mag_add,Dir_add).    

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
    noisy_line(Start,End,Mag_add,Dir_add).
    
line_extend(Start,End,Mag_add,Dir_add,NewStart,NewEnd):-
    sample_extend(Start,End,NewEnd2),
    line(Start,NewEnd2,Mag_add,Dir_add),
    line_extend(Start,NewEnd2,Mag_add,Dir_add,NewStart,NewEnd).

line_extend(Start,End,Mag_add,Dir_add,NewStart,NewEnd):-
    sample_extend(End,Start,NewStart2),
    line(NewStart2,End,Mag_add,Dir_add),
    line_extend(NewStart2,End,Mag_add,Dir_add,NewStart,NewEnd).

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


angle_diff(A1,A2,Diff):-
    C1 is (sin(A1) - sin(A2))**2,
    C2 is (cos(A1) - cos(A2))**2,
    Diff is acos((2.0 - C1 - C2)/2.0).

sample_between([Sx,Sy,Sz],[Ex,Ey,Ez],[X,Y,Z]):-
    sample_between([Sx,Sy,Sz],[Ex,Ey,Ez], 0.5,[X,Y,Z]),
    % Conditions ensure we don't get stuck
    not((X = Sx, Y = Sy, Z = Sz)),
    not((X = Ex, Y = Ey, Z = Ez)).
    
sample_between([Sx,Sy,Sz],[Ex,Ey,Ez], Pct,[X,Y,Z]):-
    X is round(Sx + ((Ex - Sx) * Pct)),
    Y is round(Sy + ((Ey - Sy) * Pct)),
    Z is round(Sz + ((Ez - Sz) * Pct)).

coord_diff([X1,Y1,Z1],[X2,Y2,Z2],[X,Y,Z]):-
    X is X1 - X2,
    Y is Y1 - Y2,
    Z is Z1 - Z2.

normalise_vector([A,B,C],[X,Y,Z]):-
    distance([A,B,C],[0,0,0],L),
    X is A / L,
    Y is B / L,
    Z is C / L.

sample_extend(Start,End,[X,Y,Z]):-
    coord_diff(End,Start,Diff),
    [Sx, Sy, Sz] = End,
    normalise_vector(Diff,[Dx,Dy,Dz]),
    mindist(MinDist),
    X is round(Sx + (MinDist * Dx)),
    Y is round(Sy + (MinDist * Dy)),
    Z is round(Sz + (MinDist * Dz)).

adjacent(P1,P2,Dist):-
    distance(P1,P2,D1),
    Dist >= D1.

distance([Ax, Ay, Az],[Bx, By, Bz],Dist):-
    X is (Ax - Bx) ** 2,
    Y is (Ay - By) ** 2,
    Z is (Az - Bz) ** 2,
    Dist is sqrt(X + Y + Z).
    

subsetY(A,B,L):-
    findall(X, (subsetZ(X,B), length(X,L)),A).
    
subsetZ([],[]).
subsetZ([X|L],[X|S]) :-
    subsetZ(L,S).
subsetZ(L, [_|S]) :-
    subsetZ(L,S).

random_radian(Radian):-
    % Returns a number in (0, 2*pi)
    Pi2 is 2 * pi,
    random(0, Pi2, Radian).

calc_coords(L,A1,A2, [X,Y,Z]):-
    Z is integer(L * sin(A1)),
    L2 is (L * cos(A1)),
    X is integer(L2 * sin(A2)),
    Y is integer(L2 * cos(A2)).

calc_coords_2d(L,A,[X,Y]):-
    X is integer(L * sin(A)),
    Y is integer(L * cos(A)).


random_point([X,Y,Z],Len,Dest):-
    % Random point without enforcing bounds
    random_radian(Dir1),
    calc_coords_2d(Len,Dir1,[Dx,Dy]),
    Nx is X + Dx,
    Ny is Y + Dy,
    Dest = [Nx,Ny,Z].
    
random_point([X,Y,Z],[MaxX, MaxY, MaxZ],Len,Dest):-
    % Random point with enforcing bounds
    % Enforcement done by limiting - could be better.
    random_point([X,Y,Z],Len,[Tx,Ty,Tz]),
    Nx is min(max(Tx,0),MaxX),
    Ny is min(max(Ty,0),MaxY),
    Nz is min(max(Tz,0),MaxZ),
    Dest = [Nx,Ny,Nz].
    
% Random walls in lower left quadrant.
random_edge_point([MaxX, MaxY], Dir, [X,Y]):-
    Dir > 0,
    Dir =< pi / 2,
    random(Wall), 
    (Wall > 0.5 -> 
        X is 0,
        random(0, MaxY,Y);
        Y is 0,
        random(0, MaxX,X)).
        
% Random walls in upper left quadrant.
random_edge_point([MaxX, MaxY], Dir, [X,Y]):-
    Dir > pi / 2,
    Dir =< pi,
    random(Wall), 
    (Wall > 0.5 -> 
        X is 0,
        random(0, MaxY,Y);
        Y is MaxY,
        random(0, MaxX,X)).

% Random walls in upper right quadrant.
random_edge_point([MaxX, MaxY], Dir, [X,Y]):-
    Dir > pi,
    Dir =< (pi * 3 / 2),
    random(Wall), 
    (Wall > 0.5 -> 
        X is MaxX,
        random(0, MaxY,Y);
        Y is MaxY,
        random(0, MaxX,X)).
        
% Random walls in lower right quadrant.
random_edge_point([MaxX, MaxY], Dir, [X,Y]):-
    Dir > (pi * 3 / 2),
    Dir =< (pi * 2),
    random(Wall), 
    (Wall > 0.5 -> 
        X is MaxX,
        random(0, MaxY,Y);
        Y is 0,
        random(0, MaxX,X)).

random_line_sample(Bounds,Z,Mag_add,Dir_add,Point):-
    random_radian(Dir),
    random_edge_point(Bounds,Dir,[X,Y]),
    Start = [X,Y,Z],
    random_line_sample_ex(Bounds,Start,Dir,Mag_add,Dir_add,P),
    (Start = P -> 
        random_line_sample_ex(Bounds,Start,Dir,Mag_add,Dir_add,Point);
        P = Point),
    not(point_on_edge(Point,Bounds)).
         
    
random_line_sample_ex([MaxX,MaxY],[Sx,Sy,Z],Dir,Mag_add,Dir_add,Point):-
    sample_point([Sx,Sy,Z],Mag_add,Dir_add,[Mag,_]),
    AMag is abs(Mag),
    AMag =< 0,
    mindist(L),
    calc_coords_2d(L,Dir,[Dx,Dy]),
    Nx is Sx + Dx, between(0, MaxX, Nx),
    Ny is Sy + Dy, between(0, MaxY, Ny),
    not((Nx == Sx, Ny == Sy)),
    P = [Nx,Ny,Z],
    random_line_sample_ex([MaxX,MaxY],P,Dir,Mag_add,Dir_add,Point).
    
random_line_sample_ex(_,Point,_,_,_,Point).


point_on_edge([X,Y,_],[MaxX,MaxY]):-
    (X =< 0; X >= MaxX; Y =< 0; Y >= MaxY).
    
    
    
