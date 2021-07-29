# libraries & variables ----
if (!require(librarian)){
  install.packages("librarian")
  library(librarian)
}
shelf(
  dplyr, glue, here, purrr, readr, rerddap, tibble, tidyr, usethis, yaml)

ed_url     <- "https://oceanview.pfeg.noaa.gov/erddap"
ed_q       <- "cciea"
dir_raw    <- here("data-raw")
ed_ds_csv  <- file.path(dir_raw, "_cciea_datasets.csv")
ed_ixs_csv <- file.path(dir_raw, "_extra_erddap_indexes.csv")
man_R      <- here("R/datasets_erddap.R")

# helper functions ----

document_erddap_dataset <- function(dataset_id, title, data, ...){

  i <- info(dataset_id)

  i_var_attr <- function(i, v, a){
    r <- i$alldata[[v]] %>%
      filter(attribute_name == a) %>%
      pull(value)

    if(identical(r, character(0))) return("")
    r
  }

  doc_var <- function(v, i){
    message(glue("  variable {v}"))

    long_name    <- i_var_attr(i, v ,'long_name')
    # description  <- i_var_attr('description') # TODO: consider adding, but long
    units        <- i_var_attr(i, v ,'units')
    actual_range <- i_var_attr(i, v ,'actual_range')

    glue("#'   \\item{<v>}{<long_name> (<units>) \\[<actual_range>\\]}", .open="<", .close=">") %>%
      as.character()
  }

  message(glue("documenting {dataset_id}"))

  # i$alldata[["NC_GLOBAL"]] %>% select(-value)
  smry <- i_var_attr(i, "NC_GLOBAL" , "summary")

  doc_vars <- tibble(
    var = names(i$alldata) %>% setdiff("NC_GLOBAL")) %>%
    mutate(
      doc_var = map_chr(var, doc_var, i)) %>%
    pull(doc_var) %>%
    paste(collapse = "\n")

  glue(
    "#' <title>
     #'
     #' <smry>
     #'
     #' @format A data frame with <nrow(data)> rows and <ncol(data)> variables:
     #' \\describe{
     <doc_vars>
     #' }
     #' @source \\url{<ed_url>/info/<dataset_id>/index.html}
     #' @concept dataset_erddap
     \"<dataset_id>\"", .open="<", .close=">") %>%
    as.character()
}

get_erddap_tbl <- function(dataset_id, ed_url = ed_url){
  # dataset_id = "cciea_AC"
  # dataset_id = "cciea_B_AS_DENS"  # density_anomaly, species_cohort
  # dataset_id = "cciea_EI_FBC"  # time, species_group, mean_cpue, Seup, Selo
  # dataset_id = "cciea_AC_mn" # month, month_number
  # dataset_id = "cciea_OC_DO" # time, location, dissolved_oxygen

  #message(glue("fetching {dataset_id}"))
  i_dataset <- which(ed_datasets$dataset_id == dataset_id)
  message(glue("{dataset_id} - {i_dataset} of {nrow(ed_datasets)} datasets"))

  info_d <- info(dataset_id)
  d <- tabledap(info_d, url=ed_url) %>%
    as_tibble()
  d_csv <- glue("{dir_raw}/{dataset_id}_raw.csv")
  write_csv(d, d_csv)
  d_csv
}

get_erddap_tbl_0 <- function(dataset_id, ed_url = ed_url){
  # dataset_id = "cciea_AC"
  # dataset_id = "cciea_B_AS_DENS"  # density_anomaly, species_cohort
  # dataset_id = "cciea_EI_FBC"  # time, species_group, mean_cpue, Seup, Selo
  # dataset_id = "cciea_AC_mn" # month, month_number
  # dataset_id = "cciea_OC_DO" # time, location, dissolved_oxygen


  #message(glue("fetching {dataset_id}"))
  i_dataset <- which(ed_datasets$dataset_id == dataset_id)
  message(glue("{dataset_id} - {i_dataset} of {nrow(ed_datasets)} datasets"))

  d <- tabledap(info(dataset_id), url=ed_url) %>%
    as_tibble()

  cols_idx = character(0)
  if ("time" %in% names(d)){
    d <- d %>%
    mutate(
      # convert time
      time = strptime(time, "%Y-%m-%dT%H:%M:%SZ", tz="GMT"))
    cols_idx = "time"

    # get extra indexes
    cols_idx = c(
      cols_idx,
      ed_ixs %>%
        filter(dataset == dataset_id) %>%
        pull(index))

    if (any(duplicated(d$time)) & length(cols_idx) < 2){
      message(glue("{dataset_id}: [{paste(names(d), collapse = ', ')}"))
      browser()
      # i_beg <- 45

      # cciea_HD_PU: [time, use_type], personal_catch
      # cciea_HD_Fish_Rel: [time, region, location], fishing_reliance
      # cciea_HD_Fish_Eng: [time, region, location], fishing_engagement
      # cciea_HD_Fish_Dep: [time, location], fishing_dependence,
      # cciea_HD_ESI_VESS: [time, vessel_category], average_ESI,
      # cciea_HB_FLO7_CH: [time, location], flow_anomaly_7_day_min, Seup, Selo
      # cciea_HB_FLO7: [time, location], flow_anomaly_7_day_min, Seup, Selo
      # cciea_HB_FLO1_CH: [time, location], flow_anomaly_1_day_max, Seup, Selo
      # cciea_HB_FLO1: [time, location], flow_anomaly_1_day_max, Seup, Selo
      # cciea_HB_AUGMX: [time, location], aug_mean_max, Seup, Selo

      # TODO: Seup, Selo
      #   eg cciea_EI_SIMP: [time, population], simpson_diversity, Seup, Selo
      #      cciea_EI_SP_RICH: [time, population], species_richness
      #      cciea_EI_SCAV_RAT: [time, population], biomass_ratio
      #      cciea_HB_SWE: [time, location], SWE_anomaly
      #      cciea_MM_cetacean: [time, common_name, scientific_name], abundance, CV
      #      cciea_EI_CRAB_FINF: [time, population], biomass_ratio
      #      cciea_EI_FBC: [time, species_group], mean_cpue
      #      cciea_EI_FBC_2020: [time, species_group], mean_cpue
      #      cciea_EI_FBN: [time, species_group], mean_density
      #      cciea_EI_FBN_2020: [time, species_group], mean_density
      #      cciea_EI_MTL: [time, population], mean_trophic_level
      #      cciea_EI_RREAS_diversity_grid: [time, taxa], abundance abundance_error richness richness_error diversity
      #
    }
  }
  if (all(c("month", "month_number") %in% names(d))){
    # cciea_AC_mn: month, month_number, landings, fish_tickets
    message(glue("{dataset_id} - MONTH, MONTH_NUMBER!"))
    cols_idx = c("month", "month_number") #
  }

  stopifnot(length(cols_idx) > 0)

  d <- d %>%
    mutate(
      # convert NaNs
      across(where(is.character), na_if, "NaN"),
      # convert character to numeric if NAs match after
      across(where(is.character), function(x, na.rm=T){
        x_dbl <- suppressWarnings(as.double(x))
        if (sum(is.na(x_dbl)) == sum(is.na(x)))
          return(x_dbl)
        x
      }),
      across(where(is.integer), as.numeric),
      across(where(is.logical), as.numeric))

  var_classes <- lapply(select(d, -all_of(cols_idx)), class) %>% unlist()
  bad_classes <- setdiff(var_classes, c("numeric", "character"))
  bad_vars    <- var_classes[var_classes %in% bad_classes]
  if(length(bad_vars) != 0)
    stop(glue("bad var {names(bad_vars)}: {bad_vars}; "))

  # pivot character values
  d_chr <- d %>%
    select(all_of(cols_idx)) %>%
    slice(0) %>%
    mutate(
      variable        = character(0),
      value_character = character(0))
  if (length(select(d, where(is.character), -all_of(cols_idx))) > 0){
    d_chr <- d %>%
      select(all_of(cols_idx), where(is.character)) %>%
      pivot_longer(
        -all_of(cols_idx),
        names_to  = "variable",
        values_to = "value_character",
        values_drop_na = T) %>%
      mutate(
        value_type = "character")
  }

  # pivot numeric values
  d_num <- d %>%
    select(all_of(cols_idx)) %>%
    slice(0) %>%
    mutate(
      variable      = character(0),
      value_numeric = numeric(0))
  if (length(select(d, where(is.numeric), -all_of(cols_idx))) > 0){
    d_num <- d %>%
      select(all_of(cols_idx), where(is.numeric)) %>%
      pivot_longer(
        -all_of(cols_idx),
        names_to  = "variable",
        values_to = "value_numeric",
        values_drop_na = T) %>%
      mutate(
        value_type = "numeric")
  }

  bind_rows(
    d_chr,
    d_num)
}

# fetch ERDDAP datasets ----

Sys.setenv(RERDDAP_DEFAULT_URL = ed_url)
ed_s <- ed_search(ed_q, which = "tabledap")

write_csv(ed_s$info, ed_ds_csv)

# get extra indexes
ed_ixs <- read_csv(ed_ixs_csv)

# get tibble of all datasets with data
#ed_datasets <- ed_s$info %>%
ed_datasets <- read_csv(ed_ds_csv) %>%
  arrange(dataset_id)

options(readr.show_types = FALSE)
ed_datasets <- ed_datasets %>%
  # slice(i_beg:nrow(ed_datasets)) %>%
  mutate(
    #raw_csv   = map_chr(dataset_id, get_erddap_tbl),
    raw_csv    = here(glue("data-raw/{dataset_id}_raw.csv")),
    raw_csv_ok = file.exists(raw_csv),
    raw_data   = map(raw_csv, read_csv, na = c("", "NA", "NaN")))

# d <- ed_datasets %>%
#   # filter(dataset_id == "cciea_AC") %>%
#   filter(dataset_id == "cciea_B_AS_DENS") %>%
#   pull(raw_data) %>% .[[1]]
# d

# ed_datasets_1 <- ed_datasets
# ed_datasets <- ed_datasets_1

ed_datasets <- ed_datasets %>%
  mutate(
    col_time = map(raw_data, function(d){
      intersect(names(d), "time")
    }),
    cols_idx = map(raw_data, function(d){
      cols_idx_all = c(
        "metric",    # cciea_EI_RREAS_diversity_list
        "latitude",  # cciea_OC_BEUTI, cciea_OC_CUTI, cciea_OC_SL1
        "longitude", # cciea_OC_SL1
        "blob_id",   # cciea_OC_MHW_EV
        "station",   # cciea_OC_SL1, newportCTD
        "depth", "project", # newportCTD
        # read_csv("data-raw/_extra_erddap_indexes.csv") %>%
        #   distinct(index) %>% pull(index) %>% sort() %>% paste(collapse = '", "') %>% cat()
        "common_name", "county", "diet_species_cohort", "location", "population", "region", "scientific_name", "site", "species", "species_cohort", "species_group", "taxa", "timeseries", "use_type", "vessel_category")
      # cols_idx = intersect(names(d), cols_idx_all)
      intersect(names(d), cols_idx_all)
    }),
    cols_err = map(raw_data, function(d){
      cols_err_all = c(
        "Seup","Selo","std_dev","CV",
        "stdev", # cciea_OC_UI3
        "std_error") # cciea_OC_SL1)
      # cols_err = intersect(names(d), cols_err_all)

      # TODO: match with col_val (not `nobs`)

      intersect(names(d), cols_err_all)
      # TODO: match columns with error suffixes
      #  cols_err_sfx = c(
      #   "_SEup", "_SElo", "_SEtype" # cciea_HMS
      #   "_se") # cciea_MM_pup_count
      #  So yml
    }),
    cols_vals = pmap(., function(raw_data, col_time, cols_idx, cols_err, ...){
      # cols_vals <-
      setdiff(names(raw_data), c(col_time, cols_idx, cols_err)) }),
    ncols_vals = map_int(cols_vals, length),
    cols_dup = map2(raw_data, cols_vals, function(d, cols_vals){
      if (length(cols_vals) == 1){
        return(character(0))
      }
      d %>%
        summarize(across(all_of(cols_vals), duplicated)) %>%
        summarize(across(all_of(cols_vals), sum)) %>%
        pivot_longer(everything()) %>%
        filter(value > 0) %>%
        pull(name) }),
    ncols_dup = map_int(cols_dup, length))

pmap(ed_datasets, function(dataset_id, col_time, cols_idx, cols_err, cols_vals, ...){
  meta_yml <- here(glue("data-raw/{dataset_id}_meta.yml"))
  meta <- list(
    columns = list(
      time   = col_time,
      index  = cols_idx,
      values = cols_vals,
      error  = cols_err))
  write_yaml(meta, meta_yml)
})

# ed_datasets %>%
#   select(dataset_id, title) %>%
#   View()

library(listviewer)
# ds <-
#
ed_datasets %>%
  filter(ncols_dup > 1) %>%
  select(dataset_id, cols_dup) %>%
  pivot_wider(
    names_from = "dataset_id",
    values_from = "cols_dup") %>%
  jsonlite::toJSON() %>%
  # mutate(across(everything(), as.vector))
  listviewer::jsonedit()

as.vector()
ds$cciea_EI_COP




 }))


# write data-raw/*.csv, data/*.rda dataset, R/*.R documentation ----
writeLines("", man_R)
ed_datasets %>%
  arrange(dataset_id) %>%
  pwalk(
    function(dataset_id, title, data, csv, ...){

      # load dataset into R package
      write_csv(data, csv)
      cmd <- glue("{dataset_id} <- data; use_data({dataset_id}, overwrite = T)")
      eval(parse(text = cmd))

      # write documentation into R package
      doc = document_erddap_dataset(dataset_id, title, data) %>%
        paste0("\n\n")
      write(doc, man_R, append=T)
    })

# Run in Console after:
#   devtools::document()
#   pkgdown::build_reference()
