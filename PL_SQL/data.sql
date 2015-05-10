insert into Department(DeptId, DeptName, Abbreviation) values (1, 'Computer Science', 'CS');
insert into Department(DeptId, DeptName, Abbreviation) values (2, 'Statistics', 'STAT');
insert into Department(DeptId, DeptName, Abbreviation) values (3, 'NewDept', 'ND');
--Note: NewDept is a new department that does not have any affiliated faculty, however, it offers courses taught by CS and Stats faculties
--Faculties
insert into Faculty(FacultyId, FacultyName, DeptId) values (1, 'CSFaculty1', 1);
insert into Faculty(FacultyId, FacultyName, DeptId) values (2, 'CSFaculty2', 1);
insert into Faculty(FacultyId, FacultyName, DeptId) values (3, 'CSFaculty3', 1);
insert into Faculty(FacultyId, FacultyName, DeptId) values (4, 'StatsFaculty1', 2);
insert into Faculty(FacultyId, FacultyName, DeptId) values (5, 'StatsFaculty2', 2);
--Students
insert into Student(StudentId, StudentName, DeptId, BirthDate) values (1, 'CSStudent1', 1, to_date('19900101','YYYYMMDD'));
insert into Student(StudentId, StudentName, DeptId, BirthDate) values (2, 'CSStudent2', 1, to_date('19910101','YYYYMMDD'));
insert into Student(StudentId, StudentName, DeptId, BirthDate) values (3, 'CSStudent3', 1, to_date('19910101','YYYYMMDD'));
insert into Student(StudentId, StudentName, DeptId, BirthDate) values (4, 'CSStudent4', 1, to_date('19920101','YYYYMMDD'));
insert into Student(StudentId, StudentName, DeptId, BirthDate) values (5, 'StatsStudent1', 2, to_date('19910101','YYYYMMDD'));
insert into Student(StudentId, StudentName, DeptId, BirthDate) values (6, 'StatsStudent2', 2, to_date('19930101','YYYYMMDD'));
insert into Student(StudentId, StudentName, DeptId, BirthDate) values (7, 'StatsStudent3', 2, to_date('19940101','YYYYMMDD'));
insert into Student(StudentId, StudentName, DeptId, BirthDate) values (8, 'NDStudent1', 3, to_date('19940101','YYYYMMDD'));
insert into Student(StudentId, StudentName, DeptId, BirthDate) values (9, 'NDStudent2', 3, to_date('19930101','YYYYMMDD'));
--Courses
insert into Course(CourseId, DeptId, CourseNum, CourseTitle, Credits) values (1, 1, 123, 'CSCourse1', 3);
insert into Course(CourseId, DeptId, CourseNum, CourseTitle, Credits) values (2, 1, 124, 'CSCourse2', 3);
insert into Course(CourseId, DeptId, CourseNum, CourseTitle, Credits) values (3, 1, 125, 'CSCourse3', 3);
insert into Course(CourseId, DeptId, CourseNum, CourseTitle, Credits) values (4, 1, 126, 'CSCourse4', 1);
insert into Course(CourseId, DeptId, CourseNum, CourseTitle, Credits) values (5, 2, 234, 'StatsCourse1', 3);
insert into Course(CourseId, DeptId, CourseNum, CourseTitle, Credits) values (6, 2, 235, 'StatsCourse2', 3);
insert into Course(CourseId, DeptId, CourseNum, CourseTitle, Credits) values (7, 2, 236, 'StatsCourse3', 3);
insert into Course(CourseId, DeptId, CourseNum, CourseTitle, Credits) values (8, 3, 345, 'NDCourse1', 3);
insert into Course(CourseId, DeptId, CourseNum, CourseTitle, Credits) values (9, 3, 346, 'NDCourse2', 3);
--Offerings
insert into Offering(OfferingId, CourseId, FacultyId, Year, Semester) values (1, 1, 1, 2010, 'Fall');
insert into Offering(OfferingId, CourseId, FacultyId, Year, Semester) values (2, 1, 1, 2011, 'Spring');
insert into Offering(OfferingId, CourseId, FacultyId, Year, Semester) values (3, 1, 1, 2011, 'Fall');
insert into Offering(OfferingId, CourseId, FacultyId, Year, Semester) values (4, 1, 1, 2012, 'Spring');
insert into Offering(OfferingId, CourseId, FacultyId, Year, Semester) values (5, 1, 2, 2013, 'Fall');
insert into Offering(OfferingId, CourseId, FacultyId, Year, Semester) values (6, 8, 2, 2010, 'Fall');
insert into Offering(OfferingId, CourseId, FacultyId, Year, Semester) values (7, 5, 4, 2011, 'Spring');
insert into Offering(OfferingId, CourseId, FacultyId, Year, Semester) values (8, 5, 4, 2012, 'Spring');
insert into Offering(OfferingId, CourseId, FacultyId, Year, Semester) values (9, 9, 4, 2014, 'Fall');
--Registration
insert into Registration(StudentId, OfferingId, GradeAsPercentage) values (1, 1, 59);
insert into Registration(StudentId, OfferingId, GradeAsPercentage) values (1, 2, 70);
insert into Registration(StudentId, OfferingId, GradeAsPercentage) values (1, 9, 80);
insert into Registration(StudentId, OfferingId, GradeAsPercentage) values (8, 8, 90);
insert into Registration(StudentId, OfferingId, GradeAsPercentage) values (5, 9, 75);
insert into Registration(StudentId, OfferingId, GradeAsPercentage) values (5, 3, 84);

