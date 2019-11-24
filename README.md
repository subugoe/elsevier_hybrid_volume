## Research compendium: Mining and analysing invoice data from Elsevier relative to hybrid open access

### Overview

This repository contains invoice data from Elsevier hybrid journals from 2015 to mid November 2019 along with the analytical code. It is organised as a [research compendium](https://doi.org/10.7287/peerj.preprints.3192v2). A research compendium contains data, code, and text associated with it. 

To start with, read the blog post:


### File organisation

The R files in the [`analysis/`](analysis/) directory provide details about the data analysis, particularly about how Crossref services were interfaced, and the [*blog post*](analysis/paper.md). The [`data/`](data/) directory contains all aggregated data. The main file you want to start your analyis is `data/elsevier_hybrid_oa_df.csv`.

### Reproducibility notes

This repository follows the concept of a [research compendium](https://doi.org/10.7287/peerj.preprints.3192v2) that uses the R package structure to port data and code. 

Using the [holepunch-package](https://github.com/karthik/holepunch) the project was made Binder ready. Binder allows you to execute the code in the cloud in your web browser.

### Contributing

This data analytics works has been developed using open tools. There are a number of ways you can help make it better:

- If you don’t understand something, please let me know and [submit an issue](https://github.com/subugoe/oa2020cadata).

Feel free to add new features or fix bugs by sending a pull request.

Please note that this project is released with a Contributor Code of Conduct. By participating in this project you agree to abide by its terms.

### Contact

Najko Jahn, Data Analyst, SUB Göttingen. najko.jahn@sub.uni-goettingen.de
