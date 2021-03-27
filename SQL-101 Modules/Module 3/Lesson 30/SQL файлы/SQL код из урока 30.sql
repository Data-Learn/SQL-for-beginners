-- Логический порядок обработки операторов в SQL запросе

--FROM
--ON
--JOIN
--WHERE
--GROUP BY
--WITH CUBE или WITH ROLLUP
--HAVING
--SELECT
--DISTINCT
--ORDER BY
--TOP

-- Наш запрос из видео:
SELECT
	C.CustomerID,
	E.BusinessEntityID
FROM
	Sales.Customer AS C
CROSS JOIN
	HumanResources.Employee AS E;

--Отдельная выборка из первой таблицы:

SELECT
	*
FROM
	Sales.Customer;

--Отдельная выборка из второй таблицы:

SELECT
	*
FROM
	HumanResources.Employee;

--Текстовый формат плана выполнения запроса, который отображает преполагаемый план с полным набором информации

SET SHOWPLAN_ALL ON
GO

SELECT
	*
FROM
	sys.databases;

--SET SHOWPLAN_ALL OFF

--Текстовый формат плана выполнения запроса, который отображает преполагаемый план с ограниченным набором информации

SET SHOWPLAN_TEXT ON
GO

SELECT
	*
FROM
	sys.databases;

--SET SHOWPLAN_TEXT OFF

--Текстовый формат плана выполнения запроса, который отображает фактический план со всеми деталями

SET STATISTICS PROFILE ON 
GO

SELECT
	*
FROM
	sys.databases;

--SET STATISTICS PROFILE OFF


--XML формат плана выполнения запроса, который отображает преполагаемый план

SET SHOWPLAN_XML ON 
GO

SELECT
	*
FROM
	sys.databases;

--SET SHOWPLAN_XML OFF

--XML формат плана выполнения запроса, который отображает фактический план

SET STATISTICS XML ON 
GO

SELECT
	*
FROM
	sys.databases;

--SET STATISTICS XML OFF

--Пример Nested Loops Joins

SELECT
	SOH.OrderDate,
	SOD.OrderQty,
	SOD.ProductID,
	SOD.UnitPrice
FROM
	Sales.SalesOrderDetail AS SOD
JOIN
	Sales.SalesOrderHeader AS SOH
		ON SOH.SalesOrderID = SOD.SalesOrderID
WHERE
	SOH.OrderDate BETWEEN '2013-07-01' AND '2013-07-05';

--поменять для теста '2013-07-05' на '2014-07-05'  и будет merge join

--Пример Merge Joins

SELECT
	C.CustomerID,
	SOH.SalesOrderID
FROM
	Sales.SalesOrderHeader AS SOH
JOIN
	Sales.Customer AS C
		ON SOH.CustomerID = C.CustomerID;

--Пример Hash Match Joins

SELECT
	C.PersonID,
	C.AccountNumber,
	SOH.SalesOrderID
FROM
	Sales.SalesOrderHeader AS SOH
JOIN
	Sales.Customer AS C
		ON SOH.TerritoryID = C.TerritoryID
WHERE
	C.AccountNumber LIKE '%067%';

--Создадим 2 таблицы на основе таблиц, в которых есть индексы:

SELECT
	*
INTO
	Sales.SalesOrderHeader1
FROM
	Sales.SalesOrderHeader;

SELECT
	*
INTO
	Sales.SalesOrderDetail1
FROM
	Sales.SalesOrderDetail;

--Query Hints ("заставить" SQL Server выбрать тот или иной тип физического соединения,
--для этого используем ключевое слово OPTION и в круглых скобках указываем название соединения)

--Для исходного запроса по-умолчанию выбирается тип соединения Merge join
--Но мы принудительно задаем Hash match join

SELECT
	C.CustomerID,
	SOH.SalesOrderID
FROM
	Sales.SalesOrderHeader AS SOH
JOIN
	Sales.Customer AS C
		ON SOH.CustomerID = C.CustomerID
OPTION (HASH JOIN)

--Для исходного запроса по-умолчанию выбирается тип соединения Hash match join
--Но мы принудительно задаем Nested Loops join

SELECT
	SOH.CustomerID,
	SOH.SalesOrderID,
	SOD.ProductID
FROM
	Sales.SalesOrderHeader1 SOH
INNER JOIN
	Sales.SalesOrderDetail1 SOD
		ON SOH.SalesOrderID = SOD.SalesOrderID 
WHERE
	SOH.CustomerID = 29825
OPTION (LOOP JOIN)

--Для исходного запроса по-умолчанию выбирается тип соединения Hash match join
--Но мы принудительно задаем Merge join

SELECT
	SOH.CustomerID,
	SOH.SalesOrderID,
	SOD.ProductID
FROM
	Sales.SalesOrderHeader1 SOH 
INNER JOIN
	Sales.SalesOrderDetail1 SOD
		ON SOH.SalesOrderID = SOD.SalesOrderID 
WHERE
	SOH.CustomerID = 29825
OPTION (MERGE JOIN)

--------------------------------------------------Индексы--------------------------------------------------

-- Посмотреть данные об индексах в sys.indexes:

SELECT
	*
FROM
	[master].[sys].[indexes];

--Создадим для теста новую базу данных:

CREATE DATABASE schooldb;

--Переключимся на эту базу данных:
USE schooldb;

--Создадим таблицу в этой базе данных:
          
CREATE TABLE student
(
	ID INT PRIMARY KEY,
	Name VARCHAR(50) NOT NULL,
	Gender VARCHAR(50) NOT NULL,
	DOB datetime NOT NULL,
	TotalScore INT NOT NULL,
	City VARCHAR(50) NOT NULL
 );

--Чтобы увидеть все индексы в конкретной таблице, выполним хранимую процедуру sp_helpindex
          
EXECUTE sp_helpindex student;

--Наполним нашу таблицу тестовыми данными

INSERT INTO
	student
VALUES  
	(6, 'Kate', 'Female', '03-JAN-1985', 500, 'Liverpool'), 
	(2, 'Jon', 'Male', '02-FEB-1974', 545, 'Manchester'),
	(9, 'Wise', 'Male', '11-NOV-1987', 499, 'Manchester'), 
	(3, 'Sara', 'Female', '07-MAR-1988', 600, 'Leeds'), 
	(1, 'Jolly', 'Female', '12-JUN-1989', 500, 'London'),
	(4, 'Laura', 'Female', '22-DEC-1981', 400, 'Liverpool'),
	(7, 'Joseph', 'Male', '09-APR-1982', 643, 'London'),  
	(5, 'Alan', 'Male', '29-JUL-1993', 500, 'London'), 
	(8, 'Mice', 'Male', '16-AUG-1974', 543, 'Liverpool'),
	(10, 'Elis', 'Female', '28-OCT-1990', 400, 'Leeds');

--Сделаем выборку из нашей таблицы и посмотрим на результат:

SELECT
	*
FROM
	student;

--Удалим автоматически созданный кластерный индекс вручную через графическое меню
-- и создадим новый кластерный индекс

CREATE CLUSTERED INDEX IX_tblStudent_Gender_Score
	ON student(gender ASC, TotalScore DESC);

--Сделаем выборку из нашей таблицы и посмотрим на результат::

SELECT
	*
FROM
	student;

-- создадим некластерный индекс:

CREATE NONCLUSTERED INDEX IX_tblStudent_Name
	ON student(name ASC);

--Когда выполняется запрос к столбцу, по которому создается индекс,
--база данных сначала переходит к индексу и ищет адрес соответствующей 
--строки в таблице. Затем он перейдет к адресу этой строки и получит другие значения столбца.

--Переключимся на другую базу данных:

USE AdventureWorks2019;

--Создадим новую таблицу на базе таюлицы, у которой есть индексы:

SELECT
	*
INTO
	Person.Person2
FROM
	Person.Person;

--Сделаем выборку из нашей исходной таблицы, где есть индексы:

SELECT
	*
FROM 
	Person.Person
WHERE
	BusinessEntityID = 1;

--Сделаем выборку из нашей созданной таблицы, где нет индексов:

SELECT
	*
FROM 
	Person.Person2
WHERE
	BusinessEntityID = 1;

--Посмотрим информацию об индексах нашей новой созданной таблицы:

SELECT
	*
FROM
	sys.indexes
WHERE
	object_id = OBJECT_ID('Person.Person2', 'U');

--Создадим некластерный индекс:

CREATE NONCLUSTERED INDEX IX_Last_Name
	ON Person.Person2(LastName DESC);

--Создадим кластерный индекс:

CREATE CLUSTERED INDEX IX_BusinessEntityID
	ON Person.Person2(BusinessEntityID ASC);

--Сделем запрос, в котором у нас будут содержаться столбец с некластерным индексом:
SELECT
	LastName
FROM
	Person.Person2
WHERE
	LastName = 'Ross';

--Сделем запрос, в котором у нас будут содержаться столбец с некластерным индексом и столбец без индекса:

SELECT
	FirstName,
	LastName
FROM
	Person.Person2
WHERE
	LastName = 'Ross';

--Сделем запрос, в котором у нас будут содержаться столбец с некластерным индексом и столбец без индекса,
-- при этом у нас фильтр будет сразу по столбцу с кластерным индексом:

SELECT
	FirstName,
	LastName
FROM
	Person.Person2 
WHERE
	BusinessEntityID = 1; 