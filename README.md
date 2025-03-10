
<!-- README.md is generated from README.Rmd. Please edit that file -->

# tbat

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
[![R-CMD-check](https://github.com/emraher/tbat/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/emraher/tbat/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

The goal of `tbat` is to download data from The Banks Association of
Turkey webpage. The webpage has a Data Query System but has no public
API. `tbat` uses POST requests to download data programmatically.

## Features

- **Robust Error Handling**: Comprehensive error detection and reporting
  for network issues, API failures, and invalid inputs
- **Informative Error Messages**: Clear guidance on how to fix issues
  when they occur
- **Parameter Validation**: Automatic validation of input parameters
  with helpful error messages
- **Network Resilience**: Timeouts and connection error handling to
  prevent hanging on slow connections

## Installation

You can install the development version of tbat from
[Github](https://github.com/emraher/tbat) with:

``` r
devtools::install_github("emraher/tbat")
```

## Usage

### Regional Data

There are 3 functions in this section.

- `years_region()`: Requires no inputs. Returns available years.

- `params_region()`: Requires no inputs. Returns parameter and region
  codes.

- `data_region(years = NULL, regions = NULL, parameters = NULL)`: Inputs
  are optional. Returns regional data.

``` r
library(tbat)
        
(df <- params_region())
#> # A tibble: 61 × 6
#>    parametre_uk il_bolge_key   il_bolge     deger_tipi parametre_adi parametre_adi_eng
#>    <chr>        <chr>          <chr>        <chr>      <chr>         <chr>            
#>  1 4978         -363956677     Türkiye      FLOAT      Yurt İçi      Domestic         
#>  2 11978        -363956677     Türkiye      FLOAT      Yurt Dışı     Abroad           
#>  3 4978         1965766610     Marmara Böl… FLOAT      Yurt İçi      Domestic         
#>  4 11978        1965766610     Marmara Böl… FLOAT      Yurt Dışı     Abroad           
#>  5 4978         -1473634822    Ege Bölgesi  FLOAT      Yurt İçi      Domestic         
#>  6 11978        -1473634822    Ege Bölgesi  FLOAT      Yurt Dışı     Abroad           

summary(years_region())
#>       yil       
#>  Min.   :2014  
#>  1st Qu.:2016  
#>  Median :2018  
#>  Mean   :2018  
#>  3rd Qu.:2020  
#>  Max.   :2022
```

If no input argument is given, the function downloads all regional data.
It may take some time to download all data.

You can define `years`, `regions`, and/or `parameters`. To check
available years, regions, and parameters first run `years_region()`
and/or `params_region()`.

- `regions` are codes from `il_bolge_key` column of `params_region()`
  result.

- `parameters` are codes from `parametre_uk` column of `params_region()`
  result.

``` r
(df <- data_region(years = 2018:2019, 
                   regions = c("-363956677", "1965766610"), 
                   parameters = c("4978", "11978")))
#> # A tibble: 16 × 7
#>    yil il_bolge     parametre_adi deger   il_bolge_key parametre_uk il_bolge_eng   
#>    <chr> <chr>        <chr>         <chr>   <chr>        <chr>        <chr>          
#>  1 2018  Türkiye      Yurt İçi      1121567 -363956677   4978         Turkey         
#>  2 2018  Türkiye      Yurt Dışı     84057   -363956677   11978        Turkey         
#>  3 2018  Marmara Böl… Yurt İçi      608246  1965766610   4978         Marmara Region 
#>  4 2018  Marmara Böl… Yurt Dışı     50118   1965766610   11978        Marmara Region 
#>  5 2019  Türkiye      Yurt İçi      1156117 -363956677   4978         Turkey         
#>  6 2019  Türkiye      Yurt Dışı     83585   -363956677   11978        Turkey         
#>  7 2019  Marmara Böl… Yurt İçi      624380  1965766610   4978         Marmara Region 
#>  8 2019  Marmara Böl… Yurt Dışı     49915   1965766610   11978        Marmara Region
```

### Historical Data

There are 2 functions in this section.

- `bank_hist()`: Requires no inputs. Returns historical information
  about banks.

- `gm_hist()`: Requires no inputs. Returns historical information about
  managers.

``` r
(bankHist <- bank_hist())
#> Downloading operating banks data...
#> Downloading closed banks data...
#> # A tibble: 116 × 3
#>    bank                                          establish_year historical_data
#>    <chr>                                         <chr>          <chr>         
#>  1 Adabank A.Ş.                                  1984           1984-....     
#>  2 Akbank T.A.Ş.                                 1948           1948-....     
#>  3 Aktif Yatırım Bankası A.Ş.                    1999           1999-....     
#>  4 Alternatifbank A.Ş. (Alternatif Bank A.Ş.)    1991           1991-....     
#>  5 Anadolubank A.Ş.                              1996           1996-....     
#>  6 Arap Türk Bankası A.Ş.                        1977           1977-....     

(gmHist <- gm_hist())
#> # A tibble: 130 × 10
#>    id    bank  start end   name          eng_name      tr_title      eng_title duty_tr duty_en
#>    <chr> <chr> <chr> <chr> <chr>         <chr>         <chr>         <chr>     <chr>   <chr>  
#>  1 1     1     1924  1938  Celal BAYAR   Celal BAYAR   Umum Müdür    General … İdare … Board…
#>  2 2     1     1938  1960  Sait NURSEL   Sait NURSEL   Umum Müdür    General … İdare … Board…
#>  3 3     1     1960  1964  Münci KAPAN…  Münci KAPANI  Umum Müdür    General … İdare … Board…
#>  4 4     1     1964  1975  Ekrem ARSAN   Ekrem ARSAN   Genel Müdür   General … İdare … Board…
#>  5 5     1     1975  1981  Orhan ERSİN   Orhan ERSİN   Genel Müdür   General … İdare … Board…
```

### Current Infomation Data

There are 2 functions in this section.

- `banks_summary()`: Requires no inputs. Returns number of currently
  operating banks and branches.

- `banks_info(date = format(Sys.time(), "%d/%m/%Y"))`: `date` is
  optional. If date (should be in DD/MM/YYYY format) is given returns
  info for the given date. Returns contact and information about banks.

``` r
(bankSum <- banks_summary())
#> # A tibble: 1 × 2
#>   banks branches
#>   <chr> <chr>   
#> 1 53    11075   

(bankInfo <- banks_info())
#> # A tibble: 53 × 12
#>    banka_tr_adi    banka_eng_adi  tel_no     fax     email  web   merkez_adresi
#>    <chr>           <chr>          <chr>      <chr>   <chr>  <chr> <chr>        
#>  1 Türkiye Cumhu…  Central Bank … (0212) 25… (0212)… iletis… www.… İstiklal Cad…
#>  2 Adabank A.Ş.    Adabank A.Ş.   (0212) 24… (0212)… null   www.… Büyükdere Ca…
#>  3 Akbank T.A.Ş.   Akbank T.A.Ş.  (0212) 38… (0212)… null   www.… Sabancı Cent…
#>  4 Aktif Yatırım…  Aktif Yatırım… (0212) 34… (0212)… info@a… www.… Buyukdere Ca…
```

### Risk Center Data

There are 3 functions in this section.

- `periods_risk()`: Requires no inputs. Returns available periods.

- `categories_risk()`: Requires no inputs. Returns parameter codes.

- `data_risk(categories = NULL, periods = NULL)`: Inputs are optional.
  Returns risk data.

To check available periods and categories first run `periods_risk()`
and/or `categories_risk()`.

- `periods` are codes from `DONEM` column of `periods_risk()` result.

- `categories` are codes from `uk_kategori` column of
  `categories_risk()` result.

``` r
(periodsRisk <- periods_risk())
#> # A tibble: 32 × 4
#>    donem           yil   ay    ay_adi
#>    <chr>           <chr> <chr> <chr> 
#>  1 202211          2022  11    Kasım 
#>  2 202210          2022  10    Ekim  
#>  3 202209          2022  09    Eylül 
#>  4 202208          2022  08    Ağust…
#>  5 202207          2022  07    Temmuz

(categoriesRisk <- categories_risk())
#> # A tibble: 28 × 9
#>    ana_kategori ana_kategori_en uk_rapor rapor_adi     rapor_adi_en uk_kategori
#>    <chr>        <chr>           <chr>    <chr>         <chr>        <chr>      
#>  1 Kişi Sayısı  Number of Pers… 5766825… Kredi Riski … Credit Risk… 1519211213 
#>  2 Kişi Sayısı  Number of Pers… 5766825… Kredi Riski … Credit Risk… -1926721825
#>  3 Kişi Sayısı  Number of Pers… 5766825… Kredi Riski … Credit Risk… 644444219  
#>  4 Kişi Sayısı  Number of Pers… 5766825… Kredi Riski … Credit Risk… 1741293520 
#>  5 Kişi Sayısı  Number of Pers… 5766825… Kredi Riski … Credit Risk… 1493747200 

mycategories <- categoriesRisk %>% 
  dplyr::filter(uk_rapor == 576682514) %>% 
  dplyr::select(uk_kategori) %>% 
  unlist()

myperiods <- periodsRisk %>% 
  dplyr::slice_sample(n = 3) %>% 
  unlist()

(dataRisk <- data_risk(categories = mycategories,
                      periods = myperiods))
#> # A tibble: 58 × 18
#>    donem yil   ay    uk_rapor rapor_adi rapor_adi_en uk_kategori kategori
#>    <chr> <chr> <chr> <chr>    <chr>     <chr>        <chr>       <chr>   
#>  1 20220… 2022  06    576682… Kredi Ri… Credit Risk… 1519211213  Kredisi…
#>  2 20220… 2022  06    576682… Kredi Ri… Credit Risk… 1519211213  Kredisi…
#>  3 20220… 2022  06    576682… Kredi Ri… Credit Risk… 1519211213  Kredisi…
#>  4 20220… 2022  06    576682… Kredi Ri… Credit Risk… -1926721825 Temerrü…
#>  5 20220… 2022  06    576682… Kredi Ri… Credit Risk… -1926721825 Temerrü…
```

### Financial Tables Data

There are 4 functions in this section.

- `periods_financial()`: Requires no inputs. Returns available periods.

- `banks_financial()`: Requires no inputs. Returns bank codes.

- `groups_financial()`: Requires no inputs. Returns bank group codes.

- `tables_financial(bank_code, periods = NULL)`: Returns table codes.

- `data_financial(periods, tables, banks = NULL, groups = NULL)`:
  Returns financial tables data. At least a bank or bank group must be
  chosen.

  - `periods`: Period codes from `periods_financial()` **key** column

  - `tables`: Table codes from `tables_financial()` **unique_key**
    column

  - `banks`: Bank codes from `banks_financial()` **banka_kodu** column

  - `groups`: Group codes from `groups_financial()` **grup_no** column

``` r
(periodsFinancial <- periods_financial())
#> # A tibble: 86 × 5
#>    key         yil   ay    tr_donem            eng_donem          
#>    <chr>       <chr> <chr> <chr>               <chr>              
#>  1 1477300252  2022  06    2022 - Haziran      2022 - June        
#>  2 1477300253  2022  03    2022 - Mart         2022 - March       
#>  3 1477300254  2021  12    2021 - Aralık       2021 - December    
#>  4 1477300255  2021  09    2021 - Eylül        2021 - September   
#>  5 1477300256  2021  06    2021 - Haziran      2021 - June        

(banksFinancial <- banks_financial())
#> # A tibble: 47 × 4
#>    banka_kodu tr_adi                                eng_adi             banka_grup
#>    <chr>      <chr>                                 <chr>               <chr>     
#>  1 1          Türkiye Cumhuriyet Merkez Bankası     Central Bank of t…  6         
#>  2 3          Türkiye İş Bankası A.Ş.               Türkiye İş Bankas…  3         
#>  3 4          Türkiye Vakıflar Bankası T.A.O.        Türkiye Vakıflar …  1         
#>  4 5          Türkiye Halk Bankası A.Ş.             Türkiye Halk Bank…  1         
#>  5 6          Türkiye Garanti Bankası A.Ş.           Türkiye Garanti B…  2         

(groupsFinancial <- groups_financial())
#> # A tibble: 9 × 4
#>   grup_no tr_adi                       eng_adi                    uk_grup     
#>   <chr>   <chr>                        <chr>                      <chr>       
#> 1 1       Kamusal Sermayeli Mevduat … Public Deposit Banks       -1328693357 
#> 2 2       Özel Sermayeli Mevduat Ban… Private Deposit Banks      -1328693356 
#> 3 3       Tasarruf Mevduatı Sigorta … Deposit Banks Under SDIF    1939496508 
#> 4 4       Yabancı Sermayeli Bankalar  Foreign Banks in Turkey     1611697152 
#> 5 5       Kalkınma ve Yatırım Bankası Development and Investmen… -1328693353 

(tablesFinancial <- tables_financial(bank_code = c(3, 5)))
#> # A tibble: 3,172 × 11
#>    banka_kodu unique_key donem       ay    yil   tr_adi        eng_adi       tr_adi_2
#>    <chr>      <chr>      <chr>       <chr> <chr> <chr>         <chr>         <chr>   
#>  1 3          2086       2022 - Haz… 06    2022  Aktif Toplamı Total Assets  Aktif   
#>  2 3          2087       2022 - Haz… 06    2022  NAKİT DEĞERL… CASH AND CAS… Aktif   
#>  3 3          2088       2022 - Haz… 06    2022  Kasa          Cash          NAKİT …
#>  4 3          2089       2022 - Haz… 06    2022  Efektif Depo… Foreign Curr… NAKİT …
#>  5 3          2090       2022 - Haz… 06    2022  Merkez Banka… Central Bank  NAKİT …

(dataFinancial <- data_financial(periods = c(1477300252),
                                 tables = c(2086),
                                 banks = c(3)))
#> # A tibble: 1 × 14
#>   banka_tr_adi yil   ay    tp_deger yp_deger toplam banka_kodu unique_key tr_adi
#>   <chr>        <chr> <chr> <chr>    <chr>    <chr>  <chr>      <chr>      <chr> 
#> 1 Türkiye İş … 2022  06    335598   595693   931292 3          2086       Aktif…

(dataFinancial2 <- data_financial(periods = c(1477300252),
                                  tables = c(2087),
                                  groups = c(1)))
#> # A tibble: 3 × 16
#>   banka_tr_adi banka_eng_adi yil   ay    tr_adi banka_kodu root_tr_adi toplam
#>   <chr>        <chr>         <chr> <chr> <chr>  <chr>      <chr>       <chr> 
#> 1 Kamusal Ser… Public Depos… 2022  06    NAKİT… 1          Aktif       108146
#> 2 Türkiye Vak… Türkiye Vakı… 2022  06    NAKİT… 4          Aktif       41765 
#> 3 Türkiye Hal… Türkiye Halk… 2022  06    NAKİT… 5          Aktif       66380 
```

``` r
(dataFinancial3 <- data_financial(periods = c(1477300252),
                                  tables = c(2087),
                                  banks = c(3),
                                  groups = c(1)))

#> Error: Cannot select both banks and groups at the same time. Choose either banks or groups parameter.
```

## Error Handling Examples

The package includes comprehensive error handling to make debugging
easier:

``` r
# Example of parameter validation error
data_financial(periods = "invalid_period", tables = c(2087), banks = c(3))
#> Error: Invalid periods value(s): invalid_period. Valid values are: 1477300252, 1477300253, ... and others.

# Example of network error handling
data_risk()  # If network is unavailable
#> Error: Network connection failed. Please check your internet connection.

# Example of API response validation
data_financial(periods = c(1477300252), tables = c(9999), banks = c(3))
#> Error: No data returned for the specified parameters. Try different parameters.
```

## Code of Conduct

Please note that the tbat project is released with a [Contributor Code
of
Conduct](https://contributor-covenant.org/version/2/0/CODE_OF_CONDUCT.html).
By contributing to this project, you agree to abide by its terms.
