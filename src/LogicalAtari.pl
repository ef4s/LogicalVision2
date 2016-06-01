run_test(W):-
    format(atom(Vid_file), 'data/~w', [W]),
    format(atom(Out_file), 'results/~w_R.pl', [W]),
    load_video(Vid_file, Vid_add),
    video2imgseq(Vid_add, Img_seq_add),
    size_3d(Vid_add, Width, Height, Depth),
    write([Width, Height]),
%    sample_point(Img_seq_add, [1, 1, 1], VAR),
%   write(VAR),
    %line_points([1, 1, 1], [1, 1, 1], [Width, Height, Depth], Pts),
    %sample_line(Img_seq_add, [0, 164, 1], [1, 0, 0], 10, Pts),
    sample_line(Img_seq_add, [86, 86, 0], [0, 0, 1], 10, Pts),
    write(Pts).
%    draw_points(Img_seq_add, Pts, 'r'),
%    draw_line(Img_seq_add, [1, 1, 1], [100, 100, 100], 'red'),
%   showvid_win(Img_seq_add, debug).


