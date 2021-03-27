--Наш запрос из предыдущего урока, который выводит все данные из таблицы newspaper, 
--к которой присоединяются данные таблицы online используя внешнее соединение LEFT JOIN
SELECT
	*
FROM
	magazine.newspaper AS n
LEFT JOIN
	magazine.online AS o
		ON n.id = o.id;

--Следующий запрос демонстрирует как работает внешнее соединение RIGHT JOIN
SELECT
	*
FROM
	magazine.newspaper AS n
RIGHT JOIN
	magazine.online AS o
		ON n.id = o.id;

--Следующий запрос с использованием RIGHT JOIN аналогичен первому запросу с использованием LEFT JOIN
-- с единственным отличием, что таблицы выводятся в разном порядке:
SELECT
	*
FROM
	magazine.online AS o
RIGHT JOIN
	magazine.newspaper AS n
		ON o.id = n.id;

-- Запрос, который объединяет в себе результаты LEFT JOIN + RIGHT JOIN, для этого используется тип соединения FULL JOIN
SELECT
	*
FROM
	magazine.newspaper AS n
FULL JOIN
	magazine.online AS o
		ON o.id = n.id
ORDER BY
	o.id;

--Результат FULL JOIN - это объединение результатов трех запросов ниже:

--клиентов, которые оформили подписку ТОЛЬКО на онлайн издание
SELECT
	*
FROM
	magazine.newspaper AS n
RIGHT JOIN
	magazine.online AS o
		ON o.id = n.id
WHERE
	n.id IS NULL;

--клиентов, которые оформили подписку ТОЛЬКО на печатное издание	
SELECT
	*
FROM
	magazine.newspaper AS n
LEFT JOIN
	magazine.online AS o
		ON o.id = n.id
WHERE
	o.id IS NULL;

--клиентов, которые оформили подписку на печатное и онлайн издание	
SELECT
	*
FROM
	magazine.newspaper AS n
INNER JOIN
	magazine.online AS o
		ON o.id = n.id;


-- запрос, который выводит объединённые результаты :
-- тех, кто оформили подписку ТОЛЬКО на печатное издание
-- И тех, кто оформили подписку ТОЛЬКО на онлайн издание
-- (то есть за исключением тех, кто оформил подписку на оба типа издания)
SELECT
	*
FROM
	magazine.newspaper AS n
FULL OUTER JOIN
	magazine.online AS o
		ON o.id = n.id
WHERE
	o.id IS NULL
	OR
	n.id IS NULL;
	

--PRIMARY - Первичный ключ
--FOREIGN - внешний ключ

--Запрос, который выводит все данные из таблицы classes схемы school
SELECT
	*
FROM
	school.classes;

--Запрос, который выводит все данные из таблицы students схемы school
SELECT
	*
FROM
	school.students;

--Запрос, объединяющий таблицы classes и таблицы students схемы school по ключам (PRIMARY и FOREIGN)
SELECT
	*
FROM
	school.classes AS c
INNER JOIN
	school.students AS s
		ON c.id = s.class_id;

	
	
