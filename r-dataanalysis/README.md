r-dataanalysis
======

http://www.openintro.org/stat/textbook.php
======

The three most important parameters
· If X is a random variable, the mean of that random variable is written E[X] 
- Stands for expected value
- Measures the "center" of a distribution

· The variance of that random variable is written Var[X] 
- Measures how "spreadout" a distribution is
- Measurement is in (units of X)2

· The standard deviation is written SD[X] = √ ̅V ̅a ̅r ̅[ ̅X ̅ ̅]
- Also measures how "spreadout" a distribution is 
- Measurement is in units of X

http://en.wikipedia.org/wiki/Law_of_total_variance

http://en.wikipedia.org/wiki/Law_of_total_expectation

http://en.wikipedia.org/wiki/Poisson_distribution

Style Guides
· http://4dpiecharts.com/r-code-style-guide/
· http://google-styleguide.googlecode.com/svn/trunk/google-r-style.html 
· http://wiki.fhcrc.org/bioc/Coding_Standards

More on distributions in R
http://cran.r-project.org/web/views/Distributions.html

Simulation in R
http://www.youtube.com/watch?v=tvv4IA8PEzw&list=PLjTlxb-wKvXOzI2h0F2_rYZHIXz8GWBop&index=6

Types of Data Analysis Questions
====
· Descriptive 
· Exploratory 
· Inferential
· Predictive
· Causal
· Mechanistic

Important simulation functions
====
Distributions
· rbeta, rbinom, rcauchy, rchisq, rexp, rf, rgamma, rgeom, rhyper, rlogis, rlnorm, rnbinom, rnorm,
rpois, rt, runif, rweibull

Densities
· dbeta,dbinom, dcauchy, dchisq, dexp, df, dgamma, dgeom, dhyper, dlogis, dlnorm, dnbinom,
dnorm, dpois, dt, dunif, dweibull

Sampling
· sample(,replace=TRUE),sample(replace=FALSE)
