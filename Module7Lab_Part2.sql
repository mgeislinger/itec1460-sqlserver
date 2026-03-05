USE Northwind;
GO

-- =============================================
-- Part 2, Procedure 1: GetProductName
-- =============================================

CREATE OR ALTER PROCEDURE GetProductName
    @ProductID INT,
    @ProductName NVARCHAR(40) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    -- YOUR CODE HERE: Write a SELECT statement that sets
    -- @ProductName equal to the ProductName column
    -- from the Products table where ProductID matches @ProductID.
    SELECT @ProductName = ProductName
    FROM Products
    WHERE ProductID = @ProductID;

    IF @ProductName IS NULL
        PRINT 'Product not found.';
    ELSE
        PRINT 'Product Name: ' + @ProductName;
END
GO

-- Test it
DECLARE @ProductName NVARCHAR(40);

EXEC GetProductName
    @ProductID = 1,
    @ProductName = @ProductName OUTPUT;
GO

---CHECK THE LIST
Select * From Products;

-- =============================================
-- Part 2, Procedure 2: GetEmployeeOrderCount
-- =============================================

CREATE OR ALTER PROCEDURE GetEmployeeOrderCount
    @EmployeeID INT,
    @OrderCount INT OUTPUT
AS
BEGIN
    -- YOUR CODE HERE:
    -- 1. Turn off row count messages (SET NOCOUNT ON)
    SET NOCOUNT ON;

    -- 2. Write a SELECT statement that counts orders for this employee
    --    and stores the result in @OrderCount
    --    Hint: Use COUNT(*) and the Orders table.
    --    The Orders table has an EmployeeID column.
    SELECT @OrderCount = COUNT(*)
    FROM Orders
    WHERE EmployeeID = @EmployeeID;

    -- 3. Print a message showing the employee ID and their order count.
    --    Hint: Use CAST to convert INT values to NVARCHAR for PRINT.
    PRINT 
        'Employee ID: ' + CAST(@EmployeeID AS NVARCHAR(10)) + ', '  + 
        'Order Count: ' + CAST(@OrderCount AS NVARCHAR(10));

END
GO

-- Test it
DECLARE @OrderCount INT;

EXEC GetEmployeeOrderCount
    @EmployeeID = 5,
    @OrderCount = @OrderCount OUTPUT;
GO

-- =============================================
-- Procedure 3: From Scratch — Check if a Product Needs Reordering
-- =============================================

CREATE OR ALTER PROCEDURE CheckProductStock
    @ProductID INT,
    @NeedsReorder BIT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    -- Declare input and output
    DECLARE @UnitsInStock INT;
    DECLARE @ReorderLevel INT;

    -- Get stock information
    SELECT 
        @UnitsInStock = UnitsInStock,
        @ReorderLevel = ReorderLevel
    FROM Products
    WHERE ProductID = @ProductID;

    -- Message if it is not located
    IF @UnitsInStock IS NULL
    BEGIN
        PRINT 'Product not found.';
        SET @NeedsReorder = 0;
        RETURN;
    END

    -- Message is reorder is needed
    IF @UnitsInStock <= @ReorderLevel
    BEGIN
        SET @NeedsReorder = 1;
        PRINT 'Product ' + CAST(@ProductID AS NVARCHAR(10)) + ' needs reordering.';
    END
    ELSE
    BEGIN
        SET @NeedsReorder = 0;
        PRINT 'Product ' + CAST(@ProductID AS NVARCHAR(10)) + ' stock is OK.';
    END
END
GO

-- Test CheckProductStock
DECLARE @NeedsReorder BIT;

EXEC CheckProductStock
    @ProductID = 2,
    @NeedsReorder = @NeedsReorder OUTPUT;

PRINT 'Needs Reorder flag: ' + CAST(@NeedsReorder AS VARCHAR(1));
GO