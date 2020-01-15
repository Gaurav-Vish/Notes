<li>gets month's name
<br>
select datename(month,date) from table

<li>group by alias name
<br>
select datename(month,date) monthnm from table group by datename(month,date)

<li>get days in month
<br>
DECLARE @ADate DATETIME
SET @ADate = GETDATE()
SELECT DAY(EOMONTH(@ADate)) AS DaysInMonth

<li>Two ways of using stuff
<br>
STUFF((SELECT ',' + BrandNm from MstFixedMonthlyExpenseDetail b WHERE b.MonthlyExpID = a.MonthlyExpID FOR XML PATH (''),TYPE).value('.','varchar(max)'),1,1,'')
STUFF(( SELECT ', ' + BrandNm from MstFixedMonthlyExpenseDetail b WHERE b.MonthlyExpID = a.MonthlyExpID FOR XML PATH('')),1,2,'')