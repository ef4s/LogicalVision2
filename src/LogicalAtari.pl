:-	load_foreign_library(foreign('src/prolog2/cvio.so')),
	load_foreign_library(foreign('src/prolog2/cvsampler.so')),
	load_foreign_library(foreign('src/prolog2/cvdraw.so')),
	load_foreign_library(foreign('src/prolog2/cvatari.so')).




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


find_shapes(Diff_seq_add, [Resize_x, Resize_y], Shapes):-
	resize_image(Diff_seq_add, 1234, [20, 20], Resize_img_add),
	gradient_image(Diff_seq_add, 1234, Grad_add, Angle_add),
	findall(Shape, find_shape(Grad_add, Angle_add, Shape), Shapes).

find_shape(Grad_add, Angle_add, Shape):-
	random_point_on_line(Point),
	matching_point(Point, Grad_add, Angle_add, Point2),
	prove_line(Point, Point2)
	
	

sample_line_to_point(+Img, +[Start_x, Start_y, Dir], +Threshold, -Point):-
	
extend_point_to_line(+Img, +Point, +Grad, +Dir, -Line)
connect_lines(+Lines, -Shape)

