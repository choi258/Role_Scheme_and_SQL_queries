select distinct d.DEPTNAME as DepartmentName, count(distinct f.FACULTYNAME) as NumOfFaculties, count(distinct c.COURSETITLE) as NumOfCourses
from DEPARTMENT d inner join COURSE C
on c.DEPTID = d.DEPTID left outer join FACULTY f
on d.DEPTID = f.DEPTID 
group by d.DEPTNAME
order by NumOfFaculties desc;