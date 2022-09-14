library("tidyverse")

# ------------------------------------------------------ #
# IMPORT THE DATA
# ------------------------------------------------------ #
airbnb_df <- read.csv("airbnb-listings.csv", sep = ";")


# ------------------------------------------------------ #
# TIDY THE DATA
# ------------------------------------------------------ #

# Check out the variables and their data types
# Observations:
# 1. Most of the values are strings with no particular patterns or structure, not useful for analysis.
# 2. Some variables which look useful for our data analysis:
# "Accommodates", "Bedrooms", "Bathrooms", "Beds", "Price", "City", "State", etc
glimpse(airbnb_df)

# Create a vector of the useful variables
useful_vars <- c(
  "City",
  "State",
  "Country",
  "Accommodates",
  "Bathrooms",
  "Bedrooms",
  "Beds",
  "Price",
  "Number.of.Reviews",
  "Review.Scores.Rating",
  "Property.Type"
)

# Remove all the other variables from the data frame.
airbnb_df <- airbnb_df[, useful_vars]

# Remove all the rows with at least column equal to NA.
airbnb_df <- na.omit(airbnb_df)
# Remove all the rows with empty strings for City, State or Country
airbnb_df <- airbnb_df[airbnb_df$City != "", ]
airbnb_df <- airbnb_df[airbnb_df$State != "", ]
airbnb_df <- airbnb_df[airbnb_df$Country != "", ]
airbnb_df <- airbnb_df[airbnb_df$Property.Type != "", ]

# Check the data again.
glimpse(airbnb_df)
summary(airbnb_df)

# There is still an anomaly with the price, as it has a minimum value of 0.
# Each listing on Airbnb needs to have a non-zero price, so we'll remove these rows of data.
# Remove rows with price = 0
airbnb_df <- airbnb_df[airbnb_df$Price > 0, ]


# ------------------------------------------------------ #
# INITIAL EXPLORATORY AND DESCRIPTIVE ANALYSIS FOR USA
# ------------------------------------------------------ #

# In order to understand the relationship between a rental's price and its 89 variables in the dataset, a descriptive analysis was carried out and the variables were classified into three main categories:   

# 1. Property Information: including location, type etc.   

# 2. Previous Reviews: including number of reviews, review scores etc.   

# 3. Redundant Data: including listing url, name, notes, weekly price etc.  

# The influential variables mainly consist of two parts: property information, and previous reviews. Subsequently, 11 representative variables were selected from those three categories of data to examine their correlation.

usa_listings = airbnb_df[airbnb_df$Country == "United States", ]

# Histogram of the price.
ggplot(data = usa_listings) + geom_histogram(mapping = aes(x = usa_listings$Price), bins = 50, col = "#000000", fill = "#CCFFCC") + labs(x = "Price (per night)", y = "Count") + scale_x_continuous(breaks = c(seq(0, max(usa_listings$Price), 100)))
# Most of the properties are priced around 50$ to 150$ range and the frequency is tapering as the price increases.

# Box plot of price for each property type.
ggplot(data = usa_listings) + geom_boxplot(mapping = aes(x = usa_listings$Price, y = usa_listings$Property.Type)) + labs(x = "Price (per night)", y = "Property Type")

# Scatter plot of price vs No. of Bedrooms
ggplot(data = usa_listings) + geom_point(mapping = aes(x = usa_listings$Price, y = usa_listings$Bedrooms, color = usa_listings$Property.Type)) + labs(x = "Price (per night)", y = "No. of Bedrooms") + scale_y_continuous(breaks = c(0, max(usa_listings$Bedrooms), 1))

# Scatter plot of price vs No. of Bathrooms
ggplot(data = usa_listings) + geom_point(mapping = aes(x = usa_listings$Price, y = usa_listings$Bathrooms, color = usa_listings$Property.Type)) + labs(x = "Price (per night)", y = "No. of Bathrooms") + scale_y_continuous(breaks = c(0, max(usa_listings$Bathrooms), 1))

# Scatter plot of price vs No. of Beds
ggplot(data = usa_listings) + geom_point(mapping = aes(x = usa_listings$Price, y = usa_listings$Beds, color = usa_listings$Property.Type)) + labs(x = "Price (per night)", y = "No. of Beds") + scale_y_continuous(breaks = c(0, max(airbnb_df$Beds), 1))

# Scatter plot of price vs Ratings
ggplot(data = usa_listings) + geom_point(mapping = aes(x = usa_listings$Price, y = usa_listings$Review.Scores.Rating)) + labs(x = "Price (per night)", y = "Ratings (0 - 100)")

# Scatter plot of ratings vs No. of ratings
ggplot(data = usa_listings) + geom_point(mapping = aes(x = usa_listings$Review.Scores.Rating, y = usa_listings$Number.of.Reviews)) + labs(y = "No. of Reviews", x = "Ratings (0 - 100)")

# The pattern in the change in the no. of bedrooms, bathrooms, beds do not significantly influence the prices.
# Whereas the property type and location highly influence the prices.
#
                                  
