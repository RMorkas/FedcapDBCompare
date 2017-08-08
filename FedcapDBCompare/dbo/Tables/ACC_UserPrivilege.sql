CREATE TABLE [dbo].[ACC_UserPrivilege] (
    [UserPrivilegeId]  INT IDENTITY (1, 1) NOT NULL,
    [UserId]           INT NULL,
    [PrivilegeTableId] INT NULL,
    [RecordKeyId]      INT NULL,
    CONSTRAINT [PK_ACC_UserDepartment] PRIMARY KEY CLUSTERED ([UserPrivilegeId] ASC),
    CONSTRAINT [FK_ACC_UserPrivilege_ACC_PrivilegeTable] FOREIGN KEY ([PrivilegeTableId]) REFERENCES [dbo].[ACC_PrivilegeTable] ([Id])
);

