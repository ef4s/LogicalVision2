:-	load_foreign_library(foreign('libs/cvio.so')),
	load_foreign_library(foreign('libs/cvsampler.so')),
	load_foreign_library(foreign('libs/cvdraw.so')),
	load_foreign_library(foreign('libs/cvatari.so')).
	
mindist(2).
line([0,0,0],[0,0,0]).

test_video_source(BLUR,THRESHOLD):-
    format(atom(Vid_file), 'data/~w', ['space_invaders.mp4']),
    load_video(Vid_file, Vid_add),    

    video2imgseq(Vid_add, Img_seq_add),
    release_video(Vid_add),

    diff_seq(Img_seq_add, Diff_seq_add),
    imgseq_bounds(Diff_seq_add,[MaxX,MaxY,MaxZ]),
    release_imgseq(Img_seq_add),    
    
    resize_seq(Diff_seq_add,BLUR,[MaxX,MaxY],Resized_seq_add),        
    release_imgseq_pointer(Diff_seq_add),    

    gradient_seq(Resized_seq_add, Mag_seq_add, Dir_seq_add),
    
    %% SAMPLE POINTS PER FRAME
    MaxX2_ is MaxX - 1, MaxX2 is integer(MaxX2_), 
    MaxY2_ is MaxY - 1, MaxY2 is integer(MaxY2_),

    open("results.txt",write,Stream), 
%    process_video([MaxY2,MaxX2,MaxZ],THRESHOLD,Mag_seq_add,Dir_seq_add,Stream),
    process_video([MaxY2,MaxX2,5],THRESHOLD,Mag_seq_add,Dir_seq_add,Stream),

    %% FIND RULES TO FIT MOTION PATH OF RECTANGLE CENTER

    close(Stream),
    release_imgseq_pointer(Resized_seq_add),
    release_imgseq_pointer(Mag_seq_add),
    release_imgseq_pointer(Dir_seq_add).

process_video([X,Y,Z],THRESHOLD,Mag_seq_add,Dir_seq_add,Stream):-
    writeln("STARTING PROCESSING"),
    process_video([X,Y,Z],0,THRESHOLD,Mag_seq_add,Dir_seq_add,Stream).

process_video([_,_,Z],Z,_,_,_,_):-writeln("Processing done!").

process_video([X,Y,Z],IDX,THRESHOLD,Mag_seq_add,Dir_seq_add,Stream):-
    find_n_point_samples(100,[X,Y],IDX,THRESHOLD,Mag_seq_add,Dir_seq_add,Points),
    find_rectangles(Points,Rects),
    writeln(Stream,Rects),
    IDX2 is IDX + 1,
    write("Processing: "),write(IDX),nl,
    process_video([X,Y,Z],IDX2,THRESHOLD,Mag_seq_add,Dir_seq_add,Stream).

random_radian(Radian):-
    % Returns a number in (0, 2*pi)
    Pi2 is 2 * pi,
    random(0, Pi2, Radian).

calc_coords_2d(L,A,[X,Y]):-
    X is integer(L * sin(A)),
    Y is integer(L * cos(A)).

add_coords_2d([X,Y],Dir,[Nx,Ny]):-
    mindist(L),
    calc_coords_2d(L,Dir,[Dx,Dy]),
    not((Dx = 0, Dy = 0)),
    Nx is X + Dx,
    Ny is Y + Dy.

random_point([X,Y,Z],Len,Dest):-
    % Random point without enforcing bounds
    random_radian(Dir1),
    calc_coords_2d(Len,Dir1,[Dx,Dy]),
    Nx is X + Dx,
    Ny is Y + Dy,
    Dest = [Nx,Ny,Z].
    
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

find_n_point_samples(N,Bounds,Z,Threshold,Mag_seq_add,Dir_seq_add,Samples):-
    M is N * 10,
    find_n_point_samples(N,M,Bounds,Z,Threshold,Mag_seq_add,Dir_seq_add,Samples).
    
find_n_point_samples(0,_,_,_,_,_,_,[]).
find_n_point_samples(_,0,_,_,_,_,_,[]).
find_n_point_samples(N,M,Bounds,Z,Threshold,Mag_seq_add,Dir_seq_add,Samples):-
    (random_line_sample(Bounds,Z,Threshold,Mag_seq_add,Dir_seq_add,P1) ->    
        N2 is N - 1,
        find_n_point_samples(N2,M,Bounds,Z,Threshold,Mag_seq_add,Dir_seq_add,S),
        append([P1],S,Samples); 
        M2 is M - 1,
        find_n_point_samples(N,M2,Bounds,Z,Threshold,Mag_seq_add,Dir_seq_add,Samples)).

random_line_sample(Bounds,Z,Threshold,Mag_add,Dir_add,Point):-
    random_radian(Dir),
    random_edge_point(Bounds,Dir,[X,Y]),
    Start = [X,Y,Z],
    random_line_sample_ex(Bounds,Start,Threshold,Dir,Mag_add,Dir_add,Point).
             
random_line_sample_ex(Bounds,[X,Y,Z],Threshold,Dir,Mag_add,Dir_add,Point):-
    point_above_threshold([X,Y,Z],Threshold,Mag_add,Dir_add),
    add_coords_2d([X,Y],Dir,[Nx,Ny]),
    point_within_bounds([Nx,Ny],Bounds),
    random_line_sample_ex(Bounds,[Nx,Ny,Z],Threshold,Dir,Mag_add,Dir_add,Point).

random_line_sample_ex(_,Point,_,_,_,_,Point).

point_above_threshold([X,Y,Z],Threshold,Mag_add,Dir_add):-
    sample_point([X,Y,Z],Mag_add,Dir_add,[Mag,_]),
    AMag is abs(Mag),
    AMag =< Threshold.

point_within_bounds([X,Y],[MaxX,MaxY]):-
    X >= 0, X =< MaxX, Y >= 0, Y =< MaxY.
    
