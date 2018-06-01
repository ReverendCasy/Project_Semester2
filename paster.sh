#!
cd kallisto_ref
cd 1_after ; awk 'NR>1 {print $1"\t"$5}' abundance.tsv > ~/kallisto_ref/1after.tsv
cd ../1_before ; awk 'NR>1 {print $5}' abundance.tsv > ~/kallisto1before.tsv
for dir in $(cd ../ ; ; ls -Al | awk '{print $9}' | grep -v '1')
do cd ~/kallisto_ref/$dir ; awk 'NR>1 {print $5}' abundance.tsv > ~/kallisto_ref/$dir.tsv
done
cd ~/kallisto_ref
paste *.tsv > final_matrix.tsv
