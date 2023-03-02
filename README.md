# Airbnb Price Prediction

## Introduction

This project aims at analyzing a dataset containing Airbnb listings across several countries. Airbnb is an online marketplace for short-term rentals and holiday experiences. This platform has gained much popularity due to its affordability and flexibility compared to a traditional hotel experience. Airbnb listings span a wide range of locations which hotels cannot match as they are usually clustered around tourist and business hot-spots. With increased popularity comes increased demand and a wide range of consumer listings. According to a 2019 estimate, there are over 6 million listings on Airbnb. By analyzing a subset of this data, which contains listings across 22 countries, we try to ascertain patterns in this data and answer specific questions arising from it.

The dataset consists of 494,954 observations (rows) and 89 features (columns). The features span a wide range of attributes in a listing like the number of rooms, price, ratings, etc.

By utilizing these features, we can make inferences about the optimal price for a new listing on the website. In addition, a customer can also make inferences about the price based on location and seasonality.

The dataset has been procured from *Inside Airbnb*, a public, open-source project, which provides data and advocacy about Airbnb's impact on residential communities.

## Cleaning and tidying the dataset

The dataset had a lot of missing values and some anomalies. The first step in the analysis process was to clean this dataset, so it is ready for modeling and inference.

Looking at the proportion of missing values in each feature (column):
```
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
##  0.0000  0.0004  0.1752 17.7091 26.0058 99.2337
```

We can see that about 18% of the values are missing from each column, with a maximum of 99% of values missing from one of the columns. Features with many missing values don’t add much value to our modeling efforts, and these were removed from the dataset (using a threshold of 30%, i.e., features with more than 30% missing values have been removed). This led to a dataset with 71 features, 18 of them being removed in the previous step. Out of the remaining 71 features, again, many of them are not helpful for the predictive analysis task at hand. By carefully analyzing these features, we decided on this subset for the final models:

```
## City
## Country Code
## Country
## Property Type
## Room Type
## Accommodates
## Bathrooms
## Bedrooms
## Beds
## Price
## Number of Reviews
## Review Scores Accuracy
## Review Scores Cleanliness
## Review Scores Location
## Review Scores Communication
## Review Scores Rating
## Review Scores Value
## Latitude
## Longitude
```

These features were selected from the dataset, reducing the total number of features to 19. Checking for anomalous values, it was discovered that some listings have a nightly price of $0 which is incorrect as any listing on Airbnb must have a non-zero price. This are probably errors from the data collection process. These listings were also removed.

Also, certain countries, like China, Austria, Denmark, etc., have less than 10,000 listings. In contrast, the average is around 33,000. These countries, with insufficient data, were also removed from the dataset.

Finally, the observations with missing values from this filtered dataset were removed completely.

The cleaning and tidying process reduced the dataset from a table of 494,954 observations and 89 features to a table of 331,796 observations and 19 features with no missing values.

## Descriptive Analytics and Visualizations
Descriptive analytics focus on summarizing and identifying patterns in current and historical data. Visualization is the graphic representation of the underlying patterns, which is more efficient when the data is numerous, as in the case here.

1. Number of Listings per Country
![image](https://user-images.githubusercontent.com/38399292/222561408-17d514ab-bce5-476f-8ede-d38ad85c7966.png)
The plot reveals that the United States of America has the most listings, followed by United Kingdom and France. Also, USA has more than double the listings of 2nd placed UK. The lack of countries from the eastern side of the world clearly implies that the adoption of Airbnb has been very slow and in some cases non-existent.

2. Number of Listings per “Property Type”
![image](https://user-images.githubusercontent.com/38399292/222561592-18e6725f-9f3f-45cc-9abd-05250937b3dd.png)
Apartments and houses are the most common types of listings on Airbnb.

3. Number of Listings per “Room Type”
![image](https://user-images.githubusercontent.com/38399292/222561652-64eddefa-0413-4fda-b9ab-0b43ef839c67.png)
There are three room types — Entire home/apt, Private Room and Shared Room. Apartments are by far the most popular listings, with the number of shared rooms being insignificant compared to the other categories.

4. City-wise Distribution of the top 3 Countries
![image](https://user-images.githubusercontent.com/38399292/222561726-0b1a75c3-91e3-4334-a5d5-783b960218f5.png)

5. Histogram of Listing Price
![image](https://user-images.githubusercontent.com/38399292/222561837-15af282a-7fa9-416c-b60c-632b30ce7ace.png)
The distribution is positively skewed with the majority of values lying in the $0 to $250 range. Since the data is skewed, the median is a good measure of the center.

6. Frequency Polygon of Listing Price
![image](https://user-images.githubusercontent.com/38399292/222562012-d2d4283c-764a-49d4-b761-b88bdfbbd51e.png)
The relative distribution of the listing prices is similar for all the countries.

7. Distribution of Listing Price grouped by Country
![image](https://user-images.githubusercontent.com/38399292/222562130-044b7613-4f95-4021-b258-1e366caf58b4.png)
Denmark has a higher median price compared to other countries, and there are a lot of outliers. These outliers mostly consist of luxury listings.

8. Distribution of Listing Price grouped by Property Type
![image](https://user-images.githubusercontent.com/38399292/222562264-765c7023-8750-4699-b0f2-e1a919ffd89d.png)
Luxury listings like boats, chalets, condos, and villas have a higher median price.

9. Distribution of Listing Price grouped by Room Type
![image](https://user-images.githubusercontent.com/38399292/222562386-9db6aa06-f8ee-4b9c-a10b-3bcad2ee240c.png)
As expected, shared rooms are the cheapest and apartments/homes are the most expensive listings.

10. Median Listing Price per Country
![image](https://user-images.githubusercontent.com/38399292/222562461-6fe7dc86-56a3-4512-9db7-7d2a21fd77fc.png)

11. Median Listing Price per Property Type
![image](https://user-images.githubusercontent.com/38399292/222562525-fbc0fdeb-5609-466e-89e8-c55a9fffb80a.png)

12. Median Listing Price per Room Type
![image](https://user-images.githubusercontent.com/38399292/222562574-962514d9-6d76-4730-864b-7dc744a8260f.png)

## Predictive Analytics
We tried to answer the following research questions related to our data:

- Which model will most accurately predict the price of a listing?
- Will the customer be satisfied with the property suggested?

### Models

#### Random Forest Predictor
To answer the first question, we used the random forest predictor model.

The ability to correctly categorize observations is quite significant for many business applications, such as predicting whether a certain user will purchase a product or a specific loan will fail. To understand Random Forest, first, we need to get an idea of decision trees.

A decision tree is a graph that resembles a tree, with nodes standing in the places where we choose an attribute and pose a question, edges for responses to those questions, and leaves for the actual output or class label. Decision trees may be employed in several business settings because they closely resemble how people make decisions. Businesses frequently utilize them to forecast future results.

For example:
- Which client will remain devoted, and which one will leave?
- Given their product options, what percentage of an upsell can we offer a consumer?
- Which article should I suggest to the viewers of my blog/

Although our data may not always be this tidy in real life, a decision tree nonetheless operates according to the same principle. It will inquire at every node — what attributes will enable me to divide the current observations into groups that are as distinct as possible?

As its name suggests, a random forest is made up of several independent decision trees that work together as a group. Each tree in the random forest spits out a class prediction, and the class that received the most votes becomes the prediction made by our model. “The wisdom of crowds” is the basic idea underlying random forest model, which is a straightforward but effective idea. The success of the random forest model, in data science is due to the best results from many uncorrelated models (trees) working together as a committee.

The key is the poor correlation between models. Uncorrelated models provide aggregate forecasts that are more accurate than individual predictions, just like assets with low correlations (such stocks and bonds) combine to build a portfolio more extensive than the sum of its parts.

As long as they don’t consistently make mistakes in the same direction, the trees shield each other from their faults, which accounts for this stunning result. Many trees will be suitable while some may be wrong, allowing the group of trees to travel in the proper direction. The following conditions must be met for random forest to function effectively:

For models created utilizing those attributes to perform better than guesswork, there must be some actual signal in those features. Low correlations between the separate trees’ predictions (and thus the mistakes) are required.

To determine the best features for this model, a correlation graph was plotted:
![image](https://user-images.githubusercontent.com/38399292/222562915-20b5906a-c62a-4399-a6a1-37d386adfdd6.png)

This graph confirms the correlation between a specific set of features. For example, price is clearly correlated to the number of guests, bedrooms, bathrooms, beds, etc. Using these relationships the model was constructed using the ranger package in R. It provides a fast implementation of random forests. The data was randomly sampled into 2 subsets — one for training the model and one for testing it. The split was in the ratio of 60:40.

The formula used for the model was:
```
Price ~ Accommodates + Bathrooms + Bedrooms + Beds + Review_Scores_Rating + Latitude + Longitude + City + Property Type + Room Type
```
The ```num.trees``` parameter, which determines the number of decision trees that are combined for the final prediction, was set to a value of 500 (the default value).

Finally, ```mtry```, which denotes the number of features used to make decisions at each split, was set to 7.

Resulting model:
```
## Ranger result
## 
## Call:
##  ranger(rf_formula, airbnb_usa_training, num.trees = 500, mtry = 7) 
## 
## Type:                             Regression 
## Number of trees:                  500 
## Sample size:                      60116 
## Number of independent variables:  10 
## Mtry:                             7 
## Target node size:                 5 
## Variable importance mode:         none 
## Splitrule:                        variance 
## OOB prediction error (MSE):       5098.344 
## R squared (OOB):                  0.652542
```
The R2 metric determines the proportion of variance in the dependent variable (the listing price), that can be explained by the independent variables (the features used in the model). Our model is a decent fit for the dataset with a value of ~0.65.

Using this model to make predictions on the training data subset gives a RMSE (room mean square error) of:
```
## # A tibble: 1 × 1
##    rmse
##   <dbl>
## 1  32.9
```
On the testing subset, we get a RMSE value of:
```
## # A tibble: 1 × 1
##    rmse
##   <dbl>
## 1  72.0
```

#### kNN Algorithm
To answer the 2nd question, we decided to use the k-Nearest-Neighbors (kNN) algorithm. It is a simple but extremely powerful classification algorithm which can be used for both classification and regression problems. The name of the algorithm originates from the underlying philosophy — people having similar background or mindset tend to stay close to each other. In other words, data points with similar characteristics and features tend to be close to each other. A very simple metric to calculate the similarity of data points is the Euclidean distance.

The Euclidean distance is the length of the straight line connecting 2 points on a Cartesian plane. In terms of datasets, this distance can be measured using the underlying features.

When presented with an unknown data point, the algorithm uses the Euclidean distance to determine the nearest ‘k’ neighbors, and then use the majority class value to label this data point.

The major aspect of this algorithm is to decide an optimal value of k, i.e., how many similar elements should be considered for deciding the class label of the test element?

A few strategies to decide the best value of k are:

Set k equal to the square root of the number of training observations.

Test several values of k on a variety of test datasets and choose the one that delivers the best performance.

Use a weighted approach, where the closer neighbors are considered more influential than the distant ones.

The strengths of the kNN algorithm lie in its simplicity and the fast training time.

For our use case, the various categories of ratings like cleanliness, communication, location, etc, provide excellent parameters for tuning the kNN algorithm and to determine the overall rating or satisfaction of the customer.

Again, splitting the original dataset into 2 subsets, one for training and one for testing (70:30 split), the kNN model was created using ```k = 5```.

The value of k was determined by testing several values on random samples of the dataset. The resulting accuracy (%) of this model was:
```
## [1] 57.41659
```

The resulting accuracy of ~57% is nothing spectacular.

This result hints at the fact that the customer satisfaction cannot be predicted accurately with the current dataset. The underlying reason could be that the customers don’t give much thought to the ratings which is evident by the fact that less than 5% guests have given a rating of less than 80 (out of 100) for a listing. 95% of the data leans towards a positive experience, which makes the model biased.

## Conclusion
To conclude, the Airbnb dataset provides several insights into the world of Airbnb listings. We were able to summarize the data according to various features and also identify the patterns in the number of listings and their nightly prices. Also, the correlation between specific features allowed us to model this dataset into a set of predictive analysis tools to determine the listing price and customer satisfaction.
