/*select d.DEPTNAME as DepartmentName, trunc(avg(r.GRADEASPERCENTAGE),2) as AverageGrade
from DEPARTMENT d, COURSE c, REGISTRATION r, OFFERING o
where d.DEPTID = c.DEPTID
and o.OFFERINGID = r.OFFERINGID
and o.COURSEID = c.COURSEID
group by d.DEPTNAME  
order by d.DEPTNAME;*/

create or replace procedure pro_AvgGrade
as

min_avg integer;
max_avg integer;
i integer;   /* used for indexing */
CURSOR grade_cur IS SELECT d.DEPTNAME as DEPTNAME, trunc(avg(r.GRADEASPERCENTAGE),2) as AVGGRADE
from DEPARTMENT d, COURSE c, REGISTRATION r, OFFERING o
where d.DEPTID = c.DEPTID
and o.OFFERINGID = r.OFFERINGID
and o.COURSEID = c.COURSEID
group by d.DEPTNAME
order by d.DEPTNAME;
grade_rec grade_cur%ROWTYPE;

begin

  min_avg := 0;
  max_avg := 0;
  /*get the max and min*/
  for grade_rec in grade_cur loop
      if max_avg < grade_rec.AVGGRADE THEN
          max_avg := grade_rec.AVGGRADE;
      end if;
  end loop;
max_avg := ceil(max_avg / 10);
max_avg := max_avg * 10;
min_avg := max_avg;
  for grade_rec in grade_cur loop     
      if min_avg > grade_rec.AVGGRADE THEN
          min_avg := grade_rec.AVGGRADE;
      end if; 
  end loop;
min_avg := floor(min_avg / 10);
min_avg := min_avg * 10;
i := min_avg;
/*output */
dbms_output.put('DEPTNAME'||'     '||'AVGGRADE:'||'     ');   
while i < max_avg loop
    dbms_output.put('>'||i||', <='||(i+10));
    dbms_output.put('     ');
    i := i+10;
end loop;

dbms_output.new_line;
i := min_avg;
dbms_output.put('--------                   ');

while i < max_avg loop
    dbms_output.put('---------');
    dbms_output.put('     ');
    i := i+10;
end loop;

dbms_output.new_line;
/*get the deptname */
for grade_rec in grade_cur loop
      dbms_output.put(grade_rec.DEPTNAME);
      i := min_avg;
     while i < max_avg loop
          if grade_rec.AVGGRADE > i and grade_rec.AVGGRADE <= i+10 and i = min_avg THEN
               dbms_output.put(lpad('X',11,' '));/*dbms_output.put('           X');*/
          elsif grade_rec.AVGGRADE > i and grade_rec.AVGGRADE <= i+10 and i > min_avg THEN
               dbms_output.put(lpad('X',11,' ')); /*dbms_output.put('           X');*/
          elsif grade_rec.AVGGRADE > i+10 THEN
                dbms_output.put(lpad(' ',14,' '));/*dbms_output.put('              ');*/
          end if;
          i := i + 10;
     end loop;
          dbms_output.new_line;
end loop;

end;
/
begin
pro_AvgGrade;
end;
/
