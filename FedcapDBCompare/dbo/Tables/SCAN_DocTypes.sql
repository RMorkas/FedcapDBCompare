CREATE TABLE [dbo].[SCAN_DocTypes] (
    [ID]               INT            IDENTITY (1, 1) NOT NULL,
    [Seq]              DECIMAL (18)   NULL,
    [Code]             VARCHAR (50)   NULL,
    [Description]      VARCHAR (2000) NULL,
    [IsActive]         BIT            NULL,
    [IsFormAttachment] BIT            NULL,
    [CompanyId]        INT            NULL,
    [FileNameToSend]   VARCHAR (50)   NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC)
);

