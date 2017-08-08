CREATE TABLE [dbo].[CV_Keyword] (
    [KeywordId] INT          IDENTITY (1, 1) NOT NULL,
    [CompanyId] INT          NULL,
    [GroupId]   INT          NULL,
    [Item]      VARCHAR (80) NULL,
    [SortOrder] INT          NULL,
    [IsActive]  BIT          CONSTRAINT [DF_CV_Keyword_IsActive] DEFAULT ((1)) NULL,
    CONSTRAINT [PK_CV_Keyword] PRIMARY KEY CLUSTERED ([KeywordId] ASC)
);

