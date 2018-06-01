#!
cd kallisto_ref
for directory in $(cd ~/kallisto_ref ; ls -Al | awk '{print $9}' | tail -14)
do cd ~/kallisto_ref/$directory  ; cat abundance.tsv | sort -rn -t $'\t' -k5,5 |head -30 > ~/subset_dir/$directory.tsv
done

