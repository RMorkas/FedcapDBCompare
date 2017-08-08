CREATE TABLE [dbo].[ModulePrivilege] (
    [ModulePrivilegeId] INT IDENTITY (1, 1) NOT NULL,
    [ModuleId]          INT NULL,
    [PrivilegeId]       INT NULL,
    CONSTRAINT [PK_ModulePrivilege] PRIMARY KEY CLUSTERED ([ModulePrivilegeId] ASC),
    CONSTRAINT [FK_ModulePrivilege_Module] FOREIGN KEY ([ModuleId]) REFERENCES [dbo].[Module] ([ModuleId]),
    CONSTRAINT [FK_ModulePrivilege_Privilege] FOREIGN KEY ([PrivilegeId]) REFERENCES [dbo].[Privilege] ([PrivilegeId])
);

