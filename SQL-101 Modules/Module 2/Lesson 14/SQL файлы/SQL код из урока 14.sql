--Напишите запрос, который выводит все данные из таблицы newspaper, 
--а также присоедините к ней таблицу online используя внешнее соединение LEFT JOIN
SELECT
	*
FROM
	magazine.newspaper AS n
LEFT JOIN
	magazine.online AS o
		ON n.id = o.id;

--Напишите запрос, который выводит все данные из таблицы online 
--а также присоедините к ней таблицу newspaper используя внешнее соединение LEFT JOIN
SELECT
	*
FROM
	magazine.online AS o
LEFT JOIN
	magazine.newspaper AS n
		ON n.id = o.id;

--Выведите только те данные, по которым известно, что подписчики оформили ТОЛЬКО онлайн подписку
SELECT
	*
FROM
	magazine.online AS o
LEFT JOIN
	magazine.newspaper AS n
		ON n.id = o.id
WHERE
	n.id IS NULL;

