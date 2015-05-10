insert into Roles(RoleId, RoleName, EncryptionKey) values (1, 'ADMIN', 'B');
insert into Users(UserId, UserName, Password) values (1, 'admin', 'pass');
insert into UserRoles(UserId, RoleId) values (1, 1);
