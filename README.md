# Prediction-and-Classification-using-R
**Competitive Auctions on eBay.com. The file eBayAuctions.csv contains information
on 1972 auctions that transacted on eBay.com during May–June 2004. The goal
is to use these data to build a model that will classify auctions as competitive or noncompetitive.
A competitive auction is defined as an auction with at least two bids placed
on the item auctioned. The data include variables that describe the item (auction category),
the seller (his/her eBay rating), and the auction terms that the seller selected
(auction duration, opening price, currency, day-of-week of auction close). In addition,
we have the price at which the auction closed. The task is to predict whether or
not the auction will be competitive.**

**Data Preprocessing.** Convert variable Duration into a categorical variable. Split the
data into training (60%) and validation (40%) datasets.

**a.** Fit a classification tree using all predictors, using the best-pruned tree. To avoid
overfitting, set the minimum number of records in a terminal node to 50 (in R:
minbucket = 50). Also, set the maximum number of levels to be displayed at seven
(in R: maxdepth = 7).Write down the results in terms of rules. (Note: If you had to
slightly reduce the number of predictors due to software limitations, or for clarity
of presentation, which would be a good variable to choose?)

**b.** Is this model practical for predicting the outcome of a new auction?
**Ans b)** After interpreting the decision tree and the corresponding evaluation metrics we can see that the values against accuracy and 
F1-score is very less to classify the tree to be a good model.

**c.** Describe the interesting and uninteresting information that these rules provide.
**Ans c)** It is interesting the model starts with OpenPrice and the second split is on ClosePrice. Also, we can see that the closing and opening prices
are seems to be the 2 most important variables of a decision tree. Further, we can see that the currency becomes important if the openprice is 
between 3.7 and 21. Moreover, if the closeprice is greater than 5.7 then the sellerrating variable becomes important.

**d.** Fit another classification tree (using the best-pruned tree, with a minimum number
of records per terminal node = 50 and maximum allowed number of displayed levels
= 7), this time only with predictors that can be used for predicting the outcome of
a new auction. Describe the resulting tree in terms of rules. Make sure to report
the smallest set of rules required for classification.

**e.** Plot the resulting tree on a scatter plot: Use the two axes for the two best (quantitative)
predictors. Each auction will appear as a point, with coordinates corresponding
to its values on those two predictors. Use different colors or symbols
to separate competitive and noncompetitive auctions. Draw lines (you can sketch
these by hand or use R) at the values that create splits. Does this splitting seem
reasonable with respect to the meaning of the two predictors? Does it seem to do
a good job of separating the two classes?
