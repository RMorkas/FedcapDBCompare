CREATE TABLE [dbo].[ClientSupportServiceAttachment] (
    [ClientSupportServiceAttachmentId] INT           IDENTITY (1, 1) NOT NULL,
    [FileName]                         VARCHAR (300) NULL,
    [ClientSupportServiceId]           INT           NULL,
    [ScanImageId]                      INT           NULL,
    CONSTRAINT [PK_ClientSupportServiceAttachment] PRIMARY KEY CLUSTERED ([ClientSupportServiceAttachmentId] ASC),
    CONSTRAINT [FK_ClientSupportServiceAttachment_ClientSupportService] FOREIGN KEY ([ClientSupportServiceId]) REFERENCES [dbo].[ClientSupportService] ([ClientSupportServiceId]),
    CONSTRAINT [FK_ClientSupportServiceAttachment_SCAN_Images] FOREIGN KEY ([ScanImageId]) REFERENCES [dbo].[SCAN_Images] ([ID])
);

