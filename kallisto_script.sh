#!
cd ../arshuvalova/Skaters
for file in $(ls -Al | awk '{print $9}' | cut -c 1-6 | uniq)
do ../../uvmalovichko/kallisto_linux-v0.44.0/kallisto quant  -i ../../uvmalovichko/index -b 50 -o ../../uvmalovichko/kallisto_ref/$file* $file*R1* $file*R2*
done

