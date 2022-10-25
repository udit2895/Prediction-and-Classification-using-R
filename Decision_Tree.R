library(ggplot2)
library(dplyr)
library(rpart)
library(rpart.plot)
library(fastDummies)
library("lattice")
library(caret)
install.packages("gains")
library(gains)

#...... Question 2
#....a

ebay.auctions.df <- read.csv("eBayAuctions.csv") #To import the file from the directory
names(ebay.auctions.df)[names(ebay.auctions.df) == "Competitive."] <- "Competitive" #Change column name
head(ebay.auctions.df)

# Creating the Dummy variables for 'Duration'
ebay.auctions.df <- dummy_cols(ebay.auctions.df, select_columns = 'Duration') 

#Removing the original 'Duration' column
ebay.auctions.df <- cbind(ebay.auctions.df[,-4])
head(ebay.auctions.df)
dim(ebay.auctions.df)

#Spliting the data into training (60%) and validation(40%)
set.seed(1)

train.index <- sample(c(1:dim(ebay.auctions.df)[1]),dim(ebay.auctions.df)[1]*0.6)
train.df <- ebay.auctions.df[train.index,] #60% of the dataset in the train variable
valid.df <- ebay.auctions.df[-train.index, ]#Balance 40% of the dataset in the valid variable
nrow(valid.df)
nrow(train.df)

# classification tree on training dataset
default.train.ct <- rpart(Competitive ~ ., data = train.df, 
                    control = rpart.control(maxdepth = 7), minbucket = 50, method = "class")
prp(default.train.ct, type =1, extra = 5,under=TRUE, split.font = 0, varlen = -10, tweak=1.1)
#Confusion matrices and accuracy for the training dataset
default.ct.point.pred.train <-as.factor(predict(default.train.ct, valid.df, type = "class"));default.ct.point.pred.train
confusionMatrix(default.ct.point.pred.train, as.factor(train.df$Competitive), mode = "everything")

#.....d

#After analysis, Removing the "Category", "Currency", "Seller Rating" columns
ebay.auctions.df <- read.csv("eBayAuctions.csv")
names(ebay.auctions.df)[names(ebay.auctions.df) == "Competitive."] <- "Competitive"
head(ebay.auctions.df)
ebay.auctions.df <- cbind(ebay.auctions.df[,-1:-3])
head(ebay.auctions.df)
dim(ebay.auctions.df)

# Creating the Dummy variables for 'Duration'
ebay.auctions.df <- dummy_cols(ebay.auctions.df, select_columns = 'Duration')

#Removing the original 'Duration' column
ebay.auctions.df <- cbind(ebay.auctions.df[,-1])
head(ebay.auctions.df)
dim(ebay.auctions.df)

#Spliting the data into training (60%) and validation(40%)
set.seed(24)

train.1.index <- sample(c(1:dim(ebay.auctions.df)[1]),dim(ebay.auctions.df)[1]*0.6)
train.1.df <- ebay.auctions.df[train.1.index,]
valid.1.df <- ebay.auctions.df[-train.1.index, ]
nrow(valid.1.df)
nrow(train.1.df)

# classification tree on training dataset using best pruned tree
cv.ct <- rpart(Competitive ~ ., data = train.1.df, method = "class",control = rpart.control(maxdepth = 7),
               cp = 0.00001, minsplit = 7, xval = 5)
printcp(cv.ct)
pruned.ct <- prune(cv.ct,
                   cp = cv.ct$cptable[which.min(cv.ct$cptable[,"xerror"]),"CP"])
length(pruned.ct$frame$var[pruned.ct$frame$var == "<leaf>"])
prp(pruned.ct, type = 1, extra = 1, split.font = 1, varlen = -10,tweak = 1.2)

#Prediction and Confusion matrices of the model
default.ct.point.pred.train.1 <-as.factor(predict(cv.ct, valid.1.df, type = "class"));default.ct.point.pred.train.1
confusionMatrix(default.ct.point.pred.train.1, as.factor(valid.1.df$Competitive),mode="everything", positive = "1")


#.....e
#Scatter Plot
head(ebay.auctions.df)
ggplot(ebay.auctions.df , aes(OpenPrice,ClosePrice, color = Competitive))+
  geom_point(size = 3, alpha = 0.6)+
  geom_jitter(shape=1, size = 3)+
  theme_light()+
  ggtitle(label = "Open Price vs. Close Price")+ 
  labs(x="Open Price", y ="Close Price")


    