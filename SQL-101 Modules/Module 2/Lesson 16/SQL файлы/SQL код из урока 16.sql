--Создает все возможные комбинации строк таблицы newspaper со строками таблицы months
-- с помощью CROSS JOIN (перекрестного) соединения

SELECT
	*
FROM
	magazine.newspaper AS n
CROSS JOIN
	magazine.months AS m;

--устаревший формат записи CROSS JOIN:
SELECT
	*
FROM
	magazine.newspaper AS n,
	magazine.months AS m;

--вывод имени подписчика с возможными комбинациями месяца с сортировкой по имени и месяцу в порядке возростания
SELECT
	n.first_name,
	m.month
FROM
	magazine.newspaper AS n
CROSS JOIN
	magazine.months AS m
ORDER BY
	1,2;

--Вывести информацию о подписчиках, которые оформили подписку на протяжении января, февраля и марта
-- и закончили подписку после марта месяца (включая март):
SELECT
	*
FROM
	magazine.newspaper AS n
WHERE
	n.start_month <=3
	AND
	n.end_month >= 3;


--финальный запрос по выводу количества подписчиков в разрезе каждого месяца:
SELECT
	m.month,
	COUNT(*)
FROM
	magazine.newspaper AS n
CROSS JOIN
	magazine.months AS m
WHERE
	n.start_month <= m.month
	AND
	n.end_month >= m.month
GROUP BY
	m.month
ORDER BY
	m.month;


--вариант перекокретсного соединения только с помощью INNER JOIN:
SELECT
	*
FROM
	magazine.newspaper AS n
INNER JOIN
	magazine.months AS m
		ON TRUE;






