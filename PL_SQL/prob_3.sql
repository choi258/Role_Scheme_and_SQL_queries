/*select c.COURSEID, c.COURSETITLE, replace(d.ABBREVIATION||'-'||c.COURSENUM, ' ') as CourseCode, trunc(avg(r.GRADEASPERCENTAGE),2) as AvgScore, count(distinct r.STUDENTID) as NumOfReg
from REGISTRATION r, OFFERING o, COURSE c, DEPARTMENT d, STUDENT s
where o.OFFERINGID = r.OFFERINGID
and c.COURSEID = o.COURSEID
and d.DEPTID = c.DEPTID
and s.STUDENTID = r.STUDENTID
group by c.COURSEID, c.COURSETITLE,replace(d.ABBREVIATION||'-'||c.COURSENUM, ' ')
order by c.COURSETITLE;
*/

/*
select re1.COURSETITLE, re1.COURSEID,  max(occur) as max_occur from (select distinct c.COURSETITLE, o.COURSEID, s.DEPTID, count(distinct s.STUDENTID) as occur
from REGISTRATION r, OFFERING o, STUDENT s, COURSE c
where o.OFFERINGID = r.OFFERINGID
and s.STUDENTID = r.STUDENTID
and c.COURSEID = o.COURSEID
group by c.COURSETITLE, o.COURSEID, s.DEPTID
order by c.COURSETITLE)re1
group by re1.COURSETITLE, re1.COURSEID
order by re1.COURSETITLE;

select distinct c.COURSETITLE, o.COURSEID, s.DEPTID, d.ABBREVIATION, count(distinct s.STUDENTID) as occur
from REGISTRATION r, OFFERING o, STUDENT s, DEPARTMENT d, COURSE c
where o.OFFERINGID = r.OFFERINGID
and s.STUDENTID = r.STUDENTID
and s.DEPTID = d.DEPTID
and c.COURSEID = o.COURSEID
group by c.COURSETITLE, o.COURSEID, s.DEPTID, d.ABBREVIATION
order by c.COURSETITLE;

*/

set serveroutput on size 32000
create or replace procedure pro_DispCourse as

ab_concat  varchar2(30);
dup_course integer;
max_occur  integer;
dup_num    integer;
i          integer;
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
                    dbms_output.put(lpad(crs_rec1.COURSETITLE,12,' ')||lpad(crs_rec1.COURSECODE,13,' ')||lpad(crs_rec1.AVGSCORE,10,' ')||lpad(crs_rec1.NUMOFREG,9,' '));                   
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