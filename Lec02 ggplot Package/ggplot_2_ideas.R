#------------------------------------------------------------------------------
# UC Berkeley
#------------------------------------------------------------------------------
data(UCBAdmissions)
UCBAdmissions

# The original data is not in "tidy" format, so we tidy it.  Here tidying was
# super easy.  Typically it won't be.
UCB <- as.data.frame(UCBAdmissions)
UCB


library(scales)
ggplot(UCB, aes(x=Gender, y=Freq, fill = Admit)) +
  geom_bar(stat = "identity", position="fill") +
  facet_wrap(~ Dept, nrow = 2) +
  scale_y_continuous(labels = percent) +
  ggtitle("Acceptance Rate Split by Gender & Department") +
  xlab("Gender") +
  ylab("% of Applicants")


ggplot(UCB, aes(x=Dept, y=Freq, fill = Admit)) +
  geom_bar(stat = "identity", position="fill") +
  ggtitle("Acceptance Rate Split by Department") +
  xlab("Dept") +
  ylab("% of Applicants")


