a=10
b=20
c=a+b
d<-100
print(c, d)

library(tidyverse)
install.packages("nycflights13")
library(nycflights13)
install.packages("tinytex")
tinytex::install_tinytex()

tinytex::is_tinytex()

tinytex::reinstall_tinytex()

install.packages("tinytex")
tinytex::install_tinytex(force = TRUE)

tinytex::install_tinytex(repository = "illinois")

data(package="nycflights13")
head(airlines)
head(airports)
head(weather)
str(weather)
install.packages("DBI")
head(flights)

#1.1
flights%>%filter(dep_delay>600)%>%select(year, day, month, dep_time)

#1.2
head(weather)
str(weather)
weather%>%filter((temp*180/pi)>100)%>%select(temp, humid, year, month, day, hour)

#1.3
head(airlines)
head(planes)
str(flights)
airlines%>%filter(carrier=="WN")%>%select(name)

#1.4
head(planes)
planes%>%filter(manufacturer=="BOEING" & engines==4)%>%select(tailnum)

#1.5
str(airports)
airports%>%filter(lat>40 & lat<42)%>%filter(lon > -82 & lon < -80)%>%select(name, faa )

#1.6
str(flights)
flights%>%filter(abs(dep_delay)<1)%>%select(time_hour)

#2
str(flights)
str(airlines)

#2.1
flights%>%inner_join(airlines, by="carrier")%>%
  select(name, origin, dest, year, month, day)

#2.2
str(planes)
flights%>%left_join(planes, by="tailnum")

#2.3
flights%>%full_join(airports, by=c("dest"="faa"))   ##Outer join , i.e complete rows of both tables

#2.4
weather%>%right_join(flights, by=c("origin"="dest"))
str(weather)
str(flights)

#2.5
airports%>%right_join(weather, by=c("faa"="origin"))
str(airports)
str(weather)

#2.6
flights%>%left_join(airports, by=c("origin"="faa"))%>%select()

#Q3

#3.1
str(flights)
flights%>%inner_join(weather, by=c("origin", "time_hour")) %>% filter(arr_delay>600)%>%select(temp, time_hour, origin)
str(weather)


head(planes)
str(planes)
str(weather)
str(airports)
data(package="nycflights13")
str(flights)
str(weather)
#3.2
flights%>%inner_join(weather, by=c("origin","time_hour"))%>%filter((temp-32)*5/9> 100) %>% select(tailnum, time_hour, temp)


#3.3
flights%>%inner_join(airlines, by="carrier")%>%
  filter(year=="2013", month=="12", day=="25")%>%select(name, time_hour)

#3.4

str(weather)
weather$degree<-(weather$temp*180)/3.14
weather$degree

str(planes)
str(flights)
str(weather)

kable(weather%>%
        inner_join(flights%>%inner_join(planes, by="tailnum"), by=c("origin", "time_hour"))%>%
        filter(temp>100)%>%select(manufacturer, time_hour, temp))

#3.5

airports%>%inner_join(flights%>%inner_join(planes, by="tailnum"), by=c("faa"="dest"))%>%
  filter(engines==4)%>%select(name, engines)

#3.6
library(dplyr)

flights %>%
  inner_join(planes, by = "tailnum") %>%
  inner_join(weather, by = c("origin", "time_hour")) %>%
  filter(engines == 4, temp > 80) %>%
  inner_join(airports, by = c("origin" = "faa")) %>%
  rename(origin_name = name) %>%
  inner_join(airports, by = c("dest" = "faa")) %>%
  rename(dest_name = name) %>%
  select(origin_name, dest_name)

#Q4

#4.1
install.packages("DBI")
install.packages("RSQLite")
library(DBI)
library(RSQLite)
install.packages("RSQLite", dependencies = TRUE)
con<-dbConnect(RSQLite::SQLite(), dbname="seminar.db")

dbListTables(con)
dbListFields(con, "seminar")


res1<-dbGetQuery(con, "SELECT title from seminar where speakerIds=20")
print(res1)

res2<-dbGetQuery(con, "SELECT title from seminar where venueId=2")
print(res2)

res3<-dbGetQuery(con, "SELECT title, abstract from seminar where Id=45")
print(res3)

#Q5

res11<-dbGetQuery(con, "
SELECT seminar.title, speaker.name 
FROM seminar 
INNER JOIN speaker ON seminar.speakerIds=speaker.id 
WHERE speaker.id=20 ")

print(res11)


res22 <- dbGetQuery(con, "
  SELECT seminar.title, venue.name
  FROM seminar
  INNER JOIN venue ON seminar.venueId = venue.id
  WHERE venue.id = 2
")

print(res22)

Provide and tile, abstract, speaker name and venue for the seminar
with ID 45.

res23<-dbGetQuery(con, "
                  SELECT seminar.title, seminar.abstract, speaker.name, venue.name
                  FROM seminar 
                  INNER JOIN speaker 
                  ON seminar.speakerIds=speaker.id
                  INNER JOIN venue 
                  ON seminar.venueId=venue.id
                  WHERE seminar.id=45")
print(res23)

Provide the name and affiliation of all speakers who presented
seminars that were held before the year 2011. Note that dates are
written as date('YYYY-MM-DD')

res24<-dbGetQuery(con,"
                   SELECT speaker.name, speaker.affiliation 
                   FROM speaker
                   INNER JOIN seminar 
                   ON seminar.speakerIds=speaker.id
                   WHERE seminar.time< date('2011-01-01')")
print(res24)

Provide the title, speaker name, speaker affiliation and time of
seminars that were presented in either April of May in 2012. Order
the results by the speaker name.

res25<-dbGetQuery(con,"
                  SELECT seminar.title, speaker.name, speaker.affiliation, seminar.time
                  FROM seminar
                  INNER JOIN speaker
                  ON seminar.speakerIds=speaker.id
                  WHERE seminar.time>=date('2012-04-01') 
                  AND seminar.time<=date('2012-05-31') 
                  ORDER BY speaker.name")
print(res25)

dbDisconnect(con)
res25<-dbGetQuery(con,"
                  SELECT seminar.title, speaker.name, speaker.affiliation, seminar.time
                  FROM seminar
                  INNER JOIN speaker
                  ON seminar.speakerIds=speaker.id
                  WHERE seminar.time>=date('2012-04-01') 
                  AND seminar.time<=date('2012-05-31') 
                  ORDER BY speaker.name")
print(res25)