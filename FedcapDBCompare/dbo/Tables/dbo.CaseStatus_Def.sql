CREATE TABLE [dbo].[CaseStatus_Def] (
    [CompanyId]           INT           IDENTITY (1, 1) NOT NULL,
    [IsActive]            BIT           NULL,
    [InternalStatusCode]  VARCHAR (5)   NULL,
    [CaseStatusDefId]     INT           NOT NULL,
    [InternalDescription] VARCHAR (200) NULL,
    [IsDev]               BIT           NULL,
    [IsUAT]               BIT           NULL,
    [IsStaging]           BIT           NULL,
    [IsProd]              BIT           NULL,
    CONSTRAINT [PK_CaseStatus_Def] PRIMARY KEY CLUSTERED ([CaseStatusDefId] ASC)
);

