CREATE TABLE [dbo].[Enumes] (
    [EnumId]    INT           IDENTITY (1, 1) NOT NULL,
    [CompanyId] INT           NULL,
    [GroupId]   INT           NULL,
    [Item]      VARCHAR (100) NULL,
    [SortOrder] INT           NULL,
    [IsActive]  BIT           NULL,
    [IsDev]     BIT           NULL,
    [IsUAT]     BIT           NULL,
    [IsStaging] BIT           NULL,
    [IsProd]    BIT           NULL,
    CONSTRAINT [PK_Enumes] PRIMARY KEY CLUSTERED ([EnumId] ASC)
);

