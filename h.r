# echo $( rscript --vanilla  h.r ) | sed -e 's/\[1\]//g;s/\"//g'

library(scholar)
bob<-get_profile("5SzRq1oAAAAJ")
paste("\\small{H-Index ", bob$h_index, " (", bob$total_cites, " citations as of ", date(), ")}",sep="")
