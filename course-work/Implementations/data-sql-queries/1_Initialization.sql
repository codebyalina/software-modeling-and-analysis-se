create database TIMESWAPDB;

CREATE TABLE [User] (
    UserID           INT IDENTITY(1,1) PRIMARY KEY,       
    UserName         VARCHAR(50) NOT NULL UNIQUE,         
    Email            VARCHAR(100) NOT NULL UNIQUE,       
    FirstName        VARCHAR(50),
    LastName         VARCHAR(50),
    Balance          INT NOT NULL DEFAULT 0
                        CHECK (Balance >= -20),         
    RegistrationDate DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    [Status]          VARCHAR(20)  CHECK ([Status] IN ('Active','Inactive','Banned','Pending'))
);
CREATE TABLE Chat (
    ChatID    INT IDENTITY(1,1) PRIMARY KEY,              
    UserID    INT NOT NULL,                              
    Content   VARCHAR(MAX),
    SentDate  DATETIME2 NOT NULL DEFAULT SYSDATETIME(),

    FOREIGN KEY (UserID) REFERENCES [User](UserID)
);


CREATE TABLE Listing (
    ListingID INT IDENTITY(1,1) PRIMARY KEY,                                             
    Title     VARCHAR(100) NOT NULL,
    [Type]      VARCHAR(50),
    [Status]    VARCHAR(20)
);


CREATE TABLE Exchange (
    ExchangeID    INT IDENTITY(1,1) PRIMARY KEY,          
    UserID        INT NOT NULL,                            
    ListingID     INT NOT NULL,                            
    [Status]        VARCHAR(20),
    AgreedPoints  INT,
    StartDate     DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    EndDate       DATETIME2,

    FOREIGN KEY (UserID) REFERENCES [User](UserID),
    FOREIGN KEY (ListingID) REFERENCES Listing(ListingID)
);


CREATE TABLE Review (
    ExchangeID    INT NOT NULL,                            
    ReviewSeq     INT NOT NULL,                          
    Rating        INT CHECK (Rating BETWEEN 1 AND 5),
    Comment       VARCHAR(MAX),

    PRIMARY KEY (ExchangeID, ReviewSeq),
    FOREIGN KEY (ExchangeID) REFERENCES Exchange(ExchangeID)
);

CREATE TABLE Payment (
    PaymentID     INT IDENTITY(1,1) PRIMARY KEY,          
    UserID        INT NOT NULL,                          
    AmountPaid DECIMAL(10,2) NOT NULL CHECK (AmountPaid > 0),
    PointsBought  INT NOT NULL CHECK (PointsBought BETWEEN 1 AND 10),
    PaymentDate   DATETIME2 NOT NULL DEFAULT SYSDATETIME(),

    FOREIGN KEY (UserID) REFERENCES [User](UserID)
);

CREATE TABLE [Transaction] (
    TransactionID    INT IDENTITY(1,1) PRIMARY KEY,        
    UserID           INT NOT NULL,                        
    PaymentID        INT NULL,  
    [Type]            VARCHAR(20) NOT NULL
                        CHECK ([Type] IN ('earn','spend','purchase')),
    Amount           INT NOT NULL,
    TransactionDate  DATETIME2 NOT NULL DEFAULT SYSDATETIME(),

    FOREIGN KEY (UserID) REFERENCES [User](UserID),
    FOREIGN KEY (PaymentID) REFERENCES Payment(PaymentID),	

    
    CHECK (NOT ([Type] = 'purchase' AND Amount > 10))
);

