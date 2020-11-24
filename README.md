
<!-- README.md is generated from README.Rmd. Please edit that file -->

# tbat

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
[![R build
status](https://github.com/emraher/tbat/workflows/R-CMD-check/badge.svg)](https://github.com/emraher/tbat/actions)
<!-- badges: end -->

The goal of `tbat` is to download data from The Banks Association of
Turkey webpage. The webpage has a Data Query System but has no public
API. `tbat` uses POST requests to download data programmatically.

## Installation

You can install the development version of tbat from
[Github](https://github.com/emraher/tbat) with:

``` r
devtool::install_github("emraher/tbat")
```

## Usage

### Regional Data

There are 3 functions in this section.

-   `years_region()`: Requires no inputs. Returns available years.

-   `params_region()`: Requires no inputs. Returns parameter and region
    codes.

-   `data_region(years = NULL, regions = NULL, parameters = NULL)`:
    Inputs are optional. Returns regional data.

``` r
library(tbat)
        
(df <- params_region())
#> # A tibble: 2,592 x 12
#>    unique_key tr_adi en_adi il_bolge_key parametre parametre_en parametre_uk plaka
#>         <int> <chr>  <chr>         <int> <chr>     <chr>               <int> <lis>
#>  1     2.39e7 Ağrı   Ağrı        2216061 Çalışan … Number of E…         4978 <int…
#>  2     1.30e9 Amasya Amasya   1964562694 Çalışan … Number of E…         4978 <int…
#>  3     1.59e9 Antal… Antal…    817529530 Çalışan … Number of E…         4978 <int…
#>  4    -1.96e9 Bilec… Bilec…   1554609317 Çalışan … Number of E…         4978 <int…
#>  5    -1.16e9 Hakka… Hakka…  -1940082817 Çalışan … Number of E…         4978 <int…
#>  6     2.44e8 Ispar… Ispar…   -532918332 Çalışan … Number of E…         4978 <int…
#>  7     2.40e7 Kars   Kars        2331191 Çalışan … Number of E…         4978 <int…
#>  8     9.39e8 Kasta… Kasta…   1531408083 Çalışan … Number of E…         4978 <int…
#>  9    -1.39e9 Kırık… Kırık…   -798661739 Çalışan … Number of E…         4978 <int…
#> 10    -1.02e9 Malat… Malat…  -1796887629 Çalışan … Number of E…         4978 <int…
#> # … with 2,582 more rows, and 4 more variables: isbolge <lgl>, il_kodu <int>,
#> #   order_no <int>, birim <chr>

summary(years_region())
#>       yil      
#>  Min.   :1988  
#>  1st Qu.:1996  
#>  Median :2004  
#>  Mean   :2004  
#>  3rd Qu.:2011  
#>  Max.   :2019
```

If no input argument is given, the function downloads all regional data.
It may take some time to download all data.

You can define `years`, `regions`, and/or `parameters`. To check
available years, regions, and parameters first run `years_region()`
and/or `params_region()`.

-   `regions` are codes from `il_bolge_key` column of `params_region()`
    result.

-   `parameters` are codes from `parametre_uk` column of
    `params_region()` result.

``` r
(df <- data_region(years = 2018:2019, 
                   regions = c("-363956677", "1965766610"), 
                   parameters = c("4978", "11978")))
#> # A tibble: 8 x 17
#>     yil tr_adi en_adi parametre parametre_en toplam tp_deger yp_deger il_bolge_key
#>   <int> <chr>  <chr>  <chr>     <chr>         <dbl>    <dbl>    <dbl>        <int>
#> 1  2018 Ankara Ankara ATM Sayı… Number of A…   4193     4193        0   1965766610
#> 2  2018 Ankara Ankara Çalışan … Number of E…  17732    17732        0   1965766610
#> 3  2018 İstan… İstan… ATM Sayı… Number of A…  11823    11823        0   -363956677
#> 4  2018 İstan… İstan… Çalışan … Number of E…  82945    82945        0   -363956677
#> 5  2019 Ankara Ankara ATM Sayı… Number of A…   4142     4142        0   1965766610
#> 6  2019 Ankara Ankara Çalışan … Number of E…  16888    16888        0   1965766610
#> 7  2019 İstan… İstan… ATM Sayı… Number of A…  11933    11933        0   -363956677
#> 8  2019 İstan… İstan… Çalışan … Number of E…  82315    82315        0   -363956677
#> # … with 8 more variables: parametre_uk <int>, key <int>, unique_key <int>,
#> #   plaka <list>, isbolge <lgl>, il_kodu <int>, order_no <int>, birim <chr>
```

### Historical Data

There are 2 functions in this section.

-   `bank_hist()`: Requires no inputs. Returns historical information
    about banks.

-   `gm_hist()`: Requires no inputs. Returns historical information
    about managers.

``` r
(bankHist <- bank_hist())
#> # A tibble: 125 x 3
#>    bank                   establish_year historical_data                                
#>    <chr>                  <chr>          <chr>                                          
#>  1 Adabank A.Ş.           1985           "BRSB decided to follow up this bank according…
#>  2 Akbank T.A.Ş.          1948           "\"Akbank T.A.Ş. was founded in Adana in 30 Ja…
#>  3 Aktif Yatırım Bankası… 1999           "\"Çalık Yatırım Bankası A.Ş.\", which is a su…
#>  4 Alternatifbank A.Ş.    1992           "Alternatif Bank A.Ş. was founded in 24 Februa…
#>  5 Anadolubank A.Ş.       1996           "Anadolubank A.Ş.,  which is a subsidiary comp…
#>  6 Arap Türk Bankası A.Ş. 1977           "Arap Türk Bankası A.Ş. was founded in 18 July…
#>  7 Bank Mellat            1984           "Bank Mellat  was founded as a foreign bank ha…
#>  8 Bank of China Turkey … 2016           "Bank of China Limited was founded according t…
#>  9 BankPozitif Kredi ve … 1999           "\"Toprak Yatırım Bankası A.Ş.\" was founded i…
#> 10 Birleşik Fon Bankası … 1958           "Çaybank A.Ş. was founded as a local bank in 1…
#> # … with 115 more rows

(gmHist <- gm_hist())
#> # A tibble: 6,006 x 5
#>    bank         closed closed_date  year gm   
#>    <chr>         <dbl>       <dbl> <dbl> <chr>
#>  1 Adabank A.Ş.      0          NA  1962 <NA> 
#>  2 Adabank A.Ş.      0          NA  1963 <NA> 
#>  3 Adabank A.Ş.      0          NA  1964 <NA> 
#>  4 Adabank A.Ş.      0          NA  1965 <NA> 
#>  5 Adabank A.Ş.      0          NA  1966 <NA> 
#>  6 Adabank A.Ş.      0          NA  1967 <NA> 
#>  7 Adabank A.Ş.      0          NA  1968 <NA> 
#>  8 Adabank A.Ş.      0          NA  1969 <NA> 
#>  9 Adabank A.Ş.      0          NA  1970 <NA> 
#> 10 Adabank A.Ş.      0          NA  1971 <NA> 
#> # … with 5,996 more rows
```

### Current Infomation Data

There are 2 functions in this section.

-   `banks_summary()`: Requires no inputs. Returns number of currently
    operating banks and branches.

-   `banks_info(date = format(Sys.time(), "%d/%m/%Y"))`: `date` is
    optional. If date (should be in DD/MM/YYYY format) is given returns
    info for the given date. Returns contact and information about
    banks.

``` r
(bankSum <- banks_summary())
#> # A tibble: 60 x 4
#>    bank_group_name                         banks branches_in_turkey branches_abroad
#>    <chr>                                   <dbl>              <int>           <int>
#>  1 The Banking System in Turkey               48               9938              71
#>  2 Deposit Banks                              34               9876              71
#>  3 State-owned Deposit Banks                   3               3673              33
#>  4 Türkiye Cumhuriyeti Ziraat Bankası A.Ş.    NA               1734              24
#>  5 Türkiye Halk Bankası A.Ş.                  NA               1006               6
#>  6 Türkiye Vakıflar Bankası T.A.O.            NA                933               3
#>  7 Privately-owned Deposit Banks               9               3656              28
#>  8 Adabank A.Ş.                               NA                  1               0
#>  9 Akbank T.A.Ş.                              NA                716               1
#> 10 Anadolubank A.Ş.                           NA                114               0
#> # … with 50 more rows

(bankInfo <- banks_info())
#> # A tibble: 48 x 10
#>    bank_name address chairman_of_the… general_manager phone fax   www   kep   eft  
#>    <chr>     <chr>   <chr>            <chr>           <chr> <chr> <chr> <chr> <chr>
#>  1 Türkiye … Hacıba… Ahmet Genç       Hüseyin Aydın   312-… 312-… http… zira… 0010 
#>  2 Türkiye … Barbar… Recep Süleyman … Osman Arslan    216-… 212-… http… halk… 0012 
#>  3 Türkiye … Saray … Abdülkadir Aksu  Abdi Serdar Üs… 216-… 216-… http… vaki… 0015 
#>  4 Adabank … Büyükd… Çağrı Seyfi      Metehan Özpeki… 212-… 212-… http… adab… 0100 
#>  5 Akbank T… Sabanc… Suzan Sabancı D… S.Hakan Binbaş… 212-… 212-… http… akba… 0046 
#>  6 Anadolub… Saray … Mehmet Rüştü Ba… Namık Ülke      216-… 216-… http… anad… 0135 
#>  7 Fibabank… Esente… Hüsnü Mustafa Ö… Ömer Mert       212-… 212-… http… fiba… 0103 
#>  8 Şekerban… Emniye… Hasan Basri Gök… Nariman Zharkı… 212-… 212-… http… seke… 0059 
#>  9 Turkish … Vali K… İbrahim Hakan B… Mithat Arikan   212-… 212-… http… turk… 0096 
#> 10 Türk Eko… Saray … Yavuz Canevi     Ümit Leblebici  216-… 216-… http… turk… 0032 
#> # … with 38 more rows, and 1 more variable: swift <chr>
```

### Risk Center Data

There are 3 functions in this section.

-   `periods_risk()`: Requires no inputs. Returns available periods.

-   `categories_risk()`: Requires no inputs. Returns parameter codes.

-   `data_risk(categories = NULL, periods = NULL)`: Inputs are optional.
    Returns risk data.

To check available periods and categories first run `periods_risk()`
and/or `categories_risk()`.

-   `periods` are codes from `DONEM` column of `periods_risk()` result.

-   `categories` are codes from `uk_kategori` column of
    `categories_risk()` result.

``` r
(periodsRisk <- periods_risk())
#> # A tibble: 142 x 1
#>    DONEM  
#>    <chr>  
#>  1 2017-10
#>  2 2017-11
#>  3 2012-01
#>  4 2017-12
#>  5 2012-04
#>  6 2012-05
#>  7 2012-02
#>  8 2012-03
#>  9 2012-08
#> 10 2012-09
#> # … with 132 more rows

(categoriesRisk <- categories_risk())
#> # A tibble: 1,459 x 11
#>    uk_rapor rapor_adi rapor_adi_en uk_kategori kategori kategori_en alt_kategori_1
#>       <int> <chr>     <chr>              <int> <chr>    <chr>       <chr>         
#>  1  -1.04e9 "Bankala… Distributio…   369967857 Akdeniz  Mediterran… -             
#>  2  -1.04e9 "Bankala… Distributio… -1651575777 Batı An… West Anato… -             
#>  3  -1.04e9 "Bankala… Distributio…  -705182512 Batı Ka… West Black… -             
#>  4  -1.04e9 "Bankala… Distributio…  -728856168 Batı Ma… West Marma… -             
#>  5  -1.04e9 "Bankala… Distributio…  -523036412 Diğer    Other       -             
#>  6  -1.04e9 "Bankala… Distributio…  2008209749 Doğu Ka… East Black… -             
#>  7  -1.04e9 "Bankala… Distributio…   949943133 Doğu Ma… East Marma… -             
#>  8  -1.04e9 "Bankala… Distributio…  -285334560 Ege      Aegean      -             
#>  9  -1.04e9 "Bankala… Distributio…   631366675 Güneydo… South-East… -             
#> 10  -1.04e9 "Bankala… Distributio…   -82262122 İstanbul İstanbul    -             
#> # … with 1,449 more rows, and 4 more variables: alt_kategori_1_en <chr>,
#> #   alt_kategori_2 <chr>, alt_kategori_2_en <chr>, unique_key <int>

(dataRisk <- data_risk(categories = c(-285334560, 2008209749, 949943133),
                       periods = c("2014-08", "2019-12")))
#> # A tibble: 6 x 18
#>   donem   yil ay    uk_rapor rapor_adi rapor_adi_en uk_kategori kategori kategori_en
#>   <chr> <int> <chr>    <int> <chr>     <chr>              <int> <chr>    <chr>      
#> 1 2014…  2014 Ağus…  -1.04e9 "Bankala… Distributio…  2008209749 Doğu Ka… East Black…
#> 2 2019…  2019 Aral…  -1.04e9 "Bankala… Distributio…  2008209749 Doğu Ka… East Black…
#> 3 2014…  2014 Ağus…  -1.04e9 "Bankala… Distributio…   949943133 Doğu Ma… East Marma…
#> 4 2019…  2019 Aral…  -1.04e9 "Bankala… Distributio…   949943133 Doğu Ma… East Marma…
#> 5 2019…  2019 Aral…  -1.04e9 "Bankala… Distributio…  -285334560 Ege      Aegean     
#> 6 2014…  2014 Ağus…  -1.04e9 "Bankala… Distributio…  -285334560 Ege      Aegean     
#> # … with 9 more variables: alt_kategori_1 <chr>, alt_kategori_1_en <chr>,
#> #   alt_kategori_2 <chr>, alt_kategori_2_en <chr>, tutar <dbl>, adet <int>,
#> #   tekil_kisi_sayisi <int>, donem_order <int>, unique_key <int>

# -------------------------------------------------------------------------- ###
# Another Example using data from categoriesRisk and periodsRisk
# -------------------------------------------------------------------------- ###

mycategories <- categoriesRisk %>% 
  dplyr::filter(uk_rapor == 621177206) %>% 
  dplyr::select(uk_kategori) %>% 
  unlist()

myperiods <- periodsRisk %>% 
  dplyr::slice_sample(n = 3) %>% 
  unlist()

(dataRisk <- data_risk(categories = mycategories,
                      periods = myperiods))
#> # A tibble: 244 x 18
#>    donem   yil ay    uk_rapor rapor_adi rapor_adi_en uk_kategori kategori kategori_en
#>    <chr> <int> <chr>    <int> <chr>     <chr>              <int> <chr>    <chr>      
#>  1 2018…  2018 Ocak    6.21e8 "Bankala… Distributio…   827101828 Adana    Adana      
#>  2 2019…  2019 Aral…   6.21e8 "Bankala… Distributio…   827101828 Adana    Adana      
#>  3 2009…  2009 Eylül   6.21e8 "Bankala… Distributio…   827101828 Adana    Adana      
#>  4 2019…  2019 Aral…   6.21e8 "Bankala… Distributio…   380168905 Adıyaman Adıyaman   
#>  5 2018…  2018 Ocak    6.21e8 "Bankala… Distributio…   380168905 Adıyaman Adıyaman   
#>  6 2009…  2009 Eylül   6.21e8 "Bankala… Distributio…   380168905 Adıyaman Adıyaman   
#>  7 2018…  2018 Ocak    6.21e8 "Bankala… Distributio… -1503599664 Afyonka… Afyonkarah…
#>  8 2009…  2009 Eylül   6.21e8 "Bankala… Distributio… -1503599664 Afyonka… Afyonkarah…
#>  9 2019…  2019 Aral…   6.21e8 "Bankala… Distributio… -1503599664 Afyonka… Afyonkarah…
#> 10 2018…  2018 Ocak    6.21e8 "Bankala… Distributio…  1646672514 Ağrı     Ağrı       
#> # … with 234 more rows, and 9 more variables: alt_kategori_1 <chr>,
#> #   alt_kategori_1_en <chr>, alt_kategori_2 <chr>, alt_kategori_2_en <chr>,
#> #   tutar <dbl>, adet <int>, tekil_kisi_sayisi <int>, donem_order <int>,
#> #   unique_key <int>
```

### Financial Tables Data

There are 4 functions in this section.

-   `periods_financial()`: Requires no inputs. Returns available
    periods.

-   `banks_financial()`: Requires no inputs. Returns bank codes.

-   `groups_financial()`: Requires no inputs. Returns bank group codes.

-   `tables_financial(bank_code, periods = NULL)`: Returns table codes.

-   `data_financial(periods, tables, banks = NULL, groups = NULL)`:
    Returns financial tables data. At least a bank or bank group must be
    chosen.

    -   `periods`: Period codes from `periods_financial()` **key**
        column

    -   `tables`: Table codes from `tables_financial()` **unique\_key**
        column

    -   `banks`: Bank codes from `banks_financial()` **banka\_kodu**
        column

    -   `groups`: Group codes from `groups_financial()` **grup\_no**
        column

``` r
(periodsFinancial <- periods_financial())
#> # A tibble: 115 x 4
#>      yil    ay donem_order         key
#>    <int> <int>       <int>       <int>
#>  1  1988    12       23868 -2071619944
#>  2  1989    12       23880 -2071590153
#>  3  1990    12       23892 -2070934751
#>  4  1991    12       23904 -2070904960
#>  5  1992    12       23916 -2070875169
#>  6  1993     3       23919  1457219190
#>  7  1993     6       23922  1457219193
#>  8  1993     9       23925  1457219196
#>  9  1993    12       23928 -2070845378
#> 10  1994     3       23931  1457220151
#> # … with 105 more rows

(banksFinancial <- banks_financial())
#> # A tibble: 48 x 2
#>    tr_adi                                  banka_kodu
#>    <chr>                                        <int>
#>  1 Türkiye Cumhuriyeti Ziraat Bankası A.Ş.          3
#>  2 Türkiye Halk Bankası A.Ş.                        5
#>  3 Türkiye Vakıflar Bankası T.A.O.                  6
#>  4 Adabank A.Ş.                                     7
#>  5 Akbank T.A.Ş.                                    8
#>  6 Alternatifbank A.Ş.                              9
#>  7 Burgan Bank A.Ş.                                10
#>  8 Birleşik Fon Bankası A.Ş.                       12
#>  9 QNB Finansbank A.Ş.                             15
#> 10 Şekerbank T.A.Ş.                                22
#> # … with 38 more rows

(groupsFinancial <- groups_financial())
#> # A tibble: 12 x 5
#>    aktif grup_no tr_adi                          eng_adi                     ust_grup_no
#>    <int>   <int> <chr>                           <chr>                             <int>
#>  1     0       8 "Türkiye´de Şube Açan Yabancı … Foreign Banks Having Branc…           4
#>  2     1       9 "Kalkınma ve Yatırım Bankaları" Development and Investment…           5
#>  3     0      10 "Kamusal Sermayeli Kalkınma ve… State-owned Development an…           9
#>  4     1       5 "Türkiye Bankacılık Sistemi"    The Banking System in Turk…           0
#>  5     0      12 "Yabancı Sermayeli Kalkınma ve… Foreign Development and In…           9
#>  6     1       2 "Kamusal Sermayeli Mevduat Ban… State-owned Deposit Banks             1
#>  7     1       4 "Yabancı Sermayeli Bankalar"    Foreign Banks                         1
#>  8     0       6 "Türkiye´de Kurulmuş Yabancı S… Foreign Banks Founded in T…           4
#>  9     1       1 " Mevduat Bankaları"            Deposit Banks                         5
#> 10     1      13 "Tasarruf Mevduatı Sigorta Fon… Banks Under the Deposit In…           1
#> 11     1       3 "Özel Sermayeli Mevduat Bankal… Privately-owned Deposit Ba…           1
#> 12     0      11 "Özel Sermayeli Kalkınma ve Ya… Privately-owned Developmen…           9

(tablesFinancial <- tables_financial(bank_code = c(3, 5)))
#> # A tibble: 22,795 x 8
#>    root_tr_adi        tr_adi        root_key parents sort_key    ust_uk birim unique_key
#>    <chr>              <chr>            <int> <list>  <chr>        <int> <chr>      <int>
#>  1 ÜÇ-AYLIK HESAP ÖZ… 1. A K T İ F      2004 <int [… 105.100       2004 M              1
#>  2 ÜÇ-AYLIK HESAP ÖZ… NAKİT DEĞERL…     2004 <int [… 105.100.100      1 M              2
#>  3 ÜÇ-AYLIK HESAP ÖZ… Kasa              2004 <int [… 105.100.10…      2 M              3
#>  4 ÜÇ-AYLIK HESAP ÖZ… Efektif Depo…     2004 <int [… 105.100.10…      2 M              4
#>  5 ÜÇ-AYLIK HESAP ÖZ… Yoldaki Para…     2004 <int [… 105.100.10…      2 M              5
#>  6 ÜÇ-AYLIK HESAP ÖZ… Satın Alınan…     2004 <int [… 105.100.10…      2 M              6
#>  7 ÜÇ-AYLIK HESAP ÖZ… BANKALAR          2004 <int [… 105.100.101      1 M              7
#>  8 ÜÇ-AYLIK HESAP ÖZ… T.C.M.B.          2004 <int [… 105.100.10…      7 M              8
#>  9 ÜÇ-AYLIK HESAP ÖZ… Vadesiz           2004 <int [… 105.100.10…      8 M              9
#> 10 ÜÇ-AYLIK HESAP ÖZ… Vadeli            2004 <int [… 105.100.10…      8 M             10
#> # … with 22,785 more rows

(dataFinancial <- data_financial(periods = c(1477300252),
                                 tables = c(2086),
                                 banks = c(3)))
#> # A tibble: 1 x 19
#>   banka_tr_adi   yil    ay tr_adi banka_kodu root_tr_adi  toplam tp_deger yp_deger
#>   <chr>        <int> <int> <chr>       <int> <chr>         <dbl>    <dbl>    <dbl>
#> 1 Türkiye Cum…  2015     9 2. PA…          3 SOLO-BANKA… 2.99e11  1.92e11  1.07e11
#> # … with 10 more variables: banka_grup <lgl>, donem_key <int>, donem_order <int>,
#> #   key <chr>, unique_key <int>, root_key <int>, parents <list>, sort_key <chr>,
#> #   ust_uk <int>, birim <chr>


(dataFinancial2 <- data_financial(periods = c(1477300252),
                                  tables = c(2087),
                                  groups = c(1)))
#> # A tibble: 1 x 22
#>   banka_tr_adi banka_eng_adi   yil    ay tr_adi banka_kodu root_tr_adi  toplam tp_deger
#>   <chr>        <chr>         <int> <int> <chr>       <int> <chr>         <dbl>    <dbl>
#> 1 Mevduat Ban… Deposit Banks  2015     9 1. AK…          1 SOLO-BANKA… 2.16e12  1.31e12
#> # … with 13 more variables: yp_deger <dbl>, banka_grup <lgl>, donem_key <int>,
#> #   donem_order <int>, key <chr>, unique_key <int>, aktif <int>, ust_grup_no <int>,
#> #   root_key <int>, parents <list>, sort_key <chr>, ust_uk <int>, birim <chr>
```

``` r
(dataFinancial3 <- data_financial(periods = c(1477300252),
                                  tables = c(2087),
                                  banks = c(3),
                                  groups = c(1)))

#> Error in data_financial(periods = c(1477300252), tables = c(2087), banks = c(3),  : 
#> Cannot select both banks and groups at the same time. I'm working on this and will fix it soon!
```
