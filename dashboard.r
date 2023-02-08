df<-read.csv("C:\\Users\\diya\\OneDrive\\Desktop\\copyy.csv")
head(df)
df1<-read.csv("C:\\Users\\diya\\OneDrive\\Desktop\\first coipy.xlsx.csv")
head(df1)

data = merge(df,df1,by.x = "ARREST_KEY",by.y="ARREST_KEY",all=TRUE)
head(data)

data1 <-data[ ,-c(2,3,9,10) ]
#some redundnt data wwas genenrated duing merge
head(data1)

#the date was not consistent some was 6/26/22 and 9-34-22
#so i formatted the date
df$ARREST_DATE<-as.Date(df$ARREST_DATE,format="%d-%m-%Y")
class(df$ARREST_DATE)
head(df)

format(df$ARREST_DATE,"%d-%m-%Y")

#removing all the NA values from the dataset
df <- df[complete.cases(df), ] 
df

#the borough column was having values B,M,Q,K i needed the names of it
#so i modifed the boro Arrees_Boro column

bronx<-subset(df,df$ARREST_BORO=='B')
bronx
bronx$ARREST_BORO='Bronx'


man<-subset(df,df$ARREST_BORO=='M')
man
man$ARREST_BORO='Manhattan'

q<-subset(df,df$ARREST_BORO=='Q')
q
q$ARREST_BORO='Queens'

k<-subset(df,df$ARREST_BORO=='K')
k
k$ARREST_BORO='Brooklyn'

s<-subset(df,df$ARREST_BORO=='S')
s
s$ARREST_BORO='Staten Island'


df2<-do.call("rbind", list(s,k, q, man,bronx))
head(df2)

#adding a day column with the help of date coulmn
head(df2)
df2$day=weekdays(df2$ARREST_DATE)
head(df2)


#pushing all the changes to the file
write.csv(df2,"C:\\Users\\diya\\OneDrive\\Desktop\\NYPD_Arrest_Data__Year_to_Date_.csv")


#queries from the data
#list to 5 ofences based on their occurence
install.packages('plyr')
library(plyr)
ans=count(df2$OFNS_DESC)
ans=ans[order(-ans$freq),]
head(ans)

#list top 2 perp race based on their freq occurence
race=count(df2$PERP_RACE)
race=race[order(-race$freq),]
race
race[0:2,]

#the % of male and female perp
gender=count(df2$PERP_SEX)
summ=sum(gender$freq)
gender$freq=gender$freq*100/summ
gender

#the age grp tht committed most of the crime in %
age=count(df2$AGE_GROUP)
age$freq=age$freq/summ
age=age[order(-age$freq),]
age

#the sum of number of arrests based upon the weekday 
week=count(df2$day)
week$freq=week$freq/summ
week=week[order(-week$freq),]
week


#the top 2 type of crimes
crime=count(df2$LAW_CAT_CD)
crime$freq=crime$freq/summ
crime=crime[order(-crime$freq),]
crime[0:2,]
