# BIMarathon2021
COVID &amp; Digital Learning

## Problem:

In 2020, schools had faced the problem of choosing resources to provide an online learning process.
A large selection of technologies misleads schools. Which product should they choose? What product will better meet the needs of the school in the educational process? When there are thousands of products on the market with similar functionality.

## Goal:

The purpose of the study is to cluster existing products. Help schools choose the best packet of products based on their needs and user engagement with the platform.

Each school district has a different level of diversity. So before clusterization of products, I will classify school districts by level of diversity and provide an optimal packet of products for each level.

## Metrics:

  * DAU (daily active users) and MAU (monthly active users).
  * DAU/MAU Ratio -  Stickiness. The proportion of monthly active users that engage with the product in a single day.
  * Frequency - How often the product is used.
  * Recency - How long has the product been used.
  * Retention - Ноw schools interact with packets of products during 2020.


## Data Description

The engagement data are based on [LearnPlatform](https://learnplatform.com/)’s Student Chrome Extension. 

The extension collects page load events of over 10K education technology products in our product library, including websites, apps, web apps, software programs, extensions, ebooks, hardwares, and services used in educational institutions. The engagement data have been aggregated at school district level, and each file represents data from one school district. 

The product file includes information about the characteristics of the top 372 products with most users in 2020. 

The district file includes information about the characteristics of school districts, including data from [National Center for Education Statistics (NCES)](https://nces.ed.gov/), [The Federal Communications Commission (FCC)](https://www.fcc.gov/), and [Edunomics Lab](https://edunomicslab.org/). In addition to the files provided, we encourage you to use other public data sources such as examples listed below.


## Physical Data Model (COVID & Digital Learning)
![Physical Data Model (COVID & Digital Learning)](https://github.com/IrisSokolova/BIMarathon2021/blob/main/newfolder/data_model.png) 



## Data aggregation, Pre-Processing Data, Uploading to MySQL
   * [jupyter notebook COVID & Digital Learning - read, merge, upload data to SQL server.ipynb](https://github.com/IrisSokolova/BIMarathon2021/blob/main/COVID%20%26%20Digital%20Learning%20-%20read%2C%20merge%2C%20upload%20data%20to%20SQL%20server%20.ipynb)
   * [SQL script (CREATE DATABASE, ALTER TABLE, CREATE TABLE AND ect.)](https://github.com/IrisSokolova/BIMarathon2021/blob/main/create_tables_insert_data.sql)
  
## Dealing with Null values / Working with Missing Data in Pandas and mySQL
   * gathering additional information from open sourses
   https://www.governing.com/archive/school-district-totals-average-enrollment-statistics-for-states-metro-areas.html
   https://nces.ed.gov/programs/digest/d20/tables/dt20_204.10.asp
   https://educationdata.org/public-education-spending-statistics#newhempaer
   * Using the Python 
   * Update tables in Database SQL [(advanced SQL Query using CASE scenario and multi-table UPDATE)](https://github.com/IrisSokolova/BIMarathon2021/blob/main/Null_values_update_tables.sql)

## KMeans clustering (Clusers of districts & Clusters of product)
   [Go to notebook](https://github.com/IrisSokolova/BIMarathon2021/blob/main/KMeans_clustering_Digital_COVID2020.ipynb)

### K-means
  * K-means is a popular centroid-based, hard clustering algorithm
  * I am working with a large, unlabeled and unstructured dataset, clustering can be helpful to trim the dataset down to a size that’s more manageable for analysis.
  I am unable to make an estimate how many clusters in the data I can use algorithms like the elbow method and the silhouette method to determine the optimal number of clusters.

### How to choose the optimal number of clusters?
#### Silhouette Coefficient method
  * The Silhouette Coefficient is calculated using the mean intra-cluster distance (a) and the mean nearest-cluster distance (b) for each sample.
  * The Silhouette Coefficient for a sample is (b - a) / max(a, b).
  * To clarify, b is the distance between a sample and the nearest cluster that the sample is not a part of.
#### Elbow method
  * select the optimal number of clusters by fitting the model with a range of values for 𝐾. If the line chart resembles an arm, then the “elbow” (the point of inflection on the curve) is a good indication that the underlying model fits best at that point.
  * Inertia_ - the sum of square distances from each point to its assigned center
  How to eliminate highly correlated features?
  * Highly correlated features indicate linear relationship. I used Pearson Correlation Matrix to which of them highly correlated and exclude them.
### How to cluster data? What are the main metrict to cluster Districts or Products into a different groups?
#### District description (metrics): 

  * recency - last contact with platform
  * frequency - how often district communicate with platform
  * num_products_used - how many products district used
  * total_pages_per_student - total number of pages per student
  * num_providers - Whose products district used
  * function_covered - Total unique function covered
  * usage_day - How many days district had been with platform
  * clicks_per_day - How many loads per day
#### Result of Districts clustering 
![District clusters](https://github.com/IrisSokolova/BIMarathon2021/blob/main/newfolder/district_clusters.png)

#### Product description (metrics):

  * num_district - How many districts used particular product
  * lp_id_loads - Frequency, How many time district communicate with particular product
  * engagement_per_student - Total pages of product loaded by student
  
#### Result of Products clustering
![Product_clusters](https://github.com/IrisSokolova/BIMarathon2021/blob/main/newfolder/product_clusters.png)


## File Structure

The organization of data sets is described below:

```
Root/
  -engagement_data/
    -1000.csv
    -1039.csv
    -...
  -districts_info.csv
  -products_info.csv
  -README.md

```

## Data Definition


### Engagement data
The engagement data are aggregated at school district level, and each file in the folder `engagement_data` represents data from one school district. The 4-digit file name represents `district_id` which can be used to link to district information in `district_info.csv`. The `lp_id` can be used to link to product information in `product_info.csv`.

| Name | Description |
| :--- | :----------- |
| time | date in "YYYY-MM-DD" |
| lp_id | The unique identifier of the product |
| pct_access | Percentage of students in the district have at least one page-load event of a given product and on a given day |
| engagement_index | Total page-load events per one thousand students of a given product and on a given day |


### District information data
The district file `districts_info.csv` includes information about the characteristics of school districts, including data from [NCES](https://nces.ed.gov/) (2018-19), [FCC](https://www.fcc.gov/) (Dec 2018), and [Edunomics Lab](https://edunomicslab.org/). In this data set, we removed the identifiable information about the school districts. We also used an open source tool [ARX](https://arx.deidentifier.org/) [(Prasser et al. 2020)](https://onlinelibrary.wiley.com/doi/full/10.1002/spe.2812) to transform several data fields and reduce the risks of re-identification. For data generalization purposes some data points are released with a range where the actual value falls under. Additionally, there are many missing data marked as 'NaN' indicating that the data was suppressed to maximize anonymization of the dataset. 

| Name | Description |
| :--- | :----------- |
| district_id | The unique identifier of the school district |
| state | The state where the district resides in |
| locale | NCES locale classification that categorizes U.S. territory into four types of areas: City, Suburban, Town, and Rural. See [Locale Boundaries User's Manual](https://eric.ed.gov/?id=ED577162) for more information. |
| pct_black/hispanic | Percentage of students in the districts identified as Black or Hispanic based on 2018-19 NCES data |
| pct_free/reduced | Percentage of students in the districts eligible for free or reduced-price lunch based on 2018-19 NCES data |
| county_connections_ratio | `ratio` (residential fixed high-speed connections over 200 kbps in at least one direction/households) based on the county level data from FCC From 477 (December 2018 version). See [FCC data](https://www.fcc.gov/form-477-county-data-internet-access-services) for more information. |
| pp_total_raw | Per-pupil total expenditure (sum of local and federal expenditure) from Edunomics Lab's National Education Resource Database on Schools (NERD$) project. The expenditure data are school-by-school, and we use the median value to represent the expenditure of a given school district. |


### Product information data
The product file `products_info.csv` includes information about the characteristics of the top 372 products with most users in 2020. The categories listed in this file are part of LearnPlatform's product taxonomy. Data were labeled by our team. Some products may not have labels due to being duplicate, lack of accurate url or other reasons.

| Name | Description |
| :--- | :----------- |
| LP ID| The unique identifier of the product |
| URL | Web Link to the specific product |
| Product Name | Name of the specific product |
| Provider/Company Name | Name of the product provider |
| Sector(s) | Sector of education where the product is used |
| Primary Essential Function | The basic function of the product. There are two layers of labels here. Products are first labeled as one of these three categories: LC = Learning & Curriculum, CM = Classroom Management, and SDO = School & District Operations. Each of these categories have multiple sub-categories with which the products were labeled |
