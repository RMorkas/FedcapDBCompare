CREATE TABLE [dbo].[Group] (
    [GroupId]   INT          IDENTITY (1, 1) NOT NULL,
    [CompanyId] INT          NULL,
    [GroupName] VARCHAR (60) NULL,
    [IsDefault] BIT          NULL,
    CONSTRAINT [PK_Group] PRIMARY KEY CLUSTERED ([GroupId] ASC)
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'To Determine which group is Default for every Comany and must be only one', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Group', @level2type = N'COLUMN', @level2name = N'IsDefault';

