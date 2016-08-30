for f in data/space_invaders/*
do
    echo "test_video_source('$f',5,10,1000)."
    swipl -l src/LogicalAtari.pl -g "test_video_source('$f',5,10,1000)."
done

