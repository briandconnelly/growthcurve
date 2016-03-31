# growthcurve 0.1.3

- Added kvr data set
- Removed include_grofit option. May come back in the future in ... when there are non-grofit options.
- Model parameters are now under 'parameters' key in gcfit objects


# growthcurve 0.1.2

- Some cleanup in the gcfit objects to add separation from grofit
    - Updated in plot.gcfit
- Updated pseudomonas data set making Replicate a factor
- Suppressing noisy print statements from grofit
- Changed behavior of as.data.frame to return a df of fit info

# growthcurve 0.1.1

- Added fit_growth() wrapper function
- Added stat_growthcurve() for ggplot2
    - ggplot2 is now in Suggests

# growthcurve 0.1.0

Initial release
