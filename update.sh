perl -e '$bob=`rscript --vanilla  h.r`; $bob=~s/\\//; $bob=~s/\[1\]//;$bob=~s/\"//g;  open FILE, "<CV.temp.tex"; open CV, ">CV.tex"; while(<FILE>){ if($_=~m/^H\-Index/){ print CV "$bob\n" } else{ print CV $_;}    }'
pdflatex CV.tex
