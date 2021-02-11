#'Plot time series
#'
#'Plot time series in the style of the California Current IEA. Dashed lines are
#'used in between **missing data** and points colored by `color_pts`. Include a
#'**ribbon** around `y` if low (`y_lo`) and high (`y_hi`) values are provided.
#'Include **long-term average** if `add_avg = TRUE` with average as a black
#'dashed line and solid lines indicating the **standard deviation** in the color
#'of `color_avg`. Include **rectangle** in the color of `color_avg` between the
#'standard deviation of the long-term average since `x_recent` if provided.
#'Include **icons** in the right-hand margin for recent trend (→, ↗, ↘) and
#'recent average (o, +, -) if stable, increasing, or decreasing (respectively)
#'relative to the long-term standard deviation.
#'
#'The attribute `caption` includes a textual summary.
#'
#'@param d Default dataset to use for plotting with
#'  \code{ggplot2::\link[ggplot2]{ggplot}()}. Typically includes columns:
#'  `year`, `index`, `SElo` and `SEup`.
#'@param x column for x axis from `d`, unquoted. Defaults to `year`.
#'@param y column for y axis from `d`, unquoted. Defaults to `index`.
#'@param y_lo unquoted column for low value to apply to gray ribbon, typically
#'  `y - sd(y)`. Defaults to `SElo` if present.
#'@param y_hi unquoted column for highy value to apply to gray ribbon, typically
#'  `y + sd(y)`. Defaults to `SEhi` if present.
#'@param x_recent duration of `x`, typically an integer, for which to consider
#'  as recent period to derive **rectangle** and **icons**. Defaults to `5`, as
#'  in years.
#'@param units_recent units to describe `x`, used in caption.
#'@param add_avg whether to add average as a black dashed line and solid lines
#'  indicating the **standard deviation** in the color of `color_avg`. Defaults
#'  to `TRUE`.
#'@param add_icons whether to include icons in the right-hand margin for recent
#'  trend (→, ↗, ↘) and recent average (o, +, -) if stable, increasing, or
#'  decreasing (respectively) relative to the long-term standard deviation.
#'  Defaults to `TRUE`.
#'@param font_size font size. Defaults to 24.
#'@param icon_size size of icon font. Defaults to half the `font_size`, 12.
#'@param color_pts color for points, as named color (see
#'  \code{\link[grDevices]{colors}()}) or hexadecimal value as provided by red
#'  green blue \code{\link[grDevices]{rgb}()} specification. Defaults to dusty
#'  orange.
#'@param color_avg color for standard deviation lines around long-term average
#'  and rectangle between since `x_recent`.
#'@param color_hilo color for ribbon around `y` between values `y_lo` and
#'  `y_hi`.
#'@param alpha_avg transparency (0 to 1) for colored elements of long-term
#'  average: standard deviation and recent rectangle.
#'@param alpha_hilo transparency (0 to 1) for ribbon around `y` between values
#'  `y_lo` and `y_hi`.
#'@param theme_plot theme function to apply to the ggplot. Defaults to
#'  \code{\link{theme_iea}}.
#'
#'@return This function returns a ggplot object with attributes for: `caption`,
#'  `recent_trend` and `recent_avg`.
#'
#'@import dplyr emojifont ggplot2
#'@importFrom modelr add_predictions
#'@importFrom glue glue
#'@export
#'@concept plot
#'
#' @examples
#' # example time series dataset with some NAs to show dashed line between non-NA values
#' ts1
#'
#' # defaults to include all options data frame contains x, y, SElo, SEhi
#' g <- plot_ts(ts1)
#' g
#'
#'# show the caption attributed to the returned ggplot object
#'cat(attr(g, "caption"))
#'
#'# without SElo or SEhi columns, just year and index
#'g <- plot_ts(ts1[,c("year","index")])
#'g
#'
#'# same caption as previously, since defaults to x_recent=5 and add_avg=T
#'cat(attr(g, "caption"))
#'
#'# without default x_recent, add_avg, or add_icons
#'g <- plot_ts(ts1, x_recent=NA, add_icons=F, add_avg=F)
#'g
#'# no caption, since missing x_recent and add_avg
#'cat(attr(g, "caption")) # empty caption without x_recent
#'
plot_ts <- function(
  d, x = year, y = index,
  y_lo = SElo, y_hi = SEup,
  x_recent = 5, units_recent = "years",
  add_avg    = TRUE,
  add_icons  = TRUE,
  font_size  = 24,
  icon_size  = font_size/2,
  color_pts  = rgb(225, 118, 44, max = 255), # "dusty orange" xkcdcolors::nearest_named()
  color_avg  = rgb(63, 173, 213, max = 255), # "lightblue"
  color_hilo = "lightgrey",
  alpha_avg  = 0.8,
  alpha_hilo = 0.8,
  theme_plot = theme_iea) {

  # TODO:
  # - add other captions besides recent_*
  # - account for diff't avg time period, eg OC_* like PDO
  # - remove outliers for avg, eg seabirds
  # - deal with Y2 for fitted data

  library(emojifont)

  captions <- list(
    recent_trend = list(
      "→" = "The index changed by less than one standard deviation of the full time series over the last {x_recent} {units_recent} (indicated by icon: →).",
      "↗" = "The index increased by more than one standard deviation of the full time series over the last {x_recent} {units_recent} (indicated by icon: ↗).",
      "↘" = "The index decreased by more than one standard deviation of the full time series over the last {x_recent} {units_recent} (indicated by icon: ↘)."),
    recent_avg = list(
      "o" = "The mean of the last {x_recent} {units_recent} was within one standard deviation of the long-term mean (indicated by icon: o).",
      "+" = "The mean of the last {x_recent} {units_recent} was more than one standard deviation below the mean of the full time series (indicated by icon: +).",
      "-" = "The mean of the last {x_recent} {units_recent} was less than one standard deviation above the mean of the full time series (indicated by icon: -)."))

  has_hilo   <- all(c(enexpr(y_lo), enexpr(y_hi)) %in% names(d))
  has_recent <- !(is.null(x_recent) || is.na(x_recent))

  if (!has_recent & add_icons){
    warning("Incompatible arguments: add_icons = TRUE without supplying x_recent. Setting add_icons = F.")
    add_icons = F
  }

  x_v      <- pull(d, {{x}})
  y_v      <- pull(d, {{y}})
  x_min    <- min(x_v, na.rm=T)
  x_max    <- max(x_v, na.rm=T)
  x_rng    <- x_max - x_min
  y_avg    <- mean(y_v, na.rm=T)
  y_sd     <- sd(y_v, na.rm=T)
  y_avg_lo <- y_avg - y_sd
  y_avg_hi <- y_avg + y_sd
  caption  <- character(0)

  if (has_recent){
    d_r <- d %>%
      filter({{x}} > max({{x}}, na.rm=T) - x_recent)

    y_recent_avg <- pull(d_r, {{y}}) %>% mean(na.rm = T)

    # run linear model (lm) regression on recent years
    m_formula <- glue("{enexpr(y)} ~ {enexpr(x)}") %>% as.formula()
    m   <- lm(m_formula, d_r)
    d_r <- modelr::add_predictions(d_r, m, var = "pred")

    # get recent trend as difference between first and last recent years of lm prediction
    y_recent_pred_dif <- d_r %>%
      filter({{x}} %in% c(min({{x}}), max({{x}}))) %>%
      pull(pred) %>%
      diff()

    # compare recent trend with long-term standard deviation
    recent_trend <- ifelse(
      abs(y_recent_pred_dif) - y_sd < 0,
      "→",
      ifelse(
        y_recent_pred_dif > y_sd,
        "↗",
        "↘"))

    # compare recent average with long-term standard deviation
    recent_avg <- ifelse(
      abs(y_recent_avg) - y_sd < 0,
      "o",
      ifelse(
        y_recent_avg > y_sd,
        "+",
        "-"))

    caption <- paste(
      caption,
      captions[["recent_trend"]][[recent_trend]], " ",
      captions[["recent_avg"]][[recent_avg]])
  }

  na_omit <- function(d, has_hilo){
    if(!has_hilo)
      return(na.omit(select(d, {{x}}, {{y}})))
    na.omit(select(d, {{x}}, {{y}}, {{y_lo}}, {{y_hi}}))
  }

  insert_hilo <- function(){
    if (!has_hilo)
      return(list())
    geom_ribbon(aes(ymin={{y_lo}}, ymax={{y_hi}}), color=NA, fill=alpha(color_hilo, alpha_hilo))
  }

  insert_avg <- function(){

    f <- ifelse(
      has_recent,
      list(
        annotate(
          "rect",
          xmin = x_max - x_recent, xmax = x_max,
          ymin = y_avg_lo, ymax = y_avg_hi,
          fill = alpha(color_avg, alpha_avg))),
      list())

    if (!add_avg)
      return(f)

    append(
      f,
      list(
        annotate(
          "segment",
          x    = x_min, y    = y_avg,
          xend = x_max, yend = y_avg,
          linetype = "dashed"),
        annotate(
          "segment",
          x    = x_min, y    = y_avg_lo,
          xend = x_max, yend = y_avg_lo,
          color = alpha(color_avg, alpha_avg)),
        annotate(
          "segment",
          x    = x_min, y    = y_avg_hi,
          xend = x_max, yend = y_avg_hi,
          color = alpha(color_avg, alpha_avg))))
  }

  insert_x_ticks <- function(){
    if (x_rng > 40)
      stop("Whoah! The insert_x_ticks() subfunction of plot_ts() hasn't yet considered a range beyond 40 for x, which is presumably in years.")

    # add minor ticks for all years, keep labels every 5 years and double tick size
    list(
      scale_x_continuous(
        breaks = seq(x_min, x_max),
        labels = ifelse(x_v %% 5 == 0, x_v, ""),
        limits = c(x_min, x_max)),
      theme(
        axis.ticks.x = element_line(
          size = ifelse(x_v %% 5 == 0, 1, 0.5))))
  }

  insert_icons <- function(){
    if (!add_icons | !has_recent)
      return(list())

    icons <- list(
      recent_trend = list(
        "→" =   0,
        "↗" =  45,
        "↘" = -45),
      recent_avg = list(
        "o" = "fa-dot-circle-o",
        "+" = "fa-plus-circle",
        "-" = "fa-minus-circle"))

    list(
      geom_text(
        x = x_max + x_rng/20, y = y_avg_hi,
        angle = icons[["recent_trend"]][[recent_trend]],
        label = emojifont::fontawesome('fa-arrow-circle-right'),
        family='fontawesome-webfont', size=icon_size),
      geom_text(
        x = x_max + x_rng/20, y = y_avg_lo,
        label = fontawesome(icons[["recent_avg"]][[recent_avg]]),
        family='fontawesome-webfont',  size=icon_size),
      theme(plot.margin = unit(c(0.1, 1.1, 0.1, 0.1), "lines")),
      coord_cartesian(clip = "off"))
  }

  g <- na_omit(d, has_hilo) %>%
    ggplot(aes({{x}}, {{y}})) +
    insert_avg() +
    insert_hilo() +
    geom_line(linetype = "dashed") +
    geom_line(data = d, aes({{x}}, {{y}})) +
    geom_point(color = color_pts) +
    insert_x_ticks() +
    theme_plot(base_size = font_size) +
    insert_icons()

  attr(g, "caption") <- glue(caption)
  if (has_recent){
    attr(g, "recent_trend") <- recent_trend
    attr(g, "recent_avg")   <- recent_avg
  }

  g
}

#' Plotting theme for IEA
#'
#' Derived from \code{ggplot2::\link[ggplot2]{theme_classic}()},
#' a classic-looking theme with x and y axis lines and no gridlines.
#' Additionally dropped x and y axis labels, reduced plot margin.
#'
#' @param base_size base font size, given in pts.
#' @param base_family base font family
#' @param base_line_size base size for line elements
#' @param base_rect_size base size for rect elements
#'
#' @return
#'
#' @import ggplot2
#' @export
#' @concept plot
#'
#' @examples
#' library(ggplot2)
#'
#' # default ggplot2 theme
#' plot_ts(ts1) + theme_gray()
#'
#' # slimmed down ggplot2 theme
#' plot_ts(ts1) + theme_classic()
#'
#' # this custom IEA theme, the default theme to plot_ts()
#' plot_ts(ts1, theme_plot = theme_iea)
theme_iea <- function(
  base_size = 14, base_family = "", base_line_size = base_size/28,
  base_rect_size = base_size/28){
  # derived from theme_classic

  theme_classic(base_size = base_size, base_family = base_family,
           base_line_size = base_line_size, base_rect_size = base_rect_size) %+replace%
    theme(
      axis.title       = element_blank(),
      axis.line = element_line(
        colour = "black", size = rel(1)), legend.key = element_blank(),
      plot.margin = unit(c(0.1, 0.1, 0.1, 0.1), "cm"), # top, right, bottom, left
      strip.background = element_blank(), complete = TRUE)
}

