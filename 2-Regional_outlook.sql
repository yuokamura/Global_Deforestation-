## Create a table that shows the Regions and their percent forest area (sum of
## forest area divided by sum of land area) in 1990 and 2016. (Note that 1 sq
## mi = 2.59 sq km).Based on the table you created, ....

SELECT  tab1.region,
        tab1.forest_per_1990,
        tab2.forest_per_2016,
        tab2.forest_per_2016 - tab1.forest_per_1990 AS percent_diff
FROM    (
        SELECT  region,
                SUM(forest_area_sqkm)/SUM(land_area_sqkm) * 100 AS forest_per_1990
        FROM    forestation
        WHERE   year = 1990
          AND   forest_area_per IS NOT NULL -- eliminating null entries in either forest or land area
        GROUP BY 1
        ) AS tab1
  JOIN  (
        SELECT  region,
                SUM(forest_area_sqkm)/SUM(land_area_sqkm) * 100 AS forest_per_2016
        FROM    forestation
        WHERE   year = 2016
          AND   forest_area_per IS NOT NULL
        GROUP BY 1
      ) AS tab2
  ON    tab1.region = tab2.region
ORDER BY 4

## solution 2
## !! The following codes were used to answer the questions
WITH  tab_1990 AS (
                  SELECT  region,
                          SUM(forest_area_sqkm)/SUM(land_area_sqkm) * 100 AS forest_per_region
                  FROM    forestation
                  WHERE   year = 1990
                    AND   forest_area_per IS NOT NULL -- eliminating null entries in either forest or land area
                  GROUP BY 1),
      tab_2016 AS (
                  SELECT  region,
                          SUM(forest_area_sqkm)/SUM(land_area_sqkm) * 100 AS forest_per_region
                  FROM    forestation
                  WHERE   year = 2016
                    AND   forest_area_per IS NOT NULL
                  GROUP BY 1
                  )

## a. What was the percent forest of the entire world in 2016? Which region
## had the HIGHEST percent forest in 2016, and which had the LOWEST,
## to 2 decimal places?

SELECT  region,
        forest_per_region
FROM    tab_2016 --change to tab_1990 for question b
WHERE   region = 'World'

SELECT  region,
        forest_per_region
FROM    tab_2016 -- change to tab_1990 for question b
ORDER BY 2 DESC -- Change to ASC to find the region with min forest percentage
LIMIT 1

## b. What was the percent forest of the entire world in 1990? Which region had
## the HIGHEST percent forest in 1990, and which had the LOWEST, to 2 decimal places?

-- use the code above, with tab_1990

## c. Based on the table you created, which regions of the world DECREASED
## in forest area from 1990 to 2016?

WITH  tab_1990 AS (
                  SELECT  region,
                          SUM(forest_area_sqkm)/SUM(land_area_sqkm) * 100 AS forest_per_region
                  FROM    forestation
                  WHERE   year = 1990
                    AND   forest_area_per IS NOT NULL -- eliminating null entries in either forest or land area
                  GROUP BY 1),
      tab_2016 AS (
                  SELECT  region,
                          SUM(forest_area_sqkm)/SUM(land_area_sqkm) * 100 AS forest_per_region
                  FROM    forestation
                  WHERE   year = 2016
                    AND   forest_area_per IS NOT NULL
                  GROUP BY 1
                  )
SELECT  tab_1990.region,
        tab_1990.forest_per_region AS forest_per_region_1990,
        tab_2016.forest_per_region AS forest_per_region_2016,
        tab_2016.forest_per_region - tab_1990.forest_per_region AS percent_diff
FROM    tab_1990
  JOIN  tab_2016
  ON    tab_1990.region = tab_2016.region
ORDER BY 4
