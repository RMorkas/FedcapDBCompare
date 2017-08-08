CREATE TABLE [dbo].[ClientBarcodeHistory] (
    [BarcodeHistoryId] INT           IDENTITY (1, 1) NOT NULL,
    [CompanyId]        INT           NULL,
    [SiteId]           INT           NULL,
    [ClientId]         INT           NULL,
    [Barcode]          INT           NULL,
    [StartDate]        SMALLDATETIME NULL,
    [EndDate]          SMALLDATETIME NULL,
    [CreatedBy]        VARCHAR (80)  NULL,
    [CreatedAt]        DATETIME      NULL,
    CONSTRAINT [PK_ClientBarcodeHistory] PRIMARY KEY CLUSTERED ([BarcodeHistoryId] ASC)
);

