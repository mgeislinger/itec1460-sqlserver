USE Northwind;
GO

-- Procedure 1: No parameters
-- This procedure just prints a message.

CREATE OR ALTER PROCEDURE WelcomeMessage
AS
BEGIN
    SET NOCOUNT ON;
    PRINT 'Welcome to the Northwind Database!';
END
GO

-- Test it
EXEC WelcomeMessage;
GO

-- Procedure 2: One input parameter
-- Looks up a customer's company name by CustomerID.

CREATE OR ALTER PROCEDURE GetCustomerName
    @CustomerID NCHAR(5)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @CompanyName NVARCHAR(40);

    SELECT @CompanyName = CompanyName
    FROM Customers
    WHERE CustomerID = @CustomerID;

    IF @CompanyName IS NULL
        PRINT 'Customer not found.';
    ELSE
        PRINT 'Company Name: ' + @CompanyName;
END
GO

-- Test with a valid customer
EXEC GetCustomerName @CustomerID = 'ALFKI';
GO

-- Test with an invalid customer
EXEC GetCustomerName @CustomerID = 'ZZZZZ';
GO

-- Procedure 3: One input parameter, one output parameter
-- Returns the total number of orders for a customer.

CREATE OR ALTER PROCEDURE GetCustomerOrderCount
    @CustomerID NCHAR(5),
    @OrderCount INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    --RETRIEVE ORDER COUNT *=ALL THAT APPEARS
    --CustomerID=Customer in the Parameters
    SELECT @OrderCount = COUNT(*)
    FROM Orders
    WHERE CustomerID = @CustomerID;
END
GO

SELECT * FROM Orders;

---IN LAB, Getting ALKI and OrderCount
---THis caused an error message
---Msg 137, Level 15, State 2, Line 3
---Must declare the scalar variable "@OrderCount".
---ADD THE DECLARE LANGUAGE
---EXEC GetCustomerOrderCount
---@CustomerID = 'ALFKI',
---@OrderCount = @OrderCount OUTPUT;

---PRINT 'Order count for ALFKI: ' + CAST(@OrderCount AS NVARCHAR(10));
---GO

---RETRY with DECLARE / Must declare
DECLARE @OrderCount INT;
EXEC GetCustomerOrderCount
    @CustomerID = 'ALFKI',
    @OrderCount = @OrderCount OUTPUT;

PRINT 'Order count for ALFKI: ' + CAST(@OrderCount AS NVARCHAR(10));
GO

-- Procedure 4: Input and output parameters with error handling
-- Calculates the total dollar amount for a given order.
--- OUTPUT PARAMETER
--- ADD BEGIN / END BLOCK
CREATE OR ALTER PROCEDURE CalculateOrderTotal
    @OrderID INT,
    @TotalAmount MONEY OUTPUT
AS
BEGIN
    ---Suppresses the number of rows message that you usually see
    SET NOCOUNT ON;

    ---Retrieve (SELECT) the data calculation*SUM* from (FROM) the table 
    ---filtered (WHERE) the input OrderID is OUTput 
    SELECT @TotalAmount = SUM(UnitPrice * Quantity * (1 - Discount))
    FROM [Order Details]
    WHERE OrderID = @OrderID;

    ---If the output is not found or in the table, we are creating message
    ---If there is more than 1 or more line of code, use BEGIN/END block
    IF @TotalAmount IS NULL
    BEGIN
        ---Set the total amount to Zero
        ---OUTput (SET) to 0, then send message (PRINT)
        ---CAST - change to string
        SET @TotalAmount = 0;
        PRINT 'Order ' + CAST(@OrderID AS NVARCHAR(10)) + ' not found.';
        RETURN; ---END PROCEDURE
    END
    ---Only Print the total amount if there is a value
    ---CAST Function - Change the OrderID to a string
    PRINT 'Total for Order ' + CAST(@OrderID AS NVARCHAR(10)) + ': $' + CAST(@TotalAmount AS NVARCHAR(20));
END
GO

-- Test with a valid order: 10249, 10280, 10000
DECLARE @TotalAmount MONEY;

EXEC CalculateOrderTotal
    @OrderID = 10249,
    @TotalAmount = @TotalAmount OUTPUT;

PRINT 'Returned total: $' + CAST(@TotalAmount AS NVARCHAR(20));
GO

-- Test with an invalid order
DECLARE @TotalAmount MONEY;

EXEC CalculateOrderTotal
    @OrderID = 99999,
    @TotalAmount = @TotalAmount OUTPUT;

PRINT 'Returned total: $' + CAST(ISNULL(@TotalAmount, 0) AS NVARCHAR(20));
GO