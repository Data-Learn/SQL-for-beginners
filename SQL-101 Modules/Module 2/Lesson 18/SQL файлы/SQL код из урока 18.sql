--Вывести данные о тех подписчиках, которые офомили подписку ТОЛЬКО на печатное издание
-- (используйте оператор EXCEPT)

SELECT
  *
FROM
  magazine.newspaper AS n
  
EXCEPT

SELECT
  *
FROM
  magazine.online AS o
ORDER BY
	1;

--Вывести данные о тех подписчиках, которые офомили подписку ТОЛЬКО на печатное издание
-- (используйте оператор LEFT JOIN)

SELECT
  *
FROM
    magazine.newspaper AS n
LEFT JOIN
	magazine.online AS o
		ON n.id = o.id
WHERE
	o.id IS NULL
ORDER BY
	1;

--Вывести данные о тех подписчиках, которые офомили подписку на печатное издание И на онлайн издание
-- (используйте оператор INTERSECT)
SELECT
  *
FROM
  magazine.newspaper AS n
  
INTERSECT

SELECT
  *
FROM
  magazine.online AS o
ORDER BY
	1;

--Вывести данные о тех подписчиках, которые офомили подписку на печатное издание И на онлайн издание
-- (используйте оператор INNER JOIN)
SELECT
  *
FROM
    magazine.newspaper AS n
INNER JOIN
	magazine.online AS o
		ON n.id = o.id
ORDER BY
	1;

--Запрос выше можно записать используя оператор USING вместо ON:
SELECT
  *
FROM
    magazine.newspaper AS n
INNER JOIN
	magazine.online AS o
		USING(id)
ORDER BY
	1;












