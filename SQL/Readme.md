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

<li>get currently running query
select r.total_elapsed_time / 1000.0 as total_elapsed_s,percent_complete, r.blocking_session_id,r.last_wait_type, s.login_name,'MySessionID= ' + cast(r.session_id as varchar) as MySessionID, DB_NAME(r.database_id) as DatabaseName, command ,SUBSTRING(t.text, (r.statement_start_offset/2) + 1, ((CASE statement_end_offset WHEN -1 THEN DATALENGTH(t.text) ELSE r.statement_end_offset END - r.statement_start_offset)/2) + 1) AS statement_text, r.status,wait_time, wait_type, wait_resource, text, start_time, s.program_name, r.last_wait_type, s.host_name, r.granted_query_memory * 8 / 1024 as memory_mb
from sys.dm_exec_requests r
inner join sys.dm_exec_sessions s on r.session_id = s.session_id
cross apply sys.dm_exec_sql_text(r.sql_handle) t
