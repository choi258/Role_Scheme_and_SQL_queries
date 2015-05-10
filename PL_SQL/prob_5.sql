/*
select o.FACULTYID, f.FACULTYNAME, r.OFFERINGID, c.COURSETITLE, r.STUDENTID,r.GRADEASPERCENTAGE as Grade
from REGISTRATION r, OFFERING o, COURSE c, FACULTY f
where r.OFFERINGID = o.OFFERINGID
and c.COURSEID = o.COURSEID
and o.FACULTYID = f.FACULTYID
order by o.FACULTYID, o.OFFERINGID;*/
/*
select distinct o.FACULTYID, f.FACULTYNAME, d.DEPTNAME
from FACULTY f, OFFERING o, DEPARTMENT d, REGISTRATION r
where r.OFFERINGID = o.OFFERINGID
and o.FACULTYID = f.FACULTYID
and f.DEPTID = d.DEPTID
order by o.FACULTYID;*/

create or replace procedure pro_SearchFaculty as

input FACULTY.FACULTYNAME%TYPE;
input_id FACULTY.FACULTYID%TYPE;
dup_id integer;
dup_grade integer;
avg_grade  float;
std_count integer;
pass_count integer;
pass_rate  integer;
row_count  integer;
i          integer;

CURSOR fac_cur1 (fac_name IN FACULTY.FACULTYNAME%TYPE) is select o.FACULTYID, f.FACULTYNAME, r.OFFERINGID, c.COURSETITLE, r.STUDENTID,r.GRADEASPERCENTAGE as Grade
from REGISTRATION r, OFFERING o, COURSE c, FACULTY f
where r.OFFERINGID = o.OFFERINGID
and c.COURSEID = o.COURSEID
and o.FACULTYID = f.FACULTYID
and fac_name = f.FACULTYNAME
order by o.FACULTYID, o.OFFERINGID;
fac_rec1 fac_cur1%ROWTYPE;

CURSOR fac_cur2 (fac_name IN FACULTY.FACULTYNAME%TYPE)is select distinct o.FACULTYID, f.FACULTYNAME, d.DEPTNAME
from FACULTY f, OFFERING o, DEPARTMENT d, REGISTRATION r
where r.OFFERINGID = o.OFFERINGID
and o.FACULTYID = f.FACULTYID
and f.DEPTID = d.DEPTID
and fac_name = f.FACULTYNAME
order by o.FACULTYID;
fac_rec2 fac_cur2%ROWTYPE;

begin
      dup_id := 0;
      dup_grade := 0;
      std_count := 0;
      pass_count := 0;
      pass_rate := 0;
      row_count := 0;
      avg_grade := 0.0;
      i := 0;
      
      dbms_output.put('Enter Value for FacultyName: ');
      input := &input;
      dbms_output.put_line(input);
      
      for fac_rec2 in fac_cur2(input) loop
          dbms_output.put_line('FacultyID: '||fac_rec2.FACULTYID);
          dbms_output.put_line('FacultyName: '||fac_rec2.FACULTYNAME);
          dbms_output.put_line('DepartmentName: '||fac_rec2.DEPTNAME);
      end loop;
      dbms_output.put_line('OfferingId    CourseName AverageScore  PassRate');
      dbms_output.put_line('-----------  ----------  ------------  --------');
      
      for fac_rec1 in fac_cur1(input) loop
          row_count := row_count + 1;
      end loop;
      
      for fac_rec1 in fac_cur1(input) loop
          if i = 0 THEN    
              dup_id := fac_rec1.OFFERINGID;
              dup_grade := dup_grade + fac_rec1.GRADE;
              std_count := 1;
              pass_count := 0;
               if fac_rec1.GRADE > 60 THEN
                      pass_count := pass_count + 1;
               end if;
               if row_count = 1 THEN
                  pass_rate := (pass_count / std_count)*100;
                  avg_grade := (dup_grade / std_count);
                  dbms_output.put_line(lpad(dup_id,11,' ')||lpad(trim(fac_rec1.COURSETITLE),12,' ')||lpad(trunc(avg_grade,2),12,' ')||lpad(pass_rate,11,' '));
               end if;
          elsif i < row_count - 1 THEN
              if fac_rec1.OFFERINGID = dup_id THEN
                  std_count := std_count + 1;
                  dup_grade := dup_grade + fac_rec1.GRADE;
                  if fac_rec1.GRADE > 60 THEN
                      pass_count := pass_count + 1;
                  end if;
              else
                  pass_rate := (pass_count / std_count)*100;
                  avg_grade := (dup_grade / std_count);
                  dbms_output.put_line(lpad(dup_id,11,' ')||lpad(trim(fac_rec1.COURSETITLE),12,' ')||lpad(trunc(avg_grade,2),12,' ')||lpad(pass_rate,11,' '));
                  dup_id := fac_rec1.OFFERINGID;
                  dup_grade := fac_rec1.GRADE;
                  std_count := 1;
                  pass_count := 0;
                  pass_rate := 0;
                  if fac_rec1.GRADE > 60 THEN
                      pass_count := pass_count + 1;
                  end if;
              end if;
          else
              if fac_rec1.OFFERINGID = dup_id THEN
                  std_count := std_count + 1; 
                  dup_grade := dup_grade + fac_rec1.GRADE; 
                  if fac_rec1.GRADE > 60 THEN
                      pass_count := pass_count + 1;
                  end if;
                  pass_rate := (pass_count / std_count)*100;  
                  avg_grade := (dup_grade / std_count);
                  dbms_output.put_line(lpad(dup_id,11,' ')||lpad(trim(fac_rec1.COURSETITLE),12,' ')||lpad(trunc(avg_grade,2),12,' ')||lpad(pass_rate,11,' '));
              else
                  pass_rate := (pass_count / std_count)*100;
                  avg_grade := (dup_grade / std_count);
                  dbms_output.put_line(lpad(dup_id,11,' ')||lpad(trim(fac_rec1.COURSETITLE),12,' ')||lpad(trunc(avg_grade,2),12,' ')||lpad(pass_rate,11,' '));
                  std_count := 1;
                  dup_grade := fac_rec1.GRADE;
                  dup_id := fac_rec1.OFFERINGID;
                  pass_count := 0;
                  pass_rate := 0;
                  if fac_rec1.GRADE > 60 THEN
                      pass_count := pass_count + 1;
                  end if;
                  pass_rate := (pass_count / std_count)*100; 
                  avg_grade := (dup_grade / std_count);
                  dbms_output.put_line(lpad(dup_id,11,' ')||lpad(trim(fac_rec1.COURSETITLE),12,' ')||lpad(trunc(avg_grade,2),12,' ')||lpad(pass_rate,11,' '));
              end if;  
          end if;
          i := i + 1;
      end loop;
end;

/
begin
pro_SearchFaculty;
end;
/
