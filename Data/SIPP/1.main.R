# analyze survey data for free (http://asdfree.com) with the r language
# survey of income and program participation
# 2008 panel wave 2


# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#############################################################################################################################################################
# prior to running this analysis script, the survey of income and program participation 2008 panel must be loaded as a database (.db) on the local machine. #
# running the "2008 panel - download and create database" script will create this database file                                                             #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# https://raw.github.com/ajdamico/asdfree/master/Survey%20of%20Income%20and%20Program%20Participation/2008%20panel%20-%20download%20and%20create%20database.R #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# that script will create a file "SIPP08.db" in C:/My Directory/SIPP or wherever the working directory was set for the program                              #
#############################################################################################################################################################
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# "SIPP08.db" created by the R program specified above

# install.packages( c( "survey" , "RSQLite" ) )
library(survey)		# load survey package (analyzes complex design surveys)
library(RSQLite) 	# load RSQLite package (creates database files in R)
library(stats)

# immediately connect to the SQLite database
# this connection will be stored in the object 'db'
db <- dbConnect( SQLite() , "./databases/SIPP08.db" )

#########################################
# access the appropriate core wave data #

# which wave would you like to pull?
# to see which waves correspond with what months, see http://www.census.gov/sipp/usrguide/ch2_nov20.pdf
# pages 5, 6, 7, and 8 have sipp panels 2008, 2004, 2001, and 1996, respectively
wave <- 4
# wave 2 was conducted january 2009 - april 2009 and contains data for september 2008 - march 2009.
# remember that most months occur in multiple waves (see calendar month alternative below for more detail)

# make a character vector containing the variables that should be kept from the core file (core keep variables)
core.kv <- 
	c( 
		# variables you almost certainly need for every point-in-time analysis
		'ssuid' , 'epppnum' , 'wpfinwgt' , 'tage' , 
	
		# variables specific to this analysis
		'esex' , 'ems' , 'eeducate' , 'ebornus', 'whfnwgt'
	)


# each core wave data file contains data at the person-month level.  in general, there are four records per respondent in each core wave data set.
# for most point-in-time analyses, use the fourth (most current) month,
# specifically isolated below by the 'srefmon == 4' command

# create a sql string containing the select command used to pull only a defined number of columns 
# and records containing the fourth reference month from the full core data file
sql.string <- paste0( "select " , paste( core.kv , collapse = "," ) , " from w" , wave , " where srefmon == 4" )
# note: this yields point-in-time data collected over a four month period.

# run the sql query constructed above, save the resulting table in a new data frame called 'x' that will now be stored in RAM
x <- dbGetQuery( db , sql.string )

# look at the first six records of x
head(x)

################################################
# optional: access desired topical module data #

# the 'wave' variable has already been defined above..
# the code below will assume the topical from the same wave should be used.

# make a character vector containing the variables that should be kept from the topical module file (topical module keep variables)
tm.kv <- 
	c( 
		# variables you almost certainly need for every analysis
		'ssuid' , 'epppnum' , 
		
		# variables specific to this analysis
		 'thhtnw' 
	)


# each topical module data file contains data at the person-level.  in general, there is one record per respondent in each topical module data set.
# topical module data corresponds with the month prior to the interview, so using the 'srefmon == 4' filter on the core file will correspond with that wave's topical module

# create a sql string containing the select command used to pull only a defined number of columns 
sql.string <- paste0( "select " , paste( tm.kv , collapse = "," ) , " from tm" , wave )

# run the sql query constructed above, save the resulting table in a new data frame called 'tm' that will now be stored in RAM
tm <- dbGetQuery( db , sql.string )

# look at the first six records of tm
head( tm )


######################################
# optional: merge the topical module #

# merge the topical module to the already-merged core and the replicate weights data files
#y <- merge( x.rw , tm )
y <- merge( x , tm )

# confirm no loss of records
# (in other words, each record in the core wave data file has a match in the topical module file)
stopifnot( nrow( x ) == nrow( y ) )

# remove the core and replicate weight merged data frame
# as well as the (pre-merged) topical module data frames from RAM
rm( x , tm )

# clear up RAM
gc()

save( y , file = "sipp0810wave4.rda" )
#########################################

myfunction <- function(y1){

y1$skill[y1$eeducate>39 ] = "High"
y1$skill[y1$eeducate<39 & y1$eeducate>0] = "Low"

y1$wtwealth<-y1$thhtnw/10000*y1$whfnwgt

#aHN=weighted.mean(y1$thhtnw[y1$skill=="High" & y1$ebornus==1],y1$whfnwgt[y1$skill=="High" & y1$ebornus==1],na.rm = TRUE)
#aHI=weighted.mean(y1$thhtnw[y1$skill=="High" & y1$ebornus==2],y1$whfnwgt[y1$skill=="High" & y1$ebornus==2],na.rm = TRUE)
#aLN=weighted.mean(y1$thhtnw[y1$skill=="Low" & y1$ebornus==1],y1$whfnwgt[y1$skill=="Low" & y1$ebornus==1],na.rm = TRUE)
#aLI=weighted.mean(y1$thhtnw[y1$skill=="Low" & y1$ebornus==2],y1$whfnwgt[y1$skill=="Low" & y1$ebornus==2],na.rm = TRUE)

aHN=sum(y1$wtwealth[y1$skill=="High" & y1$ebornus==1],na.rm = TRUE)
aHI=sum(y1$wtwealth[y1$skill=="High" & y1$ebornus==2],na.rm = TRUE)
aLN=sum(y1$wtwealth[y1$skill=="Low" & y1$ebornus==1],na.rm = TRUE)
aLI=sum(y1$wtwealth[y1$skill=="Low" & y1$ebornus==2],na.rm = TRUE)

shareHN = aHN/(aHN+aHI+aLN+aLI)
shareHI = aHI/(aHN+aHI+aLN+aLI)
shareLN = aLN/(aHN+aHI+aLN+aLI)
shareLI = aLI/(aHN+aHI+aLN+aLI)

odie <- c(shareHN,shareHI,shareLN,shareLI)

return(odie)
}

load("sipp0810wave10.rda")
y1 <- y[!duplicated(y$ssuid),]
Wave10shares <- myfunction(y1)

load("sipp0810wave7.rda")
y1 <- y[!duplicated(y$ssuid),]
Wave7shares <- myfunction(y1)

load("sipp0810wave4.rda")
y1 <- y[!duplicated(y$ssuid),]
Wave4shares <- myfunction(y1)

####################
# recode variables #
