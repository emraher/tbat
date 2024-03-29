% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/tables_financial.R
\name{tables_financial}
\alias{tables_financial}
\title{Get financial tables data from TBB}
\usage{
tables_financial(bank_code, periods = NULL)
}
\arguments{
\item{bank_code}{Bank codes from banks_financial()}

\item{periods}{Period codes from periods_financial()}
}
\value{
A tibble
}
\description{
Get financial tables data from TBB
}
\examples{

\dontrun{
dt <- tables_financial()
}

}
