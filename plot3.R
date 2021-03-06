# ===============================================================================
# CONFIGURATION
# ===============================================================================

# ----------  Source download script  ----------

# The R code to download the data is common to all the "plotX.R" files.  Rather
# than duplicating it in each file (which would be cumbersome to maintain or to
# improve for example), it has been extracted into a separate file "download.R".
#
# The call to source(...) below loads the functions defined in this file, and
# the data is actually downloaded from the Internet and loaded into R with the
# call to load_data() later on.

script.dir <- dirname(sys.frame(1)$ofile)

source(file.path(script.dir, 'download.R'))


# ----------  Constants & variables  ----------

data.path.png <- file.path(dir.data, 'plot3.png')



# ===============================================================================
# MAIN
# ===============================================================================

# ----------  Load data  ----------

data <- load_data()

# Not part of the assignment
# summarize_data(data)


# ----------  Create plot  ----------

par(cex=.75)

yrange <- range(c(
    data$Sub_metering_1,
    data$Sub_metering_2,
    data$Sub_metering_3
))

par(new=F); plot(data$Timestamp, data$Sub_metering_1, ylim=yrange, type='l', xlab='', ylab='', col='black')
par(new=T); plot(data$Timestamp, data$Sub_metering_2, ylim=yrange, type='l', xlab='', ylab='', col='red')
par(new=T); plot(data$Timestamp, data$Sub_metering_3, ylim=yrange, type='l', xlab='', ylab='', col='blue')
par(new=F)

title(ylab='Energy sub metering')

legend(
    x      = 'topright',
    lwd    = 2,
    col    = c('black', 'red', 'blue'),
    legend = c('Sub_metering_1', 'Sub_metering_2', 'Sub_metering_3')
)


# ----------  Create PNG  ----------

dev.copy(png, file=data.path.png)
dev.off()


# ===============================================================================
