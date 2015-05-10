select re.COURSETITLE as CourseTitle, sum(case when COURSE_COUNT <> 0 then 1 else 0 end) as FailedCount from 
(select distinct c.COURSETITLE, count(o.OFFERINGID) as COURSE_COUNT
from COURSE c left outer join OFFERING o 
on c.COURSEID = o.COURSEID, DEPARTMENT d,REGISTRATION r
where r.GRADEASPERCENTAGE < 60
and d.DEPTNAME = 'Computer Science'
and c.DEPTID = d.DEPTID
group by c.COURSETITLE) re
group by re.COURSETITLE
order by re.COURSETITLE;