CREATE TABLE [dbo].[Msg_Type] (
    [TypeId]   INT          IDENTITY (1, 1) NOT NULL,
    [TypeName] VARCHAR (20) NULL,
    CONSTRAINT [PK_Msg_Type] PRIMARY KEY CLUSTERED ([TypeId] ASC)
);

