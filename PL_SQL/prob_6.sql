/*select o.OFFERINGID, o.YEAR, o.SEMESTER
from OFFERING o;*/

/*select r.STUDENTID, avg(r.GRADEASPERCENTAGE) as Avg_Grade
from REGISTRATION r
group by r.STUDENTID;*/


create or replace procedure pro_AddGrade (course_id COURSE.COURSEID%TYPE, off_year OFFERING.YEAR%TYPE, 
off_sem OFFERING.SEMESTER%TYPE, std_id STUDENT.STUDENTID%TYPE, grade REGISTRATION.GRADEASPERCENTAGE%TYPE) as 
loc_id OFFERING.OFFERINGID%TYPE;

CURSOR off_cur (off_cid IN OFFERING.COURSEID%TYPE,off_year IN OFFERING.YEAR%TYPE, off_sem IN OFFERING.SEMESTER%TYPE) is select o.OFFERINGID, o.YEAR, o.SEMESTER
from OFFERING o
where off_cid = o.COURSEID
and off_year = o.YEAR
and off_sem = o.SEMESTER;
off_rec off_cur%ROWTYPE;

CURSOR avg_cur (std_id IN REGISTRATION.STUDENTID%TYPE) is select r.STUDENTID, avg(r.GRADEASPERCENTAGE) as Avg_Grade
from REGISTRATION r
where std_id = r.STUDENTID
group by r.STUDENTID;
avg_rec avg_cur%ROWTYPE;

begin
      dbms_output.put_line('AVGSCORE');
      dbms_output.put_line('--------');
      for avg_rec in avg_cur(std_id) loop
          dbms_output.put_line(trunc(avg_rec.AVG_GRADE,2));  
      end loop;
      dbms_output.new_line;
      for off_rec in off_cur(course_id, off_year, off_sem) loop
        loc_id := off_rec.OFFERINGID;
      end loop;
      
      dbms_output.put_line('SQL>run the procedure');
      dbms_output.new_line;
      insert into Registration(StudentId, OfferingId, GradeAsPercentage) values (std_id, loc_id, grade);
      dbms_output.put_line('AVGSCORE');
      dbms_output.put_line('--------');
      for avg_rec in avg_cur(std_id) loop
        dbms_output.put_line(trunc(avg_rec.AVG_GRADE,2));  
      end loop;
end;

/
begin
pro_AddGrade(1,2010,'Fall',8,92);
end;
