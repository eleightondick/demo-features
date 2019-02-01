USE AdventureWorks2012;
GO

-- NOTE: Turn on actual execution plans before starting

SET STATISTICS IO ON;

SELECT ResponseId, ResponseDate, SurveyId, SalesPersonID, ProductNumber, PurchaseDate, Q1, Q2, Q3, Q4
	FROM Sales.SurveyResults
	WHERE Q2 IS NULL
	ORDER BY ResponseId;
GO

CREATE NONCLUSTERED INDEX IX_SurveyResults_NoQ2
	ON Sales.SurveyResults (SalesPersonID, ResponseDate)
	INCLUDE (ResponseId, SurveyId, ProductNumber, PurchaseDate, Q1, Q2, Q3, Q4)
	WHERE Q2 IS NULL;
GO

SELECT ResponseId, ResponseDate, SurveyId, SalesPersonID, ProductNumber, PurchaseDate, Q1, Q2, Q3, Q4
	FROM Sales.SurveyResults
	WHERE Q2 IS NULL
	ORDER BY ResponseId
	OPTION(RECOMPILE);
GO

-- Another test
CREATE NONCLUSTERED INDEX IX_SurveyResults_LowQ4
	ON Sales.SurveyResults (SalesPersonID, ResponseDate)
	INCLUDE (ResponseId, SurveyId, ProductNumber, PurchaseDate, Q1, Q2, Q3, Q4)
	WHERE Q4 <= 2;
GO

SELECT ResponseId, ResponseDate, SurveyId, SalesPersonID, ProductNumber, PurchaseDate, Q1, Q2, Q3, Q4
	FROM Sales.SurveyResults
	WHERE Q4 = 2
	ORDER BY SalesPersonID;
GO

-- Create a filtered index for survey 1
CREATE NONCLUSTERED INDEX IX_SurveyResults_CustomerService
	ON Sales.SurveyResults (SalesPersonID, ResponseDate)
	INCLUDE (ResponseId, SurveyId, ProductNumber, PurchaseDate, Q1, Q2, Q3, Q4)
	WHERE SurveyId = 1;
GO

SELECT ResponseId, ResponseDate, SurveyId, SalesPersonID, ProductNumber, PurchaseDate, Q1, Q2, Q3, Q4
	FROM Sales.SurveyResults
	WHERE SurveyId = 1
	ORDER BY ResponseId;
GO

-- Filtering on non-deterministic values does NOT work
CREATE NONCLUSTERED INDEX IX_SurveyResults_LastWeek
	ON Sales.SurveyResults (SalesPersonID, ResponseDate)
	WHERE ResponseDate > DATEADD(day, -7, GETDATE());
GO

-- What about using BETWEEN or LIKE?
CREATE NONCLUSTERED INDEX IX_SurveyResults_MidQ4
	ON Sales.SurveyResults (SalesPersonID, ResponseDate)
	INCLUDE (ResponseId, SurveyId, ProductNumber, PurchaseDate, Q1, Q2, Q3, Q4)
	WHERE Q4 BETWEEN 2 AND 4;

CREATE NONCLUSTERED INDEX IX_Person_LastNameStartsWithA
	ON Person.Person (LastName, FirstName)
	WHERE LastName LIKE 'A%';
GO