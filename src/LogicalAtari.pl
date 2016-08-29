:-	load_foreign_library(foreign('libs/cvio.so')),
	load_foreign_library(foreign('libs/cvsampler.so')),
	load_foreign_library(foreign('libs/cvdraw.so')),
	load_foreign_library(foreign('libs/cvatari.so')).
	
mindist(5).

test_video_source(FILE,BLUR,THRESHOLD,NSAMPLES):-
    format(atom(Vid_file), 'data/space_invaders/~w', [FILE]),
    load_video(Vid_file, Vid_add),    

    video2imgseq(Vid_add, Img_seq_add),
    release_video(Vid_add),

    diff_seq(Img_seq_add, Diff_seq_add),
    imgseq_bounds(Diff_seq_add,[MaxX,MaxY,MaxZ]),
%    release_imgseq(Img_seq_add),  
    
%    writeln([MaxX,MaxY,MaxZ]),
    
    resize_seq(Diff_seq_add,BLUR,[210,320],Resized_seq_add),        
    release_imgseq_pointer(Diff_seq_add),    

    gradient_seq(Resized_seq_add, Mag_seq_add, Dir_seq_add),
    
    %% SAMPLE POINTS PER FRAME
    MaxX2_ is MaxX - 1, MaxX2 is integer(MaxX2_), 
    MaxY2_ is MaxY - 1, MaxY2 is integer(MaxY2_),
    MaxZ2_ is MaxZ - 1, MaxZ2 is integer(MaxZ2_),

    new_f_name(FILE,Results_File),
        
    open(Results_File,write,Stream), 

    process_video(NSAMPLES,[320,210,MaxZ2],THRESHOLD,Img_seq_add,Resized_seq_add,Mag_seq_add,Dir_seq_add,Stream),

    close(Stream),
    release_imgseq_pointer(Resized_seq_add),
    release_imgseq_pointer(Mag_seq_add),
    release_imgseq_pointer(Dir_seq_add).
    
new_f_name(Img_File,Results_File):-
    file_name_extension(F_name_0,_,Img_File),
    string_concat('results/',F_name_0,F_name_1),
    string_concat(F_name_1,'_results_',F_name_2),
    random(1,1000000000,E),
    string_concat(F_name_2,E,F_name_3),
    string_concat(F_name_3,'.pl',Results_File).

process_video(NSAMPLES,[X,Y,Z],Threshold,Img_seq_add,Resized_seq_add,Mag_seq_add,Dir_seq_add,Stream):-
    writeln("STARTING PROCESSING"),
    process_video(NSAMPLES,[X,Y,Z],0,Threshold,Img_seq_add,Resized_seq_add,Mag_seq_add,Dir_seq_add,Stream).

process_video(_,[_,_,Z],Z,_,_,_,_,_,_).

process_video(NSAMPLES,[X,Y,Z],IDX,Threshold,Img_seq_add,Resized_seq_add,Mag_seq_add,Dir_seq_add,Stream):-
    find_n_point_samples(NSAMPLES,[X,Y],IDX,Threshold,Mag_seq_add,Dir_seq_add,Points),
%    find_rectangles_from_src(Resized_seq_add, IDX, Points, Rects),
%    show_seq_img(Img_seq_add,IDX),
    find_rectangles(Points,Rects),
    write(Stream,"frame("),write(Stream,IDX),write(Stream,",["),write_shapes(Stream,Rects),writeln(Stream,"])."),
    IDX2 is IDX + 1,
    write("Processing: "),write(IDX), write(" of "), write(Z), write(". "), format('~2f%',100 * IDX / Z),nl,
    process_video(NSAMPLES,[X,Y,Z],IDX2,Threshold,Img_seq_add,Resized_seq_add,Mag_seq_add,Dir_seq_add,Stream).

write_shapes(_,[]).

write_shapes(Stream,[H]):-
    write(Stream,"shape("),write(Stream,H),write(Stream,")").
    
write_shapes(Stream,[H|T]):-
    write(Stream,"shape("),write(Stream,H),write(Stream,"),"),
    write_shapes(Stream,T).

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
    M is N * 5,
    find_n_point_samples_inner(N,M,Bounds,Z,Threshold,Mag_seq_add,Dir_seq_add,Samples).
    
find_n_point_samples_inner(N,_,_,_,_,_,_,[]):-N =< 0.
find_n_point_samples_inner(_,M,_,_,_,_,_,[]):-M =< 0.
find_n_point_samples_inner(N,M,Bounds,Z,Threshold,Mag_seq_add,Dir_seq_add,Samples):-
    M2 is M - 1,
    (random_line_sample(Bounds,Z,Threshold,Mag_seq_add,Dir_seq_add,P1) ->    
        N2 is N - 1,
        find_n_point_samples_inner(N2,M2,Bounds,Z,Threshold,Mag_seq_add,Dir_seq_add,S),
        append([P1],S,Samples);
        find_n_point_samples_inner(N,M2,Bounds,Z,Threshold,Mag_seq_add,Dir_seq_add,Samples)).

random_line_sample(Bounds,Z,Threshold,Mag_add,Dir_add,Point):-
    random_radian(Dir),
    random_edge_point(Bounds,Dir,[X,Y]),
    random_line_sample_ex(Bounds,[X,Y,Z],Threshold,Dir,Mag_add,Dir_add,Point).
             
random_line_sample_ex(Bounds,[X,Y,Z],Threshold,Dir,Mag_add,Dir_add,Point):-
    add_coords_2d([X,Y],Dir,[Nx,Ny]),
    point_within_bounds([Nx,Ny],Bounds),
    (point_above_threshold([Nx,Ny,Z],Threshold,Mag_add,Dir_add)->
        Point = [Nx,Ny,Z];
        random_line_sample_ex(Bounds,[Nx,Ny,Z],Threshold,Dir,Mag_add,Dir_add,Point)).

point_above_threshold([X,Y,Z],Threshold,Mag_add,Dir_add):-
    sample_point([X,Y,Z],Mag_add,Dir_add,[Mag,_]),
    AMag is abs(Mag),
    AMag >= Threshold.

point_within_bounds([X,Y],[MaxX,MaxY]):-
    X >= 0, X =< MaxX, Y >= 0, Y =< MaxY.
    
