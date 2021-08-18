### bash script
### Separate Backbone and Sidechain contributions for preferential binding coefficient

max=1001  # total frames
nu=23  # number of coslvent
nw=6305  # number of water
bin=100  # number of bins



gmx pairdist -f ../*.xtc -s ../md5.tpr -n ../index.ndx -ref -sel "mol_com of resname INS" -refgrouping mol -selgrouping mol -xvg none -o insBb.xvg < inoBb.inp 
gmx pairdist -f ../*.xtc -s ../md5.tpr -n ../index.ndx -ref -sel "mol_com of resname INS" -refgrouping mol -selgrouping mol -xvg none -o insSc.xvg < inoSc.inp

paste insBb.xvg insSc.xvg > totIns


gmx pairdist -f ../*.xtc -s ../md5.tpr -n ../index.ndx -ref -sel "mol_com of resname SOL" -refgrouping mol -selgrouping mol -xvg none -o solBb.xvg < solBb.inp     
gmx pairdist -f ../*.xtc -s ../md5.tpr -n ../index.ndx -ref -sel "mol_com of resname SOL" -refgrouping mol -selgrouping mol -xvg none -o solSc.xvg < solSc.inp

paste solBb.xvg solSc.xvg > totSol

awk -v ter=$max '{for(i=2;i<=24;++i) if ($(i)<=$(i+24)) {var=int($i*100); N[var]=N[var]+1}} END {for(i=1;i<=150;i++) {if ( N[i]>0 ) {print  i , N[i]/ter} else {print  i, 0}}}'  totIns > hbbIns

awk -v ter=$max '{for(i=2;i<=24;++i) if ($(i)>$(i+24)) {var=int($(i+24)*100); N[var]=N[var]+1}} END {for(i=1;i<=150;i++) {if ( N[i]>0 ) {print  i , N[i]/ter} else {print  i, 0}}}'  totIns > hscIns



awk -v ter=$max '{for(i=2;i<=6306;++i) if ($(i)<=$(i+6306)) {var=int($i*100); N[var]=N[var]+1}} END {for(i=1;i<=150;i++) {if ( N[i]>0 ) {print  i , N[i]/ter} else {print  i, 0}}}'  totSol > hbbSol

awk -v ter=$max '{for(i=2;i<=6306;++i) if ($(i)>$(i+6306)) {var=int($(i+24)*100); N[var]=N[var]+1}} END {for(i=1;i<=150;i++) {if ( N[i]>0 ) {print  i , N[i]/ter} else {print  i, 0}}}'  totSol > hscSol


awk ' { sum+=$2; print $1,sum;  } ' hbbIns > acuBbIns
awk ' { sum+=$2; print $1,sum;  } ' hscIns > acuScIns

awk ' { sum+=$2; print $1,sum;  } ' hbbSol > acuBbSol
awk ' { sum+=$2; print $1,sum;  } ' hscSol > acuScSol



paste acuBbIns  acuBbSol > allBb
paste acuScIns  acuScSol > allSc

awk '{ print $1,  $2-($4*((23-$2)/(6305-$4))) }' allBb  > pbcBb
awk '{ print $1,  $2-($4*((23-$2)/(6305-$4))) }' allSc  > pbcSc
