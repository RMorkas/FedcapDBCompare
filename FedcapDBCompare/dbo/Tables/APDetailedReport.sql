CREATE TABLE [dbo].[APDetailedReport] (
    [RecordID]           INT           IDENTITY (1, 1) NOT NULL,
    [GLDate]             DATETIME      NULL,
    [BatchName]          VARCHAR (100) NULL,
    [BatchCreationDate]  DATETIME      NULL,
    [BatchCreator]       VARCHAR (50)  NULL,
    [VendorName]         VARCHAR (200) NULL,
    [ChartsOfAccounts]   VARCHAR (100) NULL,
    [BatchEntrySeg]      VARCHAR (10)  NULL,
    [SegmentValue]       VARCHAR (50)  NULL,
    [InvoiceNumber]      VARCHAR (50)  NULL,
    [InvoiceDate]        DATETIME      NULL,
    [InvoiceDescription] VARCHAR (200) NULL,
    [InvoiceAmount]      FLOAT (53)    NULL,
    [Response]           VARCHAR (50)  NULL,
    [CheckNumber]        INT           NULL,
    [CheckDate]          DATETIME      NULL,
    [CheckAmount]        FLOAT (53)    NULL,
    [VoidDate]           DATETIME      NULL,
    [DistributionAmt]    FLOAT (53)    NULL,
    [InvoiceStatus]      VARCHAR (50)  NULL,
    [PaymentStatusFlag]  VARCHAR (10)  NULL,
    [ImportDate]         DATETIME      CONSTRAINT [DF_APDetailedReport_ImportDate] DEFAULT (getdate()) NULL,
    [ImportedBy]         VARCHAR (50)  NULL,
    CONSTRAINT [PK_APDetailedReport] PRIMARY KEY NONCLUSTERED ([RecordID] ASC)
);


GO
CREATE CLUSTERED INDEX [PK_RecordID]
    ON [dbo].[APDetailedReport]([RecordID] ASC);

