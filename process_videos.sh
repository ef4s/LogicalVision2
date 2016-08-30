for f in data/space_invaders/*
do
    b=$(basename $f)
    echo "test_video_source('$b',5,10,1000)."
    swipl -l src/LogicalAtari.pl -g "test_video_source('$b',5,10,1000)."
done

