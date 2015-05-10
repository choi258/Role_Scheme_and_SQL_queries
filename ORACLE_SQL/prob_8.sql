select a2.COURSETITLE as CourseTitle, a2.DEPTNAME as CourseDepartment, replace(a2.ABBREVIATION||'-'||a2.COURSENUM, ' ') as CourseCode , a2.FACULTYNAME as FacultyName, d.DEPTNAME as FacultyDepartment
from (select distinct c.COURSETITLE, d.DEPTNAME, d.ABBREVIATION, c.COURSENUM, f.FACULTYNAME, f.DEPTID 
from(select COURSEID, FACULTYID, OFFERINGID
from OFFERING
where YEAR = 2010 and SEMESTER = 'Fall') a1, COURSE c, DEPARTMENT d, FACULTY f
where a1.COURSEID = c.COURSEID
and c.DEPTID = d.DEPTID
and a1.COURSEID = c.COURSEID
and a1.FACULTYID = f.FACULTYID) a2, DEPARTMENT d
where a2.DEPTID = d.DEPTID;