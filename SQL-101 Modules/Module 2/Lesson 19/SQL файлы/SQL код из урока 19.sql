-- Узнать год и количество раз, которое давалось опрежеленное имя ребенку
SELECT
	year,
	number
FROM
	babies
WHERE
	name = 'Lillian';

--Вывести уникальные имена детей, которые начинаются на букву S
SELECT
	DISTINCT name
FROM
	babies
WHERE
	name LIKE 'S%';

--Вывести уникальные имена детей, которые начинаются на букву S и заканчиваются на букву n
SELECT
	DISTINCT name
FROM
	babies
WHERE
	name LIKE 'S%n';

--Вывести уникальные имена детей, которые начинаются на букву S, 4-ая буква имени является o
SELECT
	DISTINCT name
FROM
	babies
WHERE
	name LIKE 'S__o%';

--Вывести уникальные имена детей, которые начинаются на букву S (используя оператор ILIKE)
SELECT
	DISTINCT name
FROM
	babies
WHERE
	name ILIKE 's%';

--Вывести все столбцы из таблицы фильмов, при условии, что имя фильма состоит из 5 символов,
--начинается с "Se" и заканчивается на "en" 
SELECT
	id,
	name,
	genre,
	year,
	imdb_rating
FROM
	public.movies
WHERE
	name LIKE 'Se_en';

--Вывести название и длинну названия в порядке убывания
SELECT
	name,
	LENGTH(name)
FROM
	public.movies
ORDER BY
	LENGTH(name) DESC;

--Вывести все столбцы из таблицы фильмов, названия которых начинаются на букву А
SELECT
	* 
FROM
	movies
WHERE
	name LIKE 'A%';

--Вывести все столбцы из таблицы фильмов, в названии которых содержится слово man
SELECT
	* 
FROM
	movies
WHERE
	name LIKE '%man%';

--Вывести все столбцы из таблицы фильмов, название которых начинается с 'The'
SELECT
	* 
FROM
	movies
WHERE

	name LIKE 'The %';
--Вывести все столбцы из таблицы фильмов, название которых начинается с артикля 'The'
SELECT
	* 
FROM
	movies
WHERE
	name LIKE 'The %';

--Вывести названия фильмов и дополнительный столбец с рекомендациями к просмотру базируясь на рейтинге 
--используя оператор CASE. Если рейтинг больше 8 - выводить слово 'Fantastic', если рейтинг больше 6 - 
--выводить слово 'Poorly Received', иначе выводить слово 'Avoid at All Costs'. Задайте имя для нового
--столбца как recommendation
SELECT
	name,
	CASE
		WHEN imdb_rating > 8 THEN 'Fantastic'
		WHEN imdb_rating > 6 THEN 'Poorly Received'
		ELSE 'Avoid at All Costs'
	END AS recommendation
FROM
	movies;

--Уникальные жанры в таблице с фильмами
SELECT
	DISTINCT genre
FROM
	public.movies;

--Вывести названия фильмов и дополнительный столбец с информацией под какое настроение подходит тот или
--иной фильм базируясь на жанре используя оператор CASE. Если жанр 'романтика' - выводить слово 'Отдых',
--если жанр 'комедия' - выводить также слово 'Отдых', иначе выводить слово 'Другое'. Задайте имя для нового
--столбца как 'Настроение'
SELECT
	name,
	CASE
		WHEN genre = 'romance' THEN 'Отдых'
		WHEN genre = 'comedy' THEN 'Отдых'
		ELSE 'Другое'
	END AS Настроение
FROM
	movies
ORDER BY
	2 DESC;

--Пример выше только покороче используя оператор OR
SELECT
	name,
	CASE
		WHEN genre = 'romance' OR genre = 'comedy' THEN 'Отдых'
		ELSE 'Другое'
	END AS Настроение
FROM
	movies
ORDER BY
	2 DESC;

--функции для получения текущего времени:
SELECT
	current_timestamp,
	now();

--Показать текущий часовой пояс
show timezone;

-- Показать текущее время в Лос Анжелесе (США)
SELECT
	now(),
	now() at time zone 'America/Los_Angeles'

--Дополнительные примеры функциями для работы с датой и временем
SELECT
	now(),
	EXTRACT(YEAR FROM now()) AS year,
	EXTRACT(MONTH FROM now()) AS month,
	EXTRACT(DAY FROM now()) as day,
	EXTRACT(WEEK FROM now()) as week,
	now()::date AS date,
	now()::time AS time;

--пример конкатенации (соединения) строчных значений:
SELECT
	genre,
	name,
	genre || ': ' || name AS genre_name
FROM
	movies;
	
--Функции перевода для перевода регистров в строчных значениях:
SELECT
	name,
	lower(name),
	upper(name)
FROM
	movies;

--Функция по замене символов в строке
SELECT
	name,
	replace(name, 'a', 'k')
FROM
	movies;
	








