#------------------------------------------------------------------------
rm(list=ls(all=TRUE))

library('data.table')
#Count number of rows
##nrow(data.table::fread('/Users/wesleyloubar/Documents/USP - PPGEE/PCS5031 - Introdução à Ciência dos Dados/Artigo/arm_data/arm_data.csv'))
nrow(data.table(Sys.env("ARM_DATA")))
#nrow(read.csv(dataurl, header= T/F))

dataurl <- Sys.env("ARM_DATA")

#read csv file
co_mean <- c(0)
n2_mean <- c(0)
h2o_mean <- c(0)

co_stdev <- c(0)
n2_stdev <- c(0)
h2o_stdev <- c(0)

for(i in 1:699){
  arm_data <- read.csv(dataurl, header = T, stringsAsFactors = F, skip = (1+(i-1)*86400), nrows = 86400) 
  colnames(arm_data) <- c("X","DATA","CO","N2","H2O")
  
  co_mean[i] = mean(arm_data$CO, na.rm = TRUE)
  n2_mean[i] = mean(arm_data$N2, na.rm = TRUE)
  h2o_mean[i] = mean(arm_data$H2O, na.rm = TRUE)
  co_stdev[i] = sd(arm_data$CO, na.rm = TRUE)
  n2_stdev[i] = sd(arm_data$N2, na.rm = TRUE)
  h2o_stdev[i] = sd(arm_data$H2O, na.rm = TRUE)
  
  cat("Dia: ", i,"\n") 
}