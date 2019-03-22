
======
# AnalyseGEOtop
R package for GEOtop simulation analysis including functionality for
* creating GEOtop input maps for a specific basin (using SAGA GIS library - RSAGA)
* read single / multiple point output from GEOtop simulation
* GEOtop output map animation (using ImageMagick)
* diagnostic plots on hydrological budget in GEOtop 3d simulation
* visualisation of Soil Water Retention Curve (van Genuchten model)

This package is based on the R package [geotopbricks](https://github.com/ecor/geotopbricks)

# How to start

First install the package with:

```
$ R
> install.packages("devtools")
> library(devtools)
> install_github("EURAC-Ecohydro/AnalyseGEOtop")
```

and then import the library with:

```
> library(AnalyseGeotop)
```
