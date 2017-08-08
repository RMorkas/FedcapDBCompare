CREATE TABLE [dbo].[Enumes] (
    [EnumId]    INT           NOT NULL,
    [CompanyId] INT           NULL,
    [GroupId]   INT           NULL,
    [Item]      VARCHAR (100) NULL,
    [SortOrder] INT           NULL,
    [IsActive]  BIT           NULL,
    CONSTRAINT [PK_Enums] PRIMARY KEY CLUSTERED ([EnumId] ASC)
);

