library(ggplot2)
library(dplyr)
library(rpart)
library(rpart.plot)
library(fastDummies)
library("lattice")
library(caret)
install.packages("gains")
library(gains)

#...... Question 1

propensity <- c(0.03,0.52,0.38,0.82,0.33,0.42,0.55,0.59,0.09,0.21,0.43,0.04,0.08,0.13,0.01,0.79,0.42,0.29,0.08,0.02)
actual <- c(0,0,0,1,0,0,1,0,0,0,0,0,0,0,0,1,0,0,0,0)
a <- data.frame(propensity , actual)

# cut-off = 0.5
confusionMatrix(as.factor(ifelse(a$propensity>0.5, '1','0')), as.factor(a$actual), mode = "everything", positive = "1")

# cut-off = 0.25
confusionMatrix(as.factor(ifelse(a$propensity>0.25, '1','0')), as.factor(a$actual), mode = "everything", positive = "1")

# cut-off = 0.75
confusionMatrix(as.factor(ifelse(a$propensity>0.75, '1','0')), as.factor(a$actual), mode = "everything", positive = "1")

# Decile-wise-lift chart

gain <- gains(a$actual,a$propensity)
barplot(gain$mean.resp/mean(a$actual),names.arg = gain$depth, xlab = "Percentile", ylab = "Mean Response",
        main = "Decile-wise lift chart")


#...... Question 2
#....a

ebay.auctions.df <- read.csv("eBayAuctions.csv")
names(ebay.auctions.df)[names(ebay.auctions.df) == "Competitive."] <- "Competitive"
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
train.df <- ebay.auctions.df[train.index,]
valid.df <- ebay.auctions.df[-train.index, ]
nrow(valid.df)
nrow(train.df)

# classification tree on training dataset
default.train.ct <- rpart(Competitive ~ ., data = train.df, 
                    control = rpart.control(maxdepth = 7), minbucket = 50, method = "class")
prp(default.train.ct, type =1, extra = 5,under=TRUE, split.font = 0, varlen = -10, tweak=1.55)
#Confusion matrices and accuracy for the training dataset
default.ct.point.pred.train <-as.factor(predict(default.train.ct, train.df, type = "class"));default.ct.point.pred.train
confusionMatrix(default.ct.point.pred.train, as.factor(train.df$Competitive))

# classification tree on validation dataset
default.valid.ct <- rpart(Competitive ~ ., data = valid.df, 
                          control = rpart.control(maxdepth = 7), minbucket = 50, method = "class")
prp(default.valid.ct, type =1, extra = 1, split.font = 1, varlen = -10)

#Confusion matrices and accuracy for the validation dataset
default.ct.point.pred.valid <-as.factor(predict(default.valid.ct, valid.df, type = "class"));default.ct.point.pred.valid
confusionMatrix(default.ct.point.pred.valid, as.factor(valid.df$Competitive), mode = "everything", positive = "1")

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

# classification tree on training dataset
default.train.1.ct <- rpart(Competitive ~ ., data = train.1.df, 
                            control = rpart.control(maxdepth = 7), minbucket = 50, method = "class")
prp(default.train.1.ct, type =1, extra = 5,under=TRUE, split.font = 0, varlen = -10, tweak=1.0)
#Confusion matrices and accuracy for the training dataset
default.ct.point.pred.train.1 <-as.factor(predict(default.train.1.ct, train.1.df, type = "class"));default.ct.point.pred.train.1
confusionMatrix(default.ct.point.pred.train.1, as.factor(train.1.df$Competitive),mode="everything", positive = "1")

# classification tree on validation dataset
default.valid.ct.1 <- rpart(Competitive ~ ., data = valid.1.df, 
                            control = rpart.control(maxdepth = 7), minbucket = 50, method = "class")
prp(default.valid.ct.1, type =1, extra = 1, split.font = 1, varlen = -10, tweak=1.0)

#Confusion matrices and accuracy for the validation dataset
default.ct.point.pred.valid.1 <-as.factor(predict(default.valid.ct.1, valid.1.df, type = "class"));default.ct.point.pred.valid.1
confusionMatrix(default.ct.point.pred.valid.1, as.factor(valid.1.df$Competitive), mode = "everything", positive = "1")

#.....e
#Scatter Plot
head(ebay.auctions.df)
ggplot(ebay.auctions.df , aes(OpenPrice,ClosePrice, color = Competitive))+
  geom_point(size = 3, alpha = 0.6)+
  geom_jitter(shape=1, size = 3)+
  theme_light()+
  ggtitle(label = "Open Price vs. Close Price")+ 
  labs(x="Open Price", y ="Close Price")


    