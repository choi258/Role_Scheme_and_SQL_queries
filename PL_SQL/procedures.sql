/*
Programmer: SoMi Choi
Email address: choi257@purdue.edu
login-id: choi257
Project2
Date: 2/28/2015
*/

set serveroutput on size 32000

/* #1 pro_AvgGrade */

/*
/*select d.DEPTNAME as DepartmentName, trunc(avg(r.GRADEASPERCENTAGE),2) as AverageGrade
from DEPARTMENT d, COURSE c, REGISTRATION r, OFFERING o
where d.DEPTID = c.DEPTID
and o.OFFERINGID = r.OFFERINGID
and o.COURSEID = c.COURSEID
group by d.DEPTNAME  
order by d.DEPTNAME;*/

/* create the procedure */
create or replace procedure pro_AvgGrade
as
/* declarations */
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
/* actually run the procedure */
begin
    pro_AvgGrade;
end;
/

/* #2 pro_DispAge */

/*select round(months_between(Sysdate,s.BIRTHDATE)/12,0) as Age, count(s.STUDENTID) as num
from STUDENT s
group by round(months_between(Sysdate,s.BIRTHDATE)/12,0)
order by Age;*/

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


/* #3 pro_DispCourse */

/*select c.COURSEID, c.COURSETITLE, replace(d.ABBREVIATION||'-'||c.COURSENUM, ' ') as CourseCode, trunc(avg(r.GRADEASPERCENTAGE),2) as AvgScore, count(distinct r.STUDENTID) as NumOfReg
from REGISTRATION r, OFFERING o, COURSE c, DEPARTMENT d, STUDENT s
where o.OFFERINGID = r.OFFERINGID
and c.COURSEID = o.COURSEID
and d.DEPTID = c.DEPTID
and s.STUDENTID = r.STUDENTID
group by c.COURSEID, c.COURSETITLE,replace(d.ABBREVIATION||'-'||c.COURSENUM, ' ')
order by c.COURSETITLE;*/

/*
select re1.COURSETITLE, re1.COURSEID,  max(occur) as max_occur from (select distinct c.COURSETITLE, o.COURSEID, s.DEPTID, count(distinct s.STUDENTID) as occur
from REGISTRATION r, OFFERING o, STUDENT s, COURSE c
where o.OFFERINGID = r.OFFERINGID
and s.STUDENTID = r.STUDENTID
and c.COURSEID = o.COURSEID
group by c.COURSETITLE, o.COURSEID, s.DEPTID
order by c.COURSETITLE)re1
group by re1.COURSETITLE, re1.COURSEID
order by re1.COURSETITLE;*/

/*
select distinct c.COURSETITLE, o.COURSEID, s.DEPTID, d.ABBREVIATION, count(distinct s.STUDENTID) as occur
from REGISTRATION r, OFFERING o, STUDENT s, DEPARTMENT d, COURSE c
where o.OFFERINGID = r.OFFERINGID
and s.STUDENTID = r.STUDENTID
and s.DEPTID = d.DEPTID
and c.COURSEID = o.COURSEID
group by c.COURSETITLE, o.COURSEID, s.DEPTID, d.ABBREVIATION
order by c.COURSETITLE;*/


create or replace procedure pro_DispCourse as

ab_concat  varchar2(30);
dup_course integer;
max_occur  integer;
dup_num    integer;   /*duplicate numbers */
i          integer;   /* indexing*/
CURSOR crs_cur1 is select c.COURSEID, c.COURSETITLE, replace(d.ABBREVIATION||'-'||c.COURSENUM, ' ') as CourseCode, trunc(avg(r.GRADEASPERCENTAGE),2) as AvgScore, count(distinct r.STUDENTID) as NumOfReg
from REGISTRATION r, OFFERING o, COURSE c, DEPARTMENT d, STUDENT s
where o.OFFERINGID = r.OFFERINGID
and c.COURSEID = o.COURSEID
and d.DEPTID = c.DEPTID
and s.STUDENTID = r.STUDENTID
group by c.COURSEID, c.COURSETITLE,replace(d.ABBREVIATION||'-'||c.COURSENUM, ' ')
order by c.COURSETITLE;
crs_rec1 crs_cur1%ROWTYPE;

CURSOR crs_cur2 is select distinct c.COURSETITLE, o.COURSEID, s.DEPTID, d.ABBREVIATION, count(distinct s.STUDENTID) as occur
from REGISTRATION r, OFFERING o, STUDENT s, DEPARTMENT d, COURSE c
where o.OFFERINGID = r.OFFERINGID
and s.STUDENTID = r.STUDENTID
and s.DEPTID = d.DEPTID
and c.COURSEID = o.COURSEID
group by c.COURSETITLE, o.COURSEID, s.DEPTID, d.ABBREVIATION
order by c.COURSETITLE, d.ABBREVIATION;
crs_rec2 crs_cur2%ROWTYPE;

CURSOR max_cur is select re1.COURSETITLE, re1.COURSEID,  max(occur) as max_occur from (select distinct c.COURSETITLE, o.COURSEID, s.DEPTID, count(distinct s.STUDENTID) as occur
from REGISTRATION r, OFFERING o, STUDENT s, COURSE c
where o.OFFERINGID = r.OFFERINGID
and s.STUDENTID = r.STUDENTID
and c.COURSEID = o.COURSEID
group by c.COURSETITLE, o.COURSEID, s.DEPTID
order by c.COURSETITLE)re1
group by re1.COURSETITLE, re1.COURSEID
order by re1.COURSETITLE;
max_rec max_cur%ROWTYPE;

begin
    i := 0;
    dup_num := 0;
    dbms_output.put_line('CourseName    CourseCode  AvgScore  NumOfReg  DeptWithMostReg');
    dbms_output.put_line('------------   ----------  -------- ---------  ---------------');
  
    
  for max_rec in max_cur loop
            dup_course := max_rec.COURSEID;
            max_occur := max_rec.MAX_OCCUR;
            for crs_rec1 in crs_cur1 loop
                if dup_course = crs_rec1.COURSEID THEN
                    dbms_output.put(lpad(trim(crs_rec1.COURSETITLE),11,' ')||lpad(trim(crs_rec1.COURSECODE),12,' ')||lpad(trim(crs_rec1.AVGSCORE),12,' ')||lpad(trim(crs_rec1.NUMOFREG),9,' '));                   
                end if;
            end loop;
            dup_num := 0;
            ab_concat := '';
            for crs_rec2 in crs_cur2 loop
                if dup_course = crs_rec2.COURSEID THEN
                    if max_occur = crs_rec2.OCCUR THEN
                          dup_num := dup_num + 1;
                          if dup_num = 1 THEN
                              ab_concat:= ab_concat||trim(crs_rec2.ABBREVIATION);
                          else
                              ab_concat:= ab_concat||(trim('/')||trim(crs_rec2.ABBREVIATION));  
                          end if;                      
                    end if;
                end if;
            end loop;
              dbms_output.put(lpad(ab_concat,16,' '));
              dbms_output.new_line;
  end loop;
end;


/
begin
pro_DispCourse;
end;
/

/* #4 pro_SearchStudent */

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
               dbms_output.put(lpad(input_ID,16,' ')||lpad(trim(fmt_rec.STUDENTNAME),24,' ')||lpad(trim(fmt_rec.DEPTNAME),21,' '));
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
      dbms_output.put_line(lpad(tot_credit,7,' ')||lpad(trunc(tot_gpa,2),13,' '));
          
end;

/
begin
pro_SearchStudent;
end;
/

/* #5 pro_SearchFaculty */

/*
select o.FACULTYID, f.FACULTYNAME, r.OFFERINGID, c.COURSETITLE, r.STUDENTID,r.GRADEASPERCENTAGE as Grade
from REGISTRATION r, OFFERING o, COURSE c, FACULTY f
where r.OFFERINGID = o.OFFERINGID
and c.COURSEID = o.COURSEID
and o.FACULTYID = f.FACULTYID
order by o.FACULTYID, o.OFFERINGID;*/
/*
select distinct o.FACULTYID, f.FACULTYNAME, d.DEPTNAME
from FACULTY f, OFFERING o, DEPARTMENT d, REGISTRATION r
where r.OFFERINGID = o.OFFERINGID
and o.FACULTYID = f.FACULTYID
and f.DEPTID = d.DEPTID
order by o.FACULTYID;*/


create or replace procedure pro_SearchFaculty as

input FACULTY.FACULTYNAME%TYPE;
input_id FACULTY.FACULTYID%TYPE;
dup_id integer;
dup_grade integer;
avg_grade  float;
std_count integer;
pass_count integer;
pass_rate  integer;
row_count  integer;
i          integer;

CURSOR fac_cur1 (fac_name IN FACULTY.FACULTYNAME%TYPE) is select o.FACULTYID, f.FACULTYNAME, r.OFFERINGID, c.COURSETITLE, r.STUDENTID,r.GRADEASPERCENTAGE as Grade
from REGISTRATION r, OFFERING o, COURSE c, FACULTY f
where r.OFFERINGID = o.OFFERINGID
and c.COURSEID = o.COURSEID
and o.FACULTYID = f.FACULTYID
and fac_name = f.FACULTYNAME
order by o.FACULTYID, o.OFFERINGID;
fac_rec1 fac_cur1%ROWTYPE;

CURSOR fac_cur2 (fac_name IN FACULTY.FACULTYNAME%TYPE)is select distinct o.FACULTYID, f.FACULTYNAME, d.DEPTNAME
from FACULTY f, OFFERING o, DEPARTMENT d, REGISTRATION r
where r.OFFERINGID = o.OFFERINGID
and o.FACULTYID = f.FACULTYID
and f.DEPTID = d.DEPTID
and fac_name = f.FACULTYNAME
order by o.FACULTYID;
fac_rec2 fac_cur2%ROWTYPE;

begin
      dup_id := 0;
      dup_grade := 0;
      std_count := 0;
      pass_count := 0;
      pass_rate := 0;
      row_count := 0;
      avg_grade := 0.0;
      i := 0;
      
      dbms_output.put('Enter Value for FacultyName: ');
      input := &input;
      dbms_output.put_line(input);
      
      for fac_rec2 in fac_cur2(input) loop
          dbms_output.put_line('FacultyID: '||fac_rec2.FACULTYID);
          dbms_output.put_line('FacultyName: '||fac_rec2.FACULTYNAME);
          dbms_output.put_line('DepartmentName: '||fac_rec2.DEPTNAME);
      end loop;
      dbms_output.put_line('OfferingId    CourseName AverageScore  PassRate');
      dbms_output.put_line('-----------  ----------  ------------  --------');
      
      for fac_rec1 in fac_cur1(input) loop
          row_count := row_count + 1;
      end loop;
      
      for fac_rec1 in fac_cur1(input) loop
          if i = 0 THEN    
              dup_id := fac_rec1.OFFERINGID;
              dup_grade := dup_grade + fac_rec1.GRADE;
              std_count := 1;
              pass_count := 0;
               if fac_rec1.GRADE > 60 THEN
                      pass_count := pass_count + 1;
               end if;
               if row_count = 1 THEN
                  pass_rate := (pass_count / std_count)*100;
                  avg_grade := (dup_grade / std_count);
                  dbms_output.put_line(lpad(dup_id,11,' ')||lpad(trim(fac_rec1.COURSETITLE),22,' ')||lpad(trunc(avg_grade,2),12,' ')||lpad(pass_rate,11,' '));
               end if;
          elsif i < row_count - 1 THEN
              if fac_rec1.OFFERINGID = dup_id THEN
                  std_count := std_count + 1;
                  dup_grade := dup_grade + fac_rec1.GRADE;
                  if fac_rec1.GRADE > 60 THEN
                      pass_count := pass_count + 1;
                  end if;
              else
                  pass_rate := (pass_count / std_count)*100;
                  avg_grade := (dup_grade / std_count);
                  dbms_output.put_line(lpad(dup_id,11,' ')||lpad(trim(fac_rec1.COURSETITLE),22,' ')||lpad(trunc(avg_grade,2),12,' ')||lpad(pass_rate,11,' '));
                  dup_id := fac_rec1.OFFERINGID;
                  dup_grade := fac_rec1.GRADE;
                  std_count := 1;
                  pass_count := 0;
                  pass_rate := 0;
                  if fac_rec1.GRADE > 60 THEN
                      pass_count := pass_count + 1;
                  end if;
              end if;
          else
              if fac_rec1.OFFERINGID = dup_id THEN
                  std_count := std_count + 1; 
                  dup_grade := dup_grade + fac_rec1.GRADE; 
                  if fac_rec1.GRADE > 60 THEN
                      pass_count := pass_count + 1;
                  end if;
                  pass_rate := (pass_count / std_count)*100;  
                  avg_grade := (dup_grade / std_count);
                  dbms_output.put_line(lpad(dup_id,11,' ')||lpad(trim(fac_rec1.COURSETITLE),22,' ')||lpad(trunc(avg_grade,2),12,' ')||lpad(pass_rate,11,' '));
              else
                  pass_rate := (pass_count / std_count)*100;
                  avg_grade := (dup_grade / std_count);
                  dbms_output.put_line(lpad(dup_id,11,' ')||lpad(trim(fac_rec1.COURSETITLE),22,' ')||lpad(trunc(avg_grade,2),12,' ')||lpad(pass_rate,11,' '));
                  std_count := 1;
                  dup_grade := fac_rec1.GRADE;
                  dup_id := fac_rec1.OFFERINGID;
                  pass_count := 0;
                  pass_rate := 0;
                  if fac_rec1.GRADE > 60 THEN
                      pass_count := pass_count + 1;
                  end if;
                  pass_rate := (pass_count / std_count)*100; 
                  avg_grade := (dup_grade / std_count);
                  dbms_output.put_line(lpad(dup_id,11,' ')||lpad(trim(fac_rec1.COURSETITLE),22,' ')||lpad(trunc(avg_grade,2),12,' ')||lpad(pass_rate,11,' '));
              end if;  
          end if;
          i := i + 1;
      end loop;
end;

/
begin
pro_SearchFaculty;
end;
/

/* #6 pro_AddGrade */

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
/
