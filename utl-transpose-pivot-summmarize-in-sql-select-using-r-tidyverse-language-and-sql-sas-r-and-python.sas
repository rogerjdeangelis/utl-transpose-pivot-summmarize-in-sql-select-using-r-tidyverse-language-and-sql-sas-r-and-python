%let pgm=utl-transpose-pivot-summmarize-in-sql-select-using-r-tidyverse-language-and-sql-sas-r-and-python;

%stop_submission;

Transpose pivot summmarize in sql select using r tidyverse language and sql sas r and python

  SOLUTIONS

     1 sas sql
     2 r sql
     3 python sql
     4 r tidyverse language

     https://stackoverflow.com/users/7514527/edward

github
https://tinyurl.com/3mcpafh9
https://github.com/rogerjdeangelis/utl-transpose-pivot-summmarize-in-sql-select-using-r-tidyverse-language-and-sql-sas-r-and-python

stackoverflow r
https://tinyurl.com/5cyhpuz
https://stackoverflow.com/questions/78996033/calculating-population-estimate-on-multiple-species-in-same-table

/*               _     _
 _ __  _ __ ___ | |__ | | ___ _ __ ___
| `_ \| `__/ _ \| `_ \| |/ _ \ `_ ` _ \
| |_) | | | (_) | |_) | |  __/ | | | | |
| .__/|_|  \___/|_.__/|_|\___|_| |_| |_|
|_|
*/

/**************************************************************************************************************************/
/*                      |                                                           |                                     */
/*            INPUT     |    PROCESS   CALCULATE NUM[1]^2)/(NUM[1] - NUM[2])        |          OUTPUT                     */
/*            =====     |    ==============================================         |          ======                     */
/*                      |                                                           |                                     */
/* SPECIES  PASS    NUM | CALCULATE ESTIMATED POPULATON(POPEST)                     | SPECIES    NUM1    NUM2     POPEST  */
/*                      |                                                           |                                     */
/*   RGN      1     18  | SPECIES  PASS    NUM     POPEST                           |   RBT       10       3     14.2857  */
/*   RGN      2      5  |                                                           |   RGN       18       5     24.9231  */
/*   RBT      1     10  |   RGN      1     18    NUM[1]^2)/(NUM[1] - NUM[2]         |   XRK        6       .       .      */
/*   RBT      2      3  |   RGN      2      5    18**2/(18-5) = 24.92               |                                     */
/*   XRK      1      6  |                                                           |                                     */
/*                      |   RBT      1     10                                       |                                     */
/*                      |   RBT      2      3    10**2/(10-3) = 14.29               |                                     */
/*                      |                                                           |                                     */
/*                      |   XRK      1      6    6**2/(6 - missing) = missing       |                                     */
/*                      |                                                           |                                     */
/*                      |-----------------------------------------------------------|                                     */
/*                      |                                                           |                                     */
/*                      | SAS (SIMILAR IN R AND PYTHON)                             |                                     */
/*                      | =============================                             |                                     */
/*                      |                                                           |                                     */
/*                      |  proc sql;                                                |                                     */
/*                      |    create                                                 |                                     */
/*                      |      table want as                                        |                                     */
/*                      |    select                                                 |                                     */
/*                      |      species                                              |                                     */
/*                      |     ,max(case when (PASS =1) then Num else . end) as num1 |                                     */
/*                      |     ,max(case when (PASS =2) then Num else . end) as num2 |                                     */
/*                      |     ,calculated num1**2                                   |                                     */
/*                      |         /(calculated num1 - calculated num2) as popest    |                                     */
/*                      |   from                                                    |                                     */
/*                      |      sd1.have                                             |                                     */
/*                      |   group                                                   |                                     */
/*                      |      by species                                           |                                     */
/*                      |  ;quit;                                                   |                                     */
/*                      |                                                           |                                     */
/*                      |-----------------------------------------------------------|                                     */
/*                      |                                                           |                                     */
/*                      | R TIDYVERSE LANGUAGE ( |>, arrange, summarize,drop_na,by) |                                     */
/*                      | ========================================================= |                                     */
/*                      |                                                           |                                     */
/*                      | library(tidyverse)                                        |                                     */
/*                      | want <- have |>                                           |                                     */
/*                      |   arrange(SPECIES, PASS) |>                               |                                     */
/*                      |   summarize(                                              |                                     */
/*                      |     POPEST = (NUM[1]^2)/(NUM[1] - NUM[2]),                |                                     */
/*                      |     .by = SPECIES                                         |                                     */
/*                      |   ) |>                                                    |                                     */
/*                      |   tidyr::drop_na()                                        |                                     */
/*                      |                                                           |                                     */
/**************************************************************************************************************************/

/*                   _
(_)_ __  _ __  _   _| |_
| | `_ \| `_ \| | | | __|
| | | | | |_) | |_| | |_
|_|_| |_| .__/ \__,_|\__|
        |_|
*/


options validvarname=upcase;
libname sd1 "d:/sd1";
data sd1.have;
input Species$ Pass Num;
cards4;
RGN   1   18
RGN   2    5
RBT   1   10
RBT   2    3
XRK   1    6
;;;;
run;quit;

/**************************************************************************************************************************/
/*                                                                                                                        */
/* SPECIES    PASS    NUM                                                                                                 */
/*                                                                                                                        */
/*   RGN        1      18                                                                                                 */
/*   RGN        2       5                                                                                                 */
/*   RBT        1      10                                                                                                 */
/*   RBT        2       3                                                                                                 */
/*   XRK        1       6                                                                                                 */
/*                                                                                                                        */
/**************************************************************************************************************************/

/*                             _
/ |  ___  __ _ ___   ___  __ _| |
| | / __|/ _` / __| / __|/ _` | |
| | \__ \ (_| \__ \ \__ \ (_| | |
|_| |___/\__,_|___/ |___/\__, |_|
                            |_|
*/

proc sql;
  create
    table want as
  select
    species
   ,max(case when ( PASS =1 ) then Num else . end) as num1
   ,max(case when ( PASS =2 ) then Num else . end) as num2
   ,calculated num1**2
       /(calculated num1 - calculated num2) as popest
 from
    sd1.have
 group
    by species
;quit;

proc print data=sd1.want;
run;quit;

/**************************************************************************************************************************/
/*                                                                                                                        */
/*  WANT total obs=3 12OCT2024:09:53:39                                                                                   */
/*                                                                                                                        */
/*   SPECIES    NUM1    NUM2     POPEST                                                                                   */
/*                                                                                                                        */
/*     RBT       10       3     14.2857                                                                                   */
/*     RGN       18       5     24.9231                                                                                   */
/*     XRK        6       .       .                                                                                       */
/*                                                                                                                        */
/**************************************************************************************************************************/

/*___                     _
|___ \   _ __   ___  __ _| |
  __) | | `__| / __|/ _` | |
 / __/  | |    \__ \ (_| | |
|_____| |_|    |___/\__, |_|
                       |_|
*/

%utl_rbeginx;
parmcards4;
library(sqldf)
library(haven)
source("c:/oto/fn_tosas9x.R")
have<-read_sas("d:/sd1/have.sas7bdat")
print(have)
want <- sqldf('
 select
    species
   ,num1*num1/(num1-num2) as popest
 from
     (select
       species
      ,max(case when ( PASS =1 ) then Num else null end) as num1
      ,max(case when ( PASS =2 ) then Num else null end) as num2
     from
       have
     group
       by species)
 ')
want
fn_tosas9x(
      inp    = want
     ,outlib ="d:/sd1/"
     ,outdsn ="sqlwant"
     )
;;;;
%utl_rendx;

proc print data=sd1.sqlwant;
run;quit;

/**************************************************************************************************************************/
/*                                                                                                                        */
/*                                                                                                                        */
/*    R                      SAS                                                                                          */
/*                                                                                                                        */
/*    > want                 ROWNAMES    SPECIES     POPEST                                                               */
/*      species   popest                                                                                                  */
/*    1     RBT 14.28571         1         RBT      14.2857                                                               */
/*    2     RGN 24.92308         2         RGN      24.9231                                                               */
/*    3     XRK       NA         3         XRK        .                                                                   */
/*                                                                                                                        */
/**************************************************************************************************************************/

/*____               _   _                             _
|___ /   _ __  _   _| |_| |__   ___  _ __    ___  __ _| |
  |_ \  | `_ \| | | | __| `_ \ / _ \| `_ \  / __|/ _` | |
 ___) | | |_) | |_| | |_| | | | (_) | | | | \__ \ (_| | |
|____/  | .__/ \__, |\__|_| |_|\___/|_| |_| |___/\__, |_|
        |_|    |___/                                |_|
*/


proc datasets lib=sd1 nolist nodetails;
 delete pywant;
run;quit;

%utl_pybeginx;
parmcards4;
exec(open('c:/oto/fn_python.py').read());
have,meta = ps.read_sas7bdat('d:/sd1/have.sas7bdat');
want=pdsql('''
 select
    species
   ,num1*num1/(num1-num2) as popest
 from
     (select
       species
      ,max(case when ( PASS =1 ) then Num else null end) as num1
      ,max(case when ( PASS =2 ) then Num else null end) as num2
     from
       have
     group
       by species)
   ''');
print(want);
fn_tosas9x(want,outlib='d:/sd1/',outdsn='pywant',timeest=3);
;;;;
%utl_pyendx;

proc print data=sd1.pywant;
run;quit;

/**************************************************************************************************************************/
/*                                                                                                                        */
/*     PYTHON                      SPECIES     POPEST                                                                     */
/*                                                                                                                        */
/*       species     popest                                                                                               */
/*     0     RBT  14.285714          RBT      14.2857                                                                     */
/*     1     RGN  24.923077          RGN      24.9231                                                                     */
/*     2     XRK        NaN          XRK        .                                                                         */
/*                                                                                                                        */
/**************************************************************************************************************************/

/*  _     _   _     _                                _
| || |   | |_(_) __| |_   ___   _____ _ __ ___  ___ | | __ _ _ __   __ _ _   _  __ _  __ _  ___
| || |_  | __| |/ _` | | | \ \ / / _ \ `__/ __|/ _ \| |/ _` | `_ \ / _` | | | |/ _` |/ _` |/ _ \
|__   _| | |_| | (_| | |_| |\ V /  __/ |  \__ \  __/| | (_| | | | | (_| | |_| | (_| | (_| |  __/
   |_|    \__|_|\__,_|\__, | \_/ \___|_|  |___/\___||_|\__,_|_| |_|\__, |\__,_|\__,_|\__, |\___|
                      |___/                                        |___/             |___/
*/

%utl_rbeginx;
parmcards4;
library(tidyverse)
library(haven)
source("c:/oto/fn_tosas9x.R")
have<-read_sas("d:/sd1/have.sas7bdat")
print(have)
want <- have |>
  arrange(SPECIES, PASS) |>
  summarize(
    POPEST = (NUM[1]^2)/(NUM[1] - NUM[2]),
    .by = SPECIES
  ) |>
  tidyr::drop_na()
want
fn_tosas9x(
      inp    = want
     ,outlib ="d:/sd1/"
     ,outdsn ="rtidy"
     )
;;;;
%utl_rendx;

proc print data=sd1.rtidy;
run;quit;

/**************************************************************************************************************************/
/*                                                                                                                        */
/* R                                                                                                                      */
/*                        SAS                                                                                             */
/*  > want                                                                                                                */
/*  # A tibble: 2 Ã— 2                                                                                                    */
/*    SPECIES POPEST      ROWNAMES    SPECIES     POPEST                                                                  */
/*    <chr>    <dbl>                                                                                                      */
/*                            1         RBT      14.2857                                                                  */
/*  1 RBT       14.3          2         RGN      24.9231                                                                  */
/*  2 RGN       24.9                                                                                                      */
/*                                                                                                                        */
/**************************************************************************************************************************/

/*              _
  ___ _ __   __| |
 / _ \ `_ \ / _` |
|  __/ | | | (_| |
 \___|_| |_|\__,_|

*/
