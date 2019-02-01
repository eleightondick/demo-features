USE AdventureWorks2012;
GO

IF OBJECT_ID('Sales.SurveyResults') IS NOT NULL
	DROP TABLE Sales.SurveyResults;

CREATE TABLE Sales.SurveyResults
	(ResponseId int NOT NULL IDENTITY(1,1) PRIMARY KEY CLUSTERED,
	 ResponseDate datetime NOT NULL DEFAULT (GETDATE()),
	 SurveyId int NOT NULL,
	 SalesPersonID int SPARSE NULL,
	 ProductNumber nvarchar(25) SPARSE NULL,
	 PurchaseDate date SPARSE NULL,
	 Q1 int SPARSE NULL,
	 Q2 int SPARSE NULL,
	 Q3 int SPARSE NULL,
	 Q4 int SPARSE NULL,
	 Q5 int SPARSE NULL,
	 OtherComments varchar(500) SPARSE NULL,
	 AllAnswers xml COLUMN_SET FOR ALL_SPARSE_COLUMNS);
GO

-- Insert some fielded data
INSERT INTO Sales.SurveyResults (SurveyId, SalesPersonID, Q1, Q2, Q3, Q4, OtherComments)
	VALUES (1, 274, 4, 5, 5, 3, NULL),
		   (1, 274, 5, 4, 5, 5, 'Exceptional service!'),
		   (1, 301, 4, 5, 5, 5, NULL);
GO

INSERT INTO Sales.SurveyResults (SurveyId, ProductNumber, PurchaseDate, Q1, Q2, OtherComments)
	VALUES (2, 775, '12/24/2013', 2, 2, 'Why can''t I ride my new bike in the winter?'),
		   (2, 754, '4/7/2014', 9, 7, 'Great value'),
		   (2, 800, '4/19/2014', 7, 8, NULL);
GO

-- Select the fielded data
SELECT ResponseId, ResponseDate, SurveyId, SalesPersonID, Q1, Q2, Q3, Q4, OtherComments
	FROM Sales.SurveyResults
	WHERE SurveyId = 1
	ORDER BY ResponseId;
GO

SELECT ResponseId, ResponseDate, SurveyId, ProductNumber, PurchaseDate, Q1, Q2, OtherComments
	FROM Sales.SurveyResults
	WHERE SurveyId = 2
	ORDER BY ResponseId;
GO

-- Select everything
SELECT ResponseId, ResponseDate, SurveyId, SalesPersonID, ProductNumber, PurchaseDate, Q1, Q2, Q3, Q4, OtherComments
	FROM Sales.SurveyResults
	ORDER BY ResponseId;
GO

SELECT *
	FROM Sales.SurveyResults
	ORDER BY ResponseId;
GO

-- Insert answers as XML
INSERT INTO Sales.SurveyResults (SurveyId, AllAnswers)
	VALUES (1, '<SalesPersonID>274</SalesPersonID><Q1>5</Q1><Q2>2</Q2><Q3>3</Q3><Q4>5</Q4><OtherComments>Responding again</OtherComments>');
GO

SELECT ResponseId, ResponseDate, SurveyId, SalesPersonID, Q1, Q2, Q3, Q4, OtherComments
	FROM Sales.SurveyResults
	WHERE SurveyId = 1
	ORDER BY ResponseId;
GO

-- All fields work as expected!
UPDATE Sales.SurveyResults
	SET Q2 = NULL
	WHERE ResponseId = 7;
GO

SELECT ResponseId, ResponseDate, SurveyId, SalesPersonID, Q1, Q2, Q3, Q4, OtherComments
	FROM Sales.SurveyResults
	WHERE ResponseId = 7;
GO

SELECT *
	FROM Sales.SurveyResults
	WHERE ResponseId = 7;
GO
