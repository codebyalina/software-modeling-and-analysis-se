-- Функция: връща пълното име на потребителя по UserID
CREATE FUNCTION GetFullName (@UserID INT)
RETURNS VARCHAR(120)
AS
BEGIN
    DECLARE @FullName VARCHAR(120);

    SELECT @FullName = CONCAT(FirstName, ' ', LastName)
    FROM [User]
    WHERE UserID = @UserID;

    RETURN @FullName;
END;
GO

-- Извикване на функция в SELECT
SELECT dbo.GetFullName(1) AS FullName;

-- Функция: връща броя на Exchange за дадения потребител
CREATE FUNCTION CountUserExchanges (@UserID INT)
RETURNS INT
AS
BEGIN
    DECLARE @Count INT;

    SELECT @Count = COUNT(*)
    FROM Exchange
    WHERE UserID = @UserID;

    RETURN @Count;
END;
GO
-- Извикване на функция в SELECT
SELECT dbo.CountUserExchanges(1) AS ExchangeCount;

-- Функция: връща общата оценка Review за конкретен Exchange
CREATE FUNCTION TotalReviewScore (@ExchangeID INT)
RETURNS INT
AS
BEGIN
    DECLARE @Total INT;

    SELECT @Total = SUM(Rating)
    FROM Review
    WHERE ExchangeID = @ExchangeID;

    RETURN @Total;
END;
GO
-- Извикване на функция в SELECT
SELECT dbo.TotalReviewScore(2) AS TotalRating;


