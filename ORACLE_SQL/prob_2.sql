select s.STUDENTNAME as StudentName, count(o.COURSEID) as NumOfCourses
from STUDENT s left outer join REGISTRATION r
on s.STUDENTID = r.STUDENTID left outer join OFFERING o
on r.OFFERINGID = o.OFFERINGID
where s.BIRTHDATE >= all(select BIRTHDATE from STUDENT)
group by s.STUDENTNAME
order by count(o.COURSEID) asc;