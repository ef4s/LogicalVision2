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
    gradient_image(Diff_seq_add, 1234, Grad_add, Angle_add),
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
    gradient_image(Img_add,Dir_add,Mag_add),
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
    gradient_image(Img_add,Dir_add,Mag_add),
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
    P1 = [142,157,100],
    P2 = [203,389,100],
    draw_points_2d(Img_add, [P1,P2], red),
    gradient_image(Img_add,Dir_add,Mag_add),
%    print(Dir_add),
%    print(Mag_add),
%    sample_point_image(Dir_add,Mag_add,P1,X),
%    print(X),
    showimg_win(Img_add, 'debug'),
%    similar_grad(P1,P2,Dir_add,Mag_add,0.1),
%     adjacent(P1,P2),
%    line(P1,P2,Dir_add,Mag_add),
    corner(P1,Mag_add,Dir_add),
%    showimg_win(Dir_add, 'dir'),
%    showimg_win(Mag_add, 'mag'),
    release_img(Img_add).    
    

find_shapes(Diff_seq_add, [Resize_x, Resize_y], Shapes):-
	resize_image(Diff_seq_add, 1234, [20, 20], Resize_img_add),
	gradient_image(Diff_seq_add, 1234, Grad_add, Angle_add),
	findall(Shape, find_shape(Grad_add, Angle_add, Shape), Shapes).

find_shape(Grad_add, Angle_add, Shape):-
	random_point_on_line(Point),
	matching_point(Point, Grad_add, Angle_add, Point2),
	prove_line(Point, Point2).
	
find_square(Grad_add,Angle_add,Square):-
    corner(C1,Grad_add,Angle_add),
    corner(C2,Grad_add,Angle_add),
    line(C1,C2,Grad_add,Angle_add),
    corner(C3,Grad_add,Angle_add),
    line(C2,C3,Grad_add,Angle_add),
    corner(C4,Grad_add,Angle_add),
    line(C3,C4,Grad_add,Angle_add),
    line(C4,C1,Grad_add,Angle_add).

corner(C,Grad_add,Angle_add):-
    random_point(C,10,C1),
    random_point(C,10,C2),    
    corner(C,C1,C2,Grad_add,Angle_add).

corner(C,C1,C2,Grad_add,Angle_add):-
    line(C,C1,Grad_add,Angle_add),
    line(C,C2,Grad_add,Angle_add).    


random_radian(Radian):-
    % Takes in a number in (0,1) and transforms it into (0, 2*pi)
    random(Dir1),
    Radian is (Dir1 - 0.5) * 3.1415 * 2.

calc_coords(L,A1,A2, [X,Y,Z]):-
    Z is (L * sin(A1)),
    L2 is (L * cos(A1)),
    X is (L2 * sin(A2)),
    Y is (L2 * cos(A2)).

random_point([X,Y,Z],Len,Dest):-
    %Select direction
    random_radian(Dir1),
    random_radian(Dir2),
    calc_coords(Len,Dir1,Dir2,[Dx,Dy,Dz]),
    Nx is X + Dx,
    Ny is Y + Dy,
    Nz is Z + Dz,
    Dest = [Nx,Ny,Nz].
    
random_point([X,Y,Z],[MaxX, MaxY, MaxZ],Len,Dest):-
    random_point([X,Y,Z],Len,[Tx,Ty,Tz]),
    Nx is min(max(Tx,0),MaxX),
    Ny is min(max(Ty,0),MaxY),
    Nz is min(max(Tz,0),MaxZ),
    Dest = [Nx,Ny,Nz].
    



line(Start,End,Grad_add,Angle_add):-
    similar_grad(Start,End,Grad_add,Angle_add,0.1), 
    adjacent(Start,End).
    
line(Start,End,Grad_add,Angle_add):-
    sample_between(Start,End,C), 
    line(Start,C,Grad_add,Angle_add), 
    line(C,End,Grad_add,Angle_add).

line(Start,End,Grad_add,Angle_add):-
    noisy_line_image(Start,End,Grad_add,Angle_add).
%    noisy_extend_line(Start,End,Grad_add,Angle_add, 0.5, New_Start, New_End).

similar_grad(P1,P2,Grad_add,Angle_add,Threshold):-
    sample_point_image(Angle_add,Grad_add,P1,[X_dir,X_mag]),
    sample_point_image(Angle_add,Grad_add,P2,[Y_dir,Y_mag]),
    Mag is abs(X_mag - Y_mag),
    Dir is abs(X_dir - Y_dir),
    Mag >  Threshold,
    Dir >=  1.

sample_between([Sx,Sy,Sz],[Ex,Ey,Ez],[X,Y,Z]):-
    X is round(Sx + ((Sx - Ex) / 2)),
    Y is round(Sy + ((Sy - Ey) / 2)),
    Z is round(Sz + ((Sz - Ez) / 2)),
    not((X = Sx, Y = Sy, Z = Sz)),
    not((X = Ex, Y = Ey, Z = Ez)).


adjacent([Ax, Ay, Z],[Bx, By, Z]):-
    X is abs(Ax - Bx),
    Y is abs(Ay - By),
    X =< 1,
    Y =< 1.

adjacent([Ax, Y, Az],[Bx, Y, Bz]):-
    X is abs(Ax - Bx),
    Z is abs(Az - Bz),
    X =< 1,
    Z =< 1.

adjacent([X, Ay, Az],[X, By, Bz]):-
    Y is abs(Ay - By),
    Z is abs(Az - Bz),
    Y =< 1,
    Z =< 1.
    

