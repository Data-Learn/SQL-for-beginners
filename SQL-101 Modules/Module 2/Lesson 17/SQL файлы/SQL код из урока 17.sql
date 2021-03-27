--Объединение результатов двух запросов с помощью UNION ALL

SELECT
	*
FROM
	magazine.newspaper
UNION ALL
SELECT
	*
FROM
	magazine.online;

-- Объединение результатов двух запросов с сортировкой по первому столбцу и учеnом дублирующих строк
SELECT
	*
FROM
	magazine.newspaper
UNION ALL
SELECT
	*
FROM
	magazine.online
ORDER BY
	1;

-- Объединение результатов двух запросов с сортировкой по первому столбцу исключая дубликаты
SELECT
	*
FROM
	magazine.newspaper
UNION
SELECT
	*
FROM
	magazine.online
ORDER BY
	1;

-- Запрос выше равносилен ниже запросу с использованием подзапроса, в котором используется UNION ALL:
SELECT
	our_query.first_name,
	our_query.last_name
FROM
	(SELECT
		m.first_name,
		m.last_name
	FROM
		magazine.newspaper AS m
	UNION
	SELECT
		o.first_name,
		o.last_name
	FROM
		magazine.online AS o
	ORDER BY
		1) AS our_query
ORDER BY
	1;

--Мы можем объединять любые данные, главное, чтобы количество столбцов совпадало, 
--при этом псевдонимы столбцов берутся из первого запроса:
SELECT
	m.first_name,
	m.email
FROM
	magazine.newspaper AS m
UNION
SELECT
	o.email,
	o.first_name
FROM
	magazine.online AS o

--Мы можем объединять любые данные, главное, чтобы кроме количества столбцов совпадали еще 
--типы данных этих столбцов (в случае если тип данных не соответствуют, можно попробовать поменять тип данных):
SELECT
	m.id::text, --это и есть приведение типа (столбец id изначально был числовым, а тепреь это текст)
	m.first_name
FROM
	magazine.newspaper AS m
UNION
SELECT
	o.email,
	o.first_name
FROM
	magazine.online AS o;
