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

<li>Get Column name and their data type
<br>
select COLUMN_NAME,DATA_TYPE from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME='<TableName>'

<li>get all table names with no. of rows
<br>
select
    s.name as schemaname,
    t.name as tablename,
    p.rows as rowcounts,
    sum(a.total_pages) * 8 as totalspacekb, 
    cast(round(((sum(a.total_pages) * 8) / 1024.00), 2) as numeric(36, 2)) as totalspacemb,
    sum(a.used_pages) * 8 as usedspacekb, 
    cast(round(((sum(a.used_pages) * 8) / 1024.00), 2) as numeric(36, 2)) as usedspacemb, 
    (sum(a.total_pages) - sum(a.used_pages)) * 8 as unusedspacekb,
    cast(round(((sum(a.total_pages) - sum(a.used_pages)) * 8) / 1024.00, 2) as numeric(36, 2)) as unusedspacemb
from
    sys.tables t
inner join     
    sys.indexes i on t.object_id = i.object_id
inner join
    sys.partitions p on i.object_id = p.object_id and i.index_id = p.index_id
inner join
    sys.allocation_units a on p.partition_id = a.container_id
left outer join
    sys.schemas s on t.schema_id = s.schema_id
where
    t.name not like 'dt%' 
    and t.is_ms_shipped = 0
    and i.object_id > 255 
group by 
    t.name, s.name, p.Rows
order by
    t.name
