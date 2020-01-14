--gets month's name
'''
select datename(month,date) from table
'''

--group by alias name

select datename(month,date) monthnm from table group by datename(month,date)

--get days in month

DECLARE @ADate DATETIME
SET @ADate = GETDATE()
SELECT DAY(EOMONTH(@ADate)) AS DaysInMonth

--Two ways of using stuff

STUFF((SELECT ',' + BrandNm from MstFixedMonthlyExpenseDetail b WHERE b.MonthlyExpID = a.MonthlyExpID FOR XML PATH (''),TYPE).value('.','varchar(max)'),1,1,'')
STUFF(( SELECT ', ' + BrandNm from MstFixedMonthlyExpenseDetail b WHERE b.MonthlyExpID = a.MonthlyExpID FOR XML PATH('')),1,2,'')
