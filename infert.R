library(data.table)
library(caret)

# --- a) ---
infert <- data.table(infert)
M1 <- glm(case ~ age + parity, data=infert, family="binomial")
summary(M1)
M1$deviance
pval <- pchisq(M1$null.deviance - M1$deviance, df=2, lower.tail=FALSE)
signif(pval, 3)

# --- b) ---
M2 <- glm(case ~ age + parity + spontaneous, data=infert, family="binomial")
or.spontaneous <- exp(coef(M2)[4])
ci.spontaneous <- exp(confint(M2))[4, ]

pval <- pchisq(M1$deviance - M2$deviance, df=1, lower.tail=FALSE)

or.spontaneous
ci.spontaneous
pval

# --- c) ---
# Function for computing the binomial log-likelihood 
loglik.binom <- function(y.obs, y.pred) {
  loglik <- sum(y.obs*log(y.pred)) + sum((1-y.obs)*log(1-y.pred))
  return(loglik)
}

# compute the predictions using model M2
pred <- predict(M2, type="response", newdata=infert) 

# compute the loglikelihood of model M2
loglik.binom(infert$case, pred)

# compute the deviance
dev <- -2*loglik.binom(infert$case, pred)  

# compute the null deviance
null.model <- glm(case ~ 1 , data=infert, family="binomial")
pred.null <- predict(null.model, type="response", newdata=infert)
dev.null <- -2*loglik.binom(infert$case, pred.null)

dev
dev.null

# --- d) ---
glm.cv <- function(formula, data, folds) {
  regr.cv <- NULL
  for (fold in 1:length(folds)) {
    regr.cv[[fold]] <- glm(formula, data=data[-folds[[fold]], ], family="binomial")
  }
  return(regr.cv)
}

predict.cv <- function(regr.cv, data, outcome, folds ) {
  pred.cv <- NULL
  for (fold in 1:length(folds)) {
    test.idx <- folds[[fold]]
    pred.cv[[fold]] <- data.frame(obs=outcome[test.idx], pred=predict(regr.cv[[fold]], newdata=data, type="response")[test.idx])
  }
  return(pred.cv)
}

set.seed(1)
folds <- createFolds(infert$case, k=10)
cvM2 <- glm.cv(M2, infert, folds)  
pred.cvM2 <- predict.cv(cvM2, infert, infert$case, folds)

# compute the log-likelihood for each test fold
cv.lik <- numeric(length(folds))
for (fold in 1:length(folds)) {
  cv.lik[fold] <- loglik.binom(pred.cvM2[[fold]]$obs, pred.cvM2[[fold]]$pred)
}

# sum of the test log likelihood over all folds
sum(cv.lik)