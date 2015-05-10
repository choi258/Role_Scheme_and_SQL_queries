select distinct s.STUDENTNAME as StudentName, round(months_between(Sysdate,s.BIRTHDATE)/12,0) as Age, count(o.OFFERINGID) as NumOfOfferings
from STUDENT s left outer join REGISTRATION r
on s.STUDENTID = r.STUDENTID left outer join OFFERING o
on o.OFFERINGID = r.OFFERINGID, DEPARTMENT d
where s.DEPTID = d.DEPTID and d.DEPTNAME = 'Computer Science'
group by s.STUDENTNAME, round(months_between(Sysdate,s.BIRTHDATE)/12,0)
order by s.STUDENTNAME;