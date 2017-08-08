CREATE TABLE [dbo].[EmployerLocationContacts] (
    [EmpLocatContactId] INT           IDENTITY (1, 1) NOT NULL,
    [EmployerId]        INT           NULL,
    [EmpLocationId]     INT           NULL,
    [FirstName]         VARCHAR (50)  NULL,
    [MiddleName]        VARCHAR (50)  NULL,
    [LastName]          VARCHAR (50)  NULL,
    [HomePhone]         VARCHAR (50)  NULL,
    [CellPhone]         VARCHAR (50)  NULL,
    [Fax]               VARCHAR (50)  NULL,
    [Email]             VARCHAR (100) NULL,
    [JobTitle]          VARCHAR (100) NULL,
    [IsActive]          BIT           CONSTRAINT [DF_EmployerLocationContacts_IsDeleted] DEFAULT ((1)) NULL,
    [CreatedBy]         VARCHAR (80)  NULL,
    [CreatedAt]         DATETIME      NULL,
    [UpdatedBy]         VARCHAR (80)  NULL,
    [UpdatedAt]         DATETIME      NULL,
    CONSTRAINT [PK_EmployerLocationContacts] PRIMARY KEY CLUSTERED ([EmpLocatContactId] ASC),
    CONSTRAINT [FK_EmployerLocationContacts_EmployerLocation] FOREIGN KEY ([EmpLocationId]) REFERENCES [dbo].[EmployerLocation] ([EmpLocationId])
);

