--Создание схем songify
CREATE SCHEMA IF NOT EXISTS songify

--Давайте посмотрим, какие тарифные планы используют премиум-пользователи
SELECT
	pu.user_id,
	p.description
FROM
	songify.premium_users AS pu
JOIN
	songify.plans AS p
		ON pu.membership_plan_id = p.id;
--Давайте посмотрим названия песен, которые cлушает каждый пользователь
SELECT
	p.user_id,
	p.play_date,
	s.title
FROM
	songify.plays AS p
JOIN
	songify.songs AS s
		ON p.song_id = s.id;

--Какие пользователи не являются премиум-пользователями?
SELECT
	u.id
FROM
	songify.users AS u
LEFT JOIN
	songify.premium_users AS pu
		ON u.id = pu.user_id
WHERE
	pu.user_id IS NULL;

--С помощью СTE найдите пользователей, которые слушали музыку в январе и феврале, а потом оставьте
--только тех пользователей, которые слушали музыку ТОЛЬКО в январе.
WITH january AS
	(SELECT
		*
	FROM
		songify.plays
	WHERE
		EXTRACT(MONTH FROM play_date) = 1),
	
february AS
	(SELECT
		*
	FROM
		songify.plays
	WHERE
		EXTRACT(MONTH FROM play_date) = 2)

SELECT
	j.user_id
FROM
	january AS j
LEFT JOIN
	february AS f
		ON j.user_id = f.user_id 
WHERE
	f.user_id IS NULL;

--Для каждого месяца в таблице months мы хотим знать, был ли каждый премиум-пользователь
--активным или удаленным (не продлевал свою подписку на сервис)
SELECT
	pu.user_id,
	pu.purchase_date::date AS purchase_date,
	pu.cancel_date::date AS cancel_date,
	m.months::date
FROM
	songify.months AS m
CROSS JOIN
	songify.premium_users AS pu;

--Определить какие пользователи у нас активные, а какие не активные в каждом месяце
SELECT
	pu.user_id,
  	m.months,
	CASE
    	WHEN (pu.purchase_date <= m.months)
      		AND
      		(pu.cancel_date >= m.months OR pu.cancel_date IS NULL)
    	THEN 'active'
    	ELSE 'not_active'
  	END AS status
FROM
	songify.months AS m
CROSS JOIN
	songify.premium_users AS pu;

--Объедините таблицу songs и bonus_songs с помощью UNION и выберите все столбцы.
--Поскольку таблица songs очень большая, просто посмотрите на некий срез данных
--и выведите только 10 строк с помощью LIMIT.
SELECT
	*
FROM
	songify.songs
UNION
SELECT
	*
FROM
	songify.bonus_songs
LIMIT
	10;

--Дополнительный пример использования UNION:
SELECT '2017-01-01' as month
UNION
SELECT '2017-02-01' as month
UNION
SELECT '2017-03-01' as month
ORDER BY
	1;

--Найти количество раз, которое была прослушана каждая песня,
--добавить дополнительную информацию из таблицs songs
WITH play_count AS
	(SELECT
		p.song_id,
		COUNT(*) AS "times_played"
	FROM
		songify.plays AS p
	GROUP BY
		p.song_id)
SELECT
	s.title,
	s.artist,
	pc.times_played
FROM
	play_count AS pc
JOIN
	songify.songs AS s
		ON pc.song_id = s.id;

--Создание схем metropolitan
CREATE SCHEMA IF NOT EXISTS metropolitan

--Выведем первые 10 записей таблицы met из схемы metropolitan
SELECT
	*
FROM
	metropolitan.met
LIMIT
	10;

--Сколько произведений в коллекции американского декоративного искусства
SELECT
	COUNT(*)
FROM
	metropolitan.met;

--Подсчитайте количество произведений исскуства, в которых в category содержится слово 'celery' (сельдерей)
SELECT
	COUNT(*)
FROM
	metropolitan.met
WHERE
	category ILIKE '%celery%';

--Выведите уникальные категории произведений исскуства, в которых содержится слово 'celery' (сельдерей)
SELECT
	COUNT(*)
FROM
	metropolitan.met
WHERE
	category ILIKE '%celery%';

--Выведите title и medium самых старых произведений исскуств в коллекции
--минимальная дата
SELECT
	MIN(date)
FROM
	metropolitan.met;

--наш финальный запрос
SELECT
	date,
	title,
	medium
FROM
	metropolitan.met
WHERE
	date LIKE '%1600%';

--Найдите 10 стран с наибольшим количеством предметов в коллекции
SELECT
	country,
	COUNT(*)
FROM
	metropolitan.met
WHERE
	country IS NOT NULL
GROUP BY
	country
ORDER BY
	2 DESC
LIMIT
	10;

--Найдите категории, в которых больше 100 произведений исскуства	
SELECT
	category,
	COUNT(*)
FROM
	metropolitan.met
GROUP BY
	category
HAVING
	COUNT(*) > 100;

--Посчитаем количество произведений исскуства, которые сделаны из золота или серебра.
--Выведем также сам материал
SELECT
	medium,
	COUNT(*)
FROM
	metropolitan.met
WHERE
	medium ILIKE '%gold%' OR medium ILIKE '%silver%'
GROUP BY
	medium
ORDER BY
	2 DESC;

--Более элегантный вариант
WITH gold_silver AS
	(SELECT
		CASE
			WHEN medium ILIKE '%gold%' THEN 'Gold'
			WHEN medium ILIKE '%silver%' THEN 'Silver'
			ELSE NULL
		END AS Bling,
		COUNT(*)
	FROM
		metropolitan.met
	GROUP BY
		1
	ORDER BY
		2 DESC)
SELECT
	*
FROM
	gold_silver AS gs
WHERE
	gs.Bling IS NOT NULL;


--Создание схем vr_startup
CREATE SCHEMA IF NOT EXISTS vr_startup

--Выведем данные таблицы employees из схемы vr_startup
SELECT
	*
FROM
	vr_startup.employees;

--Выведем данные таблицы projects из схемы vr_startup
SELECT
	*
FROM
	vr_startup.projects;

--Как зовут сотрудников, которые не выбрали проект?
SELECT
	first_name,
	last_name
FROM
	vr_startup.employees
WHERE
	current_project IS NULL;


--Как называются проекты, которые не выбраны никем из сотрудников?
SELECT
	p.project_name
FROM
	vr_startup.projects AS p
WHERE
	p.project_id
		NOT IN
			(SELECT
				e.current_project
			FROM
				vr_startup.employees AS e
			WHERE
				e.current_project IS NOT NULL);

--Какой проект выбирают большинство сотрудников (укажите название)?
SELECT
	p.project_name
FROM
	vr_startup.projects AS p
JOIN
	vr_startup.employees AS e
		ON p.project_id = e.current_project
GROUP BY
	p.project_name
ORDER BY
	COUNT(e.employee_id) DESC
LIMIT
	1;

--Какие проекты выбрали несколько сотрудников (то есть больше 1)?
SELECT
	p.project_name
FROM
	vr_startup.projects AS p
JOIN
	vr_startup.employees AS e
		ON p.project_id = e.current_project
GROUP BY
	p.project_name
HAVING
	COUNT(e.employee_id) > 1
ORDER BY
	COUNT(e.employee_id) DESC;

--На каждый проект нужно как минимум 2 разработчика. Сколько доступных проектных позиций для разработчиков?
--Достаточно ли у нас разработчиков для заполнения необходимых вакансий?
SELECT
	(COUNT(*) * 2)
	-
	(SELECT
		COUNT(*)
	FROM
		vr_startup.employees AS e
	WHERE
		e.current_project IS NOT NULL
		AND
		e.position = 'Developer') AS "Count"
FROM
	vr_startup.projects AS p;

-- Тип личности			…не совместим с
-- 	INFP			ISFP, ESFP, ISTP, ESTP, ISFJ, ESFJ, ISTJ, ESTJ
-- 	ENFP			ISFP, ESFP, ISTP, ESTP, ISFJ, ESFJ, ISTJ, ESTJ
-- 	INFJ			ISFP, ESFP, ISTP, ESTP, ISFJ, ESFJ, ISTJ, ESTJ
-- 	ENFJ			ESFP, ISTP, ESTP, ISFJ, ESFJ, ISTJ, ESTJ
-- 	ISFP			INFP, ENFP, INFJ
-- 	ESFP			INFP, ENFP, INFJ, ENFJ
-- 	ISTP			INFP, ENFP, INFJ, ENFJ
-- 	ESTP			INFP, ENFP, INFJ, ENFJ
-- 	ISFJ			INFP, ENFP, INFJ, ENFJ
-- 	ESFJ			INFP, ENFP, INFJ, ENFJ
-- 	ISTJ			INFP, ENFP, INFJ, ENFJ
-- 	ESTJ			INFP, ENFP, INFJ, ENFJ

--Какая личность наиболее характерна для наших сотрудников?
SELECT
	e.personality
FROM
	vr_startup.employees AS e
GROUP BY
	e.personality
ORDER BY
	COUNT(e.personality) DESC
LIMIT
	1;

--Какие названия проектов выбирают сотрудники с наиболее распространенным типом личности?
SELECT
	p.project_name
FROM
	vr_startup.projects AS p
JOIN
	vr_startup.employees AS e
		ON p.project_id = e.current_project
WHERE
	e.personality = (SELECT
				e.personality
			FROM
				vr_startup.employees AS e
			GROUP BY
				e.personality
			ORDER BY
				COUNT(e.personality) DESC
			LIMIT
				1);

--Найдите тип личности, наиболее представленный сотрудниками с выбранным проектом.
--Как зовут этих сотрудников, тип личности и названия проекта, который они выбрали?
SELECT
	e.first_name,
	e.last_name,
	e.personality,
	p.project_name
FROM
	vr_startup.projects AS p
JOIN
	vr_startup.employees AS e
		ON p.project_id = e.current_project
WHERE
	e.personality = (SELECT
						e.personality
					FROM
						vr_startup.employees AS e
					WHERE
					 	e.current_project IS NOT NULL
					GROUP BY
						e.personality
					ORDER BY
						COUNT(e.personality) DESC
					LIMIT
						1);

--Для каждого сотрудника укажите его имя, личность, названия любых выбранных ими проектов
--и количество несовместимых сотрудников.
SELECT
	e.first_name,
	e.last_name,
	e.personality,
	p.project_name,	
	CASE
		WHEN e.personality IN ('INFP', 'ENFP', 'INFJ') THEN (SELECT COUNT(*) FROM vr_startup.employees AS e WHERE e.personality IN ('ISFP', 'ESFP', 'ISTP', 'ESTP', 'ISFJ', 'ESFJ', 'ISTJ', 'ESTJ'))
		WHEN  e.personality = 'ENFJ' THEN (SELECT COUNT(*) FROM vr_startup.employees AS e WHERE e.personality IN ('ESFP', 'ISTP', 'ESTP', 'ISFJ', 'ESFJ', 'ISTJ', 'ESTJ'))
		WHEN  e.personality = 'ISFP' THEN (SELECT COUNT(*) FROM vr_startup.employees AS e WHERE e.personality IN ('INFP', 'ENFP', 'INFJ'))  
		WHEN  e.personality IN ('ESFP', 'IESTP', 'ESTP', 'ISFJ', 'ESFJ', 'ISTJ', 'ESTJ') THEN (SELECT COUNT(*) FROM vr_startup.employees AS e WHERE e.personality IN ('INFP', 'ENFP', 'INFJ', 'ENFJ'))
		ELSE 0
	END AS imcompats
FROM
	vr_startup.employees AS e
LEFT JOIN
	vr_startup.projects AS p
		ON p.project_id = e.current_project;







