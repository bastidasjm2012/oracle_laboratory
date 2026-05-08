set linesize 220 pagesize 200
column object_type format a30
column race format a80

prompt ---- POST DATA PUMP IMPORT VALIDATION ----

select object_type, count(*)
from all_objects
where owner='F1'
group by object_type
order by object_type;

prompt ---- BUSINESS VALIDATION SAMPLE ----

select ra.name || ' ' || ra.year as race
from f1.f1_races ra,
     f1.f1_results re,
     f1.f1_drivers d
where d.forename='Kevin'
  and d.surname='Magnussen'
  and re.position=2
  and d.driverid=re.driverid
  and ra.raceid=re.raceid;
