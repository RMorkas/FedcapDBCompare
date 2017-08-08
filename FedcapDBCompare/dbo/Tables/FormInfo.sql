CREATE TABLE [dbo].[FormInfo] (
    [FormId]        INT          IDENTITY (1, 1) NOT NULL,
    [CompanyId]     INT          NULL,
    [FormName]      VARCHAR (60) NOT NULL,
    [Description]   VARCHAR (80) NULL,
    [IsProcessForm] BIT          CONSTRAINT [DF_FormInfo_IsProcessForm] DEFAULT ((0)) NOT NULL,
    [ModuleId]      INT          NULL,
    CONSTRAINT [PK_FormInfo] PRIMARY KEY CLUSTERED ([FormId] ASC),
    CONSTRAINT [FK_FormInfo_Module] FOREIGN KEY ([ModuleId]) REFERENCES [dbo].[Module] ([ModuleId])
);

