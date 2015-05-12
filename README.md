growthcurve
===========

growthcurve is an [R](http://r-project.org) package for analyzing
biological growth curves. It is designed to integrate into modern
workflows, allowing it to be used in conjunction with powerful tools
like [dplyr](http://cran.r-project.org/web/packages/dplyr/index.html)
and
[magrittr](http://cran.r-project.org/web/packages/magrittr/index.html).

This package is currently a wrapper for the powerful
[grofit](http://cran.r-project.org/web/packages/grofit/index.html)
package, which is no longer being developed. This is temporary, as I
plan to eventually make growthcurve an independent tool with more
flexibility.

Installation
------------

`growthcurve` is not quite ready to be available on
[CRAN](http://cran.r-project.org), but you can use
[devtools](http://cran.r-project.org/web/packages/devtools/index.html)
to install the current development version:

    if(!require('devtools')) install.packages('devtools')
    devtools::install_github('briandconnelly/growthcurve')

Examples
--------

### Fit a logistic growth curve

First, let's create some sample data containing some time points in the
*Time* column and some corresponding growth measurements in the *OD600*
column:

    sampledata <- data.frame(Time=1:30, OD600=1/(1+exp(0.5*(15-1:30)))+rnorm(30)/20)

Now, let's fit a logistic growth curve for this data set:

    library(growthcurve)

    lfit <- fit_growth_logistic(sampledata, Time, OD600)

Information about the logistic fit is available in `parameters`:

    lfit$parameters

    ## $A
    ##   Estimate Std. Error 
    ##  0.9645620  0.0151592 
    ## 
    ## $mu
    ##   Estimate Std. Error 
    ## 0.15421865 0.01359186 
    ## 
    ## $lambda
    ##   Estimate Std. Error 
    ## 11.6677049  0.3106475 
    ## 
    ## $integral
    ## [1] 14.66587

For this fit, the maximum growth value is 0.99848023
(`lfit$parameters$A`), the maximum growth rate (the slope) is
0.127109284 (`lfit$parameters$mu`), the lag phase ends approximately
time 10.9985254 (`lfit$parameters$lambda`), and the area under the
growth curve is about 15 (`lfit$parameters$integral`). The units for
these results depend on the units in the input data.

We can also plot the results:

    plot(lfit)

![](figures/plot_example_logistic-1.png)

If we'd like to take a look at how well the fitted curve matches the
data, we can plot its residuals:

    lfit.res <- residuals(lfit)
    plot(x=lfit$raw.time, y=lfit.res, xlab='Time', ylab='Residuals')
    abline(h=0)

![](figures/resid_example_logistic-1.png)

Feature Requests and Bug Reports
--------------------------------

For all feature requests and bug reports, visit [growthcurve on
GitHub](https://github.com/briandconnelly/growthcurve/issues).

Related Links
-------------

-   [grofit](http://cran.r-project.org/web/packages/grofit/index.html)

License
-------

growthcurve is released under the Simplified BSD License.
