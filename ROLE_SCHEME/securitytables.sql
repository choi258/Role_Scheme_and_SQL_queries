create table Users(UserId integer, UserName Varchar(30), Password Varchar(30));
create table Roles(RoleId integer, RoleName Varchar(30), EncryptionKey Varchar(30));
create table UserRoles(UserId integer, RoleId integer);
create table Privileges(PrivId integer, PrivName Varchar(30));
create table RolePrivileges(RoleId integer, TableName Varchar(30), PrivId integer);
insert into Privileges(PrivId, PrivName) values (1, 'SELECT');
insert into Privileges(PrivId, PrivName) values (2, 'INSERT');
