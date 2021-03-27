USE [AdventureWorks2019];

--Создать синоним

CREATE SYNONYM
	P1 FOR [Person].[Person];

--Сделать выборку из исходной таблицы

SELECT
	*
FROM
	[Person].[Person];

--Сделать выборку из исходной таблицы, обращаясь к её синониму

SELECT
	*
FROM
	P1;

--Удалить созданный синоним

DROP SYNONYM
	P1;

--создаем таблицу с кандидатами
CREATE TABLE candidates ( 
	candname VARCHAR(10) NOT NULL, 
	gender CHAR(1) NOT NULL CONSTRAINT chk_gender CHECK (gender IN ('F', 'M')) 
  );

--наполняем её данными
INSERT INTO
	dbo.candidates 
VALUES
	('Neil', 'M'),
	('Trevor', 'M'), 
	('Terresa', 'F'),
	('Mary', 'F');

--делаем выборку из нашей таблицы
SELECT
	*
FROM
	dbo.candidates;

--строим нашу таблицу рекомендаций для свиданий

SELECT
	C1.candname, 
    C2.candname 
FROM
	dbo.candidates AS C1 
CROSS JOIN
	dbo.candidates AS C2
WHERE
	C1.candname <> C2.candname AND
	C1.gender <> C2.gender AND
	C1.gender = 'M';

--TOP фильтры

--Вывести все данные из нашей таблицы

SELECT
	Name,
	ProductNumber,
	StandardCost
FROM
	Production.Product
ORDER BY
	StandardCost DESC;

--Вывести первые 20 значений

SELECT
	TOP 20 Name,
	ProductNumber,
	StandardCost
FROM
	Production.Product
ORDER BY
	StandardCost DESC;

--Вывести первые 20 значений с повторами значений из столбца в ORDER BY

SELECT
	TOP 20 WITH TIES Name
	ProductNumber,
	StandardCost
FROM
	Production.Product
ORDER BY
	StandardCost DESC;

--Вывести 20% значений из нашей исходной таблицы

SELECT
	TOP 20 PERCENT Name,
	ProductNumber,
	StandardCost
FROM
	Production.Product
ORDER BY
	StandardCost DESC;

--Пропустить первые 20 строк и вывести следующие 20 строк из нашей таблицы

SELECT
	Name,
	ProductNumber,
	StandardCost
FROM
	Production.Product
ORDER BY
	StandardCost DESC
OFFSET
	20 ROWS
FETCH
	NEXT 20 ROWS ONLY;

--Пропустить 0 строк и вывести следующие 20 строк из нашей таблицы

SELECT
	Name,
	ProductNumber,
	StandardCost
FROM
	Production.Product
ORDER BY
	StandardCost DESC
OFFSET
	0 ROWS
FETCH
	NEXT 20 ROWS ONLY;

--Пропустить первые 20 строк и вывести все оставшиеся данные из нашей таблицы из нашей таблицы

SELECT
	Name,
	ProductNumber,
	StandardCost
FROM
	Production.Product
ORDER BY
	StandardCost DESC
OFFSET
	20 ROWS;

SELECT
	PI.ProductID,
	PI.LocationID,
	PI.Quantity
FROM
	Production.ProductInventory AS PI;

SELECT TOP 3
	PI.ProductID,
	PI.LocationID,
	PI.Quantity
FROM
	Production.ProductInventory AS PI
ORDER BY
	PI.Quantity DESC;

SELECT
	P.ProductID,
	P.Name
FROM
  Production.Product AS P;

--CROSS APPLY

SELECT
	P.ProductID,
	P.Name,
	A.LocationID,
	A.Quantity
FROM
  Production.Product AS P
CROSS APPLY
	(SELECT TOP 3
		PI.ProductID,
		PI.LocationID,
		PI.Quantity
	FROM
		Production.ProductInventory AS PI
	WHERE
		PI.ProductID = P.ProductID
	ORDER BY
		PI.Quantity DESC) AS A
ORDER BY
	P.ProductID;

--OUTER APPLY

SELECT
	P.ProductID,
	P.Name,
	A.LocationID,
	A.Quantity
FROM
  Production.Product AS P
OUTER APPLY
	(SELECT TOP 3
		PI.ProductID,
		PI.LocationID,
		PI.Quantity
	FROM
		Production.ProductInventory AS PI
	WHERE
		PI.ProductID = P.ProductID
	ORDER BY
		PI.Quantity DESC) AS A
ORDER BY
	P.ProductID;

--создадим новую базу данных
CREATE DATABASE
	University;

--переключимся на неё
USE
	University;

--создадим в новой базе данных таблицу

CREATE TABLE Class
(
	ID INT PRIMARY KEY IDENTITY,
	StudentName VARCHAR(50),
	Course VARCHAR(50),
	Score INT
);

--наполним эту талицу тестовыми данными

INSERT INTO
	dbo.Class
VALUES
	('Sally', 'English', 95),
	('Sally', 'History', 82),
	('Edward', 'English', 45),
	('Edward', 'History', 78);

USE
	University;

--сделаем выборку из нашей исходной таблицы

SELECT
	*
FROM
	dbo.Class;

--перевернем данные из строк в столбцы используя PIVOT

SELECT
	*
FROM
	(SELECT 
		StudentName,
		Course,
		Score
	FROM 
		dbo.Class
	) AS ClassTable
PIVOT
	(
		SUM(Score)
			FOR Course IN
				([English],[History])
	) AS SchoolPivot;

--перевернутые данные обратно вернем в строки из столбцов используя UNPIVOT

WITH original AS
	(SELECT
		*
	FROM
		(SELECT 
			StudentName,
			Course,
			Score
		FROM 
			dbo.Class
		) AS ClassTable
	PIVOT
		(
			SUM(Score)
				FOR Course IN
					([English],[History])
		) AS SchoolPivot
	UNPIVOT
		(Score
			FOR Course IN
				(English, History)
		) AS SchoolUnpivot)
SELECT
	StudentName,
	Course,
	Score
FROM
	original
ORDER BY
	1 DESC;


--Коррелируемый подзапрос:
SELECT
	P.Name,
	P.ListPrice, 
	(SELECT
		PM.Name 
	 FROM
		Production.ProductModel AS PM
	 WHERE
		PM.ProductModelID = P.ProductID) AS Model 
FROM
	Production.Product AS P;

--Вариант решения через LEFT JOIN

SELECT
	P.Name,
	P.ListPrice,
	PM.Name
FROM
	Production.Product AS P
LEFT JOIN
	Production.ProductModel AS PM
		ON PM.ProductModelID = P.ProductID;

--Пример не коррелируемого запроса:

--Вариант 1

SELECT
	SOH.SalesOrderID,
	SOH.OrderDate,
	SOH.CustomerID
FROM
	Sales.SalesOrderHeader AS SOH
WHERE
	SOH.CustomerID = (SELECT
				C.CustomerID
			  FROM
				Sales.Customer AS C
			  JOIN
				Person.Person AS P
					ON C.PersonID = P.BusinessEntityID
			  WHERE
				P.LastName = 'Sullivan'
				AND
				P.FirstName = 'Michael');

--Вариант 2

SELECT
	SP.BusinessEntityID 
FROM
	Sales.SalesPerson AS SP 
WHERE
	SP.Bonus > (SELECT
		    	MIN(SP.Bonus) 
		    FROM
			Sales.SalesPerson AS SP);

--Подзапрос с использованием ALL

SELECT
	BusinessEntityID,
	Bonus
FROM
	Sales.SalesPerson 
WHERE
	Bonus > ALL (SELECT
			Bonus 
		     FROM
			Sales.SalesPerson
		     WHERE
			SalesQuota = 250000);

--Подзапрос с использованием ANY

SELECT
	BusinessEntityID,
	Bonus
FROM
	Sales.SalesPerson 
WHERE
	Bonus > ANY (SELECT
			Bonus 
		     FROM
			Sales.SalesPerson
		     WHERE
			SalesQuota = 250000);

--подзапрос с использованием IN

SELECT
	SalesOrderID,
	OrderDate,
	AccountNumber,
	CustomerID,
	SalesPersonID,
	TotalDue
FROM
	Sales.SalesOrderHeader
WHERE
	SalesPersonID
		IN
			(279, 286, 289);

--подзапрос с использованием NOT IN

SELECT
	SalesOrderID,
    	OrderDate,
    	AccountNumber,
    	CustomerID,
    	SalesPersonID,
    	TotalDue
FROM
	Sales.SalesOrderHeader
WHERE
	SalesPersonID
		NOT IN
			(SELECT
				BusinessEntityID
             		 FROM
				Sales.SalesPerson
             		 WHERE
				Bonus > 5000);

--с помощью подзапроса проверить существуют ли у нас не заполненные идентификаторы заказа с помощью подзапроса с использованием IN

SELECT
	SalesOrderID,
	RevisionNumber,
	OrderDate
FROM
	Sales.SalesOrderHeader
WHERE
	SalesOrderID
		IN (SELECT NULL);

--подзапрос с использованием EXISTS

SELECT
	SOH.SalesOrderID,
	SOH.OrderDate
FROM
	Sales.SalesOrderHeader AS SOH
WHERE
	EXISTS (SELECT
			*
            	FROM
			Sales.SalesPerson AS SP
            	WHERE
			SP.SalesYTD > 3000000
			AND
			SOH.SalesPersonID = SP.BusinessEntityID);

--подзапрос с использованием NOT EXISTS

SELECT
	SOH.SalesOrderID,
	SOH.OrderDate
FROM
	Sales.SalesOrderHeader AS SOH
WHERE
	NOT EXISTS (SELECT
			*
            	FROM
			Sales.SalesPerson AS SP
            	WHERE
			SP.SalesYTD > 3000000
			AND
			SOH.SalesPersonID = SP.BusinessEntityID);

--Пример рекурсивного CTE

WITH cte_numbers (number_day, weekday) AS
(
	SELECT 
		0, 
        DATENAME(DW, 0)
    UNION ALL
    SELECT    
        number_day + 1, 
        DATENAME(DW, number_day + 1)
    FROM    
        cte_numbers
    WHERE
		number_day < 6
)
SELECT 
	number_day,
    weekday
FROM 
    cte_numbers;

--Вариант 1 написания конструкции CASE

SELECT
	ContactTypeID,
	CASE ContactTypeID
		WHEN 2 THEN 'Two'
		WHEN 1 THEN 'One'
		WHEN 0 THEN 'Zero'
		ELSE 'Other'
	END AS number
FROM
	Person.ContactType
WHERE
	ContactTypeID < 10;

--Вариант 2 написания конструкции CASE

SELECT
	ContactTypeID,
    	CASE
		WHEN ContactTypeID = 2 THEN 'Two'
		WHEN ContactTypeID = 1 THEN 'One'
		WHEN ContactTypeID = 0 THEN 'Zero'
		ELSE 'Other'
	END AS number
FROM
	Person.ContactType
WHERE
	ContactTypeID < 10;

--Пример объясления переменных в конструкции CASE:

--Пример 1

DECLARE
	@a TINYINT = 1,
	@b VARCHAR(10) = 'Привет!',
	@c BIT

SELECT
	CASE
		WHEN @a > 2 THEN N'a больше 2. Это неверно.'
		WHEN LEN(@b) = 10 THEN N'b состоит из 10 символов. Это неверно.'
		WHEN @c IS NULL AND @b LIKE 'П%' THEN N'c содержит пустое значение! b начинается с буквы «П»! Это верно!'
		ELSE N'Очевидно, мы не знаем, что происходит'
	END AS выражение;

--Пример 2 (меняем значение переменной а)

DECLARE
	@a TINYINT = 3,
	@b VARCHAR(10) = 'Привет!',
	@c BIT

SELECT
	CASE
		WHEN @a > 2 THEN N'a больше 2.'
		WHEN LEN(@b) = 10 THEN N'b состоит из 10 символов.'
		WHEN @c IS NULL AND @b LIKE 'П%' THEN N'c содержит пустое значение! b начинается с буквы «П»!'
		ELSE N'Очевидно, мы не знаем, что происходит'
	END AS выражение;


--Пример 3 (меняем значение переменной b)

DECLARE
	@a TINYINT = 1,
	@b VARCHAR(10) = 'Объявление',
	@c BIT

SELECT
	CASE
		WHEN @a > 2 THEN N'a больше 2.'
		WHEN LEN(@b) = 10 THEN N'b состоит из 10 символов.'
		WHEN @c IS NULL AND @b LIKE 'П%' THEN N'c содержит пустое значение! b начинается с буквы «П»!'
		ELSE N'Очевидно, мы не знаем, что происходит'
	END AS выражение;

--Пример 4 (меняем значение переменной b, чтобы выполнялось последнее условие)

DECLARE
	@a TINYINT = 1,
	@b VARCHAR(10) = 'Новости',
	@c BIT = 0

SELECT
	CASE
		WHEN @a > 2 THEN N'a больше 2.'
		WHEN LEN(@b) = 10 THEN N'b состоит из 10 символов.'
		WHEN @c IS NULL AND @b LIKE 'П%' THEN N'c содержит пустое значение! b начинается с буквы «П»!'
		ELSE N'Очевидно, мы не знаем, что происходит'
	END AS выражение;






















