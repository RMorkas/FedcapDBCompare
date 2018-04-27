CREATE TABLE [dbo].[FormVersion] (
    [FormVersionId] INT           IDENTITY (1, 1) NOT NULL,
    [CompanyId]     INT           NULL,
    [FormId]        INT           NOT NULL,
    [StartDate]     SMALLDATETIME NOT NULL,
    [EndDate]       SMALLDATETIME NULL,
    [ObjectName]    VARCHAR (80)  NULL,
    [ReportName]    VARCHAR (80)  NULL,
    [IsDev]         BIT           NULL,
    [IsUAT]         BIT           NULL,
    [IsStaging]     BIT           NULL,
    [IsProd]        BIT           NULL,
    CONSTRAINT [PK_FormVersion] PRIMARY KEY CLUSTERED ([FormVersionId] ASC),
    CONSTRAINT [FK_FormVersion_FormInfo] FOREIGN KEY ([FormId]) REFERENCES [dbo].[FormInfo] ([FormId])
);

