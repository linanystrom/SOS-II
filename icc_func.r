
ICC_func <- function(x) {
  
  model <- x
  model_vcov <- summary(model)$varcor %>%  as.data.frame()
  model_icc <- model_vcov$vcov/sum(model_vcov$vcov)
  return(model_icc)
}

