CREATE TABLE [dbo].[SectorTitle] (
    [SectorTitleId] INT           IDENTITY (1, 1) NOT NULL,
    [SectorId]      INT           NULL,
    [Title]         VARCHAR (150) NULL,
    [IsActive]      BIT           CONSTRAINT [DF_SectorTitle_IsActive] DEFAULT ((1)) NULL,
    [SaveBy]        VARCHAR (80)  NULL,
    [SaveAt]        DATETIME      NULL,
    CONSTRAINT [PK_SectorTitle] PRIMARY KEY CLUSTERED ([SectorTitleId] ASC),
    CONSTRAINT [FK_SectorTitle_Sector] FOREIGN KEY ([SectorId]) REFERENCES [dbo].[Sector] ([SectorId])
);

