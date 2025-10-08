###################################################

# Plotting results from the GOMWU test

###################################################


# Loading GOMWU results file
loadGOMWU <- function(file) {
  res <- read.delim(file, sep = "\t") %>%
    data.frame() %>%
    filter(pval <= 0.051)

  res$GOterms <- factor(res$GOterms, levels = res$GOterms)

  return(res)
}


# Customized plot of GOMWU results
PlotGOMWU <- function(data) {
  data %>%
    ggplot(aes(Trend, GOterms, color = pval, size = GeneNumber)) +
    geom_point() +
    theme(axis.text.x = element_text(size = 6),
          axis.text.y = element_text(size=10)) +
    scale_color_gradient(low = "#E6A0C4", high = "#1E1E1E") +
    theme_bw(base_size=14) +
    labs(
      x = "",
      y = "Biological Process"
    )
}