#' Processing of expression data
#' 
#' Normalisation, transformation and/or probe quality filtering of expression data.
#' 
#'  
#' Expression data is normalised and/or transformed by algorithms dedicated in 'method_norm' and/or 'transform'.
#' If a column \code{PROBEQUALITY} is available within the feature data as for Illumina expression arrays, 
#' probes assigned a `Bad' or `No match' quality score after normalisiation are removed from the dataset.
#' Lastly, if the input object is of class \code{ExpressionSetIllumina}, it is changed to \code{ExpressionSet}
#' to avoid later incompabilities with the 'limma'-package. 
#' 
#' 
#' @param eset ExpressionSet or ExpressionSetIllumina 
#' @param method_norm character with normalisation method. Options are "quantile", "qspline", "vsn", "rankInvariant", "median" and "none"
#' @param transform character with data transformation method. Options are "none", "log2", "neqc", "rsn" and "vst".
#' 
#' @return processed ExpressionSet object
#' 
#' @author Frank Ruehle
#' 
#' @export 




 
  process_eset <- function(eset, 
                         method_norm="quantile", 
                         transform="none"     
                         )  {


  
    # load required libraries
    pkg.cran <- NULL
    pkg.bioc <- c("beadarray", "Biobase") # pkg.bioc not detached afterwards
    pks2detach <- attach_package(pkg.cran=pkg.cran, pkg.bioc=pkg.bioc)
    

########### Normalisation  options are "quantile", "qspline", "vsn", "rankInvariant", "median" and "none"
cat("normalising (", method_norm, ") and/or transforming (", transform, ") expression data.\n")
eset <- normaliseIllumina(eset, method=method_norm, transform=transform)





########## Filtering non-responding probes. 
# Filtering non-responding probes from further analysis can improve the power to detect differential expression. 
# One way of achieving this is to remove probes whose probe sequence has undesirable properties.
# Four basic annotation quality categories (`Perfect', `Good', `Bad' and `No match') are
# defined and have been shown to correlate with expression level and measures of differential expression.
# (imported from array annotation package).
# We recommend removing probes assigned a `Bad' or `No match' quality score 
# after normalization. This approach is similar to the common practice of removing lowly-expressed probes, 
# but with the additional benefit of discarding probes with a high expression level caused by non-specific hybridization.

if("Status" %in% colnames(fData(eset))) { # define regular probes if control probes still present in expression set
  ids_regular <- featureNames(eset[which(fData(eset)[,"Status"] == "regular"),]) # feature names der "regular" probes
  } else {ids_regular <- 1:nrow(fData(eset))}

if("PROBEQUALITY" %in% colnames(fData(eset))) {
   annoenvir <- paste("illumina", annotation(eset), "PROBEQUALITY", sep="")
    qual <- unlist(mget(ids_regular, get(annoenvir), ifnotfound=NA))   # Chip type is specified in annotation(eset)
    rem <- qual == "No match" | qual == "Bad" | is.na(qual)
    cat("\nRemove", sum(rem), "of", length(rem), "probes with bad quality (column PROBEQUALITY required in feature data).\n")
    print(table(qual))
    eset <- eset[!rem,]  
    # Row indexing of an ExpressionSet or ExpressionSetIllumina object addresses regular probes only, 
    # i.e. no quality control probes which are also contained in the feature list of the ExpressionSet.
}

# Change object class from 'ExpressionSetIllumina' to 'ExpressionSet' 
if(class(eset)!="ExpressionSet") {
  helpset <- eset
  eset <- ExpressionSet(assayData = exprs(helpset),
                                      phenoData = phenoData(helpset), 
                                      experimentData = experimentData(helpset),
                                      annotation = annotation(helpset))
    fData(eset) <- fData(helpset)
  } 

    
# # Detaching libraries not needed any more
#  detach_package(unique(pks2detach))
    
    
# return ExpressionSet
return(eset)

}





