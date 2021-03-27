-----------------------------------Прооцедуры-----------------------------------

--Какие типы процедур бывают:

--• User-defined
--• Temporary
--• System

--Каждая из этих процедур может быть следюущего типа:
--• Без параметров
--• С одним параметром
--• С множеством параметров

--Синтаксис user-defined процедуры:

--CREATE PROCEDURE procedure_name
--AS
--sql_statement

--Синтаксис вызова (выполнения) хранимой процедуры:

--EXEC procedure_name

--Синтаксис user-defined процедуры с параметрами:

--CREATE PROCEDURE procedure_name @param1 datatype,
--...
--AS
--sql_statement

--Синтаксис вызова (выполнения) хранимой процедуры с параметрами:

--EXEC procedure_name @param1 = 'London', ...

--Пример процедуры без параметров (строки не считаются):

CREATE PROCEDURE PersonEmail
AS
SET NOCOUNT ON --не считать количество строк
SELECT
	P.FirstName,
	P.LastName,
	EA.EmailAddress
FROM
	Person.Person AS P
INNER JOIN
	Person.EmailAddress AS EA
		ON P.BusinessEntityID = EA.BusinessEntityID;

--Вызов созданной процедуры:
EXEC PersonEmail;

--Пример процедуры без параметров (строки считаются):

CREATE PROCEDURE PersonEmail2
AS
SET NOCOUNT OFF --считать количество строк
SELECT
	P.FirstName,
	P.LastName,
	EA.EmailAddress
FROM
	Person.Person AS P
INNER JOIN
	Person.EmailAddress AS EA
		ON P.BusinessEntityID = EA.BusinessEntityID;

--Вызов созданной процедуры:
EXEC PersonEmail2;

--Пример процедуры c параметрами:

CREATE PROCEDURE PersonFirstNameEmail
@FirstName VARCHAR(50)
AS
SET NOCOUNT ON --не считать количество строк
SELECT
	P.FirstName,
	P.LastName,
	EA.EmailAddress
FROM
	Person.Person AS P
INNER JOIN
	Person.EmailAddress AS EA
		ON P.BusinessEntityID = EA.BusinessEntityID
WHERE
	@FirstName = P.FirstName; 

--Вызываем процедуры передавая ей параметр (вариант 1):

EXEC PersonFirstNameEmail @FirstName = 'Kim';

--Вызываем процедуру передавая ей параметр (вариант 2):
EXEC PersonFirstNameEmail 'Kim';

--Если вызвать процедуру и не передать ей параметры, то будет ошибка:
EXEC PersonFirstNameEmail;

--Пример процедуру cо значением параметра по умолчанию:

CREATE PROCEDURE PersonFirstNameEmail2
@FirstName VARCHAR(50) = 'Alexandra'
AS
SET NOCOUNT ON --не считать количество строк
SELECT
	P.FirstName,
	P.LastName,
	EA.EmailAddress
FROM
	Person.Person AS P
INNER JOIN
	Person.EmailAddress AS EA
		ON P.BusinessEntityID = EA.BusinessEntityID
WHERE
	@FirstName = P.FirstName; 

--Вызываем процедуру передавая ей параметр, мы тем самым переопределяем значение параметра по умолчанию (Alexandra) (вариант 1):

EXEC PersonFirstNameEmail2 @FirstName = 'Catherine';

--Вызываем процедуру передавая ей параметр, мы тем самым переопределяем значение параметра по умолчанию (Alexandra) (вариант 2):
EXEC PersonFirstNameEmail2 'Catherine';

--Если вызвать процедуру и не передать ей параметры, то будет выведена информация, ипользуя для параметра значение по умолчанию:
EXEC PersonFirstNameEmail2;

--Синтаксис написания процедуры с входным (input) параметром и выходным (output) параметром

--CREATE PROCEDURE procedure_name @param1 datatype,
--@param2 datatype OUTPUT, ...
--AS
--sql_statement
--DECLARE @param2 DATATYPE
--EXEC procedure_name @param1 = 'London',
--@param2 OUTPUT ...

--Пример процедуры с входным (input) параметром и выходным (output) параметром:

CREATE PROCEDURE PersonCounter
@FirstName VARCHAR(50), @Counter INT OUTPUT
AS
SET NOCOUNT ON
SET @Counter =
	(SELECT
		COUNT(P.FirstName)
	 FROM
		Person.Person AS P
	INNER JOIN
		Person.EmailAddress AS EA
			ON P.BusinessEntityID = EA.BusinessEntityID
	 WHERE
		P.FirstName = @FirstName);

DECLARE @Counter INT;
EXEC PersonCounter 'Alexandra', @Counter OUTPUT;
SELECT @Counter;

--Синтаксис написания процедуры с RETURN:

--CREATE PROCEDURE procedure_name
--AS
--sql_statement
--RETURN ...

--DECLARE @return_value DATATYPE
--EXEC @return_value = procedure_name
--SELECT @return_value 

--Пример процедуры с RETURN:

CREATE PROCEDURE MyFirstReturningStoredProcedure
AS
RETURN 12;

DECLARE @MyReturnValue INT
EXEC @MyReturnValue = MyFirstReturningStoredProcedure
SELECT @MyReturnValue

--При таком включенном параметре мы можем сравнивать с NULL только способом через IS NULL

SET ANSI_NULLS ON

--Вариант 1

SELECT
	*
FROM
	Person.Person
WHERE
	MiddleName = 'NULL';

--Вариант 2

SELECT
	*
FROM
	Person.Person
WHERE
	MiddleName IS NULL;

--При таком включенном параметре у нас двойные кавычки рассматриваются как круглые скобки ([...])
--и могут использоваться для заключения в кавычки имен объектов SQL, таких как имена таблиц, имена столбцов и т. д.

SET QUOTED_IDENTIFIER ON

UPDATE
	"Person"."Person"
SET
	"FirstName" = 'Vik'
WHERE
	"MiddleName" = 'N';

--Синтаксис изменения процедуры

--ALTER PROCEDURE procedure_name
--AS
--sql_statement

-Синтаксис удаления процедуры

--DROP PROCEDURE procedure_name

--Правила хорошего тона по удалению процедур:

--IF OBJECT_ID ( '<procedure_name>', 'P' ) IS NOT NULL
--	DROP PROCEDURE <procedure_name>;
--GO

--Синтаксис переименования процедуры:

--EXEC sp_rename '<old_name_of_proc>', '<new_name_of_proc>'

--Пример создания временной процедуры (локальной), которая доступна только в текущей сессии (вкладке):

CREATE PROCEDURE #TempProcedure
AS
SET NOCOUNT ON
PRINT 'This is my first Temporary Procedure'

--Данная временная процедура (локальная) может быть вызывана только в том окне, где она была первоначально создана:

EXEC #TempProcedure

--Пример создания временной процедуры (глобальной), которая доступна и в других сессиях (вкладках):

CREATE PROCEDURE ##TempProcedure2
AS
SET NOCOUNT ON
PRINT 'This is my second Temporary Procedure'

--Данная временная процедура (глобальная) может быть вызывана в любом окне до момента закрытия Management Studio

EXEC ##TempProcedure2

--Создадим хранимую процедуру sp_ChangeCity, которая изменяет все города в таблице Person.Address на верхний регистр

CREATE PROCEDURE sp_ChangeCity
AS
	SET NOCOUNT ON --не считать количество строк
	SELECT
		UPPER(A.City)
	FROM
		Person.Address AS A;

--Выполним созданную процедуру

EXECUTE sp_ChangeCity;

--Создадим хранимую процедуру с именем sp_GetLastName, которая принимает входной параметр с именем EmployeeID
--и возвращает фамилию этого сотрудника (мы можете объединить таблицы Employee и Person)

CREATE PROCEDURE sp_GetLastName
@EmployeeID INT
AS
	SET NOCOUNT ON
	SELECT
		E.BusinessEntityID,
		P.LastName
	FROM
		HumanResources.Employee AS E
	INNER JOIN 
		Person.Person AS P
			ON P.BusinessEntityID =E.BusinessEntityID
	WHERE
		E.BusinessEntityID = @EmployeeID;

--Выполним созданную процедуру и передадим значение в наш входной параметр

EXECUTE sp_GetLastName @EmployeeID = 211;

--Примеры системных хранимых процедур:

EXEC sp_help --сообщает информацию об объектах базы данных

EXEC sys.sp_tables --сообщает информацию о списке таблиц из базы данных

EXEC sp_helptext --используется для создания объекта в несколько строк

EXEC sp_depends --используется для получения сведений о зависимом объекте


-----------------------------------Вычисляемые столбцы-----------------------------------

--Создадим для примера таблицу

CREATE TABLE dbo.Products
   (
	ProductID INT IDENTITY (1,1) NOT NULL,
	QtyAvailable SMALLINT,
	UnitPrice MONEY,
	InventoryValue AS QtyAvailable * UnitPrice
    );

-- Вставим данные в таблицу

INSERT INTO
	dbo.Products (QtyAvailable, UnitPrice)
VALUES
	(25, 2.00),
	(10, 1.5);

-- Выведем строки з нашей таблицы
SELECT
	ProductID,
	QtyAvailable,
	UnitPrice,
	InventoryValue
FROM
	dbo.Products;

--Изменим нашу таблицу и добавив еще один вычисляемый столбец

ALTER TABLE
	dbo.Products
ADD
	RetailValue AS (QtyAvailable * UnitPrice * 1.5);

-- Выведем все данные з нашей таблицы

SELECT
	*
FROM
	dbo.Products;

--Удалим наш вычисляемый столбец

ALTER TABLE
	dbo.Products
DROP COLUMN
	RetailValue;

-- И создадим такой же, только изменим нашу формулу

ALTER TABLE
	dbo.Products
ADD
	RetailValue AS (QtyAvailable * UnitPrice * 1.3);

--Нельзя принудительно поменять данные вычисляемого столбца (получим ошибку)

UPDATE
	dbo.PersonInfo
SET
	FullName = 'Andrey Stepanov'
 WHERE
	FirstName = 'Anatolii';


-----------------------------------Пользовательские функции-----------------------------------

--Типы пользовательских функций:

--• Скалярные функции
--• Табличные функции
--• Системные функции

--Синтаксис создания скалярной функции

--CREATE FUNCTION FunctionName (@Parameter1 DataTypeForParameter1)
--RETURNS FunctionDataType
--AS
--	BEGIN
--		--Объявляем здесь возвращаемую переменную
--		DECLARE @ResultVariable FunctionDataType
--		--Добавляем сюда операторы SQL для вычисления возвращаемого значения
--		SELECT @ResultVariable
--		= ...
--		--Возвращаем результат функции
--		RETURN @ResultVariable
--	END
--GO

--cмотрим содержимое нашей таблицы:

SELECT
	*
FROM
	Sales.SalesTerritory;

--создаем функцию без параметров

CREATE FUNCTION YtdSales() 
RETURNS MONEY
AS
	BEGIN
		--Объявляем здесь возвращаемую переменную
		DECLARE @YtdSales MONEY
		--Добавляем сюда операторы SQL для вычисления возвращаемого значения
		SELECT @YtdSales = SUM(SalesYTD) FROM Sales.SalesTerritory
		--Возвращаем результат функции
		RETURN @YtdSales
	END
GO

--вызываем функцию и сохраняем результат в переменную

DECLARE @YtdResults MONEY
SELECT @YtdResults = dbo.YtdSales()
PRINT @YtdResults

--создаем скалярную функцию с параметром

CREATE FUNCTION YtdGroup(@Group VARCHAR(50)) 
RETURNS MONEY
AS
	BEGIN
		DECLARE @YtdSales MONEY
		SELECT @YtdSales = SUM(SalesYTD) FROM Sales.SalesTerritory
		WHERE [Group] = @Group
		RETURN @YtdSales
	END
GO

--вызываем функцию, передавая ей параметр на вход и сохраняем результат в переменную

DECLARE @YtdResults MONEY
--SELECT @YtdResults = dbo.YtdGroup('North America')
SELECT @YtdResults = dbo.YtdGroup('Europe')
PRINT @YtdResults

-- Cинтаксис создания табличной функции

--CREATE FUNCTION FunctionName (@Parameter1 DataTypeForParameter1)
--RETURNS TABLE
--AS RETURN
--	{sql_statement}
--END
--GO

--cмотрим содержимое нашей таблицы:

SELECT
	*
FROM
	Sales.SalesTerritory;

--создаем табличную функцию с параметром

CREATE FUNCTION TableValuedFunction (@TerritoryID INT) 
RETURNS TABLE
AS RETURN
	SELECT
		Name,
		CountryRegionCode,
		[Group],
		SalesYTD
	FROM
		Sales.SalesTerritory
	WHERE
		TerritoryID = @TerritoryID

--вызываем функцию путём выборки данных как с обычной таблицы, при этом передавая ей параметр на входе

SELECT
	*
FROM
	TableValuedFunction(7);

-- или моем выбрать только те столбцы, которые нам нужны

SELECT
	Name,
	[Group]
FROM
	TableValuedFunction(9);

-- синтаксис создания табличной функции (multi-statement)

--CREATE FUNCTION FunctionName
--(@Param1 Data_Type_For_Param1)
--RETURNS @Table_Variable_Name TABLE
--(Column_1 Data_Type_For_Column1)
--AS
--BEGIN
--{sql_statement}
--RETURN
--END
--GO

--В качестве примера ознакомьтесь с уже созданной табличной функцией (multi-statement) под названием ufnGetContactInformation

SELECT
	*
FROM
	dbo.ufnGetContactInformation(12);

--Правило хорошего тона относительно удаления функций:

-- определяем, существует ли функция в базе данных
IF OBJECT_ID (function_name, 'IF') IS NOT NULL
-- удаляем функцию
DROP FUNCTION function_name
GO

--Инвертируйте значение столбца «InputString» в таблице ReverseString в обратном порядке, не используя функцию «REVERSE».

--Создаем таблицу 

CREATE TABLE ReverseString(
	InputString VARCHAR(MAX)
 );

--Пример работы функции REVERSE

SELECT
	REVERSE('1234567890');

--Добавляем в нашу таблицу значения:

INSERT INTO
	ReverseString
VALUES
	('1234567890'),
	('How are you?'),
	('I like SQL course for beginners');

--Проверяем, что значения добавлены:

SELECT
	*
FROM
	ReverseString;

--Создаем нашу функцию, которую в итоге будет инвертировать значения в нашей таблице

CREATE FUNCTION MyReverseString (@OurString VARCHAR(MAX))
RETURNS VARCHAR(MAX)
AS
BEGIN  
	DECLARE
		@index INT,   
		@FinalResult VARCHAR(MAX)  
	SET
		@FinalResult = ''  
	SET
		@index = LEN(@OurString) 
	WHILE
		@index >= 1
			BEGIN  
				SET
					@FinalResult = @FinalResult + SUBSTRING(@OurString, @index, 1) 
				SET
					@index = @index - 1  
			END  
	RETURN
		@FinalResult
END
GO

--Выполните 2 запроса ниже для наглядности,чтобы видеть как работает наша функция:
--делаем выборку исходных данных из нашей таблицы:

SELECT
	*
FROM
	ReverseString;

--делаем выборку исходных данных из нашей таблицы, но с применением написанной нами функции:

SELECT
	dbo.MyReverseString(InputString)
FROM
	ReverseString;

-----------------------------------Транзакции-----------------------------------

--Делем выборку из исходной таблицы

SELECT
	*
FROM
	Sales.CreditCard;

--Обновляем данные в нашей таблице

UPDATE
	Sales.CreditCard
SET
	ExpYear = 2025
WHERE
	ExpYear = 2005;

--Делаем откат изменений

UPDATE
	Sales.CreditCard
SET
	ExpYear = 2005
WHERE
	ExpYear = 2025;

--Ключевые слова, которые являются важными при работе с транзакциями

--BEGIN TRANSACTION
--COMMIT TRANSACTION
--ROLLBACK TRANSACTION

--Пример транзакции

BEGIN TRANSACTION
UPDATE
	Sales.CreditCard
SET
	ExpYear = 2025
WHERE
	ExpYear = 2005
	AND
	CardType <> 'Vista';
SELECT
	*
FROM
	Sales.CreditCard;
-- COMMIT TRANSACTION
-- ROLLBACK TRANSACTION
GO

--Делаем выборку данных из таблицы

SELECT
	*
FROM
	HumanResources.JobCandidate;

--Пример еще одной транзакции

BEGIN TRANSACTION DeleteJobCandidate    
DELETE FROM
	HumanResources.JobCandidate  
WHERE
	JobCandidateID = 13; 
-- COMMIT TRANSACTION DeleteJobCandidate 
-- ROLLBACK TRANSACTION DeleteJobCandidate 

--Пример транзакции с точками сохранения, к которым мы можем возвращаться

BEGIN TRANSACTION

SELECT
	*
FROM
	HumanResources.JobCandidate;

SAVE TRANSACTION SavePoint1;

DELETE FROM
	HumanResources.JobCandidate  
WHERE
	JobCandidateID = 12;

SAVE TRANSACTION SavePoint2;

SELECT
	*
FROM
	HumanResources.JobCandidate;

ROLLBACK TRANSACTION SavePoint1;

SELECT
	*
FROM
	HumanResources.JobCandidate;

-----------------------------------Обработка ошибок-----------------------------------

--Делаем выборку из нашей таблицы

SELECT
	*
FROM
	Sales.SalesTerritory;

--Пример обработки ошибок:

DECLARE
	@ERRORRESULTS VARCHAR(50)
BEGIN TRANSACTION
INSERT INTO
	Sales.SalesTerritory
		(Name,
		CountryRegionCode,
		[Group],
		SalesYTD,
		SalesLastYear,
		CostYTD,
		CostLastYear,
		rowguid,
		ModifiedDate)
VALUES
	('ABCD',
	'US',
	'NA',
	1.00,
	1.00,
	1.00,
	1.00,
	'43689A10-E30B-497F-B0DE-11DE20267FF',
	GETDATE());

SET
	@ERRORRESULTS = @@ERROR

IF(@ERRORRESULTS = 0)
	BEGIN
		PRINT 'SUCCESS!!!'
		COMMIT TRANSACTION
	END
ELSE
	BEGIN
		PRINT 'STATEMENT FAILED!!!'
		ROLLBACK TRANSACTION
	END

--Пример работы блока TRY и CATCH

BEGIN TRY
	BEGIN TRANSACTION
	INSERT INTO
		Sales.SalesTerritory
			(Name,
			CountryRegionCode,
			[Group],
			SalesYTD,
			SalesLastYear,
			CostYTD,
			CostLastYear,
			rowguid,
			ModifiedDate)
	VALUES
		('ABCD',
		'US',
		'NA',
		1.00,
		1.00,
		1.00,
		1.00,
		'43689A10-E30B-497F-B0DE-11DE20267FF8',
		GETDATE())
	COMMIT TRANSACTION
END TRY
BEGIN CATCH
	PRINT 'CATCH STATEMENT ENTERED'
	ROLLBACK TRANSACTION
END CATCH

--Смотрим данные в нашей таблице:

SELECT
	*
FROM
	Sales.SalesTerritory


--У нас даже есть доступ к некоторым специальным данным, доступным только внутри оператора CATCH:

--ERROR_NUMBER - возвращает внутренний номер ошибки
--ERROR_STATE - возвращает информацию об источнике
--ERROR_SEVERITY - возвращает информацию обо всем, от информационных ошибок до ошибок, которые может исправить пользователь DBA и т. Д.
--ERROR_LINE - возвращает номер строки, на которой произошла ошибка
--ERROR_PROCEDURE - возвращает имя хранимой процедуры или функции
--ERROR_MESSAGE - возвращает наиболее важную информацию, а именно текст сообщения об ошибке

BEGIN TRY
	SELECT
		1/0 AS Error;
END TRY
BEGIN CATCH
	SELECT
		ERROR_NUMBER() AS ErrorNumber,
		ERROR_STATE() AS ErrorState,
		ERROR_SEVERITY() AS ErrorSeverity,
		ERROR_PROCEDURE() AS ErrorProcedure,
		ERROR_LINE() AS ErrorLine,
		ERROR_MESSAGE() AS ErrorMessage;
END CATCH;
















































