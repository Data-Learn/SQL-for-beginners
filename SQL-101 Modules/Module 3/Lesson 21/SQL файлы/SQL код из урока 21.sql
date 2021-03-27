--Создание схем windows_functions
CREATE SCHEMA IF NOT EXISTS windows_functions

--Выведем все данные из таблицы в схеме windows_functions:
SELECT
	*
FROM
	windows_functions.salary;

--Кто получает больше всего в каждом департаменте?
SELECT
	department,
	MAX(gross_salary)
FROM
	windows_functions.salary
GROUP BY
	department;

--Кто получает больше всего в каждом департаменте (дополнительно вывести идентификатор сотрудника и его имя)?
SELECT
	s.id,
	s.first_name,
	s.department,
	max_s.max_salary
FROM
	windows_functions.salary AS s
JOIN
	(SELECT
		s.department,
		MAX(s.gross_salary) AS max_salary
	FROM
		windows_functions.salary AS s
	GROUP BY
		s.department) AS max_s
			ON  max_s.department = s.department
				AND
				max_s.max_salary = s.gross_salary;

--Запрос выше только с помощью USING вместо ON
SELECT
	s.id,
	s.first_name,
	s.department,
	max_s.gross_salary
FROM
	windows_functions.salary AS s
JOIN
	(SELECT
		s.department,
		MAX(s.gross_salary) AS gross_salary
	FROM
		windows_functions.salary AS s
	GROUP BY
		s.department) AS max_s
			USING (gross_salary, department);

--Решить эту же задачу с помощью оконных функций
SELECT
	s.id,
	s.first_name,
	s.department,
	s.gross_salary,
	MAX(s.gross_salary) OVER(PARTITION BY s.department) AS max_gross_salary
FROM
	windows_functions.salary AS s;
	
--Отфильтровать потенциальных кандидатов на сокращение выделив запрос в подзапрос:	
SELECT
	max_s.id,
	max_s.first_name,
	max_s.department,
	max_s.max_gross_salary
FROM
	(SELECT
		s.id,
		s.first_name,
		s.department,
		s.gross_salary,
		MAX(s.gross_salary) OVER(PARTITION BY s.department) AS max_gross_salary
	FROM
		windows_functions.salary AS s) AS max_s
WHERE
	max_s.max_gross_salary = max_s.gross_salary
ORDER BY
	max_s.id;
	
--Показать пропорцию зарплат в отделе относительно суммы всех зарплат в этом отделе, 
--а также относительно всего фонда оплаты труда
WITH gross_by_departments AS
	(SELECT
		s.department,
		SUM(s.gross_salary) AS department_gross_salary
	FROM
		windows_functions.salary AS s
	GROUP BY
		s.department)

SELECT
	s.id,
	s.first_name,
	s.department,
	s.gross_salary,
	ROUND(((s.gross_salary::numeric / gbd.department_gross_salary) * 100), 2) AS department_ratio,
	ROUND(((s.gross_salary::numeric / (SELECT SUM(s.gross_salary) FROM windows_functions.salary AS s)) * 100), 2) AS total_ratio
FROM
	windows_functions.salary AS s
JOIN
	gross_by_departments AS gbd
		USING(department)
ORDER BY
	s.department,
	department_ratio DESC;

--Решить эту же задачу с помощью оконных функций	
SELECT
	s.id,
	s.first_name,
	s.department,
	s.gross_salary,
	ROUND(((s.gross_salary::numeric / SUM(s.gross_salary) OVER(PARTITION BY s.department)) * 100), 2) AS department_ratio,
	ROUND(((s.gross_salary::numeric / SUM(s.gross_salary) OVER()) * 100), 2) AS total_ratio
FROM
	windows_functions.salary AS s
ORDER BY
	s.department,
	department_ratio DESC;

--Вернуть имя сотрудника у которого самая высокая зарплата в департаменте используя оконные функции
SELECT
	s.id,
	s.first_name,
	s.department,
	s.gross_salary,
	FIRST_VALUE(s.first_name) OVER(PARTITION BY s.department ORDER BY s.gross_salary DESC) AS highest_paid_employee
FROM
	windows_functions.salary AS s;

--Вернуть имя сотрудника у которого самая низкая зарплата в департаменте используя оконные функции		
SELECT
	s.id,
	s.first_name,
	s.department,
	s.gross_salary,
	LAST_VALUE(s.first_name) OVER(PARTITION BY s.department ORDER BY s.gross_salary DESC ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS lowest_paid_employee
FROM
	windows_functions.salary AS s;


--Посмотреть какие данные хранятся в таблице social_media в схеме windows_functions
SELECT
	*
FROM
	windows_functions.social_media;

--Вывести данные о сумме прироста последователей для аккаунта instagram за весь период
SELECT
	username,
	SUM(change_in_followers)
FROM
	windows_functions.social_media
WHERE
	username = 'instagram'
GROUP BY
	username;
	
--Вывести столбцы месяц и количество последователей для аккаунта instagram, а также 
--добавьте еще один столбец running_total, который будет отображать нарастающую сумму последователей
--из месяца в месяц в порядке возростания (используйте оконную функцию)
SELECT
	month,
	change_in_followers,
	SUM(change_in_followers) OVER(ORDER BY month ASC) AS running_total
FROM
	windows_functions.social_media
WHERE
	username = 'instagram';

--Теперь найдем кумулятивное среднее, изменив функцию SUM на функцию AVG	
SELECT
	month,
	change_in_followers,
	AVG(change_in_followers) OVER(ORDER BY month ASC) AS running_avg
FROM
	windows_functions.social_media
WHERE
	username = 'instagram';	

--Рассмотрим пример того как работает PARTITION BY в оконных функциях	
SELECT
	username,
	month,
	change_in_followers,
	SUM(change_in_followers) OVER(PARTITION BY username ORDER BY month ASC) AS running_total_followers_change,
	AVG(change_in_followers) OVER(PARTITION BY username ORDER BY month ASC) AS running_avg_followers_change
FROM
	windows_functions.social_media;

--Пример использования оконной функции FIRST_VALUE() - наименьшее количество постов по каждому пользователю за весь период:
SELECT
	username,
	month,
	posts,
	FIRST_VALUE(posts) OVER (PARTITION BY username ORDER BY posts DESC) AS least_posts
FROM
	windows_functions.social_media;

--Пример использования оконной функции FIRST_VALUE() - наибольшее количество постов по каждому пользователю за весь период:
SELECT:
SELECT
	username,
	month,
	posts,
	FIRST_VALUE(posts) OVER (PARTITION BY username ORDER BY posts DESC) AS most_posts
FROM
	windows_functions.social_media;

--Пример использования оконной функции LAST_VALUE():
SELECT
	username,
	month,
	posts,
	LAST_VALUE(posts) OVER (PARTITION BY username ORDER BY posts RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)
FROM
	windows_functions.social_media;

--Посмотреть какие данные хранятся в таблице streams в схеме windows_functions
SELECT
	*
FROM
	windows_functions.streams;

--Пример использования оконной функции LAG:
SELECT
	artist,
	week,
	streams_millions,
	LAG(streams_millions::text, 1, 'нет значения') OVER(ORDER BY week ASC) AS previous_week_streams 
FROM
	windows_functions.streams
WHERE
	artist = 'Lady Gaga';

--Расчет изменения streams_millions от недели к недели с помощью оконной функции LAG для артиста 'Lady Gaga:
SELECT
	artist,
	week,
	streams_millions,
	streams_millions - LAG(streams_millions, 1, streams_millions) OVER(ORDER BY week ASC) AS streams_millions_change
FROM
	windows_functions.streams
WHERE
	artist = 'Lady Gaga';

--Расчет изменения streams_millions и chart_position от недели к недели для всех артистов с помощью оконной функции LAG:
SELECT
	artist,
	week,
	streams_millions,
	streams_millions - LAG(streams_millions, 1, streams_millions) OVER(PARTITION BY artist ORDER BY week ASC) AS streams_millions_change,
	chart_position,
	LAG(chart_position, 1, chart_position) OVER(PARTITION BY artist ORDER BY week ASC) - chart_position AS chart_position_change
FROM
	windows_functions.streams;
	
--Пример использования оконной функции LEAD:
SELECT
	artist,
	week,
	streams_millions,
	LEAD(streams_millions, 1) OVER(PARTITION BY artist ORDER BY week ASC) AS next_week_streams,
	chart_position,
	LEAD(chart_position, 1) OVER(PARTITION BY artist ORDER BY week ASC) AS next_week_chart_position
FROM
	windows_functions.streams;

--Расчет изменения streams_millions и chart_position от недели к недели для всех артистов с помощью оконной функции LEAD:
SELECT
	artist,
	week,
	streams_millions,
	LEAD(streams_millions, 1, streams_millions) OVER(PARTITION BY artist ORDER BY week ASC) - streams_millions AS streams_millions_change,
	chart_position,
	chart_position - LEAD(chart_position, 1, chart_position) OVER(PARTITION BY artist ORDER BY week ASC) AS chart_position_change
FROM
	windows_functions.streams;
	
--Пример использования оконной функции ROW_NUMBER:
SELECT
		artist,
		week,
		streams_millions,
		ROW_NUMBER() OVER(ORDER BY streams_millions ASC) AS row_num
	FROM
		windows_functions.streams;


--Пример использования оконной функции ROW_NUMBER c фильтрацией (вывод 30-ой строки):
WITH our_rows AS
	(SELECT
		artist,
		week,
		streams_millions,
		ROW_NUMBER() OVER(ORDER BY streams_millions ASC) AS row_num
	FROM
		windows_functions.streams)
SELECT
	*
FROM
	our_rows
WHERE
	row_num = 30;


--Пример использования оконной функции ROW_NUMBER c фильтрацией (вывод с 1 по 10 строку):
WITH our_rows AS
	(SELECT
		artist,
		week,
		streams_millions,
		ROW_NUMBER() OVER(ORDER BY streams_millions ASC) AS row_num
	FROM
		windows_functions.streams)
SELECT
	*
FROM
	our_rows
WHERE
	row_num BETWEEN 1 AND 10;

--Пример использования оконных функции RANK и DENSE_RANK:
SELECT
	artist,
	week,
	streams_millions,
	RANK() OVER(ORDER BY streams_millions ASC) AS rank_result,
	DENSE_RANK() OVER(ORDER BY streams_millions ASC) AS dense_rank_result
FROM
	windows_functions.streams;

--Пример использования оконных функции RANK и DENSE_RANK с группировкой по неделям:
SELECT
	artist,
	week,
	streams_millions,
	RANK() OVER(PARTITION BY week ORDER BY streams_millions ASC) AS rank_result,
	DENSE_RANK() OVER(PARTITION BY week ORDER BY streams_millions ASC) AS dense_rank_result
FROM
	windows_functions.streams;

--Пример использования оконной функции NTILE:
SELECT
	artist,
	week,
	streams_millions,
	NTILE(5) OVER(ORDER BY streams_millions DESC) AS weekly_streams_group
FROM
	windows_functions.streams;

--Пример использования использования оконной функции NTILE с группировкой по неделям :
SELECT
		artist,
		week,
		streams_millions,
		NTILE(4) OVER(PARTITION BY week ORDER BY streams_millions DESC) AS quartile
	FROM
		windows_functions.streams;

--Посмотреть какие данные хранятся в таблице state_climate в схеме windows_functions
SELECT
	*
FROM
	windows_functions.state_climate;

--Посмотрим как изменяется средняя температура с течением времени в каждом штате		
SELECT
	state,
	year,
	tempf,
	AVG(tempf) OVER(PARTITION BY state ORDER BY year) AS running_avg_tempf,
	tempc,
	AVG(tempc) OVER(PARTITION BY state ORDER BY year) AS running_avg_tempc
FROM
	windows_functions.state_climate;	


--Найти самую низкую температуру по каждому штату
SELECT
	state,
	year,
	tempf,
	FIRST_VALUE(tempf) OVER(PARTITION BY state ORDER BY tempf) AS lowest_tempf,
	tempc,
	FIRST_VALUE(tempc) OVER(PARTITION BY state ORDER BY tempc) AS lowest_tempc
FROM
	windows_functions.state_climate;
	
--Найти самую высокую температуру по каждому штату
SELECT
	state,
	year,
	tempf,
	LAST_VALUE(tempf) OVER(PARTITION BY state ORDER BY tempf RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS highest_tempf,
	tempc,
	LAST_VALUE(tempc) OVER(PARTITION BY state ORDER BY tempc RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS highest_tempc
FROM
	windows_functions.state_climate;

--Посмотрим на сколько меняется температура каждый год в каждом штате		
SELECT
	state,
	year,
	tempf,
	tempf - LAG(tempf, 1, tempf) OVER(PARTITION BY state ORDER BY year) AS change_in_tempf,
	tempc,
	tempc - LAG(tempc, 1, tempc) OVER(PARTITION BY state ORDER BY year) AS change_in_tempc
FROM
	windows_functions.state_climate;	

--Найти самую низкую температуру за всю историю
SELECT
	state,
	year,
	tempf,
	RANK() OVER(ORDER BY tempf) AS coldest_rankf,
	tempc,
	RANK() OVER(ORDER BY tempc) AS coldest_rankc
FROM
	windows_functions.state_climate;	

--Найти самую высокую температуру в разбивке по штатам		
SELECT
	state,
	year,
	tempf,
	RANK() OVER(PARTITION BY state ORDER BY tempf DESC) AS warmest_rankf,
	tempc,
	RANK() OVER(PARTITION BY state ORDER BY tempc DESC) AS warmest_rankc
FROM
	windows_functions.state_climate;	

--Выведем среднегодовые температуры в квартилях и квантилях, а не в рейтингах для каждого штата
SELECT
	state,
	year,
	tempf,
	NTILE(4) OVER(PARTITION BY state ORDER BY tempf) AS quartile_f,
	NTILE(5) OVER(PARTITION BY state ORDER BY tempf) AS quintile_c,
	tempc,
	NTILE(4) OVER(PARTITION BY state ORDER BY tempc) AS quartile_c,
	NTILE(5) OVER(PARTITION BY state ORDER BY tempc) AS quintile_c
FROM
	windows_functions.state_climate;	

--Посмотреть какие данные хранятся в таблице summer_medals в схеме windows_functions
SELECT
	*
FROM
	windows_functions.summer_medals;

--Присвоим номер каждой выбранной записи с помощью оконной функции ROW_NUMBER()
SELECT
	athlete,
	event,
	ROW_NUMBER() OVER() AS row_number
FROM
	windows_functions.summer_medals
ORDER BY
	row_number ASC;

--Найдем всех олимпийских чемпионов по теннису (мужчин и женщин отдельно), начиная с 2004 года,
--и для каждого из них выяснить, кто был предыдущим чемпионом.

--Табличное выражение ищет теннисных чемпионов и выбирает нужные столбцы
WITH tennis_gold AS
	(SELECT
		athlete,
		gender,
		year,
		country
	FROM
		windows_functions.summer_medals
	WHERE
		year >= 2004
	 	AND
		sport = 'Tennis'
	 	AND
		event = 'singles'
	 	AND
		medal = 'Gold')
		
--Оконная функция разделяет по полу и берёт чемпиона из предыдущей строки
SELECT
	athlete as champion,
	gender,
	year,
	LAG(athlete) OVER (PARTITION BY gender ORDER BY year ASC) AS last_champion
FROM
	tennis_gold
ORDER BY
	gender ASC,
	year ASC;

--Найдем всех олимпийских чемпионов по теннису (мужчин и женщин отдельно), начиная с 2004 года,
--и для каждого из них выяснить, кто был cледующим чемпионом.

--Табличное выражение ищет теннисных чемпионов и выбирает нужные столбцы
WITH tennis_gold AS
	(SELECT
		athlete,
		gender,
		year,
		country
	FROM
		windows_functions.summer_medals
	WHERE
		year >= 2004
	 	AND
		sport = 'Tennis'
	 	AND
		event = 'singles'
	 	AND
		medal = 'Gold')
		
--Оконная функция разделяет по полу и берёт чемпиона из следующей строки
SELECT
	athlete as champion,
	gender,
	year,
	LEAD(athlete) OVER (PARTITION BY gender ORDER BY year ASC) AS last_champion
FROM
	tennis_gold
ORDER BY
	gender ASC,
	year ASC;

--Ранжирование стран по числу олимпиад, в которых они участвовали, разными оконными функциями:
-- Табличное выражение выбирает страны и считает годы
WITH countries AS
	(SELECT
		sm.country,
		COUNT(DISTINCT sm.year) AS participated
	FROM
		windows_functions.summer_medals AS sm
	WHERE
		sm.country
	 		IN
	 			('GBR', 'DEN', 'FRA', 'ITA','AUT')
	GROUP BY
		sm.country)

-- Разные оконные функции ранжируют страны
SELECT
	c.country,
	c.participated,
	ROW_NUMBER() OVER(ORDER BY c.participated DESC) AS "row_number",
	RANK() OVER(ORDER BY c.participated DESC) AS rank_number,
	DENSE_RANK() OVER(ORDER BY c.participated DESC) AS "dense_rank"
FROM
	countries AS c
ORDER BY
	c.participated DESC;










	

