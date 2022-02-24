################################################################################

# SoS - Computing of correlation matrix

# Original Copyright Alboukadel Kassambara (https://github.com/kassambara)
# The following script is a derivative work of the rquery.cormat code, which is 
# licensed CC BY-NC-SA 3.0 US. This script is therefore licensed under the same 
# terms. Additional scripts in repository licensed under GPL-3.0.
# Original code can be found here: 
# http://www.sthda.com/upload/rquery_cormat.r

################################################################################

# Description

# Required package : corrplot

# x : matrix

# Result is a list including the following components :
# r : correlation matrix, p :  p-values

################################################################################


corr_p_mat <-function(x)
  
{
  library(corrplot)
  # Helper functions

  # Compute the matrix of correlation p-values
  cor.pmat <- function(x) {
    mat <- as.matrix(x)
    n <- ncol(mat)
    p.mat<- matrix(NA, n, n)
    diag(p.mat) <- 0
    for (i in 1:(n - 1)) {
      for (j in (i + 1):n) {
        tmp <- cor.test(mat[, i], mat[, j])
        p.mat[i, j] <- p.mat[j, i] <- tmp$p.value
      }
    }
    colnames(p.mat) <- rownames(p.mat) <- colnames(mat)
    p.mat
  }
  # Get lower triangle of the matrix
  getLower.tri<-function(mat){
    upper<-mat
    upper[upper.tri(mat)]<-""
    mat<-as.data.frame(upper)
    mat
  }
  # Correlation matrix
  cormat<-signif(cor(x, use = "complete.obs"),2)
  pmat<-signif(cor.pmat(x),2)
    list(r=cormat, p=pmat)
  }

  

