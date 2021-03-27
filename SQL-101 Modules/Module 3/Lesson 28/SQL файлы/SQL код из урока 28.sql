--------------------------------Представления (Views)--------------------------------

--Выборка из рассматриваемой таблице в видео:
SELECT
	*
FROM
	HumanResources.Employee;

--Представим, что мы хотим вывести некоторые данные из нашей таблицы, но не все,
-- для этого мы можем создать новую таблицу, например Employee2 в схеме HumanResources
SELECT [LoginID]
      ,[OrganizationLevel]
      ,[JobTitle]
      ,[BirthDate]
      ,[MaritalStatus]
      ,[Gender]
      ,[HireDate]
      ,[SalariedFlag]
      ,[VacationHours]
      ,[SickLeaveHours]
      ,[CurrentFlag]
      ,[rowguid]
      ,[ModifiedDate]
INTO [HumanResources].[Employee2]
FROM [HumanResources].[Employee];

--Удалить созданную таблицу Employee2 в схеме HumanResources:
DROP TABLE
	[HumanResources].[Employee2];

--Типы представлений:

-- - Индексируемые представления (Indexed views): это материализованное представление.
--   Вы индексируете представление, создавая для него уникальный кластерный индекс.

-- - Разделенные представления (Partitioned views): объединяют горизонтально разделенные данные из набора таблиц

-- - Системные представления (System views): предоставляют метаданные

--Синтаксис индексируемого представления:
--CREATE VIEW view_name
--WITH SCHEMABINDING AS
--SELECT column1, column2, ...
--FROM table_name
--GO
--CREATE UNIQUE CLUSTERED INDEX view_name
--ON view_name(<index_key_columns>)

--Пример создания тестовой таблицы со столбцом, который является первичным ключем
--В таком случае автоматически создается кластерный индекс по этому столбцу

CREATE TABLE test
	(ID);

--Создадим тестовое представление (обычное):

CREATE VIEW HumanResources.EmployeeInfo 
AS  
SELECT
	LoginID,
	OrganizationLevel,
	JobTitle,
	BirthDate,
	MaritalStatus,
	Gender,
	HireDate,
	SalariedFlag,
	VacationHours,
	SickLeaveHours  
FROM
	HumanResources.Employee;

--Сделаем выборку из нашего представления и отсортируем результат по идентификатору логина в алфавитном порядке
SELECT
	LoginID,
	OrganizationLevel,
	JobTitle,
	BirthDate,
	MaritalStatus,
	Gender,
	HireDate,
	SalariedFlag,
	VacationHours,
	SickLeaveHours  
FROM
	HumanResources.EmployeeInfo  
ORDER BY
	LoginID;

--Пример создания индексируемого представления:

CREATE VIEW PhonePersons
WITH SCHEMABINDING AS
SELECT
	P.PersonType,
	P.FirstName,
	P.MiddleName,
	P.LastName,
	PP.PhoneNumber
FROM
	Person.Person AS P
INNER JOIN
	Person.PersonPhone AS PP
		ON P.BusinessEntityID = PP.BusinessEntityID
GO

CREATE UNIQUE CLUSTERED INDEX PhonePersons
ON PhonePersons (FirstName, LastName, PhoneNumber);

--Синтаксис partitioned view

--CREATE VIEW view_name
--AS
--SELECT columns...
--FROM Table1
--UNION ALL
--SELECT columns...
--FROM Table2
--UNION ALL
--SELECT columns...
--FROM Table3

--Пример partitioned view

CREATE VIEW PhonePersonsPartitioned AS
SELECT
	P.[BusinessEntityID]
FROM
	[Person].[Person] AS P
UNION ALL
SELECT
	PP.[BusinessEntityID]
FROM
	[Person].[PersonPhone] AS PP;

--Синтаксис изменения представления

--ALTER VIEW view_name AS
--SELECT column1, column2, ...
--FROM table_name
--WHERE condition;

--Пример изменения ранее созданного представления EmployeeInfo

ALTER VIEW [HumanResources].[EmployeeInfo] 
AS  
SELECT
	LoginID,
	OrganizationLevel,
	JobTitle,
	BirthDate,
	MaritalStatus,
	Gender,
	HireDate,
	SalariedFlag,
	VacationHours,
	SickLeaveHours
FROM
	HumanResources.Employee
WHERE
	HireDate < '2010-01-01';

--Попытка изменить данные в представлении ссылаясь на несколько базовых таблиц (будет ошибка):

UPDATE
	HumanResources.vEmployee
SET 
	Title = 'Mr.',
	City = 'Kyiv'   
 WHERE
	BusinessEntityID = 11;

--Следующий запрос выполнится успешно:
UPDATE
	HumanResources.vEmployee
SET 
	City = 'Kyiv'   
 WHERE
	BusinessEntityID = 11;


--Еще один прмиер представления с агрегатными функциями:

CREATE VIEW HumanResources.EmployeeVacations AS
SELECT
	JobTitle,
	MAX(VacationHours) AS MaxVacationHours
FROM
	[HumanResources].[Employee]
GROUP BY
	JobTitle;


--Попытка изменить агрегируемые данные в нашем представлении вызовет ошибку:

UPDATE
	HumanResources.EmployeeVacations
SET 
	MaxVacationHours = 45  
WHERE
	JobTitle = 'Accounts Manager';

--Изменим наше представление еще раз, поменяв город с Kyiv на Kharkiv:

UPDATE
	HumanResources.vEmployee
SET 
	City = 'Kharkiv'   
 WHERE
	BusinessEntityID = 11;

--Изменения в представлениях затрагивают изменения в нашей базовой таблице:

SELECT
	*
FROM
	Person.Address
WHERE
	City = 'Kharkiv';

--Синтаксис изменения представления:

--UPDATE view_name
--SET column1 = value1, column2 = value2, ...
--WHERE condition;

--Еще пример изменения представления:

UPDATE
	HumanResources.EmployeeInfo
SET
	MaritalStatus = 'M'
WHERE
	LoginID = 'adventure-works\ken0';

--Еще один пример изменения представления:

UPDATE
	HumanResources.vEmployeeDepartmentHistory  
SET
	StartDate = '20120203',
	EndDate = GETDATE()   
WHERE
	LastName = 'Sánchez'
	AND
	FirstName = 'Ken'; 

--Синтаксис добавления данных в представление:

--INSERT INTO view_name (column1, column2, ...)
--VALUES (value1, value2, ...)

--Пример добавления данных в представление:

INSERT INTO
	HumanResources.vEmployeeDepartmentHistory (Department, GroupName)   
VALUES
	('MyTestDepartment', 'MyTestGroup');  

--В нашу базовую таблицу HumanResources.Department эти данные были добавлены
SELECT
	*
FROM
	HumanResources.Department;

--идентификатор у нового отдела стал = 17:

SELECT
	*
FROM
	HumanResources.Department
WHERE
	DepartmentID = 17;

--при такого идентификатора нет в нашей другой таблице HumanResources.EmployeeDepartmentHistory:

SELECT
	*
FROM
	HumanResources.EmployeeDepartmentHistory
WHERE
	DepartmentID = 17;

--В нашем представлении новые данные не отображаются из-за того, что внутри нашего представления используется INNER JOIN
-- между двумя выше упомянутыми таблицами  (следовательно находятся только общие значения DepartmentID):

SELECT
	*
FROM
	HumanResources.vEmployeeDepartmentHistory
WHERE
	Department LIKE 'M%';

--Посмотреть свойства представления можно с помощью запроса:

SELECT
	OBJECT_DEFINITION (OBJECT_ID('HumanResources.vEmployee')) AS ObjectDefinition;

--переименовать представление

EXEC sp_rename
@objname = 'HumanResources.HumanResources.EmployeeInfos',
@newname = 'HumanResources.EmployeeInfos';

--Пример удаления представления хорошим стилем:

IF OBJECT_ID ('HumanResources.EmployeeHireDate', 'V') IS NOT NULL  
DROP VIEW HumanResources.EmployeeHireDate;

--Пример создания временной таблицы (которая доступна только в текущей сессии):

CREATE TABLE #temp_table
	(ID INT);

INSERT INTO #temp_table
	VALUES (1);


--------------------------------Триггеры (Triggers)--------------------------------


--Типы триггеров:

--DML (Data Manipulation Language) триггеры
--DDL (Data Definition Language) триггеры

--DML тригеры в свою очередь делятся на 2 подтипа триггеров:
-- - AFTER триггеры
-- - INSTEAD OF триггеры 

--Синтаксис создания AFTER триггера

--CREATE TRIGGER trigger_name
--ON table_name
--AFTER { INSERT, UPDATE, DELETE }
--AS { T-SQL_statement }
--GO

--Запрос из видео

SELECT
	*
FROM
	Sales.SalesOrderDetail;

--Проверка таблицы, на которую у нас будет создаваться триггер:

SELECT
	*
FROM
	HumanResources.Shift;

--Создаём триггер:

CREATE TRIGGER Trg_Shift
	ON HumanResources.Shift
	AFTER INSERT
AS
	BEGIN
		PRINT 'INSERT IS NOT ALLOWED!'
		ROLLBACK TRANSACTION
	END
GO

--Попытка вставить данные в нашу таблицу завершится неудачей:

INSERT INTO
	HumanResources.Shift (Name, StartTime, EndTime, ModifiedDate)
VALUES
	('MyShift', '07:00:00.0000000', '08:00:00.0000000', GETDATE());

--Проверка таблицы, на которую у нас будет создаваться триггер:

SELECT
	*
FROM
	Sales.Store;

--Создаём триггер:

CREATE TRIGGER Sales.uStore
   ON Sales.Store
   AFTER UPDATE
AS
	UPDATE
		Sales.Store
	SET
		ModifiedDate = GETDATE()
	FROM
		inserted
	WHERE
		inserted.BusinessEntityID = Sales.Store.BusinessEntityID
	SELECT * FROM deleted
GO

--Попытка обновить данные в нашей таблице (кроме обновления строки выведется еще строка, которая была удалена):

UPDATE
	Sales.Store
SET
	Name = 'Riders'
WHERE
	BusinessEntityID = 296;

--Синтаксис создания INSTEAD OF триггера

--CREATE TRIGGER trigger_name
--ON table_name
--INSTEAD OF { INSERT, UPDATE, DELETE }
--AS { T-SQL_statement }
--GO

--Проверка таблицы, на которую у нас будет создаваться триггер:

SELECT
	*
FROM
	HumanResources.Shift;

--Создаём триггер:

CREATE TRIGGER Trg_Shift
	ON HumanResources.Shift
	INSTEAD OF DELETE
AS
	BEGIN
		PRINT 'DELETE OF SHIFT IS NOT ALLOWED!'
		ROLLBACK TRANSACTION
	END
GO

--Попытка удалить данные из нашей таблицы завершится неудачей:

DELETE FROM
	HumanResources.Shift 
WHERE
	ShiftID = 1;

--Пример изменения триггера:

ALTER TRIGGER Sales.uStore
	ON Sales.Store
	AFTER UPDATE
AS
	UPDATE
		Sales.Store
	SET
		ModifiedDate = GETDATE()
	FROM
		inserted
	WHERE
		inserted.BusinessEntityID = Sales.Store.BusinessEntityID
	SELECT
		*
	FROM
		deleted
GO

--Синтаксис cоздания DDL триггеров:

--CREATE TRIGGER trigger_name
--ON {DATABASE | ALL SERVER}
--FOR|AFTER {event_type | event_group}
--AS {sql_statement}

--Примеры event_type

--• CREATE_VIEW
--• ALTER_VIEW
--• DROP_VIEW
--• CREATE_TABLE
--• DROP_DATABASE

--Создаём триггер:

CREATE TRIGGER DB_LEVEL_TRIGGER
	ON DATABASE
	AFTER CREATE_TABLE
AS
	BEGIN
		PRINT 'CREATION OF NEW TABLES IS NOT ALLOWED!'
		ROLLBACK TRANSACTION
	END

--Пытаемся создать таблицу в нашей базе данных и получаем отказ:

CREATE TABLE
	DemoTable(MyColumn INT);


--------------------------------Групповые функции--------------------------------

--Какие групповые функции бывают

--GROUP BY - группировать данные по одному набору группировки
--GROUP BY GROUPING SETS - группировать данные по нескольким группирующим наборам
--GROUP BY CUBE - принимает список выражений и определяет все возможные наборы группировки из этого ввода
--GROUP BY ROLLUP - применяется для иерархических структур данных (например, location -> country, region, city)

--Данные о продажах в разбивке по территориальной группе

SELECT
	TerritoryGroup,
	SUM(SalesYTD) AS TotalSales
FROM
	Sales.vSalesPerson 
WHERE
	TerritoryGroup IS NOT NULL
GROUP BY
	TerritoryGroup;

--Данные о продажах в разбивке по территориальной группе и названию территории

SELECT
	TerritoryGroup,
	TerritoryName,
	SUM(SalesYTD) AS TotalSales
FROM
	Sales.vSalesPerson 
WHERE
	TerritoryGroup IS NOT NULL
GROUP BY
	TerritoryGroup,
	TerritoryName;

--Данные о продажах в разбивке по по территориальной группе, названию территории и имени с фамилией продавца

SELECT
	TerritoryGroup,
	TerritoryName,
	(FirstName + ' ' + LastName) AS 'FullName'
	SUM(SalesYTD) AS TotalSales
FROM
	Sales.vSalesPerson 
WHERE
	TerritoryGroup IS NOT NULL
GROUP BY
	TerritoryGroup,
	TerritoryName,
	(FirstName + ' ' + LastName);

--Объёдиним все 3 запроса выше в один запрос:

SELECT
	TerritoryGroup,
	NULL AS TerritoryName,
	NULL AS FullName,
	SUM(SalesYTD) AS TotalSales
FROM
	Sales.vSalesPerson 
WHERE
	TerritoryGroup IS NOT NULL
GROUP BY
	TerritoryGroup
UNION ALL
SELECT
	TerritoryGroup,
	TerritoryName,
	NULL,
	SUM(SalesYTD) AS TotalSales
FROM
	Sales.vSalesPerson 
WHERE
	TerritoryGroup IS NOT NULL
GROUP BY
	TerritoryGroup,
	TerritoryName
UNION ALL
SELECT
	TerritoryGroup,
	TerritoryName,
	(FirstName + ' ' + LastName) AS FullName,
	SUM(SalesYTD) AS TotalSales
FROM
	Sales.vSalesPerson 
WHERE
	TerritoryGroup IS NOT NULL
GROUP BY
	TerritoryGroup,
	TerritoryName,
	(FirstName + ' ' + LastName);

--Пример использования GROUPING SETS

SELECT
	TerritoryGroup,
	TerritoryName,
	(FirstName + ' ' + LastName) AS FullName,
	SUM(SalesYTD) AS TotalSales
FROM
	Sales.vSalesPerson 
WHERE
	TerritoryGroup IS NOT NULL
GROUP BY GROUPING SETS
(
	(TerritoryGroup),
	(TerritoryGroup, TerritoryName),
	(TerritoryGroup, TerritoryName, (FirstName + ' ' + LastName))
);

--Пример использования GROUP BY ROLLUP

SELECT
	TerritoryGroup,
	TerritoryName,
	(FirstName + ' ' + LastName) AS FullName,
	SUM(SalesYTD) AS TotalSales
FROM
	Sales.vSalesPerson 
WHERE
	TerritoryGroup IS NOT NULL
GROUP BY ROLLUP
(
	TerritoryGroup, TerritoryName, (FirstName + ' ' + LastName)
);

--Пример использования GROUP BY CUBE

SELECT
	TerritoryGroup,
	TerritoryName,
	(FirstName + ' ' + LastName) AS FullName,
	SUM(SalesYTD) AS TotalSales
FROM
	Sales.vSalesPerson 
WHERE
	TerritoryGroup IS NOT NULL
GROUP BY CUBE
(
	TerritoryGroup, TerritoryName, (FirstName + ' ' + LastName)
)
ORDER BY
	TerritoryGroup DESC;
