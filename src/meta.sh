for f in intput*.txt
do
    echo "results_$f"
    #yap -l src/MetaAtari_grammar.pl -r $f -g a >> "results_$f"
done

for f in results_intput*.txt
do
    yap -l $f
    #yap -l src/MetaAtari_grammar.pl -r $f -g b >> "counts_${f%.*}".txt
done




