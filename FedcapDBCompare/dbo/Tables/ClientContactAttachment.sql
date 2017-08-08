CREATE TABLE [dbo].[ClientContactAttachment] (
    [ContactAttachmentId] INT           IDENTITY (1, 1) NOT NULL,
    [FileName]            VARCHAR (300) NULL,
    [ClientContactId]     INT           NULL,
    [ScanImageId]         INT           NULL,
    CONSTRAINT [PK_ClientContactAttachment] PRIMARY KEY CLUSTERED ([ContactAttachmentId] ASC),
    CONSTRAINT [FK_ClientContactAttachment_ClientContact] FOREIGN KEY ([ClientContactId]) REFERENCES [dbo].[ClientContact] ([ClientContactId]),
    CONSTRAINT [FK_ClientContactAttachment_SCAN_Images] FOREIGN KEY ([ScanImageId]) REFERENCES [dbo].[SCAN_Images] ([ID])
);

