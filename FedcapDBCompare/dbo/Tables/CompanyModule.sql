CREATE TABLE [dbo].[CompanyModule] (
    [CompanyModulePkId] INT IDENTITY (1, 1) NOT NULL,
    [CompanyId]         INT NULL,
    [ModuleId]          INT NULL,
    CONSTRAINT [PK_CompanyModule] PRIMARY KEY CLUSTERED ([CompanyModulePkId] ASC),
    CONSTRAINT [FK_CompanyModule_Company] FOREIGN KEY ([CompanyId]) REFERENCES [dbo].[Company] ([CompanyId]),
    CONSTRAINT [FK_CompanyModule_Module] FOREIGN KEY ([ModuleId]) REFERENCES [dbo].[Module] ([ModuleId])
);

