---
title: "Choice-Based Conjoint study"
author: "Hamza"
output:
  word_document:
    toc: yes
  pdf_document:
    toc: yes
  html_document:
    number_sections: yes
    toc: yes
    fig_width: 8
    fig_height: 5
    theme: cosmo
    highlight: tango
    code_folding: hide
---
# Task 1

Read and inspect the data set. Provide a descriptive analysis for each of the variables in the data set. Make sure you provide an analysis that is meaningful for each variable type (e.g., factors, identifiers).

- **Anwser**

```{r task1}
# Load packages
library("plotly")
library("tidyverse")
library("data.table")
library("dplyr")
library("gridExtra")
library("knitr")
library("scales")

# Load Cloud Data
df.aal <- read_csv("cloud.csv")
# view first 6 rows of cloud.csv
head(df.aal)
# reveal cloud.csv data analysis
str(df.aal)
# descriptive analysis of cloud.csv
summary(df.aal)
by_price <- df.aal %>% group_by(price)  
ggplot(by_price) + geom_bar(aes(x=price))  + labs(title="Preferred Price") + xlab("Price") + ylab("Frequency")
```

   running the str() function gives a quick description of cloud.csv.
  we have 9 Columns and 9000 attributes.
  we have 5 columns with Number data types or class , these columns are respondent_id , choiseset_id ,                  alternative_id, choice_id, and choice
  we have 4 columns with character data type or class , these columns are cloud_storage , customer_support              ,cloud_services , and price.

# Task 2

Convert the attribute variables cloud_storage and price so that the factor reference levels are the levels representing the smallest values (i.e., 30GB for cloud_storage and p6 for price). Why there is no need to perform this step on the rest of the attribute variables?

- **Anwser**

```{r task2}
# convert cloud_storage as factors in order 30gb<200gb<5000gb 
df.aal$cloud_storage <- as.factor(df.aal$cloud_storage)
# view of cloud_storage attributes
table(df.aal$cloud_storage)
# convert price as factors in order p6<p12<p18 
df.aal$price <- as.factor(df.aal$price)
# view order of price
table(df.aal$price)
df.aal$cloud_services <- as.factor(df.aal$cloud_services)
# view order of price
table(df.aal$cloud_services)
df.aal$customer_support <- as.factor(df.aal$customer_support)
# view order of price
table(df.aal$customer_support)
```
     
  The reason there is no need to perform this step on the rest of the attribute variables and only cloud_storage and    
  price has a need to indicate hierarchy from the list in character class, the other attribute variables like     
  
  customer_support and customer_services whom are not converted to factors do not need to indicate hierarchy.

# Task 3

Create a new variable in the data set that turns price into numeric class (do not overwrite price). Call this new variable price_n. What is the mean of variable price_n?

- **Anwser**

```{r task3}
# create a variable price_n as numberic
price_n <- as.numeric(df.aal$price)
# view or confirm conversion true
mean(price_n)
```

  Mean of price_n = 2.002556


# Task 4

There are 3000 choice sets in the data set. Therefore, there were 3000 choices made. Out of these 3000 choices, how many times did respondents choose a 30GB cloud storage? What is the percentage of respondents who chose email only as cloud service?

- **Anwser**

```{r task4}
# make a pie chart of storage in percentages 
p <- df.aal %>% group_by(cloud_storage) %>% count(cloud_storage) %>% mutate( n=as.numeric(n))
head(p)
perc = p$n/sum(p$n)
Labels = percent(perc)
pie(p$n,labels = Labels ,main = "Pie Chart Of Cloud Storage", col=c("lightblue","orange","brown"))
legend("topright", c("30gb","2000gb","5000gb"), cex = 0.8,fill = c("lightblue","orange","brown"))

# make a pie chart of storage in percentages
q <- df.aal %>% group_by(cloud_services) %>% count(cloud_services) %>% mutate( n=as.numeric(n))
head(q)
perc = q$n/sum(q$n)
Labels = percent(perc)
pie(q$n,labels = Labels ,main = "Pie Chart Of Cloud Services", col=c("purple","blue","yellow"))
legend("topright", c("email","email, video","email, video, productivity"), cex = 0.8,fill = c("purple","blue","yellow"))
```

  30gb was choosen 3003 times
  
  Email only as cloud service was 33.322%


# Task 5

Use the dfidx() function from the dfidx package to create a specially formatted data object that will be used in the process of estimating a multinomial conjoint model. In the argument idx, use a list of the two indexes (choice_id and respondent_id) that define unique observations. Also use alternative_id as the variable defining the levels of the alternatives. Call this data object m_data. How many variables (i.e., columns) does m_data have?

- **Anwser**

```{r task5}
# load dfidx package
library("dfidx")
# remove duplicated rows based on choice_id and respondent_id
z <- df.aal 
z$choice <- as.logical(z$choice)
z$choice_id <- as.factor(z$choice_id)
z$customer_support <- as.factor(z$customer_support)
z$cloud_services <- as.factor(z$cloud_services)
# create formated data object _m_data
m_data <- dfidx(z, idx = list(c("choice_id", "respondent_id"), "alternative_id"),choice = "choice")
#
head(m_data)
```

  m_data has 7 columns

# Task 6

Use m_data to build a multinomial logit model that predicts choice from cloud_storage,customer_support,cloud_services, and price.Make sure that you tell the mlogit() function to exclude the intercept term. Call this model model1. Use set.seed(123) right before running the command that builds the model. Comment on the coefficient estimates of cloud_storage5000gb and pricep12.

- **Anwser**

```{r task6}
# load mlogit package
library("mlogit")
# build multinomial logit model
model1 <- mlogit (choice ~ cloud_storage + customer_support + cloud_services + price | 0, data = m_data  , seed = 123  )
summary(model1)

```
    
   cloud_storage5000gb  = 0.729560 this means the price is relevant and is the most favorable and choosen choice in storage
   pricep12 is the reference price  

# Task 7

Now follow the same process as in Task 6 to build a multinomial logit model that uses price_n instead of price. Call this model model2. Again use set.seed(123) right before running the command that builds the model. Comment on the coefficient estimate of price_n. What does this mean?

- **Anwser**

```{r task7}
# change column price to price_n
m_data3<-mutate(m_data,price = price_n)
# build multinomial logit model
model2 <- mlogit (choice ~ cloud_storage + customer_support + cloud_services + price_n  | 0 , data = m_data3 , seed = 123,)
summary(model2)
```

  coefficient estimate price_n  -0.803613 that price is inversely proportional to choices made, that when price         
  increases this will negatively affect choice. 

# Task 8

Use a likelihood ratio test to test the model2 against model1. What is the outcome of the test? Are model2 and model1 significantly different?Which model we should choose between the two and for what reason(s)?

- **Anwser**

```{r task8}
library(lmtest)
# perform likelihood ratio test for differences in models
lrtest(model1, model2)

```

  From the output we can see that the p-value of the likelihood ratio test is 0.5031. Since this is greater than .05,   
  we would accept the null hypothesis.

  Thus, we would conclude that the model with variable price offers no significant improvement in fit over the model    
  with variable price_n.

  Thus, we should use the price_n variable model (model2) because the additional predictor variables in the full model     
  don’t offer a significant improvement in fit.

# Task 9

Use model2 to predict the choice probabilities for different alternatives in the data. What is the predicted probability of choosing the third alternative in the first choice set?

- **Anwser**

```{r task9}
# mode2
predicted_alt <- predict(model2, m_data3)
head(predicted_alt)

```

  Probability of choosing the the third alternative in first choice set is = 0.02837185


# Task 10

Use the predicted probabilities from Task 9 to compute the predicted alternatives using the maximum choice probabilities. Which is the predicted alternative in the third choice set?

- **Anwser**

```{r task10}
head(summary(predicted_alt))
```
  Max probability in the 3 choice set is 0.96483

# Task 11

Then we can extract the selected alternatives from the original data. Which is the selected alternative in the fifteenth choice set?

- **Anwser**

```{r task11}
# call from row 15
head(m_data[15,])
```

   Give Above in the code execution

# Task 12

Compute the confusion matrix for model2. What is the accuracy (or hit rate) of model2? How does model2 compare to the baseline method (i.e., making random predictions)?

- **Anwser**

```{r task12}
# compute confussion matrix of model2 
tab = table(predicted_alt>0.5,m_data3$choice)
tab
#compute accuracy of model2
accurracy <- sum(diag(tab))/sum(tab)*100
accurracy

# load package if required 
library(ggpubr)
library(CGPfunctions)


# compute r model 


```


  Accurracy of model2 gives 58.02%


# Task 13

Now let us see how we can use the model2 parameters to predict market shares under hypothetical market scenarios for an arbitrary set of products. First, build a custom function to predict market share for an arbitrary set of alternatives available in a data set d. You can find the commands for building the custom function in the “Multinomial Choice Modelling Practical”. Call the custom function predict.share.

- **Anwser**

```{r task13}
products <- select(z,-c(respondent_id,choice))
predict.share <- function(model2,products) {
x <- predict(model2, products) 
share <- matrix(x,dimnames=list(t(outer(colnames(x),rownames(x),FUN=paste)),NULL)) 
shares <- cbind(share, products)
return(shares)
}
```


# Task 14

Create a data object (i.e., data.frame or tibble) with the following hypothetical market consisting of five alternatives:
Call this data object d_base.

- **Anwser**

```{r task14}

cloud_storage <- c("30gb","30gb","30gb","5000gb","5000gb")
customer_support <- c("no","no","yes","yes","no")
cloud_services <- c("email","email,video","email","email","email,video,productivity")
price_n   <- c("6","12","12","18","18")
d_base <- data.frame(cloud_storage,customer_support,cloud_services,price_n)
head(d_base)
```


# Task 15

Run the customer function predict.share using model2 and d_base as input arguments. What is the predicted market share for alternative four of this hypothetical market?

- **Anwser**

```{r task15}
d_base[nrow(d_base)+8995,] <- NA
head(predict.share(model2,d_base))

```

  predicted market share for 4 is 0.5991325

# Task 16

Now consider a modification on the previous hypothetical market, in which the level of the cloud_services attribute changes for the fifth alternative to “email, video”. What is the predicted market share for alternative four of this new hypothetical market?

- **Anwser**

```{r task16}
cloud_storage <- c("30gb","30gb","30gb","5000gb","5000gb")
customer_support <- c("no","no","yes","yes","no")
cloud_services <- c("email","email,video","email","email","email, video")
price_n   <- c("6","12","12","18","18")
d_base1 <- data.frame(cloud_storage,customer_support,cloud_services,price_n)
head(d_base1)
```


# Task 17

Which alternative was affected the most from this modification of the hypothetical market, and by how much (in percentage terms)?

- **Anwser**

```{r task17}
d_base1[nrow(d_base1)+8995,] <- NA
head(predict.share(model2,d_base1))

```
  Alternative 3 is affected most by 3.466%

# Task 18

Use the model2 coefficients to calculate how much a consumer would be willing to pay (in £ per month) for customer support.

- **Anwser**

```{r task18}
print(coef(model2)[3]/coef(model2)[6])

```

  Per Month Consumers are willing to pay -0.614034893

# Task 19
Use the model2 coefficients to calculate how much a consumer would be willing to pay (in £ per month) for an upgrade from 30GB to 2000GB cloud storage.

- **Anwser**

```{r task19}
print(coef(model2)[1]/coef(model2)[6])

```

  Per Month Consumers are willing to pay -0.7870795 per month to upgrade from 30GB to 2000GB


# Task 20

Use the model2 coefficients to calculate how much a consumer would be willing to pay (in £ per month) for an upgrade from 2000GB to 5000GB cloud storage.

- **Anwser**

```{r task20}
print(coef(model2)[2]/coef(model2)[6])
```

  Per Month Consumers are willing to pay -0.2866035 per month to upgrade from 2000GB to 5000GB
