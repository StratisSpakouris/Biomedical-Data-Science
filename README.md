# Biomedical-Data-Science
Indicative exercise from the master course "Biomedical Data Science" at University of Edinburgh

The builtin infert dataset contains data from a study of secondary infertility (that is, the
inability to get pregnant for a woman who had previously been pregnant, recorded in column
“case”). Import the dataset, convert to data table and perform the following:

**(a)** Fit a logistic regression model (M1) to predict secondary infertility using age and parity
(number of previous successful pregnancies) as predictors. Use the deviance to judge the
goodness of fit of the model and report a p-value to 3 significant figures.

**(b)** Fit a second model (M2) by adding the number of spontaneous abortions to the set
of predictors used in model M1. Report odds ratio and 95% confidence interval for the
spontaneuous abortions variable. Perform a likelihood ratio test to compare model M2 to
model M1, and report the p-value for the test. 

**(c)** Implement a function that computes the binomial log-likelihood according to the formula:

<p align="center"> 
<img src="https://latex.codecogs.com/png.latex?%5Clog%20%5Clambda%20%5Cleft%20%28%20%5Cbeta%20%5Cright%20%29%20%3D%20%5Csum_%7Bi%20%5Cin%20case%7D%20%5Clog%20p_%7Bi%7D%20&plus;%5Csum_%7Bi%5Cin%20ctrl%7D%20%5Clog%20%5Cleft%20%28%201-%20p_%7Bi%7D%5Cright%20%29">
</p>

The function should have the following signature:
loglik.binom <- function(y.obs, y.pred)
where y.obs is a vector of observed outcomes (with values either 0 or 1 to represent controls
and cases, respectively), and y.pred is a vector of fitted probabilities learnt from a logistic
regression model. Use function loglik.binom() to compute deviance and null deviance for
model M2.

**(d)** Using functions glm.cv() and predict.cv(), perform 10-folds crossvalidation
for model M2 (set the random seed to 1 before creating the folds). To evaluate
the predictive performance of model M2, use function loglik.binom() to compute the
log-likelihood of the predicted probabilities for each test fold. Report the sum of the test
log-likelihoods over all folds. 
