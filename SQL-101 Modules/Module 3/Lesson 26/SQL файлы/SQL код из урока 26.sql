--CREATE TABLE table_name (
--	column1 datatype constraint,
--	column2 datatype constraint,
--	column3 datatype constraint,
--	....
--);

--NOT NULL - гарантирует, что столбец не может иметь значение NULL

--UNIQUE - гарантирует, что все значения в столбце различны (уникальны)

--PRIMARY KEY - комбинация NOT NULL и UNIQUE. Уникально идентифицирует каждую строку в таблице

--FOREIGN KEY  - однозначно идентифицирует строку/запись в другой таблице

--CHECK - гарантирует, что все значения в столбце удовлетворяют определенному условию

--DEFAULT - устанавливает значение по умолчанию для столбца, если значение не указано

--UNIQUE constraint

--CREATE TABLE PersonInfo (
--	ID INT NOT NULL,
--	LastName VARCHAR(255) NOT NULL,
--	FirstName VARCHAR(255) NOT NULL,
--	Age INT
--);


INSERT INTO
	[dbo].[PersonInfo] (ID, LastName, Age)
VALUES
	(1, 'Petrov', 38);

SELECT
	*
FROM
	[dbo].[PersonInfo];

--UNIQUE constraint

CREATE TABLE PersonInfo2 (
	ID INT UNIQUE,
	LastName VARCHAR(255) NOT NULL,
	FirstName VARCHAR(255) NOT NULL,
	Age INT
);

INSERT INTO
	[dbo].[PersonInfo2] (ID, LastName, FirstName, Age)
VALUES
	(1, 'Petrov', 'Petr', 38);

SELECT
	*
FROM
	[dbo].[PersonInfo2];

INSERT INTO
	[dbo].[PersonInfo2] (ID, LastName, FirstName, Age)
VALUES
	(1, 'Ivanov', 'Ivan', 45);

--PRIMARY KEY constraint

CREATE TABLE PersonInfo3 (
	ID INT NOT NULL PRIMARY KEY,
	LastName VARCHAR(255) NOT NULL,
	FirstName VARCHAR(255) NOT NULL,
	Age INT
);

SELECT
	*
FROM
	[dbo].[PersonInfo3];

INSERT INTO
	[dbo].[PersonInfo3] (ID, LastName, FirstName, Age)
VALUES
	(2, 'Ivanov', 'Ivan', 45);

SELECT
	*
FROM
	[dbo].[PersonInfo3];

INSERT INTO
	[dbo].[PersonInfo3] (LastName, FirstName, Age)
VALUES
	('Ivanov', 'Ivan', 45);

INSERT INTO
	[dbo].[PersonInfo3] (ID, LastName, FirstName, Age)
VALUES
	(2, 'Ivanov', 'Ivan', 45);

--СHECK Constraint

CREATE TABLE PersonInfo4 (
	ID INT NOT NULL,
	LastName VARCHAR(255) NOT NULL,
	FirstName VARCHAR(255),
	Age INT CHECK (Age >= 18)
);

--DEFAULT constraint

CREATE TABLE Orders (
	ID INT NOT NULL,
	OrderNumber INT NOT NULL,
	OrderDate DATE DEFAULT GETDATE()
);

SELECT GETDATE();

INSERT INTO
	[dbo].[Orders] (ID, OrderNumber)
VALUES
	(1, 25636);

SELECT
	*
FROM
	[dbo].[Orders];

--FOREIGN KEY constraint

CREATE TABLE OrderDetails (
	OrderID INT PRIMARY KEY,
	OrderNumber INT NOT NULL,
	PersonID INT FOREIGN KEY REFERENCES dbo.PersonInfo3(ID)
);

SELECT
	*
FROM
	dbo.PersonInfo3;

USE master; 
INSERT INTO
	[dbo].[OrderDetails] (OrderID, OrderNumber, PersonID)
VALUES
	(1, 28698, 1);

SELECT
	*
FROM
	dbo.OrderDetails;

INSERT INTO
	[dbo].[OrderDetails] (OrderID, OrderNumber, PersonID)
VALUES
	(2, 28699, 8);

--• Primary Key - это столбец или группа столбцов в таблице, которые однозначно идентифицируют каждую строку в этой таблице.
--• Natural key (также известный как business key) - это ключ в таблице, состоящей из атрибутов, которые существуют и являются
--используется во внешнем мире вне базы данных.
--• Surrogate Key - искусственный ключ, предназначенный для уникальной идентификации каждой записи.
--• Candidate Key - набор атрибутов, которые однозначно идентифицируют кортежи в таблице. Candidate Key - супер
--ключ без повторяющихся атрибутов.
--• Alternate Key  - это столбец или группа столбцов в таблице, которые однозначно идентифицируют каждую строку в этой таблице.
--• Super Key - это группа из одного или нескольких ключей, определяющая строки в таблице.
--• Compound Key - имеет два или более атрибутов, которые позволяют однозначно распознать определенную запись.
--• Foreign Key - это столбец, который создает связь между двумя таблицами. Назначение внешних ключей
--заключается в поддержании целостности данных и обеспечении навигации между двумя разными экземплярами объекта.

--NOT NULL

--Следующий SQL запрос гарантирует, что столбцы «ID», «LastName» и «FirstName» НЕ будут принимать значения NULL при создании таблицы «Student»

CREATE TABLE Student (​
	ID INT NOT NULL,​
	LastName VARCHAR(255) NOT NULL,​
	FirstName VARCHAR(255) NOT NULL,​
	Age INT
);​	

--Чтобы создать ограничение NOT NULL для столбца «Age», когда таблица «Student» уже создана
ALTER TABLE
	dbo.Student
ALTER COLUMN
	Age INT NOT NULL;	

INSERT INTO
	dbo.Student (ID, FirstName, LastName, Age)
VALUES
	(1, 'Ivan', 'Ivanov', 18);

SELECT
	*
FROM
	Student;

INSERT INTO
	dbo.Student (ID, FirstName, LastName)
VALUES
	(2, 'Ivan', 'Ivanov');

--UNIQUE

--Следующий SQL запрос создает ограничение UNIQUE для столбца «ID» при создании таблицы «Student»

DROP TABLE dbo.Student;  --удалим ранее созданную таблицу
CREATE TABLE Student (​
	ID INT NOT NULL UNIQUE,​
	LastName VARCHAR(255) NOT NULL,​
	FirstName VARCHAR(255),​
	Age INT​
);​

--Чтобы создать ограничение UNIQUE для столбца «LastName», когда таблица уже создана

ALTER TABLE
	dbo.Student
ADD UNIQUE
	(LastName);

INSERT INTO
	dbo.Student (ID, FirstName, LastName)
VALUES
	(1, 'Ivan', 'Ivanov');

SELECT
	*
FROM
	dbo.Student;

INSERT INTO
	dbo.Student (ID, FirstName, LastName)
VALUES (2, 'Ivan', 'Litvinov');

--Что случится если выполнить следующий запрос?
INSERT INTO
	dbo.Student (ID, FirstName, LastName)
VALUES
	(NULL,'Ivan','Litvinov');

INSERT INTO
	dbo.Student (ID, FirstName, LastName)
VALUES
	(3,'Ivan','Litvinov');

USE AdventureWorks2019;
--В следующем примере используется OVER с агрегатными функциями для всех строк, возвращаемых запросом:
SELECT
	SalesOrderID,
	ProductID,
	OrderQty,
	SUM(OrderQty) OVER(PARTITION BY SalesOrderID) AS Total,  
	AVG(OrderQty) OVER(PARTITION BY SalesOrderID) AS Average, 
	COUNT(OrderQty) OVER(PARTITION BY SalesOrderID) AS Quantity, 
	MIN(OrderQty) OVER(PARTITION BY SalesOrderID) AS Minimum,
	MAX(OrderQty) OVER(PARTITION BY SalesOrderID) AS Maximum 
FROM
	Sales.SalesOrderDetail 
WHERE
	SalesOrderID IN
			(43659, 43664); 

--Чтобы добавить столбец с номером строки перед каждой строкой, добавим столбец с функцией ROW_NUMBER, 
--в данном случае с именем Row#.
SELECT 
	name,
	recovery_model_desc,
	database_id,
	ROW_NUMBER() OVER(ORDER BY name ASC) AS Row#
FROM
	sys.databases 

--Добавление выражение PARTITION BY в столбец recovery_model_desc приведет к перезапуску
--нумерации при изменении значения recovery_model_desc
SELECT 
	name,
	recovery_model_desc,
	database_id,
	ROW_NUMBER() OVER(PARTITION BY recovery_model_desc ORDER BY name ASC) AS Row#
FROM
	sys.databases;

--Вывести только строки с номером 1
SELECT
	*
FROM
	(SELECT 
		name,
		recovery_model_desc,
		database_id,
		ROW_NUMBER() OVER(PARTITION BY recovery_model_desc ORDER BY name ASC) AS Row#
	FROM
		sys.databases) AS number
WHERE
	number.Row# = 1;

--В следующем примере продукты в инвентаре ранжируются в соответствии с их количеством.
--Набор результатов разделен по LocationID и логически упорядочен по количеству.
USE [AdventureWorks2019];

SELECT
	PI.ProductID,
	P.Name,
	PI.LocationID,
	PI.Quantity,
	RANK() OVER(PARTITION BY PI.LocationID ORDER BY PI.Quantity DESC) AS Ranking  
FROM
	Production.ProductInventory AS PI   
INNER JOIN
	Production.Product AS P   
		ON PI.ProductID = P.ProductID  
WHERE
	PI.LocationID BETWEEN 3 AND 4  
ORDER BY
	PI.LocationID; 

--В следующем примере продукты в инвентаре ранжируются в соответствии с их количеством.
--Набор результатов разделен по LocationID и логически упорядочен по количеству.

SELECT
	PI.ProductID,
	P.Name,
	PI.LocationID,
	PI.Quantity,
	DENSE_RANK() OVER(PARTITION BY PI.LocationID ORDER BY PI.Quantity DESC) AS Ranking  
FROM
	Production.ProductInventory AS PI   
INNER JOIN
	Production.Product AS P   
		ON PI.ProductID = P.ProductID  
WHERE
	PI.LocationID BETWEEN 3 AND 4  
ORDER BY
	PI.LocationID; 

--В следующем примере строки делятся на четыре группы сотрудников на основе их продаж за год.
--Поскольку общее количество строк не делится на количество групп, первые две группы имеют четыре строки,
--а остальные группы - по три строки каждая

SELECT
	P.FirstName,
	P.LastName,
    NTILE(4) OVER(ORDER BY SP.SalesYTD DESC) AS Quartile,   
    A.PostalCode,
	SP.SalesYTD
FROM
	Sales.SalesPerson AS SP   
INNER JOIN
	Person.Person AS P   
		ON SP.BusinessEntityID = P.BusinessEntityID  
INNER JOIN
	Person.Address AS A   
		ON A.AddressID = P.BusinessEntityID  
WHERE
	SP.TerritoryID IS NOT NULL AND
	SP.SalesYTD <> 0;  

--В следующем примере FIRST_VALUE используется для получения наименования продукта,
--который является наименее дорогим в данной категории продуктов

SELECT
	Name,
	ListPrice,   
    FIRST_VALUE(Name) OVER (ORDER BY ListPrice ASC) AS LeastExpensive   
FROM
	Production.Product  
WHERE
	ProductSubcategoryID = 37; 

--В следующем примере возвращается дата найма последнего сотрудника в каждом отделе для заданной зарплаты (Rate).
--Выражение PARTITION BY разделяет сотрудников по отделам, а функция LAST_VALUE применяется к каждому разделу независимо.
SELECT
	EDH.Department,
	EDH.LastName,
	EPH.Rate,
	E.HireDate,   
    	LAST_VALUE(E.HireDate) OVER (PARTITION BY EDH.Department ORDER BY EPH.Rate ASC) AS LastValue  
FROM
	HumanResources.vEmployeeDepartmentHistory AS EDH  
INNER JOIN
	HumanResources.EmployeePayHistory AS EPH    
		ON EPH.BusinessEntityID = EDH.BusinessEntityID  
INNER JOIN
	HumanResources.Employee AS E  
		ON E.BusinessEntityID = EDH.BusinessEntityID  
WHERE
	EDH.Department IN
		('Information Services', 'Document Control'); 

--Расширим наш диапазон захвата значений
SELECT
	EDH.Department,
	EDH.LastName,
	EPH.Rate,
	E.HireDate,   
    	LAST_VALUE(E.HireDate) OVER (PARTITION BY EDH.Department ORDER BY EPH.Rate ASC ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS LastValue  
FROM
	HumanResources.vEmployeeDepartmentHistory AS EDH  
INNER JOIN
	HumanResources.EmployeePayHistory AS EPH    
		ON EPH.BusinessEntityID = EDH.BusinessEntityID  
INNER JOIN
	HumanResources.Employee AS E  
		ON E.BusinessEntityID = EDH.BusinessEntityID  
WHERE
	EDH.Department IN
		('Information Services', 'Document Control'); 

--В следующем примере функция LAG используется для сравнения продаж сотрудников за текущий год.
--Предложение PARTITION BY указано для разделения строк в наборе результатов по территории продаж.
--Функция LAG применяется к каждому разделу отдельно, и вычисления перезапускаются для каждого раздела.
--Предложение ORDER BY в выражении OVER упорядочивает строки в каждом разделе. 
--Выражение ORDER BY в операторе SELECT сортирует строки во всем наборе результатов

SELECT
	TerritoryName,
	BusinessEntityID,
	SalesYTD,   
    LAG (SalesYTD, 1, 0) OVER (PARTITION BY TerritoryName ORDER BY SalesYTD DESC) AS PrevRepSales  
FROM
	Sales.vSalesPerson  
WHERE
	TerritoryName IN (N'Northwest', N'Canada')   
ORDER BY
	TerritoryName;

--В следующем примере функция LEAD используется для сравнения продаж сотрудников за текущий год.
--Предложение PARTITION BY указано для разделения строк в наборе результатов по территории продаж.
--Функция LEAD применяется к каждому разделу отдельно, и вычисления перезапускаются для каждого раздела.
--Предложение ORDER BY в выражении OVER упорядочивает строки в каждом разделе. 
--Выражение ORDER BY в операторе SELECT сортирует строки во всем наборе результатов

SELECT
	TerritoryName,
	BusinessEntityID,
	SalesYTD,   
    	LEAD (SalesYTD, 1, 0) OVER (PARTITION BY TerritoryName ORDER BY SalesYTD DESC) AS PrevRepSales  
FROM
	Sales.vSalesPerson  
WHERE
	TerritoryName IN (N'Northwest', N'Canada')   
ORDER BY
	TerritoryName;

--Следующий запрос вернет текущую дату вместе со временем в MS SQL Server
    
SELECT
	GETDATE() AS CurrentDateTime

--Следующий запрос вернет часть текущей даты в MS SQL Server
    
SELECT
	DATEPART(DAY, GETDATE()) AS CurrentDate;

--Следующий запрос вернет дату и время через 10 дней с текущей даты и времени в MS SQL Server

SELECT
	DATEADD(DAY, 10, GETDATE()) AS After10DaysDateTimeFromCurrentDateTime;

--Следующий запрос вернет разницу в ЧАСАХ между датами 2021-02-19 и 2021-01-01 в MS SQL Server

SELECT
	DATEDIFF(HOUR, 2021-02-19, 2021-01-01) AS DifferenceHoursBetween20210219And20210101;

--Следующие запросы вернут дату и время в другом формате в MS SQL Server​
​
SELECT
	CONVERT(VARCHAR(19), GETDATE());
	
SELECT
	CONVERT(VARCHAR(10), GETDATE(), 10)​;

SELECT
	CONVERT(VARCHAR(10), GETDATE(), 110);

--Вернуть символ на основе кода числа 65

SELECT
	CHAR(65) AS CodeToCharacter;

--Сложить две строки вместе

SELECT
	CONCAT('DataLearn', '.ru', ' - Anatolii');​

SELECT
	'Happy ' + 'BirthDAY ' + ' 02' + '/' + '06' AS Result;

--Извлечь 3 символа из строки (начиная слева):

SELECT
	LEFT('SQL Lesson', 3) AS ExtractString;

--Извлечь 3 символа из строки (начиная справа):

SELECT
	RIGHT('SQL Lesson', 3) AS ExtractString;

--Вернуть длину строки

SELECT
	LEN('DataLearn.com');

--Заменить «Т» на «М»:

SELECT
	REPLACE('SQL Tutorial', 'T', 'M');

--Перевернуть строку:

SELECT
	REVERSE('SQL Tutorial');

--Преобразовать текст в верхний регистр

SELECT
	UPPER('SQL lesson is FUN!');

--Преобразовать текст в нижний регистр

SELECT
	LOWER('SQL lesson is FUN!');
















































































































