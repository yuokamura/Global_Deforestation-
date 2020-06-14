## TASK: create a 'forestation' view which combines three tables - forest_area,
## land_area, and regions.


## Joining three tables.  Full outer join is used not to omit raws with missing
## entries (although there is no missing entry)

SELECT  fa.country_code,
        fa.country_name,
        r.region,
        r.income_group,
        fa.year,
        fa.forest_area_sqkm,
        la.total_area_sq_mi*2.59 AS land_area_sqkm,
        fa.forest_area_sqkm/(la.total_area_sq_mi*2.59) * 100 AS forest_area_per
FROM    forest_area fa
  FULL JOIN land_area la
        ON  fa.country_code = la.country_code
        AND fa.year = la.year
  JOIN  regions r
  ON    r.country_code = fa.country_code
ORDER BY fa.country_code, fa.year

## create view based on the code above
CREATE VIEW forestation AS
  SELECT  fa.country_code,
          fa.country_name,
          r.region,
          r.income_group,
          fa.year,
          fa.forest_area_sqkm,
          la.total_area_sq_mi*2.59 AS land_area_sqkm,
          fa.forest_area_sqkm/(la.total_area_sq_mi*2.59)*100 AS forest_area_per
  FROM    forest_area fa
    FULL JOIN land_area la
          ON  fa.country_code = la.country_code
          AND fa.year = la.year
    JOIN  regions r
    ON    r.country_code = fa.country_code
  ORDER BY fa.country_code, fa.year
