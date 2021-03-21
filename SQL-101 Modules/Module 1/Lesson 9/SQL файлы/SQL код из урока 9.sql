--вывод агрегируемых данных по всем регионам
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
ORDER BY
	region;

--вывод агрегируемых данных по двум регионам
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
	region = 'Albany' OR region = 'Atlanta'
GROUP BY
	region
ORDER BY
	region;

--вывод агрегируемых данных по нескольким регионам
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
	region = 'Albany' OR
	region = 'BaltimoreWashington' OR
	region = 'California' OR
	region = 'DallasFtWorth' OR
	region = 'HarrisburgScranton'
GROUP BY
	region
ORDER BY
	region;

--вывод агрегируемых данных по нескольким регионам c использованием оператора IN
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
	region IN ('Albany',
			   'BaltimoreWashington',
				'California',
				'DallasFtWorth',
				'HarrisburgScranton')
GROUP BY
	region
ORDER BY
	region;