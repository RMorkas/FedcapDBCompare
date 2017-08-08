CREATE TABLE [dbo].[CaseStatus_Def] (
    [CompanyId]           INT           NULL,
    [IsActive]            BIT           NULL,
    [InternalStatusCode]  VARCHAR (5)   NULL,
    [CaseStatusDefId]     INT           IDENTITY (1, 1) NOT NULL,
    [InternalDescription] VARCHAR (200) NULL,
    CONSTRAINT [PK_CaseStatus_Def] PRIMARY KEY CLUSTERED ([CaseStatusDefId] ASC)
);

