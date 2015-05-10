create table Department(DeptId integer, DeptName char(20), Abbreviation char(5), primary key(deptid));
create table Faculty(FacultyId integer, FacultyName varchar(30), DeptId integer, primary key(FacultyId), foreign key(DeptId) references Department(DeptId));
create table Student(StudentId integer, StudentName varchar(30), DeptId integer, BirthDate date, primary key(StudentId), foreign key (DeptId) references Department(DeptId));
create table Course(CourseId integer, DeptId integer, CourseNum integer, CourseTitle varchar(50), Credits integer, primary key(CourseId), foreign key (DeptId) references Department(DeptId));
create table Offering(OfferingId integer, CourseId integer, FacultyId integer, Year integer, Semester varchar(10), primary key(OfferingId), foreign key (CourseId) references Course(CourseId), foreign key (FacultyId) references Faculty(FacultyId));
create table Registration(StudentId integer, OfferingId integer, GradeAsPercentage number(4,2), primary key(StudentId, OfferingId), foreign key(StudentId) references Student(StudentId), foreign key(OfferingId) references Offering(OfferingId));