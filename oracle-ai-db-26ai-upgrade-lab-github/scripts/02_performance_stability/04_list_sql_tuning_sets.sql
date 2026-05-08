set linesize 200 pagesize 100
column name format a35
column owner format a15

select name, owner, statement_count
from dba_sqlset
where name like 'STS_Capture%'
order by name;
