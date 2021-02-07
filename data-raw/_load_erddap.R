# libraries & variables ----
if (!require(librarian)){
  install.packages("librarian")
  library(librarian)
}
shelf(
  dplyr, glue, here, purrr, readr, rerddap, usethis)

ed_url    <- "https://oceanview.pfeg.noaa.gov/erddap"
ed_q      <- "cciea"
dir_raw   <- here("data-raw")
ed_ds_csv <- file.path(dir_raw, "_cciea_datasets.csv")
man_R     <- here("R/datasets_erddap.R")

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

# fetch ERDDAP datasets ----

Sys.setenv(RERDDAP_DEFAULT_URL = ed_url)
ed_s <- ed_search(ed_q, which = "tabledap")

write_csv(ed_s$info, ed_ds_csv)

ed_datasets <- ed_s$info %>%
  tibble() %>%
  mutate(
    csv  = glue("{dir_raw}/{dataset_id}.csv"),
    data = map(
      dataset_id,
      function(dataset_id){
        message(glue("fetching {dataset_id}"))
        tabledap(info(dataset_id))}))

# write data-raw/*.csv, data/*.rda dataset, R/*.R documentation ----
writeLines("", man_R)
ed_datasets %>%
  pwalk(
    function(dataset_id, title, data, csv, ...){

      # write_csv(data, csv)
      #
      # cmd <- glue("{dataset_id} <- data; use_data({dataset_id}, overwrite = T)")
      # eval(parse(text = cmd))

      doc = document_erddap_dataset(dataset_id, title, data) %>%
        paste0("\n\n")
      #writeLines(doc, here(glue("R/{dataset_id}.R")))
      write(doc, man_R, append=T)
    })

# Run in Console after:
#   devtools::document()
#   pkgdown::build_reference()
