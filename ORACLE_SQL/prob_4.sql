select s.STUDENTNAME as StudentName, count(r.OFFERINGID) as NumOfCourses
from REGISTRATION r inner join OFFERING o
on o.SEMESTER = 'Fall'
and o.YEAR = '2014'
and r.OFFERINGID = o.OFFERINGID
inner join REGISTRATION r2
on r2.STUDENTID = r.STUDENTID, STUDENT s
where r.STUDENTID = s.STUDENTID
group by s.STUDENTNAME
order by s.STUDENTNAME;
