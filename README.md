# House-price-prediction-using-Advanced-regression-techniques

Ask a home buyer to describe their dream house, and they probably won't begin with the height of the basement ceiling or the proximity to an east-west railroad. But this playground competition's dataset proves that much more influences price negotiations than the number of bedrooms or a white-picket fence.
With 79 explanatory variables describing (almost) every aspect of residential homes in Ames, Iowa, this competition challenges you to predict the final price of each home.

This competetion has been coded in R.
The preprocessing include checking the feature space and identifying the nulls in each feature using summary.
The numerical values for features containing nulls have been replaced by their corresponding mean, we can also try doing the same by replacing those nulls with median.
The categorical features have been paid special attention:
- Apart from the features which had NA just as a missing value, those with NA as a different level have been added to the feature space to now adjust the number of levels according to the problem.
This increases the robustness of the model to any dataset (test dataset in this case) which was also dealt in the same way and then was trained on a bunch of different models.
Different models tried on this data are:
Random Forest
Gradient Boosting
Deep Neural Network(DNN using Caret)
GBM
