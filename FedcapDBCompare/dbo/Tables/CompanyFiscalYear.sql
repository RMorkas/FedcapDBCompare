CREATE TABLE [dbo].[CompanyFiscalYear] (
    [CompanyFiscalYearId] INT           NOT NULL,
    [CompanyId]           INT           NOT NULL,
    [StartDate]           SMALLDATETIME NULL,
    [EndDate]             SMALLDATETIME NULL,
    CONSTRAINT [PK_CompanyFiscalYear] PRIMARY KEY CLUSTERED ([CompanyFiscalYearId] ASC),
    CONSTRAINT [FK_CompanyFiscalYear_Company] FOREIGN KEY ([CompanyId]) REFERENCES [dbo].[Company] ([CompanyId])
);

