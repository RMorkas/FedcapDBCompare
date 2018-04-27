CREATE TABLE [dbo].[Sector] (
    [SectorId]   INT           IDENTITY (1, 1) NOT NULL,
    [CompanyId]  INT           NULL,
    [SetcorName] VARCHAR (150) NULL,
    [IsActive]   BIT           CONSTRAINT [DF_Sector_IsActive] DEFAULT ((1)) NULL,
    [SaveBy]     VARCHAR (80)  NULL,
    [SaveAt]     DATETIME      NULL,
    [IsDev]      BIT           NULL,
    [IsUAT]      BIT           NULL,
    [IsStaging]  BIT           NULL,
    [IsProd]     BIT           NULL,
    CONSTRAINT [PK_Sectors] PRIMARY KEY CLUSTERED ([SectorId] ASC)
);

