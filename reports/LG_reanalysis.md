Reanalysis of Luke and Granhag (2022)
================
2023-06-13

- <a href="#reanalysis-of-luke-and-granhag-2022"
  id="toc-reanalysis-of-luke-and-granhag-2022">Reanalysis of Luke and
  Granhag (2022)</a>
  - <a href="#predicting-disclosed-details-by-self-asessment-of-performance"
    id="toc-predicting-disclosed-details-by-self-asessment-of-performance">Predicting
    disclosed details by self asessment of performance</a>
    - <a href="#main-effect-model" id="toc-main-effect-model">Main effect
      model</a>
    - <a href="#interaction-effect-model"
      id="toc-interaction-effect-model">Interaction effect model</a>
    - <a href="#comparing-model-fit" id="toc-comparing-model-fit">Comparing
      model fit</a>
  - <a href="#predicting-perceived-interviewer-quality-by-disclosed-details"
    id="toc-predicting-perceived-interviewer-quality-by-disclosed-details">Predicting
    perceived interviewer quality by disclosed details</a>
    - <a href="#main-effect-model-1" id="toc-main-effect-model-1">Main effect
      model</a>
    - <a href="#interaction-effect-model-1"
      id="toc-interaction-effect-model-1">Interaction effect model</a>
    - <a href="#comparing-model-fit-1"
      id="toc-comparing-model-fit-1">Comparing model fit</a>
  - <a href="#predicting-perceived-interview-qulity-på-disclosed-details"
    id="toc-predicting-perceived-interview-qulity-på-disclosed-details">Predicting
    perceived interview qulity på disclosed details</a>
    - <a href="#main-effect-model-2" id="toc-main-effect-model-2">Main effect
      model</a>
    - <a href="#interaction-effect-model-2"
      id="toc-interaction-effect-model-2">Interaction effect model</a>
    - <a href="#comparing-model-fit-2"
      id="toc-comparing-model-fit-2">Comparing model fit</a>

# Reanalysis of Luke and Granhag (2022)

In light of analyses performed in the current project “Advancing The
Shift-Of-Strategy Approach: Shifting Suspects’ Strategies in Extended
Interrogations” we wanted to perform the same analyses on the firt paper
on the Shift-Of-Strategy approach to assess wether we find the same
patterns here.

## Predicting disclosed details by self asessment of performance

We found that the realtionship between self assessment of performance
and disclosed details was reversed in the Direct and SoS conditions in
the current experiement. We found a negative relationship between
disclosed details and self assessed performance for the Direct
condition, and a positive relationship betweent he variables in both SoS
conditions.

Below we perform the same analyses on the data from Luke and Granhag
(2022). The interaction effect model exhibits better fit with data and
we observe the same relationship between self assessment of performance
and information disclosure as we found in the current experiment.

### Main effect model

    ## boundary (singular) fit: see help('isSingular')

    ## Linear mixed model fit by maximum likelihood . t-tests use Satterthwaite's
    ##   method [lmerModLmerTest]
    ## Formula: info_disc ~ self_assessment + condition + (1 | crime_order/ID) +  
    ##     (1 | interviewer)
    ##    Data: luke_granhag_2022_long
    ## 
    ##      AIC      BIC   logLik deviance df.resid 
    ##   3024.1   3062.4  -1504.1   3008.1      883 
    ## 
    ## Scaled residuals: 
    ##     Min      1Q  Median      3Q     Max 
    ## -2.4719 -0.6579 -0.0735  0.5682  3.1155 
    ## 
    ## Random effects:
    ##  Groups         Name        Variance  Std.Dev.
    ##  ID:crime_order (Intercept) 8.627e-01 0.928841
    ##  crime_order    (Intercept) 0.000e+00 0.000000
    ##  interviewer    (Intercept) 3.981e-05 0.006309
    ##  Residual                   1.158e+00 1.076220
    ## Number of obs: 891, groups:  
    ## ID:crime_order, 297; crime_order, 18; interviewer, 3
    ## 
    ## Fixed effects:
    ##                     Estimate Std. Error        df t value Pr(>|t|)    
    ## (Intercept)          0.53701    0.28569 213.89020   1.880 0.061510 .  
    ## self_assessment      0.26020    0.09205 290.85839   2.827 0.005027 ** 
    ## conditionSelective   0.38902    0.15933 294.38471   2.442 0.015211 *  
    ## conditionReactive    0.61125    0.16408 294.81628   3.725 0.000234 ***
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## Correlation of Fixed Effects:
    ##             (Intr) slf_ss cndtnS
    ## slf_ssssmnt -0.919              
    ## condtnSlctv -0.350  0.079       
    ## conditnRctv -0.500  0.251  0.502
    ## optimizer (nloptwrap) convergence code: 0 (OK)
    ## boundary (singular) fit: see help('isSingular')

### Interaction effect model

    ## boundary (singular) fit: see help('isSingular')

    ## Linear mixed model fit by maximum likelihood . t-tests use Satterthwaite's
    ##   method [lmerModLmerTest]
    ## Formula: 
    ## info_disc ~ self_assessment + condition + self_assessment * condition +  
    ##     (1 | crime_order/ID) + (1 | interviewer)
    ##    Data: luke_granhag_2022_long
    ## Control: lmerControl(optCtrl = list(maxfun = 1e+05), optimizer = "bobyqa")
    ## 
    ##      AIC      BIC   logLik deviance df.resid 
    ##   3013.1   3061.0  -1496.5   2993.1      881 
    ## 
    ## Scaled residuals: 
    ##      Min       1Q   Median       3Q      Max 
    ## -2.57598 -0.67272 -0.07539  0.58077  3.12774 
    ## 
    ## Random effects:
    ##  Groups         Name        Variance Std.Dev.
    ##  ID:crime_order (Intercept) 0.8011   0.895   
    ##  crime_order    (Intercept) 0.0000   0.000   
    ##  interviewer    (Intercept) 0.0000   0.000   
    ##  Residual                   1.1582   1.076   
    ## Number of obs: 891, groups:  
    ## ID:crime_order, 297; crime_order, 18; interviewer, 3
    ## 
    ## Fixed effects:
    ##                                    Estimate Std. Error       df t value
    ## (Intercept)                          1.8632     0.4591 297.0000   4.058
    ## self_assessment                     -0.2046     0.1563 297.0000  -1.309
    ## conditionSelective                  -1.9848     0.6267 297.0000  -3.167
    ## conditionReactive                   -0.8535     0.6070 297.0000  -1.406
    ## self_assessment:conditionSelective   0.8503     0.2178 297.0000   3.904
    ## self_assessment:conditionReactive    0.5223     0.2226 297.0000   2.346
    ##                                    Pr(>|t|)    
    ## (Intercept)                        6.33e-05 ***
    ## self_assessment                    0.191447    
    ## conditionSelective                 0.001699 ** 
    ## conditionReactive                  0.160756    
    ## self_assessment:conditionSelective 0.000117 ***
    ## self_assessment:conditionReactive  0.019631 *  
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## Correlation of Fixed Effects:
    ##             (Intr) slf_ss cndtnS cndtnR slf_:S
    ## slf_ssssmnt -0.971                            
    ## condtnSlctv -0.733  0.711                     
    ## conditnRctv -0.756  0.735  0.554              
    ## slf_ssssm:S  0.697 -0.717 -0.969 -0.527       
    ## slf_ssssm:R  0.682 -0.702 -0.499 -0.963  0.504
    ## optimizer (bobyqa) convergence code: 0 (OK)
    ## boundary (singular) fit: see help('isSingular')

### Comparing model fit

    ## Data: luke_granhag_2022_long
    ## Models:
    ## self_main_lg: info_disc ~ self_assessment + condition + (1 | crime_order/ID) + (1 | interviewer)
    ## self_int_lg: info_disc ~ self_assessment + condition + self_assessment * condition + (1 | crime_order/ID) + (1 | interviewer)
    ##              npar    AIC    BIC  logLik deviance Chisq Df Pr(>Chisq)    
    ## self_main_lg    8 3024.1 3062.4 -1504.0   3008.1                        
    ## self_int_lg    10 3013.1 3061.0 -1496.5   2993.1 15.05  2  0.0005395 ***
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

## Predicting perceived interviewer quality by disclosed details

In the current experiment we found that the relationship between
disclosed details and perceived interviewer quality was stronger
(positive) in the SoS-Reinforcement condition than the remaining
conditions. Luke and Granhag (2022) did not include a condition that’s
equivalent to SoS-Reinforcement, why can’t explicitly compare the
patterns over the two experiments. However, the Direct and Reactive
conditions in Luke and Granhag (2022) used the same style of questioning
as our Direct and SoS-Standard conditions. The relationship between the
variables should be similar in both conditions and weakly positive to be
consistent with the analyses from the current experiment. Instead, we
find significant differences between the conditions. In direct we
observe a slightly negative relationship between disclosing details and
interviewer perception. This relationship is reversed in Reactive.

We can only speculate to why we don’t observe the same patterns in both
experiments. It is possible that these results stem form the length of
the interviews were Luke & Granhag (2022) utilized procedures that
resulted in relatively brief interviews and the current experiment used
longer interviews.

Participants being interviewed with a style consistent to Direct might
have different experiences depending on the length of the interview. In
brief interviews, participant’s disclosing little, to no information
might have a relatively positive experiences as they are not confronted
with evidence, are asked a limited amount of questions and are quickly
let go. These participants might feel like they are easily “getting
away” with saying nothing without being pressed or challenges by the
interviewer. When interviewed for a longer time, participants will still
not be confronted with evidence, but they will be asked more questions
which may cause participants have a less positive experience when being
withholding as they might feel they are not easily “getting away” with
disclosing no information as the interviewer keeps asking questions.

### Main effect model

    ## boundary (singular) fit: see help('isSingular')

    ## Linear mixed model fit by maximum likelihood . t-tests use Satterthwaite's
    ##   method [lmerModLmerTest]
    ## Formula: info_disc ~ interviewer_qual + condition + (1 | crime_order/ID) +  
    ##     (1 | interviewer)
    ##    Data: luke_granhag_2022_long
    ## 
    ##      AIC      BIC   logLik deviance df.resid 
    ##   3041.7   3080.1  -1512.9   3025.7      886 
    ## 
    ## Scaled residuals: 
    ##     Min      1Q  Median      3Q     Max 
    ## -2.3371 -0.6722 -0.0725  0.5511  3.0764 
    ## 
    ## Random effects:
    ##  Groups         Name        Variance Std.Dev.
    ##  ID:crime_order (Intercept) 0.84294  0.9181  
    ##  crime_order    (Intercept) 0.00000  0.0000  
    ##  interviewer    (Intercept) 0.01193  0.1092  
    ##  Residual                   1.17561  1.0843  
    ## Number of obs: 894, groups:  
    ## ID:crime_order, 298; crime_order, 18; interviewer, 3
    ## 
    ## Fixed effects:
    ##                    Estimate Std. Error       df t value Pr(>|t|)   
    ## (Intercept)          0.2535     0.4062 230.5312   0.624  0.53313   
    ## interviewer_qual     0.2863     0.1065 293.0697   2.688  0.00759 **
    ## conditionSelective   0.3841     0.1579 295.2216   2.433  0.01557 * 
    ## conditionReactive    0.5118     0.1580 295.2715   3.239  0.00133 **
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## Correlation of Fixed Effects:
    ##             (Intr) intrv_ cndtnS
    ## intervwr_ql -0.949              
    ## condtnSlctv -0.255  0.064       
    ## conditnRctv -0.216  0.023  0.502
    ## optimizer (nloptwrap) convergence code: 0 (OK)
    ## boundary (singular) fit: see help('isSingular')

### Interaction effect model

    ## boundary (singular) fit: see help('isSingular')

    ## Linear mixed model fit by maximum likelihood . t-tests use Satterthwaite's
    ##   method [lmerModLmerTest]
    ## Formula: info_disc ~ interviewer_qual + condition + interviewer_qual *  
    ##     condition + (1 | crime_order/ID) + (1 | interviewer)
    ##    Data: luke_granhag_2022_long
    ## 
    ##      AIC      BIC   logLik deviance df.resid 
    ##   3031.5   3079.4  -1505.7   3011.5      884 
    ## 
    ## Scaled residuals: 
    ##      Min       1Q   Median       3Q      Max 
    ## -2.32265 -0.68456 -0.07155  0.59106  3.07653 
    ## 
    ## Random effects:
    ##  Groups         Name        Variance Std.Dev.
    ##  ID:crime_order (Intercept) 0.787304 0.88730 
    ##  crime_order    (Intercept) 0.000000 0.00000 
    ##  interviewer    (Intercept) 0.007748 0.08802 
    ##  Residual                   1.175614 1.08426 
    ## Number of obs: 894, groups:  
    ## ID:crime_order, 298; crime_order, 18; interviewer, 3
    ## 
    ## Fixed effects:
    ##                                     Estimate Std. Error       df t value
    ## (Intercept)                           2.3306     0.6683 282.3578   3.487
    ## interviewer_qual                     -0.2870     0.1813 293.1369  -1.583
    ## conditionSelective                   -2.5866     0.9063 297.8302  -2.854
    ## conditionReactive                    -2.6021     0.9461 297.9271  -2.750
    ## interviewer_qual:conditionSelective   0.8251     0.2491 297.8384   3.312
    ## interviewer_qual:conditionReactive    0.8606     0.2584 297.9013   3.330
    ##                                     Pr(>|t|)    
    ## (Intercept)                         0.000565 ***
    ## interviewer_qual                    0.114550    
    ## conditionSelective                  0.004619 ** 
    ## conditionReactive                   0.006316 ** 
    ## interviewer_qual:conditionSelective 0.001041 ** 
    ## interviewer_qual:conditionReactive  0.000977 ***
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## Correlation of Fixed Effects:
    ##             (Intr) intrv_ cndtnS cndtnR int_:S
    ## intervwr_ql -0.984                            
    ## condtnSlctv -0.734  0.726                     
    ## conditnRctv -0.697  0.688  0.515              
    ## intrvwr_q:S  0.716 -0.728 -0.985 -0.502       
    ## intrvwr_q:R  0.684 -0.694 -0.505 -0.987  0.506
    ## optimizer (nloptwrap) convergence code: 0 (OK)
    ## boundary (singular) fit: see help('isSingular')

### Comparing model fit

    ## Data: luke_granhag_2022_long
    ## Models:
    ## intr_main_lg: info_disc ~ interviewer_qual + condition + (1 | crime_order/ID) + (1 | interviewer)
    ## intr_int_lg: info_disc ~ interviewer_qual + condition + interviewer_qual * condition + (1 | crime_order/ID) + (1 | interviewer)
    ##              npar    AIC    BIC  logLik deviance  Chisq Df Pr(>Chisq)    
    ## intr_main_lg    8 3041.7 3080.1 -1512.9   3025.7                         
    ## intr_int_lg    10 3031.5 3079.4 -1505.8   3011.5 14.247  2  0.0008058 ***
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

## Predicting perceived interview qulity på disclosed details

In the current experiment we found no significant differences between
the relationship between disclosed details and interview quality for the
different conditions. Similar to interviewer quality, we observe
significant patterns in the Luke and Granhag (2022) data. Again, we can
only speculate but the different patterns in the different experiments
may stem from the varying lenghts of the interviews.

### Main effect model

    ## boundary (singular) fit: see help('isSingular')

    ## Linear mixed model fit by maximum likelihood . t-tests use Satterthwaite's
    ##   method [lmerModLmerTest]
    ## Formula: info_disc ~ interview_qual + condition + (1 | crime_order/ID) +  
    ##     (1 | interviewer)
    ##    Data: luke_granhag_2022_long
    ## 
    ##      AIC      BIC   logLik deviance df.resid 
    ##   3032.1   3070.4  -1508.1   3016.1      883 
    ## 
    ## Scaled residuals: 
    ##      Min       1Q   Median       3Q      Max 
    ## -2.40207 -0.67498 -0.08373  0.57518  3.06906 
    ## 
    ## Random effects:
    ##  Groups         Name        Variance Std.Dev.
    ##  ID:crime_order (Intercept) 0.845013 0.91925 
    ##  crime_order    (Intercept) 0.000000 0.00000 
    ##  interviewer    (Intercept) 0.001669 0.04086 
    ##  Residual                   1.178428 1.08555 
    ## Number of obs: 891, groups:  
    ## ID:crime_order, 297; crime_order, 18; interviewer, 3
    ## 
    ## Fixed effects:
    ##                     Estimate Std. Error        df t value Pr(>|t|)   
    ## (Intercept)          0.84636    0.33081 262.57718   2.558  0.01108 * 
    ## interview_qual       0.13520    0.09431 296.93524   1.434  0.15274   
    ## conditionSelective   0.32830    0.15886 294.40573   2.067  0.03965 * 
    ## conditionReactive    0.50734    0.15981 294.51886   3.175  0.00166 **
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## Correlation of Fixed Effects:
    ##             (Intr) intrv_ cndtnS
    ## interviw_ql -0.938              
    ## condtnSlctv -0.300  0.064       
    ## conditnRctv -0.374  0.144  0.507
    ## optimizer (nloptwrap) convergence code: 0 (OK)
    ## boundary (singular) fit: see help('isSingular')

### Interaction effect model

    ## boundary (singular) fit: see help('isSingular')

    ## Linear mixed model fit by maximum likelihood . t-tests use Satterthwaite's
    ##   method [lmerModLmerTest]
    ## Formula: info_disc ~ interview_qual + condition + interview_qual * condition +  
    ##     (1 | crime_order/ID) + (1 | interviewer)
    ##    Data: luke_granhag_2022_long
    ## 
    ##      AIC      BIC   logLik deviance df.resid 
    ##   3011.0   3058.9  -1495.5   2991.0      881 
    ## 
    ## Scaled residuals: 
    ##      Min       1Q   Median       3Q      Max 
    ## -2.47562 -0.67855 -0.09072  0.61689  3.14124 
    ## 
    ## Random effects:
    ##  Groups         Name        Variance Std.Dev.
    ##  ID:crime_order (Intercept) 0.746    0.8637  
    ##  crime_order    (Intercept) 0.000    0.0000  
    ##  interviewer    (Intercept) 0.000    0.0000  
    ##  Residual                   1.178    1.0856  
    ## Number of obs: 891, groups:  
    ## ID:crime_order, 297; crime_order, 18; interviewer, 3
    ## 
    ## Fixed effects:
    ##                                   Estimate Std. Error       df t value Pr(>|t|)
    ## (Intercept)                         2.8240     0.5033 296.9998   5.610 4.62e-08
    ## interview_qual                     -0.4664     0.1494 296.9998  -3.122 0.001975
    ## conditionSelective                 -2.4090     0.7264 296.9998  -3.316 0.001025
    ## conditionReactive                  -2.8385     0.7089 296.9998  -4.004 7.87e-05
    ## interview_qual:conditionSelective   0.8395     0.2197 296.9998   3.822 0.000161
    ## interview_qual:conditionReactive    1.0500     0.2190 296.9998   4.795 2.57e-06
    ##                                      
    ## (Intercept)                       ***
    ## interview_qual                    ** 
    ## conditionSelective                ** 
    ## conditionReactive                 ***
    ## interview_qual:conditionSelective ***
    ## interview_qual:conditionReactive  ***
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## Correlation of Fixed Effects:
    ##             (Intr) intrv_ cndtnS cndtnR int_:S
    ## interviw_ql -0.977                            
    ## condtnSlctv -0.693  0.677                     
    ## conditnRctv -0.710  0.694  0.492              
    ## intrvw_ql:S  0.664 -0.680 -0.978 -0.472       
    ## intrvw_ql:R  0.667 -0.682 -0.462 -0.976  0.464
    ## optimizer (nloptwrap) convergence code: 0 (OK)
    ## boundary (singular) fit: see help('isSingular')

### Comparing model fit

    ## Data: luke_granhag_2022_long
    ## Models:
    ## intq_main_lg: info_disc ~ interview_qual + condition + (1 | crime_order/ID) + (1 | interviewer)
    ## intq_int_lg: info_disc ~ interview_qual + condition + interview_qual * condition + (1 | crime_order/ID) + (1 | interviewer)
    ##              npar    AIC    BIC  logLik deviance  Chisq Df Pr(>Chisq)    
    ## intq_main_lg    8 3032.1 3070.4 -1508.0   3016.1                         
    ## intq_int_lg    10 3011.0 3058.9 -1495.5   2991.0 25.119  2  3.512e-06 ***
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
