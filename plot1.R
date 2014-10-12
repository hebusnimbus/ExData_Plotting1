# ===============================================================================
# CONFIGURATION
# ===============================================================================

# ----------  Source download script  ----------

script.dir <- dirname(sys.frame(1)$ofile)

source(file.path(script.dir, 'download.R'))


# ----------  Constants & variables  ----------

data.path.png <- file.path(dir.data, 'plot1.png')



# ===============================================================================
# MAIN
# ===============================================================================

# ----------  Load data  ----------

data <- load_data()

# Not part of the assignment
# summarize_data(data)


# ----------  Create plot  ----------

par(cex=.75)

hist(
    x    =  data$Global_active_power,
    col  = 'red',
    main = 'Global Active Power',
    xlab = 'Global Active Power (kilowatts)'
)


# ----------  Create PNG  ----------

dev.copy(png, file=data.path.png)
dev.off()


# ===============================================================================
