CREATE TABLE [dbo].[Msg_Reason] (
    [ReasonId]    INT           IDENTITY (1, 1) NOT NULL,
    [Reason]      VARCHAR (50)  NULL,
    [Description] VARCHAR (150) NULL,
    [IsDev]       BIT           NULL,
    [IsUAT]       BIT           NULL,
    [IsStaging]   BIT           NULL,
    [IsProd]      BIT           NULL,
    CONSTRAINT [PK_Msg_Reason] PRIMARY KEY CLUSTERED ([ReasonId] ASC)
);

