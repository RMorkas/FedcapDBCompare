CREATE TABLE [dbo].[SCAN_Images] (
    [ID]             INT            IDENTITY (1, 1) NOT NULL,
    [HRACaseId]      INT            NOT NULL,
    [CompanyId]      INT            NOT NULL,
    [DocumentTypeId] INT            NOT NULL,
    [SaveLocation]   VARCHAR (1024) NULL,
    [DocumentDate]   DATETIME       NOT NULL,
    [CreatedBy]      VARCHAR (50)   NOT NULL,
    [CreatedAt]      DATETIME       NOT NULL,
    [IsDeleted]      BIT            NULL,
    [UpdatedBy]      VARCHAR (50)   NULL,
    [UpdatedAt]      DATETIME       NULL,
    [IsProcessed]    BIT            NULL,
    [DateProcessed]  DATETIME       NULL,
    CONSTRAINT [PK_SCAN_Images] PRIMARY KEY CLUSTERED ([ID] ASC),
    CONSTRAINT [FK_SCAN_Images_SCAN_DocTypes] FOREIGN KEY ([DocumentTypeId]) REFERENCES [dbo].[SCAN_DocTypes] ([ID])
);

