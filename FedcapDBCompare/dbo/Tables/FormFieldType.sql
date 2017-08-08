CREATE TABLE [dbo].[FormFieldType] (
    [FieldTypeId] INT          IDENTITY (1, 1) NOT NULL,
    [TypeName]    VARCHAR (50) NOT NULL,
    CONSTRAINT [PK_FormFieldType] PRIMARY KEY CLUSTERED ([FieldTypeId] ASC)
);

