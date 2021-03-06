% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/NMEEFSD.R
\name{NMEEF_SD}
\alias{NMEEF_SD}
\title{Non-dominated Multi-objective Evolutionary algorithm for Extracting Fuzzy rules in Subgroup Discovery (NMEEF-SD)}
\usage{
NMEEF_SD(paramFile = NULL, training = NULL, test = NULL,
  output = c("optionsFile.txt", "rulesFile.txt", "testQM.txt"), seed = 0,
  nLabels = 3, nEval = 10000, popLength = 100, mutProb = 0.1,
  crossProb = 0.6, Obj1 = "CSUP", Obj2 = "CCNF", Obj3 = "null",
  minCnf = 0.6, reInitCoverage = "yes", porcCob = 0.5,
  StrictDominance = "yes", targetVariable = NA, targetClass = "null")
}
\arguments{
\item{paramFile}{The path of the parameters file. \code{NULL} If you want to use training and test \code{SDEFSR_Dataset} variables}

\item{training}{A \code{SDEFSR_Dataset} class variable with training data.}

\item{test}{A \code{SDEFSR_Dataset} class variable with training data.}

\item{output}{character vector with the paths of where store information file, rules file and test quality measures file, respectively.}

\item{seed}{An integer to set the seed used for generate random numbers.}

\item{nLabels}{Number of linguistic labels for numerical variables.}

\item{nEval}{An integer for set the maximum number of evaluations in the evolutive process.}

\item{popLength}{An integer to set the number of individuals in the population.}

\item{mutProb}{Sets the mutation probability. A number in [0,1].}

\item{crossProb}{Sets the crossover probability. A number in [0,1].}

\item{Obj1}{Sets the Objective number 1. See \code{Objective values} for more information about the possible values.}

\item{Obj2}{Sets the Objective number 2. See \code{Objective values} for more information about the possible values.}

\item{Obj3}{Sets the Objective number 3. See \code{Objective values} for more information about the possible values.}

\item{minCnf}{Sets the minimum confidence that must have a rule in the Pareto front for being returned. A number in [0,1].}

\item{reInitCoverage}{Sets if the algorithm must perform the reinitialitation based on coverage when it is needed. A string with "yes" or "no".}

\item{porcCob}{Sets the maximum percentage of variables that participate in the rules genereted in the reinitialitation based on coverage. A number in [0,1]}

\item{StrictDominance}{Sets if the comparison between individuals must be done by strict dominance or not. A string with "yes" or "no".}

\item{targetVariable}{The name or index position of the target variable (or class). It must be a categorical one.}

\item{targetClass}{A string specifing the value the target variable. \code{null} for search for all possible values.}
}
\value{
The algorithm shows in the console the following results:
\enumerate{
 \item The parameters used in the algorithm
 \item The rules generated.
 \item The quality measures for test of every rule and the global results.

    Also, the algorithms save those results in the files specified in the \code{output} parameter of the algorithm or 
    in the \code{outputData} parameter in the parameters file.
}
}
\description{
Perfoms a subgroup discovery task executing the algorithm NMEEF-SD
}
\details{
This function sets as target variable the last one that appear in \code{SDEFSR_Dataset} object. If you want 
    to change the target variable, you can set the \code{targetVariable} to change this target variable.
    The target variable MUST be categorical, if it is not, throws an error. Also, the default behaviour is to find
    rules for all possible values of the target varaible. \code{targetClass} sets a value of the target variable where the
    algorithm only finds rules about this value.
    
    If you specify in \code{paramFile} something distinct to \code{NULL} the rest of the parameters are
    ignored and the algorithm tries to read the file specified. See "Parameters file structure" below 
    if you want to use a parameters file.
}
\section{How does this algorithm work?}{

    NMEEF-SD is a multiobjetctive genetic algorithm based on a NSGA-II approach. The algorithm
    first makes a selection based on binary tournament and save the individuals in a offspring population.
    Then, NMEEF-SD apply the genetic operators over individuals in offspring population
    
    For generate the population which participate in the next iteration of the evoluationary process
    NMEEF-SD calculate the dominance among all individuals (join main population and offspring) and then, apply the NSGA-II fast sort algorithm to order
    the population by fronts of dominance, the first front is the non-dominanted front (or Pareto), the second is 
    where the individuals dominated by one individual are, the thirt front dominated by two and so on.
    
    To promove diversity NMEEF-SD has a mechanism of reinitialization of the population based on coverage
    if the Pareto doesnt evolve during a 5%% of the total of evaluations.
    
    At the final of the evolutionary process, the algorithm returns only the individuals in the Pareto front
    which has a confidence greater than a minimum confidence level.
}

\section{Parameters file structure}{

  The \code{paramFile} argument points to a file which has the necesary parameters for NMEEF-SD works.
  This file \strong{must} be, at least, those parameters (separated by a carriage return):
  \itemize{
    \item \code{algorithm}  Specify the algorithm to execute. In this case. "NMEEFSD"
    \item \code{inputData}  Specify two paths of KEEL files for training and test. In case of specify only the name of the file, the path will be the working directory.
    \item \code{seed}  Sets the seed for the random number generator
    \item \code{nLabels}  Sets the number of fuzzy labels to create when reading the files
    \item \code{nEval}  Set the maximun number of \strong{evaluations of rules} for stop the genetic process
    \item \code{popLength}  Sets number of individuals of the main population
    \item \code{ReInitCob}  Sets if NMEEF-SD do the reinitialization based on coverage. Values: "yes" or "no"  
    \item \code{crossProb}  Crossover probability of the genetic algorithm. Value in [0,1]
    \item \code{mutProb}  Mutation probability of the genetic algorithm. Value in [0,1]
    \item \code{RulesRep}  Representation of each chromosome of the population. "can" for canonical representation. "dnf" for DNF representation.
    \item \code{porcCob}  Sets the maximum percentage of variables participe in a rule when doing the reinitialization based on coverage. Value in [0,1]
    \item \code{Obj1} Sets the objective number 1. 
    \item \code{Obj2} Sets the objective number 2. 
    \item \code{Obj3} Sets the objective number 3. 
    \item \code{minCnf} Minimum confidence for returning a rule of the Pareto. Value in [0,1] 
    \item \code{StrictDominance} Sets if the comparison of individuals when calculating dominance must be using strict dominance or not. Values: "yes" or "no"
    \item \code{targetClass}  Value of the target variable to search for subgroups. The target variable \strong{is always the last variable.}. Use \code{null} to search for every value of the target variable
  }
  
  An example of parameter file could be:
 \preformatted{
algorithm = NMEEFSD
inputData = "irisd-10-1tra.dat" "irisd-10-1tra.dat" "irisD-10-1tst.dat"
outputData = "irisD-10-1-INFO.txt" "irisD-10-1-Rules.txt" "irisD-10-1-TestMeasures.txt"
seed = 1
RulesRep = can
nLabels = 3
nEval = 500
popLength = 51
crossProb = 0.6
mutProb = 0.1
ReInitCob = yes
porcCob = 0.5
Obj1 = comp
Obj2 = unus
Obj3 = null
minCnf = 0.6
StrictDominance = yes
targetClass = Iris-setosa
}
}

\section{Objective values}{

     You can use the following quality measures in the ObjX value of the parameter file using this values:
      \itemize{
        \item Unusualness -> \code{unus}
        \item Crisp Support -> \code{csup}
        \item Crisp Confidence -> \code{ccnf}
        \item Fuzzy Support -> \code{fsup}
        \item Fuzzy Confidence -> \code{fcnf}
        \item Coverage -> \code{cove}
        \item Significance -> \code{sign}
      }
    
    If you dont want to use a objetive value you must specify \code{null}
}
\examples{
 
   NMEEF_SD(paramFile = NULL, 
               training = habermanTra, 
               test = habermanTst, 
               output = c("optionsFile.txt", "rulesFile.txt", "testQM.txt"),
               seed = 0, 
               nLabels = 3,
               nEval = 300, 
               popLength = 100, 
               mutProb = 0.1,
               crossProb = 0.6,
               Obj1 = "CSUP",
               Obj2 = "CCNF",
               Obj3 = "null",
               minCnf = 0.6,
               reInitCoverage = "yes",
               porcCob = 0.5,
               StrictDominance = "yes",
               targetClass = "positive"
               )  
\dontrun{
      NMEEF_SD(paramFile = NULL, 
               training = habermanTra, 
               test = habermanTst, 
               output = c("optionsFile.txt", "rulesFile.txt", "testQM.txt"),
               seed = 0, 
               nLabels = 3,
               nEval = 300, 
               popLength = 100, 
               mutProb = 0.1,
               crossProb = 0.6,
               Obj1 = "CSUP",
               Obj2 = "CCNF",
               Obj3 = "null",
               minCnf = 0.6,
               reInitCoverage = "yes",
               porcCob = 0.5,
               StrictDominance = "yes",
               targetClass = "null"
               )
     }
}
\references{
Carmona, C., Gonzalez, P., del Jesus, M., & Herrera, F. (2010). NMEEF-SD: Non-dominated Multi-objective Evolutionary algorithm for Extracting Fuzzy rules in Subgroup Discovery.
}

