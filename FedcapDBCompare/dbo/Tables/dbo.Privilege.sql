CREATE TABLE [dbo].[Privilege] (
    [PrivilegeId]          INT           IDENTITY (1, 1) NOT NULL,
    [PrivilegeName]        VARCHAR (100) NULL,
    [PrivilegeDescription] VARCHAR (100) NULL,
    [IsDev]                BIT           NULL,
    [IsUAT]                BIT           NULL,
    [IsStaging]            BIT           NULL,
    [IsProd]               BIT           NULL,
    CONSTRAINT [PK_Privileges] PRIMARY KEY CLUSTERED ([PrivilegeId] ASC)
);

