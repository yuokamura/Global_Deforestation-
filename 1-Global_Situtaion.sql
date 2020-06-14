## a. What was the total forest area (in sq km) of the world in 1990?
## Please keep in mind that you can use the country record denoted as
## "World" in the region table.

SELECT  country_name,
        forest_area_sqkm
FROM    forestation
WHERE   country_name = 'World'
  AND   year = 1990


## b. What was the total forest area (in sq km) of the world in 2016?
## Please keep in mind that you can use the country record in the table
## is denoted as “World.”

SELECT  country_name,
        forest_area_sqkm
FROM    forestation
WHERE   country_name = 'World'
  AND   year = 2016

## c. What was the change (in sq km) in the forest area of the world
## from 1990 to 2016?

SELECT  t2.forest_area_sqkm - t1.forest_area_sqkm AS forest_area_sqkm_diff,
        (t2.forest_area_per - t1.forest_area_per)/t1.forest_area_per * 100
        AS forest_area_per_diff
FROM    (
        SELECT  country_name,
                forest_area_sqkm,
                forest_area_per
        FROM    forestation
        WHERE   country_name = 'World'
          AND   year = 1990) AS t1
  JOIN  (
        SELECT  country_name,
                forest_area_sqkm,
                forest_area_per
        FROM    forestation
        WHERE   country_name = 'World'
          AND   year = 2016) AS t2
  ON    t1.country_name = t2.country_name

## d. What was the percent change in forest area of the world between
## 1990 and 2016?

## e. If you compare the amount of forest area lost between 1990 and 2016,
## to which countrys total area in 2016 is it closest to?

SELECT  country_name,
        land_area_sqkm
FROM    forestation
WHERE   year = 2016
    AND land_area_sqkm BETWEEN 132449.0*0.95 AND 132449.0*1.05


SELECT  country_name,
        land_area_sqkm
FROM    forestation
WHERE   year = 2016
    AND land_area_sqkm <
    (SELECT  -(t2.forest_area_sqkm - t1.forest_area_sqkm) AS forest_area_sqkm_diff
    FROM    (
            SELECT  country_name,
                    forest_area_sqkm,
                    forest_area_per
            FROM    forestation
            WHERE   country_name = 'World'
              AND   year = 1990) AS t1
      JOIN  (
            SELECT  country_name,
                    forest_area_sqkm,
                    forest_area_per
            FROM    forestation
            WHERE   country_name = 'World'
              AND   year = 2016) AS t2
      ON    t1.country_name = t2.country_name
    )
ORDER BY 2 DESC
