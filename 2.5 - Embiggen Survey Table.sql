USE AdventureWorks2012;
GO

-- Don't forget to do this!
UPDATE Sales.SurveyResults
	SET Q2 = NULL
	WHERE ResponseId = 7;
GO

-- Add about 1MM rows to the table for filtered indexes
DECLARE @dateValue date = DATEADD(year, -1, GETDATE());

INSERT INTO Sales.SurveyResults (ResponseDate, SurveyId, SalesPersonID, ProductNumber, PurchaseDate, Q1, Q2, Q3, Q4, Q5, OtherComments)
	VALUES (@dateValue, 1, 275, NULL, NULL, 1, 2, 3, 4, NULL, NULL),
		   (@dateValue, 1, 278, NULL, NULL, 4, 5, 2, 3, NULL, NULL),
		   (@dateValue, 1, 280, NULL, NULL, 3, 5, 3, 3, NULL, NULL),
		   (@dateValue, 1, 284, NULL, NULL, 5, 3, 4, 2, NULL, NULL),
		   (@dateValue, 1, 286, NULL, NULL, 3, 4, 5, 5, NULL, NULL),
		   (@dateValue, 1, 288, NULL, NULL, 3, 3, 5, 5, NULL, NULL),
		   (@dateValue, 1, 289, NULL, NULL, 4, 2, 5, 2, NULL, NULL),
		   (@dateValue, 1, 290, NULL, NULL, 5, 2, 4, 5, NULL, NULL),
		   (@dateValue, 2, NULL, 329, @dateValue, 2, 3, NULL, NULL, NULL, NULL),
		   (@dateValue, 2, NULL, 333, @dateValue, 5, 3, NULL, NULL, NULL, NULL),
		   (@dateValue, 2, NULL, 341, @dateValue, 5, 5, NULL, NULL, NULL, NULL),
		   (@dateValue, 2, NULL, 341, @dateValue, 4, 2, NULL, NULL, NULL, NULL),
		   (@dateValue, 2, NULL, 350, @dateValue, 5, 1, NULL, NULL, NULL, NULL),
		   (@dateValue, 2, NULL, 355, @dateValue, 5, 5, NULL, NULL, NULL, NULL),
		   (@dateValue, 2, NULL, 370, @dateValue, 2, 2, NULL, NULL, NULL, NULL),
		   (@dateValue, 2, NULL, 380, @dateValue, 5, 4, NULL, NULL, NULL, NULL),
		   (@dateValue, 2, NULL, 395, @dateValue, 4, 5, NULL, NULL, NULL, NULL),
		   (@dateValue, 2, NULL, 400, @dateValue, 2, 4, NULL, NULL, NULL, NULL),
		   (@dateValue, 2, NULL, 401, @dateValue, 3, 5, NULL, NULL, NULL, NULL),
		   (@dateValue, 2, NULL, 433, @dateValue, 2, 5, NULL, NULL, NULL, NULL),
		   (@dateValue, 2, NULL, 437, @dateValue, 5, 1, NULL, NULL, NULL, NULL),
		   (@dateValue, 2, NULL, 438, @dateValue, 5, 5, NULL, NULL, NULL, NULL),
		   (@dateValue, 2, NULL, 452, @dateValue, 5, 3, NULL, NULL, NULL, NULL),
		   (@dateValue, 2, NULL, 452, @dateValue, 4, 3, NULL, NULL, NULL, NULL),
		   (@dateValue, 2, NULL, 492, @dateValue, 5, 5, NULL, NULL, NULL, NULL),
		   (@dateValue, 2, NULL, 494, @dateValue, 5, 4, NULL, NULL, NULL, NULL),
		   (@dateValue, 2, NULL, 495, @dateValue, 3, 2, NULL, NULL, NULL, NULL),
		   (@dateValue, 2, NULL, 524, @dateValue, 2, 5, NULL, NULL, NULL, NULL);

SET @dateValue = DATEADD(day, 1, @dateValue);

WHILE @dateValue <= CAST(GETDATE() AS date)
BEGIN
	INSERT INTO Sales.SurveyResults (ResponseDate, SurveyId, SalesPersonID, ProductNumber, PurchaseDate, Q1, Q2, Q3, Q4, Q5, OtherComments)
		SELECT TOP(5000) @dateValue, SurveyId, SalesPersonID, ProductNumber, PurchaseDate, Q1, Q2, Q3, Q4, Q5, OtherComments
			FROM Sales.SurveyResults;

	SET @dateValue = DATEADD(day, 1, @dateValue);
END
GO

UPDATE STATISTICS Sales.SurveyResults;
GO