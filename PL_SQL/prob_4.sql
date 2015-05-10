/*select s.STUDENTID, s.STUDENTNAME, d.DEPTNAME, c.CREDITS, c.COURSEID, o.YEAR, o.SEMESTER, r.GRADEASPERCENTAGE
from STUDENT s, REGISTRATION r, COURSE c, OFFERING o, DEPARTMENT d
where r.OFFERINGID = o.OFFERINGID
and r.STUDENTID = s.STUDENTID
and o.COURSEID = c.COURSEID
and s.DEPTID = d.DEPTID
order by s.STUDENTID, c.COURSEID, o.YEAR desc, o.SEMESTER;

select distinct s.STUDENTID, s.STUDENTNAME, d.DEPTNAME
from STUDENT s, REGISTRATION r, COURSE c, OFFERING o, DEPARTMENT d
where r.OFFERINGID = o.OFFERINGID
and r.STUDENTID = s.STUDENTID
and o.COURSEID = c.COURSEID
and s.DEPTID = d.DEPTID
order by s.STUDENTID;*/

set serveroutput on size 32000

create or replace procedure pro_SearchStudent  as
dup_course integer;
row_count  integer;
dup_num    integer;
dup_credit integer;
tot_credit integer;
tot_grade  integer;
tot_gpa    float;
dup_grade  REGISTRATION.GRADEASPERCENTAGE%TYPE;
dup_year   integer;
dup_sem    OFFERING.SEMESTER%TYPE;
i          integer;
input_ID STUDENT.STUDENTID%TYPE;
input    varchar(10);
CURSOR std_cur (std_id IN STUDENT.STUDENTID%TYPE) is select s.STUDENTID, s.STUDENTNAME, d.DEPTNAME, c.CREDITS, c.COURSEID, o.YEAR, o.SEMESTER, r.GRADEASPERCENTAGE as GRADE
from STUDENT s, REGISTRATION r, COURSE c, OFFERING o, DEPARTMENT d
where r.OFFERINGID = o.OFFERINGID
and r.STUDENTID = s.STUDENTID
and o.COURSEID = c.COURSEID
and s.DEPTID = d.DEPTID
and std_id = s.STUDENTID
order by s.STUDENTID, c.COURSEID, o.YEAR desc;
std_rec std_cur%ROWTYPE;

CURSOR fmt_cur (std_id IN STUDENT.STUDENTID%TYPE) is select distinct s.STUDENTID, s.STUDENTNAME, d.DEPTNAME
from STUDENT s, REGISTRATION r, COURSE c, OFFERING o, DEPARTMENT d
where r.OFFERINGID = o.OFFERINGID
and r.STUDENTID = s.STUDENTID
and o.COURSEID = c.COURSEID
and s.DEPTID = d.DEPTID
and std_id = s.STUDENTID
order by s.STUDENTID;
fmt_rec fmt_cur%ROWTYPE;

begin
      dup_course := 0;
      dup_num := 0;
      tot_credit := 0;
      tot_grade := 0;
      i := 0;
      row_count := 0;
      /*formatting*/
      dbms_output.put('Enter Value for StudentID: ');
      input := &input;  
      input_ID := to_number(input);
      dbms_output.put(input_ID);
      dbms_output.new_line;
      dbms_output.put_line('StudentID      StudentName   Department       Credits   AverageGrade');
      dbms_output.put_line('-----------    -----------   ---------------- --------  ------------');
      for fmt_rec in fmt_cur(input_ID) loop 
               dbms_output.put(lpad(trim(input_ID),11,' ')||lpad(trim(fmt_rec.STUDENTNAME),16,' ')||lpad(trim(fmt_rec.DEPTNAME),18,' '));
      end loop;
    
      for std_rec in std_cur(input_ID) loop 
               row_count := row_count + 1;
      end loop;
      
      
        for std_rec in std_cur(input_ID) loop 
               if i = 0 THEN
                  dup_course := std_rec.COURSEID;
                  dup_grade := std_rec.GRADE;
                  dup_credit := std_rec.CREDITS;
                  if row_count = 1 THEN
                     tot_credit := tot_credit + dup_credit;
                     tot_grade := tot_grade + dup_grade * dup_credit;
                  end if;
               elsif i < row_count-1 THEN
                    if std_rec.COURSEID = dup_course THEN
                          dup_num := dup_num + 1;
                    else
                           tot_credit := tot_credit + dup_credit;
                           tot_grade := tot_grade + dup_grade * dup_credit;
                           /* change*/
                           dup_course := std_rec.COURSEID;
                           dup_grade := std_rec.GRADE;
                           dup_credit := std_rec.CREDITS;
                           dup_num := 0;
                    end if;
               else
                    if std_rec.COURSEID = dup_course THEN
                          dup_num := dup_num + 1;
                          /*testing*/ 
                          tot_credit := tot_credit + dup_credit;
                          tot_grade := tot_grade + dup_grade * dup_credit;
                    else
                          tot_credit := tot_credit + dup_credit;
                          tot_grade := tot_grade + dup_grade * dup_credit;
                          /*change*/
                          dup_course := std_rec.COURSEID;
                          dup_grade := std_rec.GRADE;
                          dup_credit := std_rec.CREDITS;
                          
                          tot_credit := tot_credit + dup_credit;
                          tot_grade := tot_grade + dup_grade * dup_credit;
                          dup_num := 0;
                    end if;
               end if;
               i := i + 1;
      end loop;
      tot_gpa := (tot_grade/tot_credit);      
      dbms_output.put_line(lpad(tot_credit,8,' ')||lpad(trunc(tot_gpa,2),14,' '));
          
end;

/
begin
pro_SearchStudent;
end;

