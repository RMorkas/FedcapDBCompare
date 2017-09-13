CREATE TABLE [dbo].[ClientIntakeAttachment] (
    [ClientIntakeAttachmentId] INT           IDENTITY (1, 1) NOT NULL,
    [FileName]                 VARCHAR (300) NULL,
    [ClientIntakeId]           INT           NULL,
    [ScanImageId]              INT           NULL,
    CONSTRAINT [PK_ClientIntakeAttachment] PRIMARY KEY CLUSTERED ([ClientIntakeAttachmentId] ASC),
    CONSTRAINT [FK_ClientIntakeAttachment_ClientIntake] FOREIGN KEY ([ClientIntakeId]) REFERENCES [dbo].[ClientIntake] ([ClientIntakeId]),
    CONSTRAINT [FK_ClientIntakeAttachment_SCAN_Images] FOREIGN KEY ([ScanImageId]) REFERENCES [dbo].[SCAN_Images] ([ID])
);

