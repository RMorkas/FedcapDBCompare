CREATE TABLE [dbo].[FormField] (
    [FieldId]       INT          IDENTITY (1, 1) NOT NULL,
    [FormVersionId] INT          NOT NULL,
    [FieldName]     VARCHAR (60) NOT NULL,
    [FieldTypeId]   INT          NULL,
    [LabelText]     VARCHAR (80) NULL,
    [IsReadOnly]    BIT          NULL,
    [IsVisible]     BIT          NULL,
    CONSTRAINT [PK_FormField] PRIMARY KEY CLUSTERED ([FieldId] ASC),
    CONSTRAINT [FK_FormField_FormFieldType] FOREIGN KEY ([FieldTypeId]) REFERENCES [dbo].[FormFieldType] ([FieldTypeId]),
    CONSTRAINT [FK_FormField_FormVersion] FOREIGN KEY ([FormVersionId]) REFERENCES [dbo].[FormVersion] ([FormVersionId])
);

