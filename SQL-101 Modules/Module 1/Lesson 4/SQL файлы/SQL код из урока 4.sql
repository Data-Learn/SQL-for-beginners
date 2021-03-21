SELECT * FROM avocado_prices; --Выборка цен на авокадо

SELECT * FROM books; --Получение информации из таблицы по книгам

SELECT * FROM video_game_sales; --Информация о продаж видео игр

/*В данной таблице представлена подробная информация о книгах:
 - идентификаторе книги (book_id),
 - названии (title),
 - авторе (authors), 
 - среднем рейтинге книги (average_rating),
 - международном номере книги (isbn),
 - языке, на котором она написана (language_code),
 - количестве страниц (num_pages),
 - количествe оценок рейтинга (ratings_count),
 - количестве написанных рецензий (отзывов) на книгу (text_reviews_count)б
 - дате публикации книги (pyblication_date),
 - издателе книги (publisher).*/

SELECT title, authors, publisher FROM books; --вывод названия книги, автора, издателя

SELECT language_code, title, publication_date FROM books; --вывод языка книга, названия книги и даты публикации

SELECT DISTINCT language_code FROM books; --вывод уникальных значений языков. 

