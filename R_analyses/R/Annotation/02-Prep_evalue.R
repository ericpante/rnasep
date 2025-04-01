#######################################

# script dedicated to annotation summary

######################################


library(tidyr)
library(readr)
library(dplyr)
library(ggplot2)


Prep_evalue <- function(blast){
  colnames(blast) <- c("qseqid", "sseqid", "pident", "length", "mismatch", "gapopen", "qstart", "qend", "sstart", "send", "evalue", "bitscore")
  
  Blast <- blast %>%
  select(qseqid,evalue) %>%
  group_by(qseqid) %>%
  summarise(evalue=mean(evalue)) %>%
  mutate(Class=ifelse(evalue>1e-50, "1e-5 - 1e-50",
         ifelse(evalue<1e-50 & evalue>1e-100, "1e-50 - 1e-100",
                ifelse(evalue<1e-100 & evalue>1e-150, "1e-100 - 1e-150",
                       ifelse(evalue<1e-150, "1e-150 - 0", "NULL")))))

  total = nrow(Blast)

  class1 = nrow(data.frame(filter(Blast, Class=="1e-5 - 1e-50")))
# return(class1)
  class2 = nrow(data.frame(filter(Blast, Class=="1e-50 - 1e-100")))
#  return(class2)
  class3 = nrow(data.frame(filter(Blast, Class=="1e-100 - 1e-150")))
#  return(class3)
  class4 = nrow(data.frame(filter(Blast, Class=="1e-150 - 0")))
#  return(class4)

  class = factor(x=c("1e-5 - 1e-50","1e-50 - 1e-100","1e-100 - 1e-150","1e-150 - 0"),
                 levels = c("1e-5 - 1e-50","1e-50 - 1e-100","1e-100 - 1e-150","1e-150 - 0"))
  nb = c(class1,class2,class3,class4)
  
  prop = c((nb*100)/nrow(Blast))
  
data.frame(class, nb, prop) %>%
  arrange(desc(class)) %>%
  mutate(lab.ypos = cumsum(prop) - 0.5*prop,
         prop=round(prop,1))
}