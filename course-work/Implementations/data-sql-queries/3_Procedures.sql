-- Процедура: добавя нов потребител в системата
CREATE PROCEDURE AddUser
    @UserName VARCHAR(50),
    @Email VARCHAR(100),
    @FirstName VARCHAR(50),
    @LastName VARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO [User] (UserName, Email, FirstName, LastName, Status)
    VALUES (@UserName, @Email, @FirstName, @LastName, 'Active');
END;
GO

-- Извикване на процедура
EXEC AddUser 
    @UserName = 'ivan_petrov1', 
    @Email = 'ivan_petrov1@mail.com', 
    @FirstName = 'Ivan', 
    @LastName = 'Petrov';

-- Проверяваме резултата в таблицата User
SELECT * FROM [User] WHERE UserName = 'ivan_petrov1';


-- Процедура: създава нова обява Listing
CREATE PROCEDURE CreateListing
    @Title VARCHAR(100),
    @Type VARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO Listing (Title, [Type], [Status])
    VALUES (@Title, @Type, 'Active');
END;
GO

-- Извикване на процедура
EXEC CreateListing 
    @Title = 'English Tutoring', 
    @Type = 'Education';

-- Проверяваме резултата в таблицата Listing
SELECT * FROM Listing WHERE Title = 'English Tutoring';

-- Процедура: създава нов запис Exchange (обмен)`
CREATE PROCEDURE StartExchange
    @UserID INT,
    @ListingID INT,
    @AgreedPoints INT
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO Exchange (UserID, ListingID, AgreedPoints, [Status])
    VALUES (@UserID, @ListingID, @AgreedPoints, 'Pending');
END;
GO
-- Извикване на процедура
EXEC StartExchange 
    @UserID = 1,       
    @ListingID = 1,    
    @AgreedPoints = 5;

--Проверяваме резултата в таблицата Exchange
SELECT * FROM Exchange 
WHERE UserID = 1 AND ListingID = 1;
