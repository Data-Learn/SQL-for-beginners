--NULL

--Данный запрос не выведет ничего:

SELECT
	*
FROM
	video_game_sales
WHERE
	Platform = 'NULL';

--Следующий запрос сработает и выведет нам строки, у которых значение столбца Platform отсутствует:

SELECT
	*
FROM
	video_game_sales
WHERE
	Platform IS NULL;

--Следующий запрос сработает и выведет нам строки за исключением тех, у которых значение столбца Platform отсутствует:

SELECT
	*
FROM
	video_game_sales
WHERE
	Platform IS NOT NULL; 

--Список агрегатных функций:

--count (количество не пустых значений),
--sum (сумму),
--avg (среднее),
--max (максимум),
--min(минимум) для набора строк.


--Данный запрос выведет все строки из таблицы avocado_prices, у которых регион - Албания:

SELECT
	*
FROM
	avocado_prices
WHERE
	region = 'Albany';

--Данный запрос выведет максимальное значение Total_Volume из таблицы avocado_prices для региона - Албания:

SELECT
	MAX("Total_Volume") AS max_volume
FROM
	avocado_prices
WHERE
	region = 'Albany';

--Данный запрос выведет минимальное значение Total_Volume из таблицы avocado_prices для региона - Албания:

SELECT
	MIN("Total_Volume") AS min_volume
FROM
	avocado_prices
WHERE
	region = 'Albany';

--Данный запрос выведет среднее значение Total_Volume из таблицы avocado_prices для региона - Албания:

SELECT
	AVG("Total_Volume") AS average_volume
FROM
	avocado_prices
WHERE
	region = 'Albany';

--Данный запрос выведет сумму значений Total_Volume из таблицы avocado_prices для региона - Албания:

SELECT
	SUM("Total_Volume") AS sum_volume
FROM
	avocado_prices
WHERE
	region = 'Albany';

--Данный запрос выведет количество значений Total_Volume из таблицы avocado_prices для региона - Албания:

SELECT
	COUNT("Total_Volume") AS count_volume
FROM
	avocado_prices
WHERE
	region = 'Albany';

--Данный запрос выведет среднее значение Total_Volume из таблицы avocado_prices для региона - Албания (другой способ):

SELECT
	SUM("Total_Volume")/COUNT("Total_Volume") AS average2
FROM
	avocado_prices
WHERE
	region = 'Albany';

--Объединим нахождение всех агрегируемых данных в один запрос:

SELECT
	MAX("Total_Volume") AS max_volume,
	MIN("Total_Volume") AS min_volume,
	AVG("Total_Volume") AS average_volume,
	SUM("Total_Volume") AS sum_volume,
	COUNT("Total_Volume") AS count_volume,
	SUM("Total_Volume")/COUNT("Total_Volume") AS average2
FROM
	avocado_prices
WHERE
	region = 'Albany';

--Следующий запрос выведет все значения столбца region из таблицы avocado_prices:

SELECT
	region
FROM
	avocado_prices;

--Следующий запрос выведет только уникальные значения столбца region из таблицы avocado_prices:

SELECT
	DISTINCT region
FROM
	avocado_prices;


--Следующий запрос выведет количество значений столбца region из таблицы avocado_prices (с учетом дубликатов):

SELECT
	COUNT(region)
FROM
	avocado_prices;

--Следующий запрос выведет количество уникальных значения столбца region из таблицы avocado_prices (дубликаты отсутствуют):

SELECT
	COUNT(DISTINCT region)
FROM
	avocado_prices;

--Следующий запрос выведет лишь уникальное значение (число) количества значений столбца region из таблицы avocado_prices.
--То есть в данном случае не будет происходить подсчет уникальных значений в самом столбце region:

SELECT
	DISTINCT COUNT(region)
FROM
	avocado_prices;

--Вывести платформы из таблицы video_game_sales, у которых значение платформы не заполнено (мы поулчим несколько NULL значений):

SELECT
	platform
FROM
	video_game_sales
WHERE
	platform IS NULL;

--Вывести количество платформ из таблицы video_game_sales (NULL значения не учитываются):

SELECT
	COUNT(platform)
FROM
	video_game_sales;

--Вывести количество строк из таблицы video_game_sales (NULL значения учитываются):

SELECT
	COUNT(*)
FROM
	video_game_sales;

--Вывести количество уникальных знчений платформы из таблицы video_game_sales (NULL значения не учитываются):

SELECT
	COUNT(DISTINCT platform)
FROM
	video_game_sales;


--Вывести все уникальные значения платформ из таблицы video_game_sales:

SELECT
	DISTINCT platform
FROM
	video_game_sales;




















