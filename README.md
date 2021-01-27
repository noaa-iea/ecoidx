# ecoidx
marine ecological indicator workflows and visualization, particularly for NOAA's Integrated Ecological Assessment program


## Developer

### Load dataset

1. Place into CSV into `data-raw/` folder
1. Create dataset. Create `get_[dataset].R` script to read, potentially wrangle and then load into R package as a dataset using `usethis::use_data()`. Run `get_[dataset].R` to generate `data/[dataset].rda`.
1. Document dataset. Create `R/[dataset].R`. Run `devtools::document()` to create `man/[dataset].Rd`.
1. Document package. Run `pkgdown::build_reference()` to update `docs/reference/index.html`.

