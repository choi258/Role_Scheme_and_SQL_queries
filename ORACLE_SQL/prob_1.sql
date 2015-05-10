select distinct d.DEPTNAME as DepartmentName, trunc(avg(r.GRADEASPERCENTAGE),2) as AverageGrade
from DEPARTMENT d, STUDENT s, REGISTRATION r
where d.DEPTID = s.DEPTID and s.STUDENTID = r.STUDENTID and r.GRADEASPERCENTAGE > 60
group by d.DEPTNAME
order by AverageGrade desc;