CREATE TABLE [dbo].[External_CaseStatus_Def] (
    [StatusCode]      VARCHAR (20)  NULL,
    [Description]     VARCHAR (200) NULL,
    [IsActive]        BIT           NULL,
    [CaseStatusDefId] INT           NULL
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'References CaseStatus_Def, if planning to use please consult team as currently only for referential purposes', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'External_CaseStatus_Def', @level2type = N'COLUMN', @level2name = N'CaseStatusDefId';

