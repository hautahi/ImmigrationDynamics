
###################################################################33
#This is used to manipulate the data pulled from data_pull.R and make graphs
##################################################################### 

library(readr)
library(dplyr)
library(ggplot2)

######## Data Manipulation##################################

# --------------------
# Wages
# --------------------

# Load Data
dw <- read_csv("output/wagedata.csv")

# Create Grouping Type Variable
dw$grouping[dw$native=="0. Immigrant" & dw$skill=="0. Low"] = "Immigrant Low"
dw$grouping[dw$native=="0. Immigrant" & dw$skill== "1. High"] = "Immigrant High"
dw$grouping[dw$native=="1. Native" & dw$skill== "0. Low"] = "Native Low"
dw$grouping[dw$native=="1. Native" & dw$skill== "1. High"] = "Native High"

# Create time variable
dw <- dw %>%
  mutate(year=as.numeric(substr(cm,1,4)), month=as.numeric(substring(cm,6))) %>%
  mutate(time=year+(month-1)/12) %>%
  filter(year<2015,year>=2005)

# Create wage ratio variable
dw <- dw %>% filter(native=="1. Native",skill=="1. High") %>%
  select(time, wHN=MA_wage) %>% left_join(dw,.,by="time") %>%
  mutate(wageratio=MA_wage/wHN)

# Stats
wagestats <- dw %>%
  group_by(grouping) %>%
  summarise(ratios=mean(wageratio,na.rm=TRUE))

# Plot for Nominal Hourly Wage
g <- ggplot(data=dw,
            aes(x=time, y=MA_wage, group = grouping)) +
  geom_line(aes(linetype=grouping), size = 1.0) + 
  scale_linetype_manual(values=c("solid", "dashed","F1","twodash")) +
  ylab("Nominal Hourly Wage") + xlab("Year") + theme_bw(base_size = 14) +
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(), 
        panel.background = element_blank(), panel.border = element_rect(colour = "black", fill=NA, size=1))

nomwage <- g + theme(legend.position= "bottom") + theme(legend.text = element_text(size=12)) +
  theme(legend.title=element_blank()) +  theme(legend.key = element_blank()) +
  guides(fill=guide_legend(nrow=2,byrow=TRUE)) + scale_x_continuous(breaks=c(2005,2007,2009, 2011,2013))

print(nomwage)
  
ggsave(file="./graphs/wage1.png", dpi=72)

# Plot for Hourly Wage Ratio
g <- ggplot(data=dw, aes(x=time, y=wageratio, group=grouping)) +
  geom_line(aes(linetype=grouping), size = 1.0) + 
  scale_linetype_manual(values=c("solid", "dashed","F1","twodash")) +
  ylab("Wage Ratio") + xlab("Year")  + theme_bw(base_size = 14) +
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(), 
        panel.background = element_blank(), 
        panel.border = element_rect(colour = "black", fill=NA, size=1))

wagerat <- g + theme(legend.position= "bottom") + theme(legend.text = element_text(size=12)) +
  theme(legend.title=element_blank()) +  theme(legend.key = element_blank()) +
  guides(values=guide_legend(nrow=2)) + scale_x_continuous(breaks=c(2005,2007,2009, 2011,2013))

print(wagerat)

ggsave(file="./graphs/wage2.png", dpi=72) 

# --------------------
# Finding Rates
# --------------------

df <- read.dta("./data/findingrates.dta", convert.dates = TRUE, convert.factors = TRUE,
               missing.type = FALSE, convert.underscore = FALSE, warn.missing.labels = TRUE)

dfagg <- read.dta("./data/timeaggrates.dta", convert.dates = TRUE, convert.factors = TRUE,
                  missing.type = FALSE, convert.underscore = FALSE, warn.missing.labels = TRUE)

df <- df[df$year<2015 & df$year>=2005,]
dfagg <- dfagg[dfagg$year<2015 & dfagg$year>=2005,]

df$time <- seq(2005,by=1/12, length.out = length(df$skill[df$skill=="High"]))
dfagg$time <- seq(2005,by=1/12, length.out = length(dfagg$skill[dfagg$skill=="High"]))

# Stats
fH = mean(df$MA_f[df$skill=="High"],na.rm = TRUE)
fL = mean(df$MA_f[df$skill=="Low"],na.rm = TRUE)

fHagg = mean(dfagg$MA_f_in[dfagg$skill=="High"],na.rm = TRUE)
fLagg = mean(dfagg$MA_f_in[dfagg$skill=="Low"],na.rm = TRUE)

FHagg = mean(dfagg$MA_F[dfagg$skill=="High"],na.rm = TRUE)
FLagg = mean(dfagg$MA_F[dfagg$skill=="Low"],na.rm = TRUE)

# Plot
g <- ggplot(data=dfagg, aes(x=time, y=MA_f_in, group=skill)) +
      geom_line(aes(linetype=skill), size = 1.0) + 
      scale_linetype_manual(values=c("solid", "dashed")) +
      ylab("Job Finding Rate") + xlab("Month")  + theme_bw(base_size = 14) +
      theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(), 
        panel.background = element_blank(), 
        panel.border = element_rect(colour = "black", fill=NA, size=1))
      
g <- g + theme(legend.position= "bottom") + theme(legend.text = element_text(size=12)) +
  theme(legend.title=element_blank()) +  theme(legend.key = element_blank()) +
  guides(fill=guide_legend(nrow=2,byrow=TRUE)) + scale_x_continuous(breaks=c(2005,2007,2009, 2011,2013)) 


print(g)

ggsave(file="./graphs/finding.png", dpi=72) 

# --------------------
# Unemployment Rates
# --------------------

dp <- read.dta("./data/population.dta", convert.dates = FALSE, convert.factors = TRUE,
               missing.type = FALSE, convert.underscore = FALSE, warn.missing.labels = TRUE)
  
dp <- dp[dp$year<2015 & dp$year>=2005,]

dp$time <- seq(2005,by=1/12, length.out = length(dp$grouping[dp$grouping=="Immigrant High"]))

g <- ggplot(data=dp, aes(x=time, y=MA_u, group=grouping)) +
    geom_line(aes(linetype=grouping), size = 1.0) + 
    scale_linetype_manual(values=c("solid", "dashed","F1","twodash")) +
    ylab("Unemployment Rate") + xlab("Year") + theme_bw(base_size = 14) +
    theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(), 
          panel.background = element_blank(), 
          panel.border = element_rect(colour = "black", fill=NA, size=1))
  
g <- g + theme(legend.position= "bottom") + theme(legend.text = element_text(size=12)) +
    theme(legend.title=element_blank()) + theme(legend.key = element_blank()) +
    guides(fill=guide_legend(nrow=2,byrow=TRUE)) + scale_x_continuous(breaks=c(2005,2007,2009, 2011,2013)) 
  
print(g)

ggsave(file="./graphs/unemployment.png", dpi=72) 

uHN = mean(dp$MA_u[dp$grouping=="Native High"],na.rm = TRUE)
uHI = mean(dp$MA_u[dp$grouping=="Immigrant High"],na.rm = TRUE)
uLN = mean(dp$MA_u[dp$grouping=="Native Low"],na.rm = TRUE)
uLI = mean(dp$MA_u[dp$grouping=="Immigrant Low"],na.rm = TRUE)

# --------------------
# Population Shares
# --------------------

odie <- aggregate(dp$LF, by=list(dp$time), FUN=sum)
rename(odie, c("Group.1"="time"))
names(odie)[names(odie)=="Group.1"] <- "time"

plyr1 <- join(dp, odie, by = "time")

plyr1$propLF <- plyr1$MA_LF/plyr1$x
dp<-plyr1

g <- ggplot(data=plyr1, aes(x=time, y=propLF, group=grouping)) +
  geom_line(aes(linetype=grouping), size = 1.0) + 
  scale_linetype_manual(values=c("solid", "dashed","F1","twodash")) +
  ylab("Population") + xlab("Year")  + theme_bw(base_size = 14) +
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(), 
        panel.background = element_blank(), 
        panel.border = element_rect(colour = "black", fill=NA, size=1))

g <- g + theme(legend.position= "bottom") + theme(legend.text = element_text(size=12)) +
  theme(legend.title=element_blank()) + theme(legend.key = element_blank()) +
  guides(fill=guide_legend(nrow=2,byrow=TRUE)) + scale_x_continuous(breaks=c(2005,2007,2009, 2011,2013)) 

print(g)

ggsave(file="./graphs/populationshare.png", dpi=72) 

QHN = mean(dp$propLF[dp$grouping=="Native High"],na.rm = TRUE)
QHI = mean(dp$propLF[dp$grouping=="Immigrant High"],na.rm = TRUE)
QLN = mean(dp$propLF[dp$grouping=="Native Low"],na.rm = TRUE)
QLI = mean(dp$propLF[dp$grouping=="Immigrant Low"],na.rm = TRUE)


##########################################
# --------------------
# Graph
# --------------------
labpcfile <- readMat("labpc.mat")
tmpdata <- labpcfile[[datastr]]
tmpdata <- drop(tmpdata)
for (k in 1:length(tmpdata)){
  if (mode(tmpdata[[k]]) == "list") {
    tmpdata[[k]]<- as.factor(do.call("rbind", tmpdata[[k]]))
  }
}
tmpdf <- as.data.frame(tmpdata)

 
