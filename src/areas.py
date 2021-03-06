# Read file
import csv


results = []
with open('inputfile.txt', newline='') as inputfile:
    for row in csv.reader(inputfile):
        results.append(row)
        
        
n_buckets = 3

for i in range(1, n_buckets):
    with open('outputfile' + str(i) + '.txt', 'w+') as outputfile,open('intputfile' + str(i) + '.txt', 'w+') as inputfile:
        
    
        inputfile.write("pos([t([")
        s = split(results[0],n_buckets,i)
        inputfile.write(",".join(s[0]))
        inputfile.write("],[])")
        
        outputfile.write(",".join(s[1]))
        outputfile.write("\n")
        
        for r in results[1:]:  
            inputfile.write(",t([")
            s = split(r,n_buckets,i)
            inputfile.write(",".join(s[0]))
            inputfile.write("],[])")

            outputfile.write(",".join(s[1]))
            outputfile.write("\n")
        
        inputfile.write("])\n")

