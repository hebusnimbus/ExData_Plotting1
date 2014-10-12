# ==============================================================================
# CONFIGURATION
# ==============================================================================

# ----------  Libraries  ----------

library(sqldf)


# ----------  Constants & variables  ----------

# Data directory resides in this script's directory
dir.data      <- file.path(dirname(sys.frame(1)$ofile), 'data')

data.url      <- 'https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip'

data.name.zip <- 'exdata-data-household_power_consumption.zip'
data.name.txt <- 'household_power_consumption.txt'

data.path.zip <- file.path(dir.data, data.name.zip)
data.path.txt <- file.path(dir.data, data.name.txt)


# ==============================================================================
# UTILITY FUNCTIONS
# ==============================================================================

# ---------------------------------------------------------------------------- #
# Utility function to emulate similar printing functionlity as found in other  #
# languages such as Java or C++.                                               #
# ---------------------------------------------------------------------------- #

printf <- function(...) cat(sprintf(...))


# ==============================================================================
# DOWNLOAD DATA
# ==============================================================================

# ---------------------------------------------------------------------------- #
# The data for the assignment is available online at a specified URL and comes #
# in the form of a 'semi-colon separated values' file, compressed inside a ZIP #
# file.                                                                        #
#                                                                              #
# This function downloads the file from the Internet, and extracts its content #
# in the current directory.  The two files (original ZIP file & uncompressed   #
# TXT file) are "cached" on disk, so the next calls to this function will not  #
# have any effects (the download and extraction will be skipped).              #
#                                                                              #
#                                                                              #
# The data could have been loaded into R directly from the zip file, without   #
# the need to uncompress it.  Something like this:                             #
#                                                                              #
#   connection <- unz(data.path.zip, data.name.txt)                            #
#   data <- read.table(connection)                                             #
#   close(connection)                                                          #
#                                                                              #
# However, because only a subset of the data is needed for this assignment, it #
# is better and more memory efficient to:                                      #
#   - first uncompress the raw text file on disk                               #
#   - then to load a subset of the data into R with the sqldf package          #
#                                                                              #
#                                                                              #
# INPUT:                                                                       #
#   - no input                                                                 #
#                                                                              #
# OUTPUT:                                                                      #
#   - no output                                                                #
# ---------------------------------------------------------------------------- #

download_data <- function() {
    # ----------  Check data directory  ----------

    if ( ! file.exists(dir.data) ) {
        dir.create(dir.data, recursive = TRUE)
    }


    # ----------  Check if raw text data was extracted  ----------

    if ( ! file.exists(data.path.txt) ) {


        # ----------  Check if zipped data was downloaded  ----------

        if ( ! file.exists(data.path.zip) ) {


            # ----------  Download data  ----------

            download.file(
                url      = data.url,
                destfile = data.path.zip,
                method   = 'curl'
            )
        }


        # ----------  Unzip raw text data  ----------

        unzip(
            zipfile = data.path.zip,
            files   = c(data.name.txt),
            exdir   = dir.data
        )
    }

    printf("Data file size: : %d bytes\n", file.info(data.path.zip)$size)
}



# ==============================================================================
# LOAD DATA
# ==============================================================================

# ---------------------------------------------------------------------------- #
# This function loads the data for this assignment into R.  Only a subset is   #
# actually loaded - days 2007-02-01 and 2007-02-02.                            #
#                                                                              #
# Some transformations are applied to the data:                                #
#   - the "Date" column is converted to a Date object                          #
#   - an extra "Timestamp" column is added, which is a combination of both the #
#     "Date" and "Time" columns                                                #
#                                                                              #
# INPUT:                                                                       #
#   - no input                                                                 #
#                                                                              #
# OUTPUT:                                                                      #
#   - a data frame with an additional "Timestamp" column                       #
#                                                                              #
# ---------------------------------------------------------------------------- #

load_data <- function() {
    # ----------  Download data  ----------

    download_data()


    # ----------  Load only the dates of interest  ----------

    data <- read.csv.sql(
        file = data.path.txt,
        sql  = "select * from file where Date = '1/2/2007' or Date = '2/2/2007'",
        sep  = ';'
    )


    # ----------  Convert date column  ----------

    data["Timestamp"] <- mapply(
        function(d,t) paste(d, t),
        data$Date,
        data$Time
    )

    data["Timestamp"] <- lapply(
        data["Timestamp"],
        function(x) strptime(x, "%d/%m/%Y %H:%M:%S")
    )


    # ----------  Convert date column  ----------

    data["Date"] <- lapply(
        data["Date"],
        function(x) as.Date(x, "%d/%m/%Y")
    )


    # ----------  Return data frame  ----------

    return(data)
}


# ==============================================================================
# SUMMARIZE DATA
# ==============================================================================

# ---------------------------------------------------------------------------- #
# This function prints a small summary about the data.                         #
#                                                                              #
# This was not required by the assigment, but it is useful to visually check   #
# if there are any invalid values ('?') in the data.                           #
#                                                                              #
# INPUT:                                                                       #
#   - the data frame for the assignment                                        #
#                                                                              #
# OUTPUT:                                                                      #
#   - no input                                                                 #
#                                                                              #
# ---------------------------------------------------------------------------- #

summarize_data <- function(data) {
    # ----------  Print summary about invalid values ('?')  ----------

    columnNames <- names(data)
    columnNames <- columnNames[(columnNames != "Date") & (columnNames != "Time")]

    # Displays the # of invalid values in each column
    for (name in columnNames) {
        printf(
            "# of invalid values in column '%s': %d\n",
            name,
            sum(data[[name]] == '?')
        )
    }

    # Another way to check for invalid values is to look at the class of the
    # columns ('factor' for invalid values, 'numeric' otherwise)
    for (name in columnNames) {
        printf(
            "class of column '%s': %s\n",
            name,
            class(data[[name]])
        )
    }


    # ----------  Print small data summary  ----------

    printf(
        "Loaded data: rows=%d, columns=%d, size=%d bytes\n",
        dim(data)[1],
        dim(data)[2],
        object.size(data)
    )

    print(summary(data))
}


# ===============================================================================
