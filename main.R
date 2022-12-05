# ------------------------------------------------------------- #
# -------------------- LOAD THE LIBRARIES --------------------- #
# ------------------------------------------------------------- #
list_of_packages <- c(
    "tidyverse",
    "vroom",
    "caret",
    "ggcorrplot",
    "ranger",
    "class"
)

missing_packages <- list_of_packages[!(list_of_packages %in% installed.packages()[, "Package"])]

if (length(missing_packages)) {
    install.packages(missing_packages)
}

for (package in list_of_packages) {
    lapply(package, require, character.only = TRUE)
}

# Load the file
if (file.exists("airbnb.csv")) {
    file <- "airbnb.csv"
} else {
    file <- "https://ind657-my.sharepoint.com/:x:/g/personal/dasss01_pfw_edu/ERrwzwXvN2dAqPkh8o-LFvYBwA6_XipX_5nmGBWeIBDhiA?download=1"
}


airbnb <- vroom(file = file, delim = ";", skip_empty_rows = TRUE, na = c("", "NA"))

View(airbnb)

glimpse(airbnb)

na_prop <- colMeans(is.na(airbnb)) * 100

airbnb <- airbnb %>% select(names(na_prop[na_prop < 30]))

useful_vars <- c(
    "City",
    "Country Code",
    "Country",
    "Property Type",
    "Room Type",
    "Accommodates",
    "Bathrooms",
    "Bedrooms",
    "Beds",
    "Price",
    "Number of Reviews",
    "Review Scores Accuracy",
    "Review Scores Cleanliness",
    "Review Scores Location",
    "Review Scores Communication",
    "Review Scores Rating",
    "Review Scores Value",
    "Latitude",
    "Longitude"
)

airbnb <- airbnb %>% select(all_of(useful_vars))

airbnb <- na.omit(airbnb)



# Exploratory Data Analysis

# Country wise distribution of listings
country_wise_distribution <- airbnb %>% group_by(Country) %>% count(sort = T)
country_wise_distribution %>%
ggplot(aes(reorder(Country, n), n)) + geom_col() + coord_flip() + labs(x = "Country", y = "Number of Listings")

# Property wise distribution of listings
property_wise_distribution <- airbnb %>% group_by(`Property Type`) %>% count(sort = T)
property_wise_distribution %>%
ggplot(aes(reorder(`Property Type`, n), n)) + geom_col() + coord_flip() + labs(x = "Property Type", y = "Number of Listings") + scale_y_log10()

# Room wise distribution of listings
room_wise_distribution <- airbnb %>% group_by(`Room Type`) %>% count(sort = T)
room_wise_distribution %>%
ggplot(aes(reorder(`Room Type`, -n), n)) + geom_col() + labs(x = "Room Type", y = "Number of Listings")

# Modify the data to exclude countries with less than 10,000 listings and property types with less than 100 listings
airbnb <- airbnb %>% filter(!(Country %in% (country_wise_distribution %>% filter(n < 10000))$Country))
airbnb <- airbnb %>% filter(!(`Property Type` %in% (property_wise_distribution %>% filter(n < 100))$`Property Type`))
airbnb <- airbnb %>% filter(Price > 0)

# City wise distribution of listings in the top 3 countries -> USA, UK and France
usa_city_wise_distribution <- airbnb %>% filter(Country == "United States") %>% group_by(City) %>% count(sort = T)
uk_city_wise_distribution <- airbnb %>% filter(Country == "United Kingdom") %>% group_by(City) %>% count(sort = T)
france_city_wise_distribution <- airbnb %>% filter(Country == "France") %>% group_by(City) %>% count(sort = T)


# Overall price distribution, positively skewed
ggplot(airbnb, aes(x = Price)) + geom_histogram(binwidth = 30)

# Distribution of price according to countries
ggplot(airbnb, aes(x = Country, y = Price)) + geom_boxplot() + coord_flip()

# Distribution of price according to property types
ggplot(airbnb, aes(x = `Property Type`, y = Price)) + geom_boxplot() + coord_flip()

# Median price per country
airbnb %>% group_by(Country) %>% summarize(Median = median(Price)) %>%
    ggplot(aes(reorder(Country, Median), Median)) + geom_col(width = 0.6) + coord_flip()

# Median price per property type
airbnb %>% group_by(`Property Type`) %>% summarize(Median = median(Price)) %>% mutate(position = (Median > 100)) %>%
    ggplot(aes(reorder(`Property Type`, Median), Median, fill = position)) + geom_col(width = 0.3) + coord_flip() +
    scale_fill_manual(values = c("blue", "firebrick"))

# Median price per room type
airbnb %>% group_by(`Room Type`) %>% summarize(Median = median(Price)) %>%
    ggplot(aes(reorder(`Room Type`, -Median), Median)) + geom_col(width = 0.4)

airbnb_num <- airbnb %>% select(-c("City", "Country Code", "Country", "Property Type", "Room Type"))
airbnb_cor <- cor(airbnb_num)
ggcorrplot(airbnb_cor) + labs(title = "Airbnb Correlogram") + theme(plot.title = element_text(hjust = 0.5))

# MODELS

# -------------------------------------------------------- #
# --------------------- RANDOM FOREST -------------------- #
# -------------------------------------------------------- #

# Filter out US Data
airbnb_usa <- airbnb %>% filter(Country == "United States")
airbnb_usa <- airbnb_usa %>% rename(Review_Scores_Rating = `Review Scores Rating`,
                                    Property_Type = `Property Type`,
                                    Room_Type = `Room Type`)

set.seed(100)
test_index <- createDataPartition(y = airbnb_usa$Price, times = 1, p = 0.4, list = F)
airbnb_usa_training <- airbnb_usa[-test_index, ]
airbnb_usa_test <- airbnb_usa[test_index, ]


set.seed(100)

rf_formula <- Price ~ Accommodates + Bathrooms + Bedrooms + Beds + Review_Scores_Rating + Latitude + Longitude + City + Property_Type + Room_Type

rf_model <- ranger(rf_formula, airbnb_usa_training, num.trees = 500, mtry = 7)
rf_model

airbnb_usa_training$pred <- predict(rf_model, airbnb_usa_training)$predictions
airbnb_usa_test$pred <- predict(rf_model, airbnb_usa_test)$predictions

airbnb_usa_training %>%
    mutate(residual = pred - Price) %>%
    summarize(rmse = sqrt(mean(residual ^ 2)))

airbnb_usa_test %>%
    mutate(residual = pred - Price) %>%
    summarize(rmse = sqrt(mean(residual ^ 2)))


# -------------------------------------------------------- #
# ---------------------- KNN MODEL ----------------------- #
# -------------------------------------------------------- #

airbnb_knn <- airbnb %>%
    rename(Number_of_Reviews = `Number of Reviews`,
           Review_Scores_Accuracy = `Review Scores Accuracy`,
           Review_Scores_Cleanliness = `Review Scores Cleanliness`,
           Review_Scores_Location = `Review Scores Location`,
           Review_Scores_Communication = `Review Scores Communication`,
           Review_Scores_Rating = `Review Scores Rating`,
           Room_Type = `Room Type`,
           Review_Scores_Value = `Review Scores Value`,
           Property_Type = `Property Type`) %>%
    filter(Country == "United States") %>%
    select(-c("City", "Country Code", "Country", "Property_Type", "Room_Type", "Longitude", "Latitude"))


set.seed(100)
normalization <- function(x) { (x - min(x)) / (max(x) - min(x)) }

airbnb_knn_norm <- as.data.frame(lapply(airbnb_knn, normalization))

set.seed(100)
test_index <- createDataPartition(y = airbnb_knn$Review_Scores_Rating, times = 1, p = 0.3, list = F)

airbnb_knn_training <- airbnb_knn_norm[-test_index, ]
airbnb_knn_test <- airbnb_knn_norm[test_index, ]

knn_model <- knn(train = airbnb_knn_training, test = airbnb_knn_test, cl = airbnb_knn_training$Review_Scores_Rating, k = 5)

accuracy_knn <- 100 * sum(airbnb_knn_test$Review_Scores_Rating == knn_model)/NROW(airbnb_knn_test$Review_Scores_Rating)
accuracy_knn

