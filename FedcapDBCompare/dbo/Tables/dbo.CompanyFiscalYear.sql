CREATE TABLE [dbo].[CompanyFiscalYear] (
    [CompanyFiscalYearId] INT           IDENTITY (1, 1) NOT NULL,
    [CompanyId]           INT           NOT NULL,
    [StartDate]           SMALLDATETIME NULL,
    [EndDate]             SMALLDATETIME NULL,
    [IsDev]               BIT           NULL,
    [IsUAT]               BIT           NULL,
    [IsStaging]           BIT           NULL,
    [IsProd]              BIT           NULL,
    CONSTRAINT [PK_CompanyFiscalYear] PRIMARY KEY CLUSTERED ([CompanyFiscalYearId] ASC)
);

