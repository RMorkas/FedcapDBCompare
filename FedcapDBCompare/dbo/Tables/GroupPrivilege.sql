CREATE TABLE [dbo].[GroupPrivilege] (
    [GroupPrivilegeId] INT IDENTITY (1, 1) NOT NULL,
    [GroupId]          INT NULL,
    [ModuleId]         INT NULL,
    [PrivilegeId]      INT NULL,
    CONSTRAINT [PK_GroupPrivilege] PRIMARY KEY CLUSTERED ([GroupPrivilegeId] ASC),
    CONSTRAINT [FK_GroupPrivilege_Group] FOREIGN KEY ([GroupId]) REFERENCES [dbo].[Group] ([GroupId]),
    CONSTRAINT [FK_GroupPrivilege_Module] FOREIGN KEY ([ModuleId]) REFERENCES [dbo].[Module] ([ModuleId]),
    CONSTRAINT [FK_GroupPrivilege_Privilege] FOREIGN KEY ([PrivilegeId]) REFERENCES [dbo].[Privilege] ([PrivilegeId])
);

