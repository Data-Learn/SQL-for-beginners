--арифметичеcкие операции со значениями столбцов
SELECT
	title,
	average_rating,
	average_rating + 1 AS average_rating_plus_one
FROM
	books;


--вывод уникальный авторов и уникальных языков, на которых написаны (изданы) книги
SELECT
	DISTINCT authors,
	language_code
FROM
	books
ORDER BY
	authors ASC,
	language_code DESC;

--сортировка книг и авторов по количеству оценок рейтинга по убыванию
SELECT
	title,
	authors,
	ratings_count
FROM
	books
ORDER BY
	ratings_count DESC;

--вывод топ-10 самый популярных книг исходя из количества оценок
SELECT
	title,
	authors,
	ratings_count
FROM
	books
ORDER BY
	ratings_count DESC
LIMIT
	10;

--отсечение некоторых строк из вывода
SELECT
	title,
	authors,
	ratings_count
FROM
	books
ORDER BY
	ratings_count DESC
OFFSET
	10;

-- комбинация операторов LIMIT и OFFSET

SELECT
	title,
	authors,
	ratings_count
FROM
	books
ORDER BY
	ratings_count DESC
LIMIT
	3
OFFSET
	3;

--быстрый просмотр первых 10 строк в таблице
SELECT
	*
FROM
	books
LIMIT
	10;















