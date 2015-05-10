/*select round(months_between(Sysdate,s.BIRTHDATE)/12,0) as Age, count(s.STUDENTID) as num
from STUDENT s
group by round(months_between(Sysdate,s.BIRTHDATE)/12,0)
order by Age;*/

set serveroutput on size 32000
create or replace procedure pro_DispAge as

total integer;
median integer;
i       integer; /*indexing*/
median_print integer; /*boolean if median was printed */
CURSOR age_cur is select round(months_between(Sysdate,s.BIRTHDATE)/12,0) as Age, count(s.STUDENTID) as std_count
from STUDENT s
group by round(months_between(Sysdate,s.BIRTHDATE)/12,0)
order by Age;
age_rec age_cur%ROWTYPE;

begin
total := 0;
median := 0;
median_print := 0;
i := 0;
for age_rec in age_cur loop
      total := total + age_rec.std_count;
  end loop;
  if mod(total+1,2) = 0 THEN
      median := (total+1)/2;
  else
      median := -1;
      /*dbms_output.put_line('odd');*/
  end if;
  dbms_output.put_line('AGE | #student');
  
  for age_rec in age_cur loop
      i := i + age_rec.std_count;
      if median != -1 and i >= median and median_print = 0 THEN
        dbms_output.put_line(age_rec.AGE||lpad('|',2,' ')||lpad(age_rec.std_count,2,' ')||lpad(' <--median',10,' '));
        median_print := 1;
      else
        dbms_output.put_line(age_rec.AGE||lpad('|',2,' ')||lpad(age_rec.std_count,2,' '));
      end if;
  end loop;
end;

/
begin
pro_DispAge;
end;
/