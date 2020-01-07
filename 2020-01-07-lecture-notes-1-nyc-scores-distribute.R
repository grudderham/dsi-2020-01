# Intro to Tidyverse/R, Data Science Institute, January 2020
# Giang Rudderham
# Lecture notes part 1.

# Some answers and codes in this script have been intentionally 
# removed, to be filled in by workshop participants.

# Questions for discussion in class are numbered 1, 2, ...
# Sections are labeled A, B, C, ...



# load packages
library(tidyverse)
library(dslabs) 

# We will use the "NYC Regents exams scores 2010" dataset.


# A. Inspect the dataset
#########################
# load dataset
data("nyc_regents_scores")


# find more information about the dataset
?nyc_regents_scores

# 1. What package is this dataset in?


# it's always helpful to know what the dataset looks like. 
# let's count the number of rows and columns
nrow(nyc_regents_scores)
ncol(nyc_regents_scores)

# 2. How many rows are in this dataset? How many columns?
# 3. What are the variable (column) names?
# 4. What does the Help page say about the "score" variable?
# 5. Does the number of rows make sense with what you read in Help?


# Let's find out what's going on by viewing the dataset.
# view the top and bottom parts of the dataset
head(nyc_regents_scores)
tail(nyc_regents_scores)
# view the whole dataset
View(nyc_regents_scores)

# 6. Now does the number of rows make sense?



# B. Filter rows in the dataset: the basics
#########################
# According to the bar chart from The New York Times, 
# there is a huge number of exams that scored 65 (minimum to pass),
# and a much smaller number of exams that scored 64 (fail).

# Let's look at the corresponding rows in the dataset.
# exams that scored 64
filter(nyc_regents_scores, score == 64)

# 1. Can you filter for the exams that scored 65?


# Let's stop and think about the filter() function for a second.

# 2. What is the first argument? What is the second argument?
# 3. Can you guess the general rule? Confirm by looking up Help.
?filter
# 4. Hmm.. what happened when you typed "?filter"? 

# We need to specify what package filter() is in.
?dplyr::filter


# So far we have seen all three of the following lines.
# 5. How are "<-", "=", and "==" different in the following lines?
x <- 3
rep(1, times = 3)
filter(nyc_regents_scores, score == 64)

# 6. What happens when you type
filter(nyc_regents_scores, score = 64)



# C. Filter() and logical operators
#########################
# Logical operators are &, |, !, xor()
# For more info about these operators, type
?base::Logic


# Recall that we previously filtered scores 64 and 65, like so:
filter(nyc_regents_scores, score == 64)
filter(nyc_regents_scores, score == 65)

# the 2 above lines can be shortened to:
filter(nyc_regents_scores, score == 64 | score == 65)
# or equivalently:
filter(nyc_regents_scores, score %in% c(64, 65))

# "x %in% y" means x takes one of the values in y.

# 1. What does "c(64, 65)" return? Try typing:
c(64, 65)


# 2. What happens with:
filter(nyc_regents_scores, score == 64, score == 65)
# Why? Hint: see the "Arguments" section in Help for filter()

# 3. Can you write the above statement using a logical operator?



# D. Filter(): some other useful filter functions
#########################

# let's try more filtering! What about scores that are above 95?
filter(nyc_regents_scores, score > 95)

# scores that are less than or equal to 5?
filter(nyc_regents_scores, score <= 5)

# what does the following do? Compare with the line above.
filter(nyc_regents_scores, between(score, 0, 5))
# find out about between() by typing 
?between


# Note that missing scores (NA) did not get filtered.
# To look at NA scores:
filter(nyc_regents_scores, is.na(score))



# E. Accessors, adding new variables, and select()
#########################
# The bar chart for this dataset (from The New York Times) shows
# total count across all five subjects for each score.

# In our dataset we have five columns, one for each subject.
# Let's create a new column for the total counts.
# Essentially we are summing the values in each row.


# The rowSums() function will achieve that.
nyc_regents_scores$all_subjects <- rowSums(nyc_regents_scores[, 2:6], 
                                           na.rm = T)

# The $ is an accessor. In this case we are creating and accessing a 
# new column in our dataset, and call it "all_subjects".

# The [] is another accessor. We are subsetting all rows of the dataset,
# and columns 2 to 6.

# View the dataset to make sure we got it right.
View(nyc_regents_scores)


# Let's try running the rowSums() command without the "na.rm = T" option
nyc_regents_scores$all_subjects <- rowSums(nyc_regents_scores[, 2:6]) 

# 1. View the dataset. What's different about the "all_subjects" column?

# NA values are contagious. Almost any operation involving NA will return NA



# Run the correct rowSums() command again so that we have the correct column
nyc_regents_scores$all_subjects <- rowSums(nyc_regents_scores[, 2:6], 
                                           na.rm = T)


# Let's inspect the "all_subjects" column specifically. 

# Use select() to narrow in on the variables of interest.
select(nyc_regents_scores, score, all_subjects)

# 2. Does the results seem consistent with the bar chart?



# F. Create a bar chart with ggplot2
######################### 
# Let's create a bar chart and see if it looks like 
# the one from the NYT article.
ggplot(data = nyc_regents_scores) +
  geom_bar(mapping = aes(x = score, y = all_subjects), stat = "identity")

# The shape definitely looks similar! 

# 1. Try just running the first part of the command, not including "+".
# What do you get?

# 2. Notice the position of the "+" sign. 
# What happens if you try to move it to the start of the second line?

# 3. what does geom_bar do? Look up ?geom_bar.

# 4. Let's find out what the "stat = "identity"" part does.
# Try running the below, without "stat". What do you get?
ggplot(data = nyc_regents_scores) +
  geom_bar(mapping = aes(x = score, y = all_subjects))

# 5. Okay. Now try running without the "y". What do you get? Why?
ggplot(data = nyc_regents_scores) +
  geom_bar(mapping = aes(x = score))





# Let's run the full code again
ggplot(data = nyc_regents_scores) +
  geom_bar(mapping = aes(x = score, y = all_subjects), stat = "identity")

# 6. There is a warning message. Why?


# Let's apply the filter() function we learned earlier
ggplot(data = filter(nyc_regents_scores, !is.na(score))) +
  geom_bar(mapping = aes(x = score, y = all_subjects), stat = "identity")

# 7. What does "!is.na(score)" do? 
# Hint: recall that ! is a logical operator that means "not".

# 7a. What does "filter(nyc_regents_scores, !is.na(score))" do? 



# Let's run our improved code again and add some elements to it.
ggplot(data = filter(nyc_regents_scores, !is.na(score))) +
  geom_bar(mapping = aes(x = score, y = all_subjects), stat = "identity",
           fill = "brown")

# If want to be more specific about the color, can specify the HEX code
ggplot(data = filter(nyc_regents_scores, !is.na(score))) +
  geom_bar(mapping = aes(x = score, y = all_subjects), stat = "identity",
           fill = "#a63603") +
  theme_minimal()

# 8. What does theme_minimal() do?

# End of lecture notes with dataset 1.