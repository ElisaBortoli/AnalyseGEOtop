\name{GEOtop_ReadPointData_Generalized}
\alias{GEOtop_ReadPointData_Generalized}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
Read  point output from GEOtop simulation
}
\description{
Read  point output from GEOtop simulation using the \pkg{geotopbricks} package.
}
\usage{
GEOtop_ReadPointData_Generalized(path,soil_info, soil_files,soil_output_files,snow_info, save_rData)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{path}{
  path pointing to simulation folder
  }
  \item{soil_info}{
  boolean, TRUE: soil files are considered and imported
  }
  \item{soil_files}{
  boolean, TRUE: soil files are provided as GEOtop input. FALSE: soil is parameterized in the geotop.inpts file
  }
  \item{soil_output_files}{
  character vector, list of soil outptut keywords. 
  Default: c("SoilLiqContentProfileFile","SoilIceContentProfileFile", "SoilLiqWaterPressProfileFile", "SoilAveragedTempProfileFile")
  }
  \item{snow_info}{
  boolean, TRUE: snow files are considered and imported
  }
  \item{save_rData}{
  boolean, TRUE: the file  PointOut.RData containing point output variables  Stored in GEOtop simulation folder, defined by the arguments \emph{path} and \emph{model_run}

}
\details{
%%  ~~ If necessary, more details than the description above ~~
}
\value{
list of zoo \emph{out}, containing point output variables.
}
\references{
Endrizzi, S., Gruber, S., Amico, M. D., & Rigon, R. (2014). \strong{GEOtop 2.0 : simulating the combined energy and water balance at and below the land surface accounting for soil freezing , snow cover and terrain effects.} \emph{Geosci. Model Dev., 7, 2831-2857}. doi:10.5194/gmd-7-2831-2014
}
\author{
Johannes Brenner, Giacomo  Bertoldi \email{giacomo.bertoldi@eurac.edu}
}
\note{
still to be finished for snow files
}

%% ~Make other sections like Warning with \section{Warning }{....} ~

\seealso{
%% ~~objects to See Also as \code{\link{help}}, ~~~
}
\examples{
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ~kwd1 }
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
