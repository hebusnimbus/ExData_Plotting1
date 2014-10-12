# ===============================================================================
# CONFIGURATION
# ===============================================================================

# ----------  Source download script  ----------

script.dir <- dirname(sys.frame(1)$ofile)

source(file.path(script.dir, "download.R"))


# ----------  Constants & variables  ----------

data.path.png <- file.path(dir.data, "plot3.png")



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
