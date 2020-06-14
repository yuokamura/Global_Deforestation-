## a. Which 5 countries saw the largest amount decrease in forest area from 1990
## to 2016? What was the difference in forest area for each?

## b. Which 5 countries saw the largest percent decrease in forest area from 1990
## to 2016? What was the percent change to 2 decimal places for each?

-- use similar technique to the previos section.  This time, use country_name
-- instead of region

WITH  tab_1990 AS (
                  SELECT  country_name,
                          region,
                          forest_area_sqkm,
                          forest_area_per
                  FROM    forestation
                  WHERE   year = 1990
                    AND   forest_area_per IS NOT NULL),
      tab_2016 AS (
                  SELECT  country_name,
                          region,
                          forest_area_sqkm,
                          forest_area_per
                  FROM    forestation
                  WHERE   year = 2016
                    AND   forest_area_per IS NOT NULL)

SELECT  tab_1990.country_name,
        tab_1990.region,
        tab_1990.forest_area_sqkm AS forest_area_sqkm_1990,
        tab_2016.forest_area_sqkm AS forest_area_sqkm_2016,
        tab_2016.forest_area_sqkm - tab_1990.forest_area_sqkm
        AS sqkm_change_in_forest_area,
        ROUND(CAST((tab_2016.forest_area_sqkm - tab_1990.forest_area_sqkm)
        /tab_1990.forest_area_sqkm*100 AS NUMERIC),2) AS perc_change_in_forest_area
FROM    tab_1990
  JOIN  tab_2016
  ON    tab_1990.country_name = tab_2016.country_name
ORDER BY  5  -- change to 6 to see percent decrease
             -- Change to DESC to see countries doing well
LIMIT 6 -- 'World' has the largest lost land.  Set to 6 to see top 5 countries


## c. If countries were grouped by percent forestation in quartiles, which group
## had the most countries in it in 2016?

-- code below creates the table of countries with respective quartiles
SELECT  country_name,
        region,
        forest_area_per,
        CASE
          WHEN  forest_area_per> 75 THEN 4
          WHEN  forest_area_per> 50 THEN 3
          WHEN  forest_area_per> 25 THEN 2
          ELSE  1
        END AS quartile
FROM    tab_2016
WHERE   country_name != 'World'


-- use the code above as subquery to count number of countries in each quartile

SELECT  quartile,
        COUNT(*)
FROM    (
        SELECT  country_name,
                region,
                forest_area_per,
                CASE
                  WHEN  forest_area_per> 75 THEN 4
                  WHEN  forest_area_per> 50 THEN 3
                  WHEN  forest_area_per> 25 THEN 2
                  ELSE  1
                END AS quartile
        FROM    tab_2016
        WHERE   country_name != 'World'
        ) AS tab_qt
GROUP BY 1
ORDER BY 1



## d. List all of the countries that were in the 4th quartile
##   (percent forest > 75%) in 2016.

SELECT  country_name,
        region,
        forest_area_per
FROM    (
        SELECT  country_name,
                region,
                forest_area_per,
                CASE
                  WHEN  forest_area_per> 75 THEN 4
                  WHEN  forest_area_per> 50 THEN 3
                  WHEN  forest_area_per> 25 THEN 2
                  ELSE  1
                END AS quartile
        FROM    tab_2016
        ) AS tab_qt
WHERE   quartile = 4
ORDER BY 3 DESC

## e. How many countries had a percent forestation higher than the
##    United States in 2016?

SELECT  COUNT(*)
FROM    tab_2016
WHERE   forest_area_per > (
                          SELECT  forest_area_per
                          FROM    tab_2016
                          WHERE   country_name = 'United States'
                          )

## solution = 94
