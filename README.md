
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
#> # A tibble: 2,592 × 12
#>     unique_key tr_adi  en_adi il_bo…¹ param…² param…³ param…⁴ plaka isbolge il_kodu order…⁵ birim
#>          <int> <chr>   <chr>    <int> <chr>   <chr>     <int> <lis> <lgl>     <int>   <int> <chr>
#>  1    23867638 Ağrı    Agri    2.22e6 Çalışa… Number…    4978 <int> FALSE        10       1 M    
#>  2  1296891711 Amasya  Amasya  1.96e9 Çalışa… Number…    4978 <int> FALSE        12       1 M    
#>  3  1594565537 Antalya Antal…  8.18e8 Çalışa… Number…    4978 <int> FALSE        14       1 M    
#>  4 -1963321972 Bilecik Bilec…  1.55e9 Çalışa… Number…    4978 <int> FALSE        18       1 M    
#>  5 -1163046810 Hakkari Hakka… -1.94e9 Çalışa… Number…    4978 <int> FALSE        41       1 M    
#>  6   244117675 Isparta Ispar… -5.33e8 Çalışa… Number…    4978 <int> FALSE        44       1 M    
#>  7    23982768 Kars    Kars    2.33e6 Çalışa… Number…    4978 <int> FALSE        49       1 M    
#>  8   938701306 Kastam… Kasta…  1.53e9 Çalışa… Number…    4978 <int> FALSE        50       1 M    
#>  9 -1391368516 Kırıkk… Kirik… -7.99e8 Çalışa… Number…    4978 <int> FALSE        52       1 M    
#> 10 -1019851622 Malatya Malat… -1.80e9 Çalışa… Number…    4978 <int> FALSE        58       1 M    
#> # … with 2,582 more rows, and abbreviated variable names ¹​il_bolge_key, ²​parametre,
#> #   ³​parametre_en, ⁴​parametre_uk, ⁵​order_no

summary(years_region())
#>   timestamp             status       error             message              path          
#>  Length:1           Min.   :500   Length:1           Length:1           Length:1          
#>  Class :character   1st Qu.:500   Class :character   Class :character   Class :character  
#>  Mode  :character   Median :500   Mode  :character   Mode  :character   Mode  :character  
#>                     Mean   :500                                                           
#>                     3rd Qu.:500                                                           
#>                     Max.   :500
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
#> # A tibble: 8 × 17
#>     yil tr_adi   en_adi   parame…¹ param…² toplam tp_de…³ yp_de…⁴ il_bo…⁵ param…⁶     key uniqu…⁷
#>   <int> <chr>    <chr>    <chr>    <chr>    <dbl>   <dbl>   <dbl>   <int>   <int>   <int>   <int>
#> 1  2018 Ankara   Ankara   ATM Say… Number…   4193    4193       0  1.97e9   11978 -7.65e8  1.29e8
#> 2  2018 Ankara   Ankara   Çalışan… Number…  17732   17732       0  1.97e9    4978 -1.12e9  1.30e9
#> 3  2018 İstanbul Istanbul ATM Say… Number…  11823   11823       0 -3.64e8   11978 -5.89e8 -1.68e8
#> 4  2018 İstanbul Istanbul Çalışan… Number…  82945   82945       0 -3.64e8    4978 -2.37e8 -2.05e9
#> 5  2019 Ankara   Ankara   ATM Say… Number…   4142    4142       0  1.97e9   11978 -7.65e8  1.29e8
#> 6  2019 Ankara   Ankara   Çalışan… Number…  16888   16888       0  1.97e9    4978 -1.12e9  1.30e9
#> 7  2019 İstanbul Istanbul ATM Say… Number…  11933   11933       0 -3.64e8   11978 -5.89e8 -1.68e8
#> 8  2019 İstanbul Istanbul Çalışan… Number…  82315   82315       0 -3.64e8    4978 -2.37e8 -2.05e9
#> # … with 5 more variables: plaka <list>, isbolge <lgl>, il_kodu <int>, order_no <int>,
#> #   birim <chr>, and abbreviated variable names ¹​parametre, ²​parametre_en, ³​tp_deger, ⁴​yp_deger,
#> #   ⁵​il_bolge_key, ⁶​parametre_uk, ⁷​unique_key
```

### Historical Data

There are 2 functions in this section.

- `bank_hist()`: Requires no inputs. Returns historical information
  about banks.

- `gm_hist()`: Requires no inputs. Returns historical information about
  managers.

``` r
(bankHist <- bank_hist())
#> # A tibble: 127 × 3
#>    bank                                       establish_year historical_data                     
#>    <chr>                                      <chr>          <chr>                               
#>  1 Adabank A.Ş.                               1985           "BRSB decided to follow up this ban…
#>  2 Akbank T.A.Ş.                              1948           "\"Akbank T.A.Ş. was founded in Ada…
#>  3 Aktif Yatırım Bankası A.Ş.                 1999           "\"Çalık Yatırım Bankası A.Ş.\", wh…
#>  4 Alternatifbank A.Ş.                        1992           "Alternatif Bank A.Ş. was founded i…
#>  5 Anadolubank A.Ş.                           1997           "During the privatization process o…
#>  6 Arap Türk Bankası A.Ş.                     1977           "Arap Türk Bankası A.Ş. was founded…
#>  7 Bank Mellat                                1984           "Bank Mellat  was founded as a fore…
#>  8 Bank of America Yatırım Bank A.Ş.          1992           "\"Tat Yatırım Bankası A.Ş.\" was f…
#>  9 Bank of China Turkey A.Ş.                  2016           "Bank of China Limited was founded …
#> 10 BankPozitif Kredi ve Kalkınma Bankası A.Ş. 1999           "\"Toprak Yatırım Bankası A.Ş.\" wa…
#> # … with 117 more rows

(gmHist <- gm_hist())
#> # A tibble: 6,239 × 5
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
#> # … with 6,229 more rows
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
#> # A tibble: 64 × 4
#>    bank_group_name                         banks branches_in_turkey branches_abroad
#>    <chr>                                   <dbl>              <int>           <int>
#>  1 The Banking System in Türkiye              52               9593              72
#>  2 Deposit Banks                              35               9521              72
#>  3 State-owned Deposit Banks                   3               3722              35
#>  4 Türkiye Cumhuriyeti Ziraat Bankası A.Ş.    NA               1733              25
#>  5 Türkiye Halk Bankası A.Ş.                  NA               1044               6
#>  6 Türkiye Vakıflar Bankası T.A.O.            NA                945               4
#>  7 Privately-owned Deposit Banks               8               3464              27
#>  8 Akbank T.A.Ş.                              NA                709               1
#>  9 Anadolubank A.Ş.                           NA                116               0
#> 10 Fibabanka A.Ş.                             NA                 44               0
#> # … with 54 more rows

(bankInfo <- banks_info())
#> # A tibble: 55 × 10
#>    bank_name                          address chair…¹ gener…² phone fax   www   kep   eft   swift
#>    <chr>                              <chr>   <chr>   <chr>   <chr> <chr> <chr> <chr> <chr> <chr>
#>  1 The Banking System in Türkiye      "The B… The Ba… The Ba… The … The … The … The … The … The …
#>  2 Türkiye Cumhuriyeti Ziraat Bankas… "Hacıb… Burhan… Alpasl… 312-… 312-… http… zira… 0010  TCZB…
#>  3 Türkiye Halk Bankası A.Ş.          "Barba… Recep … Osman … 216-… 212-… http… halk… 0012  TRHB…
#>  4 Türkiye Vakıflar Bankası T.A.O.    "Saray… Mustaf… Abdi S… 216-… 216-… http… vaki… 0015  TVBA…
#>  5 Akbank T.A.Ş.                      "Saban… Suzan … Sabri … 212-… 212-… http… akba… 0046  AKBK…
#>  6 Anadolubank A.Ş.                   "Saray… Mehmet… Namık … 216-… 216-… http… anad… 0135  ANDL…
#>  7 Fibabanka A.Ş.                     "Esent… Hüsnü … Ömer M… 212-… 212-… http… fiba… 0103  FBHL…
#>  8 Şekerbank T.A.Ş.                   "Emniy… Hasan … Orhan … 212-… 212-… http… seke… 0059  SEKE…
#>  9 Turkish Bank A.Ş.                  "Esent… İbrahi… Mithat… 212-… 212-… http… turk… 0096  TUBA…
#> 10 Türk Ekonomi Bankası A.Ş.          "Saray… Akın A… Ümit L… 216-… 216-… http… turk… 0032  TEBU…
#> # … with 45 more rows, and abbreviated variable names ¹​chairman_of_the_board, ²​general_manager
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
#> # A tibble: 170 × 1
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
#> # … with 160 more rows

(categoriesRisk <- categories_risk())
#> # A tibble: 1,395 × 11
#>      uk_rapor rapor_adi   rapor…¹ uk_ka…² kateg…³ kateg…⁴ alt_k…⁵ alt_k…⁶ alt_k…⁷ alt_k…⁸ uniqu…⁹
#>         <int> <chr>       <chr>     <int> <chr>   <chr>   <chr>   <chr>   <chr>   <chr>     <int>
#>  1  576682514 "Bankalara… Inform…  3.96e8 Bankal… Presen… -       -       -       -        3.96e8
#>  2  576682514 "Bankalara… Inform…  4.20e8 Karşıl… Return… -       -       -       -        4.20e8
#>  3  576682514 "Bankalara… Inform… -8.38e8 Karşıl… Return… -       -       -       -       -8.38e8
#>  4 -738598176 "Bankalara… Distri…  6.06e8 Akdeniz Medite… -       -       -       -        6.06e8
#>  5 -738598176 "Bankalara… Distri…  4.07e8 Batı A… West A… -       -       -       -        4.07e8
#>  6 -738598176 "Bankalara… Distri…  1.89e9 Batı K… West B… -       -       -       -        1.89e9
#>  7 -738598176 "Bankalara… Distri…  1.33e9 Batı M… West M… -       -       -       -        1.33e9
#>  8 -738598176 "Bankalara… Distri… -1.00e9 Diğer   Other   -       -       -       -       -1.00e9
#>  9 -738598176 "Bankalara… Distri…  3.08e8 Doğu K… East B… -       -       -       -        3.08e8
#> 10 -738598176 "Bankalara… Distri… -1.29e9 Doğu M… East M… -       -       -       -       -1.29e9
#> # … with 1,385 more rows, and abbreviated variable names ¹​rapor_adi_en, ²​uk_kategori, ³​kategori,
#> #   ⁴​kategori_en, ⁵​alt_kategori_1, ⁶​alt_kategori_1_en, ⁷​alt_kategori_2, ⁸​alt_kategori_2_en,
#> #   ⁹​unique_key

mycategories <- categoriesRisk %>% 
  dplyr::filter(uk_rapor == 576682514) %>% 
  dplyr::select(uk_kategori) %>% 
  unlist()

myperiods <- periodsRisk %>% 
  dplyr::slice_sample(n = 3) %>% 
  unlist()

(dataRisk <- data_risk(categories = mycategories,
                      periods = myperiods))
#> # A tibble: 9 × 18
#>   donem     yil ay      uk_rapor rapor_…¹ rapor…² uk_ka…³ kateg…⁴ kateg…⁵ alt_k…⁶ alt_k…⁷ alt_k…⁸
#>   <chr>   <int> <chr>      <int> <chr>    <chr>     <int> <chr>   <chr>   <chr>   <chr>   <chr>  
#> 1 2013-09  2013 Eylül  576682514 "Bankal… Inform…  3.96e8 Bankal… Presen… -       -       -      
#> 2 2017-12  2017 Aralık 576682514 "Bankal… Inform…  3.96e8 Bankal… Presen… -       -       -      
#> 3 2022-09  2022 Eylül  576682514 "Bankal… Inform…  3.96e8 Bankal… Presen… -       -       -      
#> 4 2017-12  2017 Aralık 576682514 "Bankal… Inform…  4.20e8 Karşıl… Return… -       -       -      
#> 5 2013-09  2013 Eylül  576682514 "Bankal… Inform…  4.20e8 Karşıl… Return… -       -       -      
#> 6 2022-09  2022 Eylül  576682514 "Bankal… Inform…  4.20e8 Karşıl… Return… -       -       -      
#> 7 2013-09  2013 Eylül  576682514 "Bankal… Inform… -8.38e8 Karşıl… Return… -       -       -      
#> 8 2017-12  2017 Aralık 576682514 "Bankal… Inform… -8.38e8 Karşıl… Return… -       -       -      
#> 9 2022-09  2022 Eylül  576682514 "Bankal… Inform… -8.38e8 Karşıl… Return… -       -       -      
#> # … with 6 more variables: alt_kategori_2_en <chr>, tutar <dbl>, adet <int>,
#> #   tekil_kisi_sayisi <int>, donem_order <int>, unique_key <int>, and abbreviated variable names
#> #   ¹​rapor_adi, ²​rapor_adi_en, ³​uk_kategori, ⁴​kategori, ⁵​kategori_en, ⁶​alt_kategori_1,
#> #   ⁷​alt_kategori_1_en, ⁸​alt_kategori_2
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
#> # A tibble: 124 × 4
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
#> # … with 114 more rows

(banksFinancial <- banks_financial())
#> # A tibble: 51 × 2
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
#> # … with 41 more rows

(groupsFinancial <- groups_financial())
#> # A tibble: 12 × 5
#>    aktif grup_no tr_adi                                                 eng_adi           ust_g…¹
#>    <int>   <int> <chr>                                                  <chr>               <int>
#>  1     0       8 "Türkiye´de Şube Açan Yabancı Sermayeli Bankalar"      Foreign Banks Ha…       4
#>  2     1       9 "Kalkınma ve Yatırım Bankaları"                        Development and …       5
#>  3     0      10 "Kamusal Sermayeli Kalkınma ve Yatırım Bankaları"      State-owned Deve…       9
#>  4     1       5 "Türkiye Bankacılık Sistemi"                           The Banking Syst…       0
#>  5     0      12 "Yabancı Sermayeli Kalkınma ve Yatırım Bankaları"      Foreign Developm…       9
#>  6     1       2 "Kamusal Sermayeli Mevduat Bankaları"                  State-owned Depo…       1
#>  7     1       4 "Yabancı Sermayeli Bankalar"                           Foreign Banks           1
#>  8     0       6 "Türkiye´de Kurulmuş Yabancı Sermayeli Bankalar"       Foreign Banks Fo…       4
#>  9     1       1 " Mevduat Bankaları"                                   Deposit Banks           5
#> 10     1      13 "Tasarruf Mevduatı Sigorta Fonuna Devredilen Bankalar" Banks Under the …       1
#> 11     1       3 "Özel Sermayeli Mevduat Bankaları"                     Privately-owned …       1
#> 12     0      11 "Özel Sermayeli Kalkınma ve Yatırım Bankaları"         Privately-owned …       9
#> # … with abbreviated variable name ¹​ust_grup_no

(tablesFinancial <- tables_financial(bank_code = c(3, 5)))
#> # A tibble: 23,073 × 8
#>    root_tr_adi                         tr_adi        root_…¹ parents sort_…² ust_uk birim uniqu…³
#>    <chr>                               <chr>           <int> <list>  <chr>    <int> <chr>   <int>
#>  1 "ÜÇ-AYLIK HESAP ÖZETİ (..-9/2001) " 1. A K T İ F…    2004 <int>   105.100   2004 M           1
#>  2 "ÜÇ-AYLIK HESAP ÖZETİ (..-9/2001) " NAKİT DEĞERL…    2004 <int>   105.10…      1 M           2
#>  3 "ÜÇ-AYLIK HESAP ÖZETİ (..-9/2001) " Kasa (3)         2004 <int>   105.10…      2 M           3
#>  4 "ÜÇ-AYLIK HESAP ÖZETİ (..-9/2001) " Efektif Depo…    2004 <int>   105.10…      2 M           4
#>  5 "ÜÇ-AYLIK HESAP ÖZETİ (..-9/2001) " Yoldaki Para…    2004 <int>   105.10…      2 M           5
#>  6 "ÜÇ-AYLIK HESAP ÖZETİ (..-9/2001) " Satın Alınan…    2004 <int>   105.10…      2 M           6
#>  7 "ÜÇ-AYLIK HESAP ÖZETİ (..-9/2001) " BANKALAR (7)     2004 <int>   105.10…      1 M           7
#>  8 "ÜÇ-AYLIK HESAP ÖZETİ (..-9/2001) " T.C.M.B. (8)     2004 <int>   105.10…      7 M           8
#>  9 "ÜÇ-AYLIK HESAP ÖZETİ (..-9/2001) " Vadesiz (9)      2004 <int>   105.10…      8 M           9
#> 10 "ÜÇ-AYLIK HESAP ÖZETİ (..-9/2001) " Vadeli (10)      2004 <int>   105.10…      8 M          10
#> # … with 23,063 more rows, and abbreviated variable names ¹​root_key, ²​sort_key, ³​unique_key

(dataFinancial <- data_financial(periods = c(1477300252),
                                 tables = c(2086),
                                 banks = c(3)))
#> # A tibble: 1 × 19
#>   banka_tr_adi   yil    ay tr_adi banka…¹ root_…²  toplam tp_de…³ yp_de…⁴ banka…⁵ donem…⁶ donem…⁷
#>   <chr>        <int> <int> <chr>    <int> <chr>     <dbl>   <dbl>   <dbl> <lgl>     <int>   <int>
#> 1 Türkiye Cum…  2015     9 2. PA…       3 "SOLO-… 2.99e11 1.92e11 1.07e11 FALSE    1.48e9   24189
#> # … with 7 more variables: key <chr>, unique_key <int>, root_key <int>, parents <list>,
#> #   sort_key <chr>, ust_uk <int>, birim <chr>, and abbreviated variable names ¹​banka_kodu,
#> #   ²​root_tr_adi, ³​tp_deger, ⁴​yp_deger, ⁵​banka_grup, ⁶​donem_key, ⁷​donem_order


(dataFinancial2 <- data_financial(periods = c(1477300252),
                                  tables = c(2087),
                                  groups = c(1)))
#> # A tibble: 1 × 22
#>   banka_tr_adi banka…¹   yil    ay tr_adi banka…² root_…³  toplam tp_de…⁴ yp_de…⁵ banka…⁶ donem…⁷
#>   <chr>        <chr>   <int> <int> <chr>    <int> <chr>     <dbl>   <dbl>   <dbl> <lgl>     <int>
#> 1 Mevduat Ban… Deposi…  2015     9 1. AK…       1 "SOLO-… 2.16e12 1.31e12 8.57e11 TRUE     1.48e9
#> # … with 10 more variables: donem_order <int>, key <chr>, unique_key <int>, aktif <int>,
#> #   ust_grup_no <int>, root_key <int>, parents <list>, sort_key <chr>, ust_uk <int>,
#> #   birim <chr>, and abbreviated variable names ¹​banka_eng_adi, ²​banka_kodu, ³​root_tr_adi,
#> #   ⁴​tp_deger, ⁵​yp_deger, ⁶​banka_grup, ⁷​donem_key
```

``` r
(dataFinancial3 <- data_financial(periods = c(1477300252),
                                  tables = c(2087),
                                  banks = c(3),
                                  groups = c(1)))

#> Error in data_financial(periods = c(1477300252), tables = c(2087), banks = c(3),  : 
#> Cannot select both banks and groups at the same time. I'm working on this and will fix it soon!
```

## Code of Conduct

Please note that the tbat project is released with a [Contributor Code
of
Conduct](https://contributor-covenant.org/version/2/0/CODE_OF_CONDUCT.html).
By contributing to this project, you agree to abide by its terms.
