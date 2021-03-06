% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/SYB_plot_region.R
\name{plot_region}
\alias{plot_region}
\title{Plot p-values in regional genomic context}
\usage{
plot_region(
  region,
  region_ext = 50000,
  title = NULL,
  data = list(),
  lines_pvalue_threshold = NULL,
  variant2highlight = "centered",
  EFFECT2highlight = c(green = "splice", red = "miss", red = "frame", red =
    "start|stop"),
  recombination.rate = NULL,
  biomaRt,
  hgnc.symbols.only = TRUE,
  LNCipedia = NULL,
  gene.color.coding = c(lightgreen = "pseudogene", brown = "snRNA", forestgreen =
    "ncRNA|antisense", orange = "miRNA", darkblue = "protein_coding"),
  numberOfRowsForGenePlotting = "auto",
  plot.protein.domains = NULL,
  cex.plot = 1.1,
  cex.legend = 1,
  gene.scale.factor = 2
)
}
\arguments{
\item{region}{Character with region of interest of form \code{chr1:20000-30000} or \code{chr1:20000}.}

\item{region_ext}{numeric with region size extension in bp to plot. Half of the extension is added 
to both sides of the given \code{region}.}

\item{title}{character with title to be used in plot.}

\item{data}{named list of dataframes containing p-vales to be plotted. Required columns of each 
data frame are \code{"CHR"}, \code{"POS"} and \code{"P"}.
An additionally column \code{"EFFECT"} with functional characterisation of the locus may be given optionally.}

\item{lines_pvalue_threshold}{named character with p-values to be plotted as threshold lines. 
Line color is given by vector names (e.g. \code{lines_pvalue_threshold = c(blue=0.05, red=0.01)}).}

\item{variant2highlight}{character vector with variants to be highlighted as filled symbols. For this, an additionally
column \code{ID} is required within \code{data}. If the vector contains color names or effect names, all according variants 
are also highlighted. Numbers \code{>=1} are interpreted as BP position to highlight while numbers \code{<1} are 
interpreted as p-value threshold with all SNPs highlighted with \code{p < threshold}.
If \code{variant2highlight = "centered"}, the centered SNP is highlighted if available 
(applicable if \code{region} is of form \code{"chr1:20000"}). 
Vertical lines are added for the highlighted SNPs. Omitted if \code{NULL}.}

\item{EFFECT2highlight}{named character vector with regular expressions (name = color, value = regexp) 
in order of priority low to high. Regular expressions is case insensitive.
If an \code{EFFECT} column with functional annotation is given within a dataset, variants with functional annotation 
corresponding to these expressions are highlighted by colors given as vector names.
If no \code{EFFECT} column is given, exonic SNPs can be highlighted according to overlapping gene exons.
For this, an \code{EFFECT} column is created if not yet existing and \code{exonic} as well as the respective 
gene biotype is appended to the entries of the \code{EFFECT} column for exonic SNPs.}

\item{recombination.rate}{character with path to file or to folder containing recombination rates to be plotted. 
Alternatively, a dataframe object can be supplied. Omitted if \code{NULL}.}

\item{biomaRt}{biomaRt object to be used for gene annotation. If \code{NULL}, biomaRt annotation is skipped.}

\item{hgnc.symbols.only}{logical. If \code{TRUE}, only Ensemble genes plotted with annotated HGNC Symbol. 
If \code{FALSE}, non-annotated genes in the plot are labeled with Ensembl gene id if available.}

\item{LNCipedia}{character with path to LNCipedia bed file to plot lncRNA genes. Omitted if \code{NULL}.}

\item{gene.color.coding}{named character vector with regular expressions for gene biotype color coding
(name = color, value = regexp) in order of priority low to high, i.e. if multiple biotypes available per gene, 
the last biotype in the vector is used. Regular expressions are case insensitive. 
\code{gray = "other"} is appended to the vector for all remaining biotypes not found by the reg exp.}

\item{numberOfRowsForGenePlotting}{numeric number of rows used for plotting genes. If \code{"auto"}, function determines
appropriate number of rows itself.}

\item{plot.protein.domains}{named character vector with file path to protein domain annotation data for a selected gene (Omitted if \code{NULL}). 
Vector names are used as gene name of the selected gene (e.g. \code{GeneXY = "filepath_to_protein_data_of_GeneXY"}).
Domains are plotted as symbols below the respective gene. The protein length is scaled to length of the plotted gene.
Domain positions and width are scaled accordingly. Arrows indicate the respective genomic start and stop positions for each domain. 
The respective txt-file may be generated by the function \code{makeDomainsFromExons} and contains the following columns:
\itemize{
  \item BP_start: genomic start position for corresponding protein domain AA position.
  \item BP_end: genomic end position for corresponding protein domain AA position.
  \item feature_length: domain/feature length in AA. Used for domain scaling in the plot.
  \item protein_length: total protein length in AA. Used for domain scaling in the plot.
  \item domain_name_plot: domain/feature name to be plotted.
  \item symbol_plot (optional): Shape to be used for plotting (either \code{"ellipse"}, \code{"rectangle"} or \code{"circle"}). 
  Default is \code{"ellipse"}.
  \item domain_height_extension (optional): height factor for symbol height. These factors are scaled respective to each other. Default is \code{1}.
  \item domain_color (optional): color for domain symbol and name to be plotted. Default is \code{"black"}.
  \item label_pos (optional): label position in the domain plot may be adjusted in case of overlapping labels 
  (Values of 1, 2, 3 and 4 indicate positions below, left, above and right of the domain center coordinates). Default is \code{3}.
  \item assignArrows2Gene (optional): Indicate if arrows shall be plotted from genomic coordinates to protein domain (default is \code{TRUE}).
  May be set to \code{FALSE} for very short features within other domains, e.g. "active site". 
  }}

\item{cex.plot}{numeric character extension plot axes.}

\item{cex.legend}{numeric character extension plot legends.}

\item{gene.scale.factor}{numeric extension factor used for gene and exon plotting.}
}
\value{
no value returned. Figure is plotted in the current graphics device.
}
\description{
\code{plot_region} reads p-value data e.g. from association analysis and prepares a regional plot of a given chromosomal region of interest.
}
\details{
Up to 5 dataframes can be committed in \code{data} and are plotted in one diagram. 
If functional information for variants is available, respective variants which fulfill the 
regular expression in \code{EFFECT2highlight} are highlighted by color. Additionally, variants 
given in \code{variant2highlight} are highlighted by filled symbols, text annotation and vertical lines 
(e.g. for the leading SNP of interest).
If given, recombination rates for that region are added to the plot using a separate y-axis.
Gene information for the specified region is downloaded from biomaRt and/or LNCipedia and is plotted 
beneath the diagram. Genes can be selected to include corresponding protein domain data for plotting. 
Modified graphical parameters are resetted at the end of the function. 
Nevertheless, this function can not be used \code{par(mfrow())} for multiple plots.
}
\author{
Frank Ruehle
}
