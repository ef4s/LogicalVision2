:-	load_foreign_library(foreign('libs/cvio.so')),
	load_foreign_library(foreign('libs/cvsampler.so')),
	load_foreign_library(foreign('libs/cvdraw.so')),
	load_foreign_library(foreign('libs/cvatari.so')).


run_test(W):-
    format(atom(Vid_file), 'data/~w', [W]),
    format(atom(Out_file), 'results/~w_R.pl', [W]),
    load_video(Vid_file, Vid_add),    
    video2imgseq(Vid_add, Img_seq_add),
    size_3d(Vid_add, Width, Height, Depth),
    diff_seq(Img_seq_add, Diff_seq_add),
    resize_image(Diff_seq_add, 1234, [20, 20], Resize_img_add),
    gradient_image(Diff_seq_add, 1234, Mag_add, Dir_add),
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
    draw_points_2d(Img_add, [P1,P2], red),
    gradient_image(Img_add,Mag_add,Dir_add),
%    print(Dir_add),
%    print(Mag_add),
%    sample_point_image(Dir_add,Mag_add,P1,X),
%    print(X),
%    showimg_win(Img_add, 'debug'),
    line(P1,P2,Dir_add,Mag_add),
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
%    showimg_win(Img_add, 'debug'),
%    similar_grad(P1,P2,Dir_add,Mag_add,0.1),
%     adjacent(P1,P2),
    line(P1,P2,Dir_add,Mag_add),
%    corner(P1,Dir_add,Mag_add),
%    showimg_win(Dir_add, 'dir'),
%    showimg_win(Mag_add, 'mag'),
    release_img(Img_add).    

test_square:-
    format(atom(Img_file), 'data/~w.jpg', ['6']),
    load_img(Img_file, Img_add),
    gradient_image(Img_add,Mag_add,Dir_add),
    
    P1 = [142,157,100], 
    P2 = [203,389,100],
    P3 = [270,122,100],
%    random_point(P1,15,P3),
    random_point(P1,15,P4),
    random_point(P1,15,P5),
%    random_point(P1,15,P6),
    P6 = [142,122,100],
%    Pts = [P1,P2,P3,P4,P5,P6],
%    Pts = [P1,P2,P3],
    Pts = [P1,P2,P3,P6],

    
%    line(P1,P2,Mag_add,Dir_add),
    line(P1,P3,Mag_add,Dir_add),

%    corner(P1,P2,P3,Mag_add,Dir_add),
    
%    all_corners(P1,Pts,Mag_add,Dir_add,Corners),
%    print(Corners),    

    draw_points_2d(Img_add, Pts, red),
    showimg_win(Img_add, 'debug'),

    release_img(Img_add).    
    

find_shapes(Diff_seq_add, [Resize_x, Resize_y], Shapes):-
	resize_image(Diff_seq_add, 1234, [20, 20], Resize_img_add),
	gradient_image(Diff_seq_add, 1234, Mag_add, Dir_add),
	findall(Shape, find_shape(Mag_add, Dir_add, Shape), Shapes).

find_shape(Mag_add, Dir_add, Shape):-
	random_point_on_line(Point),
	matching_point(Point, Mag_add, Dir_add, Point2),
	prove_line(Point, Point2).
	
find_square(Mag_add,Dir_add,Square):-
    corner(C1,Mag_add,Dir_add),
    corner(C2,Mag_add,Dir_add),
    line(C1,C2,Mag_add,Dir_add),
    corner(C3,Mag_add,Dir_add),
    line(C2,C3,Mag_add,Dir_add),
    corner(C4,Mag_add,Dir_add),
    line(C3,C4,Mag_add,Dir_add),
    line(C4,C1,Mag_add,Dir_add).

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

line(Start,End,Mag_add,Dir_add):-
    similar_grad(Start,End,Mag_add,Dir_add,0.1), 
    adjacent(Start,End,5).
    
line(Start,End,Mag_add,Dir_add):-
    sample_between(Start,End,C), 
    line(Start,C,Mag_add,Dir_add), 
    line(C,End,Mag_add,Dir_add).

line(Start,End,Mag_add,Dir_add):-
    noisy_line_image(Start,End,Mag_add,Dir_add).
    noisy_extend_line(Start,End,Mag_add,Dir_add, 0.5, New_Start, New_End).

similar_grad(P1,P2,Mag_add,Dir_add,Threshold):-
    sample_point_image(P1,Mag_add,Dir_add,[X_mag,X_dir]),
    sample_point_image(P2,Mag_add,Dir_add,[Y_mag,Y_dir]),
    Mag is abs(X_mag - Y_mag),
    angle_diff(X_dir,Y_dir,Dir),  
%    print('Mag is: '), print(Mag),print(', Dir is: '), print(Dir),
    Mag >  Threshold,
    Dir =<  3.1415 / 4.

angle_diff(A1,A2,Diff):-
    C1 is (sin(A1) - sin(A2))**2,
    C2 is (cos(A1) - cos(A2))**2,
    Diff is acos((2.0 - C1 - C2)/2.0).

sample_between([Sx,Sy,Sz],[Ex,Ey,Ez],[X,Y,Z]):-
    X is round(Sx + ((Ex - Sx) / 2)),
    Y is round(Sy + ((Ey - Sy) / 2)),
    Z is round(Sz + ((Ez - Sz) / 2)),
    not((X = Sx, Y = Sy, Z = Sz)),
    not((X = Ex, Y = Ey, Z = Ez)).

adjacent([Ax, Ay, Az],[Bx, By, Bz],Dist):-
    X is (Ax - Bx) ** 2,
    Y is (Ay - By) ** 2,
    Z is (Az - Bz) ** 2,
    Dist > sqrt(X + Y + Z).
    
    
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

calc_coords_2d(L,A1,A2, [X,Y,0]):-
    X is integer(L * sin(A2)),
    Y is integer(L * cos(A2)).


random_point([X,Y,Z],Len,Dest):-
    % Random point without enforcing bounds
    %Select direction
    random_radian(Dir1),
    random_radian(Dir2),
    calc_coords_2d(Len,Dir1,Dir2,[Dx,Dy,Dz]),
    Nx is X + Dx,
    Ny is Y + Dy,
    Nz is Z + Dz,
    Dest = [Nx,Ny,Nz].
    
random_point([X,Y,Z],[MaxX, MaxY, MaxZ],Len,Dest):-
    % Random point with enforcing bounds
    % Enforcement done by limiting - could be better.
    random_point([X,Y,Z],Len,[Tx,Ty,Tz]),
    Nx is min(max(Tx,0),MaxX),
    Ny is min(max(Ty,0),MaxY),
    Nz is min(max(Tz,0),MaxZ),
    Dest = [Nx,Ny,Nz].

