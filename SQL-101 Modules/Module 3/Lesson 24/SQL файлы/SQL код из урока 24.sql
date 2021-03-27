--DQL – Data Query Language
--DDL – Data Definition Language
--DML – Data Manipulation Language
--DCL – Data Control Language
--TCL – Transaction Control Language

--SQL – Structured Query Language
--SEQUEL – Structured English Query Language

--Синтаксис создания новой таблицы
	--CREATE TABLE table_name (
	--column1 datatype,
	--column2 datatype,
	--column3 datatype,
	--....
--);


--Создание новой таблицы Person c 5 столбцами
CREATE TABLE Person
(
	PersonID INT,
	LastName VARCHAR(255),
	FirstName VARCHAR(255),
	Address VARCHAR(255),
	City VARCHAR(255)
);

--Выборка данных (таблица пустая)
SELECT 
	*
FROM
	Person;

--Удалить таблицу Person
DROP TABLE [dbo].[Person];

--2-ой способ создания таблиц (синтаксис):
--SELECT
--	column1, column2,...
--INTO
--	new_table_name
--FROM
--	existing_table_name
--WHERE
--	....;

--Пример создания таблицы новым способом
SELECT
	[AddressID],
	[AddressLine1],
	[City]
INTO
	Address_Berlin
FROM
	[Person].[Address]
WHERE
	[City] = 'Berlin';

--Выборка данных из нашей таблицы
SELECT [AddressID]
      ,[AddressLine1]
      ,[City]
  FROM [dbo].[Address_Berlin];

--Синтаксис изменения структуры таблицы:
--ALTER TABLE table_name
--ADD
--column_name_1 data_type_1; 

--Изменить таблицу Person добавив в нее новый столбец DateCreated с типой данных date: 
ALTER TABLE Person
ADD DateCreated date;

--Синтаксис наполнения таблицы данными (перечисляем конкретные столбцы)
--INSERT INTO table_name (column1, column2, column3, ...)
--VALUES (value1, value2, value3, ...);

--Синтаксис наполнения таблицы данными (данные добавляются во все столбцы)
--INSERT INTO table_name
--VALUES (value1, value2, value3, ...);

--Добавление данных в таблицу
INSERT INTO Person (PersonID, LastName, FirstName, Address, City, DateCreated)
VALUES ('1', 'Ivanov', 'Ivan', 'Ukraine', 'Kyiv', '2020-12-01');

INSERT INTO Person (PersonID, LastName, FirstName, Address, DateCreated)
VALUES ('2', 'Sergeev', 'Sergey', 'USA', '2021-02-16'),
		('3', 'Petrov', 'John', 'Greece', '2021-02-16');34_3


--Обновить данные в таблице (синтаксис)
--UPDATE table_name
--SET column1 = value1, column2 = value2...., columnN= valueN
--WHERE [condition];

--Пример обновления данных в таблице
UPDATE Person
SET City = 'Kharkiv'
WHERE LastName='Ivanov';

--Еще 1 пример обновления данных в таблице
UPDATE Person
SET City = 'Unknown'
WHERE City IS NULL;

--Удалить данніе в таблице (синтаксис)
--DELETE
--FROM table_name
--WHERE search_condition;

--Пример удаления данных в таблице
DELETE
FROM Person
WHERE LastName='Ivanov';

--Пример обычного запроса с условием
SELECT
	*
FROM
	[Person].[Person]
WHERE
	LastName LIKE '%v%';

--Создание новой таблицы bestsellers_high_rating на базе таблицы Bestsellers:
SELECT
	boa.Author,
	boa.Name,
	boa.Price
INTO
	bestsellers_high_rating
FROM
	[dbo].[Bestsellers] AS boa
WHERE
	boa.User_Rating > 4.5;








