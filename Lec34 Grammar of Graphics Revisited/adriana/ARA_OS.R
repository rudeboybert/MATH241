FULL=read.csv("full.csv", header=TRUE)
library(car)
require(ggplot2)
require(lme4)
library(phia)
load("~/Desktop/atheism.RData")
# I've been using the inference function that was installed in this Math 141 dataset, 
# is there a better way to access this function, 
# that is if you think i need this function in my analysis

#Crearte subset and subset variables' vectors
OS  <- subset (FULL,FULL$Set.ID =='OS' )

os.sample <- OS$Sample
os.retention <- OS$Peak..rt.
os.set <- OS$Set.ID
os.gas <- OS$Gas.Estimate
os.nmoles.mL  <- OS$nmoles.mL
os.ethylene  <- OS$Gas.Estimate == "Ethylene"
os.rep  <- OS$Rep..ID.
os.time  <- OS$time..hr.
os.date  <- OS$Date

#Create model to compare ethylene amounts by sample, with respect to variation between reps & hours of experiment
os.mod <- lmer(os.nmoles.mL ~ os.sample + (1|os.rep) + (1|os.time))
print(os.mod, correlation=FALSE)
Anova(os.mod)

#Create plot 
qplot(os.sample, os.nmoles.mL, geom=c("boxplot", "jitter"), 
      xlab="Old Samples", ylab="Ethylene (nmoles)")

#Hypothesis test, sample =\= 0 nmoles
inference(y=os.nmoles.mL, x=os.sample, est="mean", type="ht", alternative="greater", method="theoretical")


