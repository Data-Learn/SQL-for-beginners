--1) FROM
--2) ON
--3) JOIN
--4) WHERE
--5) GROUP BY
--6) WITH CUBE or WITH ROLLUP
--7) HAVING
--8) SELECT
--9) DISTINCT
--10) ORDER BY
--11) TOP

USE [AdventureWorks2019];

--Следующий SQL запрос выбирает первые три записи из таблицы Sales.SalesOrderDetail

SELECT
	TOP 3 *
FROM
	Sales.SalesOrderDetail;

--Следующий запрос с сортировкой по убыванию по OrderQty:

SELECT
	TOP 3 *
FROM
	Sales.SalesOrderDetail
ORDER BY
	[OrderQty] DESC;

--Следующий запрос с сортировкой по убыванию по OrderQty WITH TIES:

SELECT
	TOP 3 WITH TIES * 
FROM
	Sales.SalesOrderDetail
ORDER BY
	[OrderQty] DESC;

--Следующий SQL инструкция выбирает ВСЕ значения из столбца «PersonType» в таблице «Person»

SELECT
	ALL PersonType
FROM
	Person.Person;​

--Аналогично

SELECT
	PersonType
FROM
	Person.Person;​

--Следующий SQL инструкция выбирает только УНИКАЛЬНЫЕ значения из столбца «PersonType» в таблице «Person»

SELECT
	DISTINCT PersonType
FROM
	Person.Person;​


--Следующий SQL запрос выбирает всех людей из города "LONDON" в таблице "Person.Address"

SELECT
	*
FROM
	Person.Address
WHERE
	City = 'London';​

--Следующий SQL запрос выбирает всех людей с AddressID = 667 в таблице «Person.Address»

SELECT
	*
FROM
	Person.Address
WHERE
	AddressID = 667;​

--Следующий SQL запрос выбирает все поля из таблицы «HumanResources.Employee», где JobTitle - «Design Engineer» И Gender - «M»

SELECT
	*
FROM
	HumanResources.Employee
WHERE
	JobTitle='Design Engineer' AND
	Gender='M';​ 
		 
--Следующий SQL запрос выбирает все поля из таблицы "HumanResources.Employee" JobTitle - "Design Engineer" ИЛИ "Senior Design Engineer"
                         
SELECT
	*
FROM
	HumanResources.Employee
WHERE
	JobTitle='Design Engineer' OR
	JobTitle='Senior Design Engineer';​ 

--Следующий SQL запрос выбирает все поля из таблицы "HumanResources.Employee", где Gender (пол) НЕ равен "F" (женский)
​
SELECT
	*
FROM
	HumanResources.Employee
WHERE
	NOT Gender='F';​ --или Gender!='F' или Gender<>'F'

--Следующий SQL запрос выбирает все поля из таблицы «HumanResources.Employee», где Gender - «M» И JobTitle - «Design Engineer» ИЛИ «Senior Design Engineer» (используйте круглые скобки для формирования сложных выражений)
        
SELECT
	*
FROM
	HumanResources.Employee
WHERE
	Gender='M' AND
	(JobTitle='Design Engineer' OR
	JobTitle='Senior Design Engineer');
		 
--Следующий SQL запрос выбирает все города из таблицы «Person.Address», отсортированные по столбцу «City»
                   
SELECT
	AddressID,
	City 
FROM
	Person.Address 
ORDER BY
	City; 

--Следующий SQL запрос выбирает весь город из таблицы «Person.Address», отсортированные по столбцу «City» по убыванию
                   
SELECT
	AddressID,
	City 
FROM
	Person.Address 
ORDER BY
	City DESC; 
		 
--Следующий SQL запрос выбирает весь город из таблицы «Person.Address», отсортированные по двум столбцам

--Вариант 1

SELECT
	AddressID,
	City
FROM
	Person.Address 
ORDER BY
	AddressID, City; 

--Вариант 2

SELECT
	AddressID,
	City
FROM
	Person.Address 
ORDER BY
	City, AddressID; 
		 
--Следующий SQL запрос выводит записи со значением NULL в поле «AddressLine1» или «AddressLine2»

SELECT
	*
FROM
	Person.Address
WHERE
	AddressLine1 IS NULL OR
	AddressLine2 IS NULL;
	   
--Следующий SQL запрос выводит записи со значением NOT NULL в поле «AddressLine2»
         
SELECT
	*
FROM
	Person.Address
WHERE
	AddressLine2 IS NOT NULL;
			 
--Следующий инструкция SQL выбирает первые 50% записей из таблицы «Sales.SalesOrderDetail»
                           
SELECT
	TOP 50 PERCENT * 
FROM
	Sales.SalesOrderDetail;​

--Следующий SQL запрос находит самую дешевую цену продукта

SELECT
	MIN(UnitPrice) AS SmallestPrice 
FROM
	Sales.SalesOrderDetail;​
	   
--Следующий SQL запрос находит самую дорогую цену продукта

SELECT
	MAX(UnitPrice) AS LargestPrice 
FROM
	Sales.SalesOrderDetail;​

--Следующий SQL запрос находит количество продуктов

SELECT
	COUNT(ProductID)
FROM
	Sales.SalesOrderDetail;

--Следующий SQL запрос находит количество уникальных продуктов

SELECT
	COUNT(DISTINCT ProductID)
FROM
	Sales.SalesOrderDetail;

--Следующий SQL запрос выводит просто список идентификаторов продуктов

SELECT
	ProductID
FROM
	Sales.SalesOrderDetail;
	   
--Следующий SQL запрос находит среднюю цену всех продуктов

SELECT
	AVG(UnitPrice) AS AveragePrice
FROM
	Sales.SalesOrderDetail;​
	  
--Следующий SQL запрос находит сумму поля «Price» в таблице «Sales.SalesOrderDetail»

SELECT
	SUM(UnitPrice) AS TotalPrice
FROM
	Sales.SalesOrderDetail;​
	  
--Следующий SQL запрос выбирает всех людей с JobTitle, которая начинается с "a"

SELECT
	JobTitle
FROM
	HumanResources.Employee 
WHERE
	JobTitle LIKE 'a%';

--Следующий SQL запрос выбирает всех людей с JobTitle, которая начинается с "a" и имеет четвертую букву l

SELECT
	JobTitle
FROM
	HumanResources.Employee 
WHERE
	JobTitle LIKE 'a__l%';

--Следующий SQL запрос выбирает всех людей с JobTitle, которая заканчивается на "r"

SELECT
	JobTitle
FROM
	HumanResources.Employee 
WHERE
	JobTitle LIKE '%r';
		 
--Следующий SQL запрос выбирает всех людей с JobTitle, у которых в названии есть буквосочетание «or» в любой позиции

SELECT
	JobTitle
FROM
	HumanResources.Employee 
WHERE
	JobTitle LIKE '%or%';
		 
--Следующий SQL запрос выбирает всех людей с JobTitle, которая НЕ начинается с "a"

SELECT
	JobTitle
FROM
	HumanResources.Employee 
WHERE
	JobTitle NOT LIKE 'a%';

--Следующий SQL запрос выбирает всех людей с JobTitle, которая начинается с "a" или "d"

SELECT
	JobTitle
FROM
	HumanResources.Employee 
WHERE
	JobTitle NOT LIKE '[AD]%';

--Следующий SQL запрос выбирает всех людей с JobTitle, которая НЕ начинается с "a" или "d"

SELECT
	JobTitle
FROM
	HumanResources.Employee 
WHERE
	JobTitle NOT LIKE '[^AD]%';

--Следующий SQL запрос выбирает всех людей с JobTitle, которая начинается на буквы в диапазоне с "a" до "d"

SELECT
	JobTitle
FROM
	HumanResources.Employee 
WHERE
	JobTitle NOT LIKE '[A-D]%';
		 
--Следующий SQL запрос выбирает всех работников, которые являются «Engineering Manager», «Senior Design Engineer» или «Design Engineer»

SELECT
	*
FROM
	HumanResources.Employee
WHERE
	JobTitle IN
		('Engineering Manager', 'Senior Design Engineer', 'Design Engineer');​

--Следующий SQL запрос выбирает всех работников, которые НЕ являются «Engineering Manager», «Senior Design Engineer» или «Design Engineer»

SELECT
	*
FROM
	HumanResources.Employee
WHERE
	JobTitle IN
		('Engineering Manager', 'Senior Design Engineer', 'Design Engineer');
		 
--Следующий SQL запрос выбирает все продукты с ценой между 10 и 100 включительно

SELECT
	*
FROM
	Sales.SalesOrderDetail
WHERE
	UnitPrice BETWEEN 10 AND 100;​
		 
--Следующий SQL запрос создает псевдоним Price для столбца UnitPrice

SELECT
	UnitPrice AS Price 
FROM
	Sales.SalesOrderDetail;​
	   
--Следующий SQL запрос выбирает все продукты с информацией о цене за единицу

SELECT
	P.Name,
	SOD.UnitPrice
FROM
	Sales.SalesOrderDetail AS SOD
INNER JOIN
	Production.Product AS P
		ON SOD.ProductID = P.ProductID
ORDER BY
	P.Name;
	   
--Следующий SQL запрос выберет все продукты и любую цену, которую они могут иметь

SELECT
	P.Name,
	SOD.UnitPrice
FROM
	Production.Product AS P
LEFT JOIN
	Sales.SalesOrderDetail AS SOD
		ON SOD.ProductID = P.ProductID
ORDER BY
	P.Name;

--Следующий SQL запрос вернет всех сотрудников и все заказы, которые они могли сделать

SELECT
	P.Name,
	PCH.StandardCost
FROM
	Production.ProductCostHistory AS PCH
RIGHT JOIN
	Production.Product AS P
		ON PCH.ProductID = P.ProductID
ORDER BY
	P.Name;
	   
--Следующий SQL запрос выбирает всех клиентов и все заказы

SELECT
	P.Name,
	SOD.UnitPrice
FROM
	Production.Product AS P
FULL OUTER JOIN
	Sales.SalesOrderDetail AS SOD
		ON SOD.ProductID = P.ProductID
ORDER BY
	P.Name;

--FULL OUTER JOIN - это сумма результатов запросов INNER JOIN + LEFT JOIN + RIGHT JOIN

--INNER JOIN
SELECT
	P.Name,
	SOD.UnitPrice
FROM
	Production.Product AS P
INNER JOIN
	Sales.SalesOrderDetail AS SOD
		ON SOD.ProductID = P.ProductID
ORDER BY
	P.Name;	   

--LEFT JOIN
SELECT
	P.Name,
	SOD.UnitPrice
FROM
	Production.Product AS P
LEFT JOIN
	Sales.SalesOrderDetail AS SOD
		ON SOD.ProductID = P.ProductID
WHERE
	SOD.ProductID IS NULL
ORDER BY
	P.Name;	

--RIGHT JOIN
SELECT
	P.Name,
	SOD.UnitPrice
FROM
	Production.Product AS P
RIGHT JOIN
	Sales.SalesOrderDetail AS SOD
		ON SOD.ProductID = P.ProductID
WHERE
	P.ProductID IS NULL
ORDER BY
	P.Name;	

--Следующий SQL запрос сопоставляет Business Entit, которые находятся в том же месте

SELECT
	A.BusinessEntityId AS PersonName1,
	B.BusinessEntityId AS PersoName2,
	A.AddressId
FROM
	Person.BusinessEntityAddress A,
	Person.BusinessEntityAddress B
WHERE
	A.BusinessEntityId <> B.BusinessEntityId AND
	A.AddressId = B.AddressId
ORDER BY
	A.AddressId;
	   

--Следующий SQL запросе указано количество BusinessEntity в каждом Location

SELECT
	COUNT(BusinessEntityId),
	AddressId
FROM
	Person.BusinessEntityAddress
GROUP BY
	AddressId;

--В следующем SQL запросе указано количество BusinessEntity в разделении по Gender

SELECT
	COUNT(BusinessEntityId),
	Gender
FROM
	HumanResources.Employee
GROUP BY
	Gender;

--В следующем SQL запросе указано количество отделов в каждой группе. Включены только те группы, в которых больше или равно 5 отделов

SELECT
	COUNT(DepartmentId),
	GroupName
FROM
	HumanResources.Department
GROUP BY
	GroupName
HAVING
	COUNT(DepartmentId) >= 5;
	  
--Следующий SQL запрос упорядочит OrderId по количеству.

SELECT
	SalesOrderID,
	OrderQty,
	CASE
		WHEN OrderQty < 2 THEN 'The quantity the quantity is too small'
		WHEN OrderQty > 2 THEN 'The quantity  is OK'
		ELSE 'The quantity is 2'
	END AS QuantityText
FROM
	Sales.SalesOrderDetail;

--Автоувеличение номера строки
CREATE TABLE Students (​
	StudentId INT IDENTITY(1,1) PRIMARY KEY,​
	LastName VARCHAR(255) NOT NULL,​
	FirstName VARCHAR(255),​
	Age INT);​

SELECT
	*
FROM
	[dbo].[Students];

INSERT INTO
	dbo.Students (FirstName, LastName)
VALUES
	('Ivan','Ivanov');

INSERT INTO
	dbo.Students (FirstName, LastName, Age)
VALUES
	('John','Orlov', 56);

--Что произойдет если выполнить следующий запрос?
INSERT INTO
	dbo.Students (StudentId, FirstName, LastName)
VALUES
	(3,'Iryna','Ivanova');

--При этом следюущий запрос сработает
INSERT INTO
	dbo.Students (FirstName, LastName)
VALUES
	('Iryna','Ivanova');