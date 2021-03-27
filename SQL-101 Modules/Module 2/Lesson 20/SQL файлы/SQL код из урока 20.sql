--Выборка первых 10 записей из таблицы band_students
SELECT
	*
FROM
	public.band_students
LIMIT
	10;

--Выборка первых 10 записей из таблицы drama_students
SELECT
	*
FROM
	public.drama_students
LIMIT
	10;

--Найти студентов, которые посещают оба кружка
SELECT
	bs.id,
	bs.first_name,
	bs.last_name
FROM
	public.band_students AS bs
INNER JOIN
	public.drama_students AS ds
		ON bs.id = ds.id;

--Найти студентов, которые посещают оба кружка (используйте подзапросы)
SELECT
	bs.id,
	bs.first_name,
	bs.last_name
FROM
	public.band_students AS bs
WHERE
	bs.id
		IN
			(SELECT
				ds.id
			FROM
				public.drama_students AS ds
			);

--Найти информацию о сстудентах из таблицы drama_students, оценка которых такая же как и у студентки
-- с идентификаторм 20 из таблицы band_students
SELECT
	*
FROM
	public.drama_students
WHERE
	grade IN
			(SELECT
				grade
			FROM
				public.band_students
			WHERE
				id = 20);

--Вывести имя и фамилию студентов из таблицы band_students, которых нет в таблице drama_students
SELECT
	first_name,
	last_name
FROM
	public.band_students
WHERE
	id NOT IN
			(SELECT
				id
			FROM
				public.drama_students
			);

--Вывести все оценки из таблицы band_students, которіе присутствуют в таблице drama_students
--Используйте оператор EXISTS
SELECT
	grade
FROM
	public.band_students
WHERE
	EXISTS
			(SELECT
				grade
			FROM
				public.drama_students
			);

--Пример использования СTE (common table expressions)
WITH previous_query AS
	(SELECT
		customer_id,
		COUNT(subscription_id) AS subscriptions
	 FROM
		orders
	 GROUP BY
		customer_id)
		
SELECT
	c.customer_name, 
    pq.subscriptions,
	c.address
FROM
	previous_query AS pq
JOIN
	customers AS c
  		ON pq.customer_id = c.customer_id;
	

	


	


	
