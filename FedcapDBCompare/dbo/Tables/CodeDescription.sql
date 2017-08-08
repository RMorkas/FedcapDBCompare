CREATE TABLE [dbo].[CodeDescription] (
    [DescrID]     INT            IDENTITY (1, 1) NOT NULL,
    [TypeID]      INT            NULL,
    [Code]        VARCHAR (30)   NULL,
    [Description] VARCHAR (2500) NULL,
    [IsActive]    BIT            NULL,
    CONSTRAINT [pk_DescrID] PRIMARY KEY CLUSTERED ([DescrID] ASC),
    CONSTRAINT [fk_OFI_CodeType_TypeID] FOREIGN KEY ([TypeID]) REFERENCES [dbo].[CodeType] ([TypeID])
);

