CREATE FUNCTION getWeeklyReportAboutOrders(@date DATE)
RETURNS @orderReportTable TABLE(OrderStatus INT,OrdersMade INT)
AS
BEGIN
INSERT INTO @orderReportTable SELECT StatusId,COUNT(*) FROM Orders WHERE ABS(DATEDIFF(day,@date,OrderMadeDate)) < 7 AND DATEPART(week,@date) = DATEPART(week,OrderMadeDate) GROUP BY StatusId;
RETURN;
END