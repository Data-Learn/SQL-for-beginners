--задание псенвдонима для таблицы с указанием схемы, откуда мы берем нашу таблицу
SELECT
	b.authors,
	b.title
FROM
	public.books AS b;

--базовый пример с заданием псевдонимов для таблиц
SELECT
	b.authors,
	b.title,
	m.authors,
	m.title
FROM
	public.books AS b
JOIN
	public.magazines AS m;

--менее читабельный код без задания псевдонимов для таблиц
SELECT
	books.authors,
	books.title,
	magazines.authors,
	magazines.title
FROM
	public.books
JOIN
	public.magazines;

--еще примеры запросов с заданием псевдонимов для таблиц

SELECT
	*
FROM
	public.avocado_prices AS ap;

--
SELECT
	*
FROM
	public.video_game_sales AS vgs;

	


	


	
