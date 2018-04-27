CREATE TABLE [dbo].[Module] (
    [ModuleId]          INT           IDENTITY (1, 1) NOT NULL,
    [ModuleName]        VARCHAR (100) NULL,
    [ModuleDescription] VARCHAR (200) NULL,
    [IsLeaf]            BIT           NULL,
    [IsDev]             BIT           NULL,
    [IsUAT]             BIT           NULL,
    [IsStaging]         BIT           NULL,
    [IsProd]            BIT           NULL,
    CONSTRAINT [PK_Modules] PRIMARY KEY CLUSTERED ([ModuleId] ASC)
);

