select f.FACULTYNAME as FacultyName, d.DEPTNAME as FacultyDepartmentName
from COURSE c, DEPARTMENT d, FACULTY f, OFFERING o
where f.DEPTID = d.DEPTID 
and c.DEPTID <> f.DEPTID 
and c.COURSEID = o.COURSEID 
and o.FACULTYID = f.FACULTYID 
order by f.FACULTYNAME;