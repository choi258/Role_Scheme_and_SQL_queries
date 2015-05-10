select res1.COURSETITLE as CourseTitle, res1.FACULTYNAME as FacultyName from 
(select c.COURSEID, c.COURSETITLE, f.FACULTYNAME, count(o.OFFERINGID) as COUNT_OFFERING
from OFFERING o, COURSE c, FACULTY f
where o.COURSEID = c.COURSEID
and o.FACULTYID = f.FACULTYID
and c.COURSEID = o.COURSEID
group by c.COURSEID, c.COURSETITLE, f.FACULTYNAME) res1,
(select res3.COURSEID, max(COUNT_OFFERING) as max_
from 
(select o.FACULTYID, o.COURSEID, count(o.OFFERINGID) as COUNT_OFFERING
from OFFERING o, COURSE c, DEPARTMENT d
where o.COURSEID = c.COURSEID
and c.DEPTID = d.DEPTID
and (d.DEPTNAME = 'Computer Science' 
or d.DEPTNAME = 'Statistics')
group by o.COURSEID, o.FACULTYID) res3, OFFERING o
where O.COURSEID = res3.COURSEID
group by res3.COURSEID) res2
where res1.COUNT_OFFERING = res2.max_ and res1.COURSEID = res2.COURSEID
order by res1.COURSETITLE;
