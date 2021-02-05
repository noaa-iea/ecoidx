# libraries & variables ----
if (!require(librarian)){
  install.packages("librarian")
  library(librarian)
}
shelf(
  dplyr, glue, ggplot2, here, readr, tibble, usethis)

ts1 <- tibble(
  year  = 1985 + 1:30,
  index = c(1.951787,1.631605,3.457652,NA,NA,NA,-1.016788,1.526880,3.908137,4.353510,3.631307,
            4.362584,3.683589,4.665410,2.294414,1.254683,2.647636,2.933235, 4.818184,6.043274,
            2.533987,1.564976,7.850845,9.314683,7.865794,10.216519,7.164671,11.329814,9.385541,10.176562)) %>%
  mutate(
    Y2         = index,
    SElo       = index - 2,
    SEup       = index + 2,
    timeseries = "(a) Trend and recent mean",
    metric     = NA,
    type       = "current.data")


plot_ts <- function(
  d,
  x = year, y = index, y_lo = SElo, y_hi = SEup,
  pt_color   =  rgb(225, 118, 44, max = 255), # orange
  plot_theme = theme_iea) {

  has_hilo <- all(c(enexpr(y_lo), enexpr(y_hi)) %in% names(d))

  na_omit <- function(d, has_hilo){
    if(has_hilo){
      d_nona <- na.omit(select(d, {{x}}, {{y}}, {{y_lo}}, {{y_hi}}))
    } else {
      d_nona <- na.omit(select(d, {{x}}, {{y}}))
    }
    d_nona
  }

  add_ribbon <- function(g, has_hilo){
    if (has_hilo){
      g <- g +
        geom_ribbon(aes(ymin={{y_lo}}, ymax={{y_hi}}), alpha=0.2)
    }
    g
  }

  v_x <- select(d, {{x}}) %>% pull({{x}})

  g <- na_omit(d, has_hilo) %>%
    ggplot(aes({{x}}, {{y}})) %>%
    add_ribbon(has_hilo) +
    geom_line(linetype = "dashed") +
    geom_line(data = d, aes({{x}}, {{y}})) +
    geom_point(color = pt_color) +
    plot_theme() +
    # add minor ticks for all years, keep labels every 5 years
    scale_x_continuous(
      breaks = seq(min(v_x), max(v_x)),
      labels = ifelse(v_x %% 5 == 0, v_x, "")) +
    theme(
      axis.ticks.x = element_line(
        size = ifelse(v_x %% 5 == 0, 1, 0.5)))

  g
}
g <- plot_ts(ts1)
g
plotly::ggplotly(g)

g +
  theme(axis.ticks.length=c(unit(1, "cm"), unit(0.5, "cm")))


df <- data.frame(x = c(1900,1950,2000), y = c(50,75,60))

p <- ggplot(df, aes(x=x, y=y))
p + geom_line() +
  scale_x_continuous(breaks= seq(1900,2000,by=10),
                     labels = c(1900, rep("",4), 1950, rep("",4), 2000),
                     limits = c(1900,2000), expand = c(0,0)) +
  scale_y_continuous(breaks = c(20,40,60,80), limits = c(0,100)) +
  theme(legend.position="none", panel.background = element_blank(),
        axis.line = element_line(color='black'), panel.grid.minor = element_blank())

g <- plot_ts(ts1)
g

theme_iea <- function(
  base_size = 11, base_family = "", base_line_size = base_size/22,
  base_rect_size = base_size/22){
  # theme_classic

  theme_bw(base_size = base_size, base_family = base_family,
           base_line_size = base_line_size, base_rect_size = base_rect_size) %+replace%
    theme(
      panel.border     = element_blank(),
      panel.grid.major = element_blank(),
      panel.grid.minor = element_blank(),
      axis.title       = element_blank(),
      axis.line = element_line(
        colour = "black", size = rel(1)), legend.key = element_blank(),
      plot.margin = unit(c(0.1, 0.1, 0.1, 0.1), "cm"), #top, right, bottom, left
      # strip.background = element_rect(
      #   fill = "white", colour = "black", size = rel(2)), complete = TRUE)
      strip.background = element_blank(), complete = TRUE)
}

g + theme_iea()

theme_bw
library(scales)
g + theme_gray()
g + theme_bw()
g + theme_classic()
g + scale_x_continuous(
    breaks = seq(min(ts1$year), max(ts1$year)),
    labels = ifelse(ts1$year %% 5 == 0, ts1$year, "")) +
  theme(
    axis.ticks.x = element_line(
      size = ifelse(ts1$year %% 5 == 0, 1, 0.5)))

  tick.sizes[(breaks %% 2.5 == 0)] <- 1

df %>%
  ggplot(aes(x)) +
  geom_histogram(binwidth = .1, color = 'black', fill = 'gray35') +
  scale_x_continuous(breaks = breaks, labels = labels, limits = c(2.5,25)) +
  theme_bw() +
  theme(panel.grid = element_blank(),
        axis.ticks.x = element_line(size = tick.sizes))
g


pretty(ts1$year, n=50)
names(breaks) <- attr(breaks, "labels")
breaks

plotly::ggplotly(g)

g +
  theme_bw() +
  theme(panel.grid = element_blank(),
        axis.ticks.x = element_line(size = 0.5))


set.seed(5)
df <- data.frame(x = rnorm(500, mean = 12.5, sd = 3))

breaks <- seq(2.5, 25, .1)

labels <- as.character(breaks)
labels[!(breaks %% 2.5 == 0)] <- ''
tick.sizes <- rep(.5, length(breaks))
tick.sizes[(breaks %% 2.5 == 0)] <- 1

df %>%
  ggplot(aes(x)) +
  geom_histogram(binwidth = .1, color = 'black', fill = 'gray35') +
  scale_x_continuous(breaks = breaks, labels = labels, limits = c(2.5,25)) +
  theme_bw() +
  theme(panel.grid = element_blank(),
        axis.ticks.x = element_line(size = tick.sizes))


ts1 %>%
  select(-SElo) %>%
  plot_ts()


test <- function(
  d,
  x = year, y = index) {

  d %>%
    select({{ y }})
}

test(ts1)

ggplot(ts1, aes(year, index)) +
  geom_line(data = na.omit(ts1 %>% select(year, index)), linetype = "dashed")
  geom_path(linetype = "dashed")

ts1_r <- ts1 %>%
  rename(yr = year, idx = index, idx_lo = SElo)
ts1_r
plot_ts(ts1_r, yr, idx, idx_lo)


PlotTimeSeries(ts1)
PlotTimeSeries(ts1, Y2 = NA, LWD = 0.8, Pt.cex = 0.5)
#legend("topleft","(a)", inset=-0.11, bty='n')

# Y =  Y2 = c(0.8288388,0.3560032,4.3554672,0.3492971,-1.6653125,3.0814942,7.0659828,0.4611352,2.0977700,1.4968837,5.9732167,5.3339023,6.2231723,2.9405107,6.8632977,8.5882587,2.7173843,5.4305515,5.6159417,3.8396360,5.6711355,4.3574772,5.5107925,5.5223462,7.3474867,8.0262139,6.1562065,4.4223551,3.6068412,2.3166955)

Y =  Y2 = c(0.8288388,0.3560032,4.3554672,0.3492971,0.5,1.06,2.2,0.4611352,2.0977700,1.4968837,5.9732167,5.3339023,6.2231723,2.9405107,6.8632977,8.5882587,2.7173843,NA,NA,3.8396360,NA,4.3574772,5.5107925,5.5223462,7.3474867,8.0262139,6.1562065,2.4223551,1.6068412,1.3166955)


se = rnorm(length(X),0,2)
SElo = Y-2
SEup = Y+2
XY = data.frame(cbind(X,Y,Y2,SEup,SElo))
colnames(XY) = cbind('year','index','Y2',"SEup","SElo")
XY$timeseries="(b) Threshold"
XY$metric = NA
XY$type = "current.data"

source("R/PlotTimeSeries.R")
PlotTimeSeries(XY, YLIM = c(0,NA), LWD = 0.8, Pt.cex = 0.7, threshold = 3, threshold.correct = TRUE, threshold.loc = 'below')
#legend("topleft","(b)", inset=-0.11, bty='n')
# reset
SElo = NA
SEup = NA
Y2 = NA
Ylab = NA

x = c(1.3,1.1,0.5, -1.5,-0.6)
y = c(2.1, -0.9, -1.5, 1.4, 0.5)
COL = c('black','grey','red','blue','green')


xerrors=NA; yerrors=NA
QuadPlot_means(D1 = x, D2 = y, style=1, TitleCex = 0.9, PointCex = 1.5, Title = "(c) Sample quadplot", bg.polys=bg.polys, PlotLegend = NA, Lmar = 4.5)
