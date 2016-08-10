:-	load_foreign_library(foreign('libs/cvio.so')),
	load_foreign_library(foreign('libs/cvsampler.so')),
	load_foreign_library(foreign('libs/cvdraw.so')),
	load_foreign_library(foreign('libs/cvatari.so')).
	
mindist(20).


run_test(W):-
    format(atom(Vid_file), 'data/~w', [W]),
%    format(atom(Out_file), 'results/~w_R.pl', [W]),
    load_video(Vid_file, Vid_add),    
    video2imgseq(Vid_add, Img_seq_add),
    size_3d(Vid_add, _, _, _),
    diff_seq(Img_seq_add, Diff_seq_add),
    resize_image(Diff_seq_add, 1234, [20, 20], Resize_img_add),
    gradient_image(Diff_seq_add, 1234, _, _),
    showimg_win(Resize_img_add, resized).
%    sample_point(Img_seq_add, [1, 1, 1], VAR),
%    write(VAR),
%    line_points([1, 1, 1], [1, 1, 1], [Width, Height, Depth], Pts),
%    sample_line(Img_seq_add, [0, 164, 1], [1, 0, 0], 10, Pts),
%    sample_line(Img_seq_add, [86, 86, 0], [0, 0, 1], 10, Pts),
%    write(Pts).
%    draw_points(Img_seq_add, Pts, 'r'),
%    draw_line(Img_seq_add, [1, 1, 1], [100, 100, 100], 'red'),
%    showvid_win(Img_seq_add, debug).

test_line:-
    format(atom(Img_file), 'data/~w.jpg', ['line']),
    load_img(Img_file, Img_add),
    P1 = [150,201,100],
    P2 = [450,201,100],
    P3 = [160,201,100],
    draw_points_2d(Img_add, [P1,P2], red),
    gradient_image(Img_add,Mag_add,Dir_add),
%    print(Dir_add),
%    print(Mag_add),
%    sample_point_image(Dir_add,Mag_add,P1,X),
%    print(X),
    showimg_win(Img_add, 'debug'),
    line(P3,P2,Mag_add,Dir_add),
%    line(P1,P2,Dir_add,Mag_add),
%    showimg_win(Dir_add, 'dir'),
%    showimg_win(Mag_add, 'mag'),
    release_img(Img_add).    

test_dashed_line:-
    format(atom(Img_file), 'data/~w.jpg', ['dashed_line']),
    load_img(Img_file, Img_add),
    P1 = [150,175,100],
    P2 = [455,180,100],
    draw_points_2d(Img_add, [P1,P2], red),
    gradient_image(Img_add,Mag_add,Dir_add),
%    print(Dir_add),
%    print(Mag_add),
%    sample_point_image(Dir_add,Mag_add,P1,X),
%    print(X),
    showimg_win(Img_add, 'debug'),
%    similar_grad(P1,P2,Dir_add,Mag_add,0.1),
%     adjacent(P1,P2),

    line(P1,P2,Mag_add,Dir_add),
%    corner(P1,Dir_add,Mag_add),
%    showimg_win(Dir_add, 'dir'),
%    showimg_win(Mag_add, 'mag'),
    release_img(Img_add).    

test_square:-
    format(atom(Img_file), 'data/~w.jpg', ['6']),
    load_img(Img_file, Img_add),
    gradient_image(Img_add,Mag_add,Dir_add),
    
    P1 = [142,157,100], 
    P2 = [215,431,100],
    P3 = [492,357,100],
    P4 = [418,82,100],
%    Pts = [P1,P2,P3,P4,P5,P6],
    Pts = [P1,P2,P3,P4],
%    Pts = [P1,P2,P3,P6],

    find_square(Pts,Mag_add,Dir_add,Square),
    print(Square),
    nl,
    shape_center(Pts,Center),
    print(Center),

    draw_points_2d(Img_add, Pts, red),
    draw_points_2d(Img_add, [Center], blue),
    showimg_win(Img_add, 'debug'),

    release_img(Img_add).    

test_line_extend:-
    format(atom(Img_file), 'data/~w.jpg', ['line']),
    load_img(Img_file, Img_add),
    P1 = [150,201,100],
    P2 = [450,201,100],
    draw_points_2d(Img_add, [P1,P2], red),
    gradient_image(Img_add,Mag_add,Dir_add),
%    print(Dir_add),
%    print(Mag_add),
%    sample_point_image(Dir_add,Mag_add,P1,X),
%    print(X),
    line(P1,P2,Dir_add,Mag_add),
    print("P1 = "),print(P1),print(", P2 = "),print(P2),nl,
    line_extend(P1,P2,Dir_add,Mag_add,Q1,Q2),
    print("Q1 = "),print(Q1),print(", Q2 = "),print(Q2),nl,
    line_extend(Q1,Q2,Dir_add,Mag_add,R1,R2),
    print("R1 = "),print(R1),print(", R2 = "),print(R2),nl,
    showimg_win(Img_add, 'debug'),

%    showimg_win(Dir_add, 'dir'),
%    showimg_win(Mag_add, 'mag'),
    release_img(Img_add).    


test_video_source(IDX,BLUR):-
    format(atom(Vid_file), 'data/~w', ['space_invaders.mp4']),
    load_video(Vid_file, Vid_add),    
    video2imgseq(Vid_add, Img_seq_add),
    release_video(Vid_add),
    print("done"),nl,
    diff_seq(Img_seq_add, Diff_seq_add),
    release_imgseq(Img_seq_add),    
    print("done"),nl,
%    resize_seq(Diff_seq_add,130,Resized_seq_add),
    resize_seq(Diff_seq_add,130,Blur_seq_add),    
    release_imgseq(Diff_seq_add),    
    print("done"),nl,
%    blur_seq(Resized_seq_add,BLUR,Blur_seq_add),
%    print("done"),nl,
    gradient_seq(Blur_seq_add, Mag_seq_add, Dir_seq_add),
    print("done"),nl,
    seq_img_ptr(Blur_seq_add,IDX,Img_add),
    print("done"),nl,
    seq_img_ptr(Mag_seq_add,IDX,Mag_add),  
    print("done"),nl,
    seq_img_ptr(Dir_seq_add,IDX,Dir_add),  
    print("done"),nl,

    %% SAMPLE POINTS PER FRAME
    random_line_sample([130,130],IDX,Mag_seq_add,Dir_seq_add,Point),
    print("FINAL POINT"),print(Point),nl,
    %% FIT LINE 
    
    %% EXEND LINE
    
    %% FIND RECTANGLE
    
    %% ADD CENTER TO BACKGROUND KNOWLEDGE
    
    %% FIND RULES TO FIT MOTION PATH OF RECTANGLE CENTER

%    P1 = [44,34,100], 
%    P2 = [221,34,100],
%    P3 = [221,130,100],
%    P4 = [44,130,100],
%    Pts = [P1,P2,P3,P4],
    
    P1 = [18,19,IDX], 
    P2 = [88,19,IDX],
    P3 = [88,81,IDX],
    P4 = [18,81,IDX],
    Pts = [P1,P2,P3,P4],
    
    PQ2 = [44,19,IDX],
    
    line_extend(P1,PQ2,Mag_seq_add,Dir_seq_add,Q1,Q2),
%    print("Q1 = "), print(Q1), print(", Q2 = "), print(Q2),nl,
%    print_point_sample(P1,Mag_seq_add, Dir_seq_add):-
    
%    line(P1,P2,Mag_seq_add,Dir_seq_add), %~2/3 success
%    line(P2,P3,Mag_seq_add,Dir_seq_add), %~1/3 success
%    line(P3,P4,Mag_seq_add,Dir_seq_add), %~2/3 success
%    line(P4,P1,Mag_seq_add,Dir_seq_add), %~2/3 success
    draw_points_2d(Img_add, [P1, PQ2], red),
%    print_point_sample([290, 110, 5],Mag_seq_add,Dir_seq_add),nl,
%    print_point_sample([290, 110, 11],Mag_seq_add,Dir_seq_add),nl,
%    print_point_sample([290, 110, 17],Mag_seq_add,Dir_seq_add),nl,
%    print_point_sample([290, 110, 23],Mag_seq_add,Dir_seq_add),nl,
%    print_point_sample([290, 110, 24],Mag_seq_add,Dir_seq_add),nl,
%    print_point_sample([290, 110, 25],Mag_seq_add,Dir_seq_add),nl,
%    print_point_sample([290, 110, 26],Mag_seq_add,Dir_seq_add),nl,
%    print_point_sample([290, 110, 27],Mag_seq_add,Dir_seq_add),nl,
%    print_point_sample([290, 110, 28],Mag_seq_add,Dir_seq_add),nl,
%    print_point_sample([290, 110, 29],Mag_seq_add,Dir_seq_add),nl.

    showimg_win(Img_add,debug),
%    showimg_win(Img_add,debug),
    release_imgseq_grad(Blur_seq_add),
    release_imgseq_grad(Mag_seq_add),
    release_imgseq_grad(Dir_seq_add).


print_point_sample(P,Mag_seq_add, Dir_seq_add):-
    sample_point(P,Mag_seq_add,Dir_seq_add,[X_mag,X_dir]),
    print(X_mag),print(','),print(X_dir).

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
    
find_square(Pts,Mag_add,Dir_add,Square):-
    [P1,P2,P3,P4] = Pts,
    line(P1,P2,Mag_add,Dir_add),
    line(P1,P4,Mag_add,Dir_add),
    line(P2,P3,Mag_add,Dir_add),
    line(P3,P4,Mag_add,Dir_add),
    Square = [P1,P2,P3,P4].

all_lines(Pts,Mag_add,Dir_add,Lines):-
    findall(X,
        (subsetZ(X,Pts), 
        length(X,2),
        [P1,P2] = X,
        line(P1,P2,Mag_add,Dir_add)),
        Lines).

all_corners(C,Pts,Mag_add,Dir_add,Corners):-  
    findall(X,
        (subsetZ(X,Pts), 
        length(X,2),
        [C1,C2] = X,
        corner(C,C1,C2,Mag_add,Dir_add)),
        Corners),
    print('**'),print(Corners),print('**').

corner(C,C1,C2,Mag_add,Dir_add):-
    C \= C1, C \= C2, C1 \= C2, 
    line(C,C1,Mag_add,Dir_add),
    line(C,C2,Mag_add,Dir_add).    

line1(Start,End,Mag_add,Dir_add):-
    line(Start,End,Mag_add,Dir_add).

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
%    print('Mag is: '), print(Mag),print(', Dir is: '), print(Dir),
    Mag >  Threshold,
    Dir =<  3.1415 / 2.

similar_grad(P1,P2,Mag_add,Dir_add,Threshold):-
    sample_point(P1,Mag_add,Dir_add,[_,X_dir]),
    sample_point(P2,Mag_add,Dir_add,[Y_mag,Y_dir]),
    Mag is abs(Y_mag),
    angle_diff(X_dir,Y_dir,Dir),  
%    print('Mag is: '), print(Mag),print(', Dir is: '), print(Dir),
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
    random(Dir1),
    Radian is (Dir1 - 0.5) * 3.1415 * 2.

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
    
random_loc([MaxX, MaxY], [X,Y]):-
    random(Xf),
    X is integer(Xf * MaxX),
    random(Yf),
    Y is integer(Yf * MaxY).

random_line_sample(Bounds,Z,Mag_add,Dir_add,Point):-
    random_loc(Bounds,[X,Y]),
    random_radian(Dir),
    Start = [X,Y,Z],
    print(Start),print(' '),print(Dir),nl,
    random_line_sample_ex(Bounds,Start,Dir,Mag_add,Dir_add,Point).    
    
random_line_sample_ex([MaxX,MaxY],[Sx,Sy,Z],Dir,Mag_add,Dir_add,Point):-
    print([Sx,Sy,Z]),nl,
    sample_point([Sx,Sy,Z],Mag_add,Dir_add,[Mag,Dir]),
    Mag > 0,
    calc_coords_2d(1,Dir,[Dx,Dy]),
    Nx is min(max(Sx + Dx,0),MaxX),
    Ny is min(max(Sy + Dy,0),MaxY),
    not(Nx == Sx, Ny == Sy),
    Dest = [Nx,Ny].
    
    
    
