(SELECT name, create_date, modify_date, type FROM sys.procedures p) 
union
(select name, create_date, modify_date, type from sys.tables t) order by modify_date desc