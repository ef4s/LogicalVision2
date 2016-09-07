ename="experiments"

trials=200

rm -rf $ename
mkdir $ename

for n in `seq $trials`
do
    echo "Running experiment $n"
#    yap -l example_objects.pl -g e >> "experiments/hypothesis_$n.pl"
    sleep 1
    echo ":-['../eval_experiment']." >> "$ename/hypothesis_$n.pl" 
    yap -l single_experiment -g e >> "$ename/hypothesis_$n.pl"
    yap -l eval_experiment -l $ename/hypothesis_$n.pl -g a >> $ename/result_$n.pl
    
done

