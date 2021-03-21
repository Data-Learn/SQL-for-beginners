--Вывести книги только Джоан Роулинг
SELECT
	*
FROM
	books
WHERE
	authors = 'J.K. Rowling';

-- вывести книги издательства Scholastic Inc.
SELECT
	*
FROM
	books
WHERE
	publisher = 'Scholastic Inc.';

--вывести несколько издателей
SELECT
	*
FROM
	books
WHERE
	publisher = 'Scholastic Inc.'
	OR
	publisher = 'Scholastic';

--вывести книги с определенным издателем (Scholastic Inc.), а также те (отдельно), которые написаны на языке 'eng'
SELECT
	*
FROM
	books
WHERE
	publisher = 'Scholastic Inc.'
	OR
	language_code = 'eng'
ORDER BY
	publisher;

--вывести книги изданные Scholastic Inc. при условии, что они написаны на языке 'eng'
SELECT
	*
FROM
	books
WHERE
	publisher = 'Scholastic Inc.'
	AND
	language_code = 'eng-US'
ORDER BY
	publisher;

--вывести книги с определенным издателем (Scholastic Inc.), а также те (отдельно), которые написаны на языке 'eng-US'
SELECT
	*
FROM
	books
WHERE
	publisher = 'Scholastic Inc.'
	OR
	language_code = 'eng-US'
ORDER BY
	publisher;

--вывести книги автора John McPhee со средним рейтингом книг больше 4
SELECT
	*
FROM
	books
WHERE
	authors = 'John McPhee'
	AND
	average_rating > 4;

--вывести все книги автора John McPhee или любые книги с рейтингом больше 4 (без привязки к автору)
SELECT
	*
FROM
	books
WHERE
	authors = 'John McPhee'
	OR
	average_rating > 4
ORDER BY
	authors;

--вывести книги двух авторов
SELECT
	*
FROM
	books
WHERE
	authors = 'Douglas Adams'
	OR
	authors = 'Frank Herbert';

--вывести книги написанные двумя авторами:
SELECT
	*
FROM
	books
WHERE
	authors = 'J.K. Rowling/Mary GrandPré';

--вывести книги, которые НЕ написаны J.K. Rowling
SELECT
	*
FROM
	books
WHERE
	NOT authors = 'J.K. Rowling';

--вывести книги с рейтингом 4.57 или 3.60 в порядке убывания
SELECT
	*
FROM
	books
WHERE
	average_rating = 4.57
	OR
	average_rating = 3.60
ORDER BY
	average_rating DESC;

--вывести книги с рейтингом в диапазоне между 3.60 и 4.57 в порядке убывания
SELECT
	*
FROM
	books
WHERE
	average_rating >= 3.60
	AND
	average_rating <= 4.57
ORDER BY
	average_rating DESC;

--вывести книги с рейтингом в диапазоне между 3.60 и 4.57 в порядке убывания с использованием оператора BETWEEN
SELECT
	*
FROM
	books
WHERE
	average_rating BETWEEN 3.60 AND 4.57
ORDER BY
	average_rating DESC;

--вывести книги в диапазоне 3.60 и 4.57 в порядке убывания при условии, что значения 3.60 и 4.57 не включены
SELECT
	*
FROM
	books
WHERE
	average_rating > 3.60
	AND
	average_rating < 4.57
ORDER BY
	average_rating DESC;

--вывести книги автора Bill Bryson, при условии, что средний рейтинг его книг = 3.90 ИЛИ количество страниц больше чем 300
SELECT
	*
FROM
	books
WHERE
	authors = 'Bill Bryson'
	AND (average_rating = 3.90 OR num_pages > 300);

--вывести книги автора Bill Bryson, при условии, что средний рейтинг его книг = 3.90 И количество страниц больше чем 300
SELECT
	*
FROM
	books
WHERE
	authors = 'Bill Bryson'
	AND (average_rating = 3.90 AND num_pages > 300);

--пример комбинированного условия (приоритет операторов AND и OR)
SELECT
	*
FROM
	books
WHERE
	authors = 'Bill Bryson'
	AND average_rating = 3.90 OR num_pages > 300
ORDER BY
	authors,
	average_rating;

--изменение приоритета за счет фигурных скобок
SELECT
	*
FROM
	books
WHERE
	authors = 'Bill Bryson'
	AND (average_rating = 3.90 OR num_pages > 300)
ORDER BY
	authors,
	average_rating;

