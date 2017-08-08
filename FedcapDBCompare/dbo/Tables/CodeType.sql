CREATE TABLE [dbo].[CodeType] (
    [TypeID]    INT           IDENTITY (1, 1) NOT NULL,
    [CodeType]  VARCHAR (250) NULL,
    [IsActive]  BIT           NULL,
    [FileName]  VARCHAR (100) NULL,
    [CompanyId] INT           NULL,
    CONSTRAINT [pk_TypeID] PRIMARY KEY CLUSTERED ([TypeID] ASC)
);

