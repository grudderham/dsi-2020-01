# Intro to Tidyverse/R, Data Science Institute, January 2020
# Giang Rudderham
# Lecture notes part 2.

# Some answers and codes in this script have been intentionally 
# removed, to be filled in by workshop participants.

# Questions for discussion in class are numbered 1, 2, ...
# Sections are labeled A, B, C, ...



# load packages
library(tidyverse)
library(dslabs) 

# We will use the "Gapminder" dataset.


# A. Inspect the dataset
#########################
# load dataset
data("gapminder")


# find more information about the dataset
?gapminder

# 1. What package is this dataset in?
# 2. What are the variable (column) names?

# 3. How many rows are in this dataset? How many columns?
nrow(gapminder)
ncol(gapminder)

# view the whole dataset
View(gapminder)

# It looks like the dataset is organized first by year, then by country.



# B. arrange()
#########################
# I'm interested in looking at infant mortality for a recent year.
# Year 2016 has a lot of missing values. So let's look at 2015.

# 1. Use the filter function we learned earlier to create a dataset
# that has only data from year 2015. Call it "year2015".

# 2. How many rows does "year2015" have? How many columns? Hint: Environment


# view the dataset
View(year2015)

# Suppose we want to know which countries have the highest and lowest
# infant mortality in 2015. 
# The arrange() function helps us achieve that.
desc_mortality <- arrange(year2015, desc(infant_mortality))

# 3. view the desc_mortality dataset. What's different about the variable 
# "infant_mortality"?
View(desc_mortality)

# 4. What is the country with the highest infant mortality? Lowest?
# 5. What happens to the countries with NA values for infant mortality?

# 6. in the code above, what does "desc()" do? Look up
?dplyr::desc

# let's remove desc_mortality from the workspace since don't need it anymore
rm(desc_mortality)


# C. summarise by group
#########################
# Let's get some aggregate numbers for each region.

# first create group by region
by_region <- group_by(year2015, region)

# then get summaries for each region
summary_by_region <- summarise(by_region, 
                  num_countries = n(), 
                  total_pop = sum(population, na.rm = T),
                  avr_infant_mortality = mean(infant_mortality, na.rm = T))

# finally, arrange so that we can view infant mortality rate
desc_mort_region <- arrange(summary_by_region, desc(avr_infant_mortality))

# view the dataset
View(desc_mort_region)

# What is the region with the highest infant mortality? Lowest?



# D. the pipe
#########################
# In parts B and C, we went through 4 steps to get a ranking of average 
# infant mortality by region in 2015. First filter to get data for year 2015,
# then create group, get summary statistics, then arrange.
# The code that we used:
year2015 <- filter(gapminder, year == 2015)
by_region <- group_by(year2015, region)
summary_by_region <- summarise(by_region, 
                  num_countries = n(), 
                  total_pop = sum(population, na.rm = T),
                  avr_infant_mortality = mean(infant_mortality, na.rm = T))
desc_mort_region <- arrange(summary_by_region, desc(avr_infant_mortality))


# Using the pipe, %>%, we can focus more on the transformations, reducing
# cluster. The code above can be re-written as:
desc_mort_region_rep <- gapminder %>%
  filter(year == 2015) %>%
  group_by(region) %>%
  summarise(num_countries = n(),
            total_pop = sum(population, na.rm = T),
            avr_infant_mortality = mean(infant_mortality, na.rm = T)) %>%
  arrange(desc(avr_infant_mortality))

# Each line takes the result dataset from the previous line and 
# operates on it.

# View the new dataset. Does it look the same as the previous one?
View(desc_mort_region)
View(desc_mort_region_rep)

# The pipe will become more useful with longer transformations.
# The pipe is commonly used with Tidyverse, so understanding it will help 
# reading code from other Tidyverse users.


# let's clean up the workspace before the next section
rm(list = ls())


# E. Data visualization
#########################
# Author: Rafael Irizarry, SimplyStatistics.org

# Being able to decipher code written by others, sometimes without comments,
# is a helpful skill to have. Let's talk through this block of code together
# (in-class activity)


data("gapminder")

west <- c("Western Europe","Northern Europe","Southern Europe",
          "Northern America","Australia and New Zealand")

gapminder <- gapminder %>%
  mutate(group = case_when(
    region %in% west ~ "The West",
    region %in% c("Eastern Asia", "South-Eastern Asia") ~ "East Asia",
    region %in% c("Caribbean", "Central America", "South America") ~ "Latin America",
    continent == "Africa" & region != "Northern Africa" ~ "Sub-Saharan Africa",
    TRUE ~ "Others"))
gapminder <- gapminder %>%
  mutate(group = factor(group, levels = rev(c("Others", "Latin America", "East Asia","Sub-Saharan Africa", "The West"))))

filter(gapminder, year%in%c(1962, 2013) & !is.na(group) &
         !is.na(fertility) & !is.na(life_expectancy)) %>%
  mutate(population_in_millions = population/10^6) %>%
  ggplot( aes(fertility, y=life_expectancy, col = group, size = population_in_millions)) +
  geom_point(alpha = 0.8) +
  guides(size=FALSE) +
  theme(plot.title = element_blank(), legend.title = element_blank()) +
  coord_cartesian(ylim = c(30, 85)) +
  xlab("Fertility rate (births per woman)") +
  ylab("Life Expectancy") +
  geom_text(aes(x=7, y=82, label=year), cex=12, color="grey") +
  facet_grid(. ~ year) +
  theme(strip.background = element_blank(),
        strip.text.x = element_blank(),
        strip.text.y = element_blank(),
        legend.position = "top")

# End of lecture notes part 2.