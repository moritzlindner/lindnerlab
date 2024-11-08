
# R(I) = Rmax*I(n)/(I(n) + k(n)) #https://karger.com/ore/article-abstract/25/3/145/257076/Methodological-Aspects-of-the-Application-of-the?redirectedFrom=fulltext

# "Under the otherwise constant conditions
# (field size, stimulus wavelength, state of adap
# tation), Rmax is related to the number of active
# photoreceptors of the retina and is the asymp
# totic value of R(log I). The value of k is indica
# tive of retinal sensitivity, while the number of
# the simultaneously responding photorecep
# tors (the level of retinal coherence) is esti
# mated by n."

naka_rushton <- function(I, Rmax, k, n) {
  Rmax * I^n / (I^n + k^n)
}

require(minpack.lm)
naka_rushton_fit <- function(I, R) {
  # Initial guesses for Rmax, k, and n
  start_params <- list(Rmax = max(R),
                       k = median(I),
                       n = 1)
  lower_bounds <-
    c(0, 0.01, 0.01)  # Avoid zero and very small values
  upper_bounds <-
    c(Inf, max(I) * 2, 10)  # Constrain n to reasonable values

  # Perform the nonlinear least squares fit
  fit <- tryCatch({
    nlsLM(
      R ~ naka_rushton(I, Rmax, k, n),
      start = start_params
    )
  }, error = function(e) {
    message("Error: ", e$message)
    return(NULL)
  })
  # Return the fitted model
  return(fit)
}

fit.list<-list()
fit.df<-NULL
for (n in names(ExamList)) {
  print(n)
  if (GroupName(ExamList[[n]]) != "Cre:TRUE_Rd1:TRUE") {
    data <- Measurements(ExamList[[n]], Marker = "a")
    data <- merge(data, Stimulus(ExamList[[n]]))
    data$Intensity <- as_units(data$Intensity, "cd*s/cm^2")
    warning("Check Intensities")
    data.fit <- data[data$Intensity < as_units(50, "cd*s/cm^2"),]
    fit <-
      naka_rushton_fit(drop_units(data.fit$Intensity),
                       -drop_units(data.fit$Voltage))
    I.range <- range(drop_units(data.fit$Intensity))
    data.fit$Predicted <-
      predict(fit, list(I = drop_units(data.fit$Intensity)))
    print(
      ggplot(dat = data.fit, aes(x = Intensity)) +
        geom_point(aes(y = -Voltage)) +
        geom_line(aes(y = Predicted), linetype = "dashed") +
        ggtitle(n) +
        theme_pubr()
    )
    fit.list[[n]] <- fit
    fit.summary <- summary(fit)
    out <- data.frame(
      Subject = Subject(ExamList[[n]]),
      Eye = unique(data$Eye),
      Group = GroupName(ExamList[[n]]),
      NK_RMax = fit.summary$parameters["Rmax", "Estimate"],
      NK_K = fit.summary$parameters["k", "Estimate"],
      NK_n = fit.summary$parameters["n", "Estimate"]
    )
    fit.df <- rbind(fit.df, out)
  }
}
n="RG0062"
out<-ggERGExam(ExamList[[n]], return.as = "list")
out$`LIGHT-Flash`+facet_grid(cols = vars(Intensity))

ggplot(data = fit.df, aes(x=Group,y=NK_RMax,group=Group,label=Subject))+
  geom_boxplot()+
  geom_jitter()+
  geom_label(position="jitter")


k scheint Sinn zu machen.
modell muss toleranter werden.
