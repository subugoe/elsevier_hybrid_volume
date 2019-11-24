## Research compendium: Mining and analysing invoice data from Elsevier relative to hybrid open access

<!-- badges: start -->
  [![Launch Rstudio Binder](http://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/njahn82/elsevier_hybrid_volume/master?urlpath=rstudio)
  <!-- badges: end -->

### Overview

This repository contains invoice data from Elsevier hybrid journals from 2015 to mid November 2019 along with the analytical code. It is organised as a [research compendium](https://doi.org/10.7287/peerj.preprints.3192v2). A research compendium contains data, code, and text associated with it. 

To start with, read the blog post:


### File organisation

The R files in the [`analysis/`](analysis/) directory provide details about the data analysis, particularly about how Crossref services were interfaced, and the [*blog post*](analysis/paper.md). The [`data/`](data/) directory contains all aggregated data. The main file you want to start your analyis is `data/elsevier_hybrid_oa_df.csv`.

Overview:

```console
.
├── .binder
│   └── Dockerfile #  Docker environment
├── DESCRIPTION # metadata and R dependencies
├── README.md # description of contents and guide to users
├── analysis # R code used for data analysis including blog post
│   ├── blog_post.Rmd # blog post written in R Markdown
│   ├── data_coding.R # coding of final dataset
│   ├── extract_email_domains.R # split email domains
│   ├── fetch_apc_list.R # obtain APC list from Elsevier
│   ├── fetch_cr_md.R # get Corssref metadata
│   ├── literature.bib # literature cited in blog post
│   └── tdm_oa_info.R # mining invoice data and emails from xml
├── data # data compiled and used in analysis
│   ├── els_hybrid_info_normalized.csv # temporary aggregate data
│   ├── elsevier_apc_list.csv # Elsevier journal-level data
│   ├── elsevier_hybrid_oa_df.csv # full aggregate dataset
│   ├── elsevier_hybrid_oa_tdm_links.csv # tdm metadata
│   ├── hybrid_license_md.json # oa article-level metadata
│   └── journal_facets.json # overview of yearly poublication volume
├── docs
│   └── blog_post.html # rendered blog post
├── elsevier_hybrid_volume.Rproj # R Studio project file
├── .gitignore # ignored files
├── .travis.yml # test, if research compendium can be build
├── LICENSE
├── LICENSE.md
```

### Reproducibility notes

This repository follows the concept of a [research compendium](https://doi.org/10.7287/peerj.preprints.3192v2) that uses the R package structure to port data and code. 

Using the [holepunch-package](https://github.com/karthik/holepunch) the project was made Binder ready. Binder allows you to execute the code in the cloud in your web browser.

### Contributing

This data analytics works has been developed using open tools. There are a number of ways you can help make it better:

- If you don’t understand something, please let me know and [submit an issue](https://github.com/subugoe/oa2020cadata).

Feel free to add new features or fix bugs by sending a pull request.

Please note that this project is released with a   [Contributor Code of Conduct](CODE_OF_CONDUCT.md). By participating in this project you agree to abide by its terms.

### Contact

Najko Jahn, Data Analyst, SUB Göttingen. najko.jahn@sub.uni-goettingen.de
