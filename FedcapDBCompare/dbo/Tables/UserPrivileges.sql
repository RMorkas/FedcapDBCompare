CREATE TABLE [dbo].[UserPrivileges] (
    [UserPrivilegeId]  INT IDENTITY (1, 1) NOT NULL,
    [ModuleId]         INT NULL,
    [PrivilegeId]      INT NULL,
    [UserId]           INT NULL,
    [DisablePrivilege] BIT CONSTRAINT [DF_UserPrivileges_DisablePrivilege] DEFAULT ((0)) NULL,
    CONSTRAINT [PK_UserPrivileges] PRIMARY KEY CLUSTERED ([UserPrivilegeId] ASC)
);

