#------------------------------------------------------------------------
rm(list=ls(all=TRUE))

packages <- c("data.table", "sparklyr")
installed_packages <- installed.packages()

for(pkg in packages) {
  print(pkg)
  if(!pkg %in% installed_packages) {
    install.packages(pkg)
  }
}

library(data.table)
library(sparklyr)
library(dplyr)

sc <- spark_connect(master = "local")

#Count number of rows
##nrow(data.table::fread('/Users/wesleyloubar/Documents/USP - PPGEE/PCS5031 - Introdução à Ciência dos Dados/Artigo/arm_data/arm_data.csv'))
#nrow(data.table(Sys.env("ARM_DATA")))
#nrow(read.csv(dataurl, header= T/F))

dataurl <- paste(Sys.getenv("ARM_DATA"), "maoaoscoS1.b1", "test.tsv, sep="/")

#read csv file
co_mean <- c(0)
n2_mean <- c(0)
h2o_mean <- c(0)

co_stdev <- c(0)
n2_stdev <- c(0)
h2o_stdev <- c(0)

summ_data <- data.table()

for(i in 1:699){
  arm_data <- read.delim(dataurl, header = T, stringsAsFactors = F, skip = (1+(i-1)*86400), nrows = 86400) 
  colnames(arm_data) <- c("DATA","CO","N2","H2O")

  arm_data_tbl <- copy_to(sc, arm_data)

  summ_data$CO_MEAN <- arm_data %>%
    summarise(co_mean=mean(arm_data_tbl$CO, na.rm = TRUE))
  
  #co_mean[i] = mean(arm_data$CO, na.rm = TRUE)
  #n2_mean[i] = mean(arm_data$N2, na.rm = TRUE)
  #h2o_mean[i] = mean(arm_data$H2O, na.rm = TRUE)
  #co_stdev[i] = sd(arm_data$CO, na.rm = TRUE)
  #n2_stdev[i] = sd(arm_data$N2, na.rm = TRUE)
  #h2o_stdev[i] = sd(arm_data$H2O, na.rm = TRUE)
  
  cat("Dia: ", i,"\n") 
}

write.csv(summ_data, paste(Sys.getenv("ARM_DATA"), "output.csv", sep="/"))