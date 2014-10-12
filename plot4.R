# ===============================================================================
# CONFIGURATION
# ===============================================================================

# ----------  Source download script  ----------

script.dir <- dirname(sys.frame(1)$ofile)

source(file.path(script.dir, "download.R"))


# ----------  Constants & variables  ----------

data.path.png <- file.path(dir.data, "plot4.png")



# ===============================================================================
# MAIN
# ===============================================================================

# ----------  Load data  ----------

data <- load_data()

# Not part of the assignment
# summarize_data(data)


# ----------  Create plot  ----------

# Global options
par(cex=.5)
par(mfrow = c(2, 2))

# 1st plot
plot(
    x    = data$Timestamp,
    y    = data$Global_active_power,
    type = 'l',
    xlab = '',
    ylab = 'Global Active Power'
)

# 2nd plot
plot(
    x    = data$Timestamp,
    y    = data$Voltage,
    type = 'l',
    xlab = 'datetime',
    ylab = 'Voltage'
)

# 3rd plot
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
    bty    = 'n',
    cex    = 0.5,
    pt.cex = 1,
    col    = c('black', 'red', 'blue'),
    legend = c('Sub_metering_1', 'Sub_metering_2', 'Sub_metering_3')
)

# 4th plot
plot(
    x    = data$Timestamp,
    y    = data$Global_reactive_power,
    type = 'l',
    xlab = 'datetime',
    ylab = 'Global_reactive_power'
)


# ----------  Create PNG  ----------

dev.copy(png, file=data.path.png)
dev.off()


# ===============================================================================
