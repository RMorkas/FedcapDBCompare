CREATE TABLE [dbo].[Msg_Type] (
    [TypeId]    INT          IDENTITY (1, 1) NOT NULL,
    [TypeName]  VARCHAR (20) NULL,
    [IsDev]     BIT          NULL,
    [IsUAT]     BIT          NULL,
    [IsStaging] BIT          NULL,
    [IsProd]    BIT          NULL,
    CONSTRAINT [PK_Msg_Type] PRIMARY KEY CLUSTERED ([TypeId] ASC)
);

