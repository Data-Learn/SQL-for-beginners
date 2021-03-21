--данный запрос вызовет ошибку потому, что мы не можем еще использовать в HAVING псевдонимы, которые назначаются в SELECT
SELECT
	region,
	MAX("Total_Volume") AS max_volume,
	MIN("Total_Volume") AS min_volume,
	AVG("Total_Volume") AS average_volume,
	SUM("Total_Volume") AS sum_volume,
	COUNT("Total_Volume") AS count_volume
FROM
	avocado_prices
GROUP BY
	region
HAVING
	max_volume > 1000000
ORDER BY
	region;

--логический порядок обработки инструкций в SQL
-- FROM
-- ON
-- JOIN
-- WHERE
-- GROUP BY
-- HAVING
-- SELECT
-- DISTINCT
-- ORDER BY

--пример фильтрации агругируемых данных
SELECT
	region,
	MAX("Total_Volume") AS max_volume,
	MIN("Total_Volume") AS min_volume,
	AVG("Total_Volume") AS average_volume,
	SUM("Total_Volume") AS sum_volume,
	COUNT("Total_Volume") AS count_volume
FROM
	avocado_prices
GROUP BY
	region
HAVING
	MAX("Total_Volume") > 1000000
ORDER BY
	max_volume DESC;

--пример фильтрации агругируемых данных и фильтрации по данным столбцов
SELECT
	region,
	MAX("Total_Volume") AS max_volume,
	MIN("Total_Volume") AS min_volume,
	AVG("Total_Volume") AS average_volume,
	SUM("Total_Volume") AS sum_volume,
	COUNT("Total_Volume") AS count_volume
FROM
	avocado_prices
WHERE
	region IN ('Albany', 'California', 'Chicago', 'Anatolii')
GROUP BY
	region
HAVING
	MAX("Total_Volume") > 1000000
ORDER BY
	max_volume DESC;
