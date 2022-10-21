# Datavengers
This repository contains code for the Data Analytics project.

# Dataset
[Airbnb Listings](https://public.opendatasoft.com/explore/dataset/airbnb-listings/table/?disjunctive.host_verifications&disjunctive.amenities&disjunctive.features&dataChart=eyJxdWVyaWVzIjpbeyJjaGFydHMiOlt7InR5cGUiOiJjb2x1bW4iLCJmdW5jIjoiQ09VTlQiLCJ5QXhpcyI6Imhvc3RfbGlzdGluZ3NfY291bnQiLCJzY2llbnRpZmljRGlzcGxheSI6dHJ1ZSwiY29sb3IiOiJyYW5nZS1jdXN0b20ifV0sInhBeGlzIjoiY2l0eSIsIm1heHBvaW50cyI6IiIsInRpbWVzY2FsZSI6IiIsInNvcnQiOiIiLCJzZXJpZXNCcmVha2Rvd24iOiJyb29tX3R5cGUiLCJjb25maWciOnsiZGF0YXNldCI6ImFpcmJuYi1saXN0aW5ncyIsI)

For many business applications, like as predicting whether a certain user will purchase a product or predicting whether a specific loan would fail or not, the ability to correctly categorize observations is quite significant. To understand Random Forest first we need to get an idea of decision trees.

Decision Trees
A decision tree is a graph that resembles a tree, with nodes standing in for the places where we choose an attribute and pose a question, edges standing in for the responses to those questions, and leaves standing in for the actual output or class label.
Decision trees may be employed in a number of business settings because they closely resemble how people make decisions.
Businesses frequently utilize them to forecast future results. For illustration:
1. Which client will remain a devoted one, and which one will leave? (Decision tree for classification)
2. What percentage of an upsell can we offer a consumer given their product options? (Decision tree using regression)
3. Which article should I suggest to viewers of my blog next? (Decisional classification trees)
Although our data may not always be this tidy in real life, a decision tree nonetheless operates according to the same principle. It will inquire at every node:
What attribute will enable me to divide the current observations into groups that are as distinct from one another as feasible (and whose members are as similar to one another as possible)?

Random Forest
Like its name suggests, a random forest is made up of several independent decision trees that work together as a group. Every tree in the random forest spits out a class prediction, and the class that receives the most votes becomes the prediction made by our model.
'The wisdom of crowds' is the basic idea underlying random forest, which is a straightforward but effective idea. The success of the random forest model, in terms of data science, is due to:
The best results come from a large number of very uncorrelated models (trees) working together as a committee.

The key is the poor correlation between models. Uncorrelated models have the ability to provide aggregate forecasts that are more accurate than any of the individual predictions, just like assets with low correlations (such stocks and bonds) combine to build a portfolio that is larger than the sum of its parts.

As long as they don't consistently all mistake in the same direction, the trees shield each other from their individual faults, which accounts for this stunning result. Many trees will be right while some may be wrong, allowing the group of trees to travel in the proper direction. The following conditions must be met for random forest to function effectively:

In order for models created utilizing those attributes to perform better than guesswork, there must be some real signal in those features.
Low correlations between the predictions (and thus the mistakes) of the separate trees are required.

