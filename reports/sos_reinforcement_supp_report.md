SoS Reinforcement - Supplemental report
================
2023-10-31

- <a href="#fixed-effects-models-with-alternate-coding-of-stages"
  id="toc-fixed-effects-models-with-alternate-coding-of-stages">Fixed
  effects models with alternate coding of stages</a>
  - <a href="#main-effect-model" id="toc-main-effect-model">Main effect
    model</a>
  - <a href="#interaction-effect-model"
    id="toc-interaction-effect-model">Interaction effect model</a>
  - <a href="#model-comparison" id="toc-model-comparison">Model
    comparison</a>
- <a href="#predicting-perceived-interview-quality-by-disclosed-details"
  id="toc-predicting-perceived-interview-quality-by-disclosed-details">Predicting
  perceived interview quality by disclosed details</a>
  - <a href="#main-effect-model-1" id="toc-main-effect-model-1">Main effect
    model</a>
  - <a href="#interaction-effect-model-1"
    id="toc-interaction-effect-model-1">Interaction effect model</a>
  - <a href="#model-comparison-1" id="toc-model-comparison-1">Model
    comparison</a>
- <a href="#assessing-training-effects"
  id="toc-assessing-training-effects">Assessing Training effects</a>
  - <a href="#main-effect-model-2" id="toc-main-effect-model-2">Main effect
    model</a>
  - <a href="#interaction-effect-model-2"
    id="toc-interaction-effect-model-2">Interaction effect model</a>
  - <a href="#model-comparison-2" id="toc-model-comparison-2">Model
    comparison</a>
- <a href="#comparing-interviewers"
  id="toc-comparing-interviewers">Comparing interviewers</a>
  - <a href="#m-vs-p" id="toc-m-vs-p">M vs. P</a>
  - <a href="#m-vs-k" id="toc-m-vs-k">M vs. K</a>
  - <a href="#p-vs-k" id="toc-p-vs-k">P vs. K</a>
- <a href="#duration-of-interview" id="toc-duration-of-interview">Duration
  of interview</a>
  - <a href="#main-effect-model-3" id="toc-main-effect-model-3">Main effect
    model</a>
  - <a href="#interaction-effect-model-3"
    id="toc-interaction-effect-model-3">Interaction effect model</a>
  - <a href="#model-comparison-3" id="toc-model-comparison-3">Model
    comparison</a>

## Fixed effects models with alternate coding of stages

In the models below we code stage 4 as the midpoint of the interview
(all non critical stages) instead of point 3. These models do not change
our interpretation of our int ital results.

### Main effect model

    ## Linear mixed model fit by maximum likelihood . t-tests use Satterthwaite's
    ##   method [lmerModLmerTest]
    ## Formula: detail ~ time + treatment + after + style + (1 | crime_order/ID) +  
    ##     (1 | interviewer)
    ##    Data: sos_midpont_4
    ## 
    ##      AIC      BIC   logLik deviance df.resid 
    ##   5482.4   5530.2  -2732.2   5464.4     1491 
    ## 
    ## Scaled residuals: 
    ##     Min      1Q  Median      3Q     Max 
    ## -2.9168 -0.5846 -0.0640  0.5941  3.0400 
    ## 
    ## Random effects:
    ##  Groups         Name        Variance Std.Dev.
    ##  ID:crime_order (Intercept) 1.61262  1.2699  
    ##  crime_order    (Intercept) 0.02506  0.1583  
    ##  interviewer    (Intercept) 0.00000  0.0000  
    ##  Residual                   1.54969  1.2449  
    ## Number of obs: 1500, groups:  
    ## ID:crime_order, 300; crime_order, 6; interviewer, 3
    ## 
    ## Fixed effects:
    ##                      Estimate Std. Error         df t value Pr(>|t|)    
    ## (Intercept)           1.99245    0.17384   45.18368  11.461 5.78e-15 ***
    ## time                 -0.16700    0.03214 1200.00027  -5.196 2.40e-07 ***
    ## treatment            -0.04500    0.11364 1200.00028  -0.396    0.692    
    ## stylereinforcement    1.08646    0.19687  299.05341   5.519 7.41e-08 ***
    ## stylestandard         0.98620    0.19708  299.69014   5.004 9.59e-07 ***
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## Correlation of Fixed Effects:
    ##             (Intr) time   trtmnt stylrn
    ## time        -0.462                     
    ## treatment    0.261 -0.707              
    ## stylrnfrcmn -0.566  0.000  0.000       
    ## stylestndrd -0.566  0.000  0.000  0.499
    ## fit warnings:
    ## fixed-effect model matrix is rank deficient so dropping 1 column / coefficient
    ## optimizer (nloptwrap) convergence code: 0 (OK)
    ## boundary (singular) fit: see help('isSingular')

### Interaction effect model

    ## Linear mixed model fit by maximum likelihood . t-tests use Satterthwaite's
    ##   method [lmerModLmerTest]
    ## Formula: 
    ## detail ~ time + treatment + after + style + time * style + treatment *  
    ##     style + after * style + (1 | crime_order/ID) + (1 | interviewer)
    ##    Data: sos_midpont_4
    ## 
    ##      AIC      BIC   logLik deviance df.resid 
    ##   5481.9   5551.0  -2728.0   5455.9     1487 
    ## 
    ## Scaled residuals: 
    ##      Min       1Q   Median       3Q      Max 
    ## -2.94728 -0.57511 -0.05885  0.59737  3.08502 
    ## 
    ## Random effects:
    ##  Groups         Name        Variance Std.Dev.
    ##  ID:crime_order (Intercept) 1.61482  1.2708  
    ##  crime_order    (Intercept) 0.02506  0.1583  
    ##  interviewer    (Intercept) 0.00000  0.0000  
    ##  Residual                   1.53875  1.2405  
    ## Number of obs: 1500, groups:  
    ## ID:crime_order, 300; crime_order, 6; interviewer, 3
    ## 
    ## Fixed effects:
    ##                                Estimate Std. Error         df t value Pr(>|t|)
    ## (Intercept)                     1.94745    0.20859   92.30510   9.336 5.53e-15
    ## time                           -0.16600    0.05547 1200.00170  -2.992 0.002825
    ## treatment                       0.16500    0.19614 1200.00169   0.841 0.400371
    ## stylereinforcement              1.03746    0.28065  975.94238   3.697 0.000231
    ## stylestandard                   1.17020    0.28080  976.32983   4.167 3.35e-05
    ## time:stylereinforcement         0.05800    0.07845 1200.00169   0.739 0.459877
    ## time:stylestandard             -0.06100    0.07845 1200.00169  -0.778 0.437001
    ## treatment:stylereinforcement   -0.62500    0.27738 1200.00168  -2.253 0.024423
    ## treatment:stylestandard        -0.00500    0.27738 1200.00168  -0.018 0.985621
    ##                                 
    ## (Intercept)                  ***
    ## time                         ** 
    ## treatment                       
    ## stylereinforcement           ***
    ## stylestandard                ***
    ## time:stylereinforcement         
    ## time:stylestandard              
    ## treatment:stylereinforcement *  
    ## treatment:stylestandard         
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## Correlation of Fixed Effects:
    ##              (Intr) time   trtmnt stylrn stylst tm:stylr tm:styls trtmnt:stylr
    ## time         -0.665                                                           
    ## treatment     0.376 -0.707                                                    
    ## stylrnfrcmn  -0.673  0.494 -0.280                                             
    ## stylestndrd  -0.673  0.494 -0.279  0.499                                      
    ## tm:stylrnfr   0.470 -0.707  0.500 -0.699 -0.349                               
    ## tm:stylstnd   0.470 -0.707  0.500 -0.349 -0.698  0.500                        
    ## trtmnt:stylr -0.266  0.500 -0.707  0.395  0.198 -0.707   -0.354               
    ## trtmnt:styls -0.266  0.500 -0.707  0.198  0.395 -0.354   -0.707    0.500      
    ## fit warnings:
    ## fixed-effect model matrix is rank deficient so dropping 3 columns / coefficients
    ## optimizer (nloptwrap) convergence code: 0 (OK)
    ## boundary (singular) fit: see help('isSingular')

### Model comparison

    ## Data: sos_midpont_4
    ## Models:
    ## info_model_M4: detail ~ time + treatment + after + style + (1 | crime_order/ID) + (1 | interviewer)
    ## info_model_M4_int: detail ~ time + treatment + after + style + time * style + treatment * style + after * style + (1 | crime_order/ID) + (1 | interviewer)
    ##                   npar    AIC    BIC  logLik deviance  Chisq Df Pr(>Chisq)  
    ## info_model_M4        9 5482.4 5530.2 -2732.2   5464.4                       
    ## info_model_M4_int   13 5481.9 5551.0 -2728.0   5455.9 8.4962  4      0.075 .
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

## Predicting perceived interview quality by disclosed details

While the relationship between perceived interviewer quality and
information disclosures differed across the conditions, perceived
interview quality did not.

### Main effect model

    ## Linear mixed model fit by maximum likelihood . t-tests use Satterthwaite's
    ##   method [lmerModLmerTest]
    ## Formula: detail ~ interview_qual + style + (1 | crime_order/ID) + (1 |  
    ##     time) + (1 | interviewer)
    ##    Data: sos_long
    ## 
    ##      AIC      BIC   logLik deviance df.resid 
    ##   6449.0   6498.4  -3215.5   6431.0     1767 
    ## 
    ## Scaled residuals: 
    ##     Min      1Q  Median      3Q     Max 
    ## -3.0087 -0.5920 -0.0287  0.5885  3.1714 
    ## 
    ## Random effects:
    ##  Groups         Name        Variance Std.Dev.
    ##  ID:crime_order (Intercept) 1.48966  1.2205  
    ##  crime_order    (Intercept) 0.05232  0.2287  
    ##  time           (Intercept) 0.11673  0.3417  
    ##  interviewer    (Intercept) 0.00000  0.0000  
    ##  Residual                   1.57538  1.2551  
    ## Number of obs: 1776, groups:  
    ## ID:crime_order, 296; crime_order, 6; time, 6; interviewer, 3
    ## 
    ## Fixed effects:
    ##                     Estimate Std. Error        df t value Pr(>|t|)    
    ## (Intercept)          1.19273    0.34386  98.42322   3.469 0.000777 ***
    ## interview_qual       0.10200    0.08972 293.10584   1.137 0.256531    
    ## stylereinforcement   1.09333    0.19000 294.13168   5.754 2.18e-08 ***
    ## stylestandard        1.02312    0.19136 294.59990   5.347 1.80e-07 ***
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## Correlation of Fixed Effects:
    ##             (Intr) intrv_ stylrn
    ## interviw_ql -0.782              
    ## stylrnfrcmn -0.374  0.132       
    ## stylestndrd -0.336  0.084  0.497
    ## optimizer (nloptwrap) convergence code: 0 (OK)
    ## boundary (singular) fit: see help('isSingular')

### Interaction effect model

    ## Linear mixed model fit by maximum likelihood . t-tests use Satterthwaite's
    ##   method [lmerModLmerTest]
    ## Formula: detail ~ interview_qual + style + interview_qual * style + (1 |  
    ##     crime_order/ID) + (1 | time) + (1 | interviewer)
    ##    Data: sos_long
    ## 
    ##      AIC      BIC   logLik deviance df.resid 
    ##   6449.9   6510.2  -3214.0   6427.9     1765 
    ## 
    ## Scaled residuals: 
    ##     Min      1Q  Median      3Q     Max 
    ## -2.9972 -0.5953 -0.0278  0.5896  3.1879 
    ## 
    ## Random effects:
    ##  Groups         Name        Variance  Std.Dev. 
    ##  ID:crime_order (Intercept) 1.469e+00 1.212e+00
    ##  crime_order    (Intercept) 5.849e-02 2.419e-01
    ##  time           (Intercept) 1.171e-01 3.422e-01
    ##  interviewer    (Intercept) 1.539e-09 3.923e-05
    ##  Residual                   1.575e+00 1.255e+00
    ## Number of obs: 1776, groups:  
    ## ID:crime_order, 296; crime_order, 6; time, 6; interviewer, 3
    ## 
    ## Fixed effects:
    ##                                    Estimate Std. Error        df t value
    ## (Intercept)                         1.81729    0.49218 217.11349   3.692
    ## interview_qual                     -0.10755    0.14781 291.75701  -0.728
    ## stylereinforcement                  0.16236    0.65502 294.36404   0.248
    ## stylestandard                       0.03571    0.65058 293.65898   0.055
    ## interview_qual:stylereinforcement   0.32200    0.22036 294.92511   1.461
    ## interview_qual:stylestandard        0.33945    0.21463 293.93570   1.582
    ##                                   Pr(>|t|)    
    ## (Intercept)                       0.000281 ***
    ## interview_qual                    0.467433    
    ## stylereinforcement                0.804405    
    ## stylestandard                     0.956266    
    ## interview_qual:stylereinforcement 0.145002    
    ## interview_qual:stylestandard      0.114827    
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## Correlation of Fixed Effects:
    ##                 (Intr) intrv_ stylrn stylst intrvw_ql:stylr
    ## interviw_ql     -0.898                                     
    ## stylrnfrcmn     -0.664  0.681                              
    ## stylestndrd     -0.664  0.678  0.498                       
    ## intrvw_ql:stylr  0.606 -0.676 -0.957 -0.454                
    ## intrvw_ql:styls  0.619 -0.688 -0.467 -0.956  0.465         
    ## optimizer (nloptwrap) convergence code: 0 (OK)
    ## boundary (singular) fit: see help('isSingular')

### Model comparison

    ## Data: sos_long
    ## Models:
    ## expl_model_5: detail ~ interview_qual + style + (1 | crime_order/ID) + (1 | time) + (1 | interviewer)
    ## expl_model_6: detail ~ interview_qual + style + interview_qual * style + (1 | crime_order/ID) + (1 | time) + (1 | interviewer)
    ##              npar    AIC    BIC  logLik deviance  Chisq Df Pr(>Chisq)
    ## expl_model_5    9 6449.0 6498.4 -3215.5   6431.0                     
    ## expl_model_6   11 6449.9 6510.2 -3214.0   6427.9 3.1424  2     0.2078

## Assessing Training effects

### Main effect model

    ## 
    ## Call:
    ## lm(formula = sum_info ~ ID + interviewer, data = sos)
    ## 
    ## Residuals:
    ##      Min       1Q   Median       3Q      Max 
    ## -15.6272  -7.3570   0.1949   7.0915  16.7945 
    ## 
    ## Coefficients:
    ##                  Estimate Std. Error t value Pr(>|t|)    
    ## (Intercept)      15.79198    1.29730  12.173   <2e-16 ***
    ## ID               -0.01268    0.00571  -2.220   0.0272 *  
    ## interviewerMalin -1.14847    1.21689  -0.944   0.3461    
    ## interviewerPär   -1.13425    1.23187  -0.921   0.3579    
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## Residual standard error: 8.561 on 296 degrees of freedom
    ## Multiple R-squared:  0.0192, Adjusted R-squared:  0.009261 
    ## F-statistic: 1.932 on 3 and 296 DF,  p-value: 0.1245

### Interaction effect model

    ## 
    ## Call:
    ## lm(formula = sum_info ~ ID + interviewer + ID * interviewer, 
    ##     data = sos)
    ## 
    ## Residuals:
    ##      Min       1Q   Median       3Q      Max 
    ## -14.7143  -6.8807   0.4853   6.8651  16.4031 
    ## 
    ## Coefficients:
    ##                      Estimate Std. Error t value Pr(>|t|)    
    ## (Intercept)         13.833841   1.974939   7.005 1.69e-11 ***
    ## ID                  -0.001161   0.010460  -0.111   0.9117    
    ## interviewerMalin     0.228000   2.719022   0.084   0.9332    
    ## interviewerPär       2.413382   2.461041   0.981   0.3276    
    ## ID:interviewerMalin -0.008068   0.014362  -0.562   0.5747    
    ## ID:interviewerPär   -0.023968   0.014064  -1.704   0.0894 .  
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## Residual standard error: 8.546 on 294 degrees of freedom
    ## Multiple R-squared:  0.0294, Adjusted R-squared:  0.01289 
    ## F-statistic: 1.781 on 5 and 294 DF,  p-value: 0.1166

### Model comparison

    ## Analysis of Variance Table
    ## 
    ## Model 1: sum_info ~ ID + interviewer
    ## Model 2: sum_info ~ ID + interviewer + ID * interviewer
    ##   Res.Df   RSS Df Sum of Sq      F Pr(>F)
    ## 1    296 21696                           
    ## 2    294 21471  2     225.6 1.5446 0.2151

## Comparing interviewers

    ## # A tibble: 9 × 5
    ## # Groups:   style [3]
    ##   style         interviewer  Mean    SD Median
    ##   <chr>         <chr>       <dbl> <dbl>  <dbl>
    ## 1 direct        Kaan         3.67 0.608   3.5 
    ## 2 direct        Malin        3.43 0.612   3.5 
    ## 3 direct        Pär          3.62 0.496   3.67
    ## 4 reinforcement Kaan         3.69 0.498   3.67
    ## 5 reinforcement Malin        3.21 0.660   3.17
    ## 6 reinforcement Pär          3.31 0.593   3.33
    ## 7 standard      Kaan         3.51 0.606   3.67
    ## 8 standard      Malin        3.22 0.561   3.33
    ## 9 standard      Pär          3.63 0.437   3.67

### M vs. P

    ## 
    ##  Welch Two Sample t-test
    ## 
    ## data:  interviewer_qual by interviewer
    ## t = -2.8319, df = 189.57, p-value = 0.005127
    ## alternative hypothesis: true difference in means between group Malin and group Pär is not equal to 0
    ## 95 percent confidence interval:
    ##  -0.39181419 -0.07008191
    ## sample estimates:
    ## mean in group Malin   mean in group Pär 
    ##            3.288660            3.519608

### M vs. K

    ## 
    ##  Welch Two Sample t-test
    ## 
    ## data:  interviewer_qual by interviewer
    ## t = 3.9419, df = 191.72, p-value = 0.0001132
    ## alternative hypothesis: true difference in means between group Kaan and group Malin is not equal to 0
    ## 95 percent confidence interval:
    ##  0.1676187 0.5033610
    ## sample estimates:
    ##  mean in group Kaan mean in group Malin 
    ##             3.62415             3.28866

### P vs. K

    ## 
    ##  Welch Two Sample t-test
    ## 
    ## data:  interviewer_qual by interviewer
    ## t = 1.3389, df = 195.3, p-value = 0.1822
    ## alternative hypothesis: true difference in means between group Kaan and group Pär is not equal to 0
    ## 95 percent confidence interval:
    ##  -0.04944778  0.25853142
    ## sample estimates:
    ## mean in group Kaan  mean in group Pär 
    ##           3.624150           3.519608

## Duration of interview

    ## # A tibble: 3 × 7
    ##   style          Mean    SD Median    SE Upper Lower
    ##   <chr>         <dbl> <dbl>  <dbl> <dbl> <dbl> <dbl>
    ## 1 direct         10.4  5.22   9.98 0.522  11.5  9.42
    ## 2 reinforcement  18.0  6.72  17.1  0.672  19.3 16.7 
    ## 3 standard       13.9  5.10  13.7  0.510  14.9 12.9

### Main effect model

    ## Linear mixed model fit by maximum likelihood . t-tests use Satterthwaite's
    ##   method [lmerModLmerTest]
    ## Formula: detail ~ minutes + style + (1 | crime_order/ID) + (1 | time) +  
    ##     (1 | interviewer)
    ##    Data: sos_time_long
    ## 
    ##      AIC      BIC   logLik deviance df.resid 
    ##   6454.2   6503.6  -3218.1   6436.2     1791 
    ## 
    ## Scaled residuals: 
    ##      Min       1Q   Median       3Q      Max 
    ## -2.97942 -0.57948 -0.02538  0.57765  3.15111 
    ## 
    ## Random effects:
    ##  Groups         Name        Variance Std.Dev.
    ##  ID:crime_order (Intercept) 1.10616  1.0517  
    ##  crime_order    (Intercept) 0.02867  0.1693  
    ##  time           (Intercept) 0.11267  0.3357  
    ##  interviewer    (Intercept) 0.00000  0.0000  
    ##  Residual                   1.56888  1.2525  
    ## Number of obs: 1800, groups:  
    ## ID:crime_order, 300; crime_order, 6; time, 6; interviewer, 3
    ## 
    ## Fixed effects:
    ##                     Estimate Std. Error        df t value Pr(>|t|)    
    ## (Intercept)          0.30091    0.22927  32.08022   1.312  0.19868    
    ## minutes              0.11581    0.01189 296.42298   9.743  < 2e-16 ***
    ## stylereinforcement   0.17331    0.18958 299.13588   0.914  0.36137    
    ## stylestandard        0.54465    0.17179 299.32919   3.170  0.00168 ** 
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## Correlation of Fixed Effects:
    ##             (Intr) minuts stylrn
    ## minutes     -0.538              
    ## stylrnfrcmn -0.059 -0.481       
    ## stylestndrd -0.218 -0.247  0.542
    ## optimizer (nloptwrap) convergence code: 0 (OK)
    ## boundary (singular) fit: see help('isSingular')

### Interaction effect model

    ## Linear mixed model fit by maximum likelihood . t-tests use Satterthwaite's
    ##   method [lmerModLmerTest]
    ## Formula: detail ~ minutes + style + minutes * style + (1 | crime_order/ID) +  
    ##     (1 | time) + (1 | interviewer)
    ##    Data: sos_time_long
    ## 
    ##      AIC      BIC   logLik deviance df.resid 
    ##   6446.3   6506.8  -3212.2   6424.3     1789 
    ## 
    ## Scaled residuals: 
    ##     Min      1Q  Median      3Q     Max 
    ## -2.9643 -0.5906 -0.0207  0.5873  3.1658 
    ## 
    ## Random effects:
    ##  Groups         Name        Variance Std.Dev.
    ##  ID:crime_order (Intercept) 1.05357  1.0264  
    ##  crime_order    (Intercept) 0.02685  0.1638  
    ##  time           (Intercept) 0.11241  0.3353  
    ##  interviewer    (Intercept) 0.00000  0.0000  
    ##  Residual                   1.56887  1.2525  
    ## Number of obs: 1800, groups:  
    ## ID:crime_order, 300; crime_order, 6; time, 6; interviewer, 3
    ## 
    ## Fixed effects:
    ##                              Estimate Std. Error         df t value Pr(>|t|)
    ## (Intercept)                 -0.116507   0.300065  83.922945  -0.388  0.69880
    ## minutes                      0.156143   0.022240 299.030235   7.021 1.49e-11
    ## stylereinforcement           1.386981   0.422543 299.524825   3.282  0.00115
    ## stylestandard                0.466135   0.424133 297.059461   1.099  0.27264
    ## minutes:stylereinforcement  -0.084488   0.028294 299.257489  -2.986  0.00306
    ## minutes:stylestandard       -0.005023   0.031682 295.993388  -0.159  0.87414
    ##                               
    ## (Intercept)                   
    ## minutes                    ***
    ## stylereinforcement         ** 
    ## stylestandard                 
    ## minutes:stylereinforcement ** 
    ## minutes:stylestandard         
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## Correlation of Fixed Effects:
    ##             (Intr) minuts stylrn stylst mnts:stylr
    ## minutes     -0.771                                
    ## stylrnfrcmn -0.533  0.556                         
    ## stylestndrd -0.522  0.538  0.371                  
    ## mnts:stylrn  0.611 -0.793 -0.890 -0.423           
    ## mnts:stylst  0.539 -0.696 -0.387 -0.913  0.550    
    ## optimizer (nloptwrap) convergence code: 0 (OK)
    ## boundary (singular) fit: see help('isSingular')

### Model comparison

    ## Data: sos_time_long
    ## Models:
    ## dur_model_1: detail ~ minutes + style + (1 | crime_order/ID) + (1 | time) + (1 | interviewer)
    ## dur_model_2: detail ~ minutes + style + minutes * style + (1 | crime_order/ID) + (1 | time) + (1 | interviewer)
    ##             npar    AIC    BIC  logLik deviance Chisq Df Pr(>Chisq)   
    ## dur_model_1    9 6454.2 6503.6 -3218.1   6436.2                       
    ## dur_model_2   11 6446.3 6506.8 -3212.2   6424.3 11.83  2   0.002698 **
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
