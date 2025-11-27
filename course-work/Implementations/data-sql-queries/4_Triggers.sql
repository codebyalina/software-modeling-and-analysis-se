-- Таблицата съхранява информация за това, че потребителят вече е направил покупка на стойност 10 точки през конкретния месец.
CREATE TABLE USER_MONTHLY_PURCHASE_LIMIT
(
    LIMIT_ID INT IDENTITY(1,1) PRIMARY KEY,
    USER_ID INT NOT NULL,
    YEAR_NUM INT NOT NULL,
    MONTH_NUM INT NOT NULL,
    POINTS_AMOUNT INT NOT NULL,
    CREATED_ON DATETIME NOT NULL DEFAULT SYSDATETIME(),

    FOREIGN KEY (USER_ID) REFERENCES [User](UserID),
    CONSTRAINT UQ_User_Month UNIQUE (USER_ID, YEAR_NUM, MONTH_NUM)
);

-- Тригер: забранява повече от една покупка на 10 точки на месец, запазва в USER_MONTHLY_PURCHASE_LIMIT
CREATE TRIGGER TRG_LimitMonthlyPayment10
ON Payment
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (SELECT 1 FROM inserted WHERE PointsBought = 10)
    BEGIN
        IF EXISTS (
            SELECT 1
            FROM USER_MONTHLY_PURCHASE_LIMIT L
            JOIN inserted I ON L.USER_ID = I.UserID
            WHERE L.YEAR_NUM = YEAR(I.PaymentDate)
              AND L.MONTH_NUM = MONTH(I.PaymentDate)
              AND L.POINTS_AMOUNT = 10
        )
        BEGIN
            RAISERROR('Monthly limit: only one purchase of 10 points per month.',16,1);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        INSERT INTO USER_MONTHLY_PURCHASE_LIMIT (USER_ID, YEAR_NUM, MONTH_NUM, POINTS_AMOUNT)
        SELECT I.UserID, YEAR(I.PaymentDate), MONTH(I.PaymentDate), 10
        FROM inserted I
        WHERE I.PointsBought = 10;
    END
END;
GO



-- Първия опит
INSERT INTO Payment (UserID, AmountPaid, PointsBought)
VALUES (1, 10.00, 10);  -- Успешно

-- Същия опит в същият месяц
INSERT INTO Payment (UserID, AmountPaid, PointsBought)
VALUES (1, 10.00, 10);  -- Грешка

-- Проверяваме таблицата с лимитите
SELECT * FROM USER_MONTHLY_PURCHASE_LIMIT WHERE USER_ID = 1;




