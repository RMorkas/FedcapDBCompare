CREATE TABLE [dbo].[PlacementSpecialistHistory] (
    [ID]                    INT           IDENTITY (1, 1) NOT NULL,
    [PlacementEntryId]      INT           NULL,
    [RetentionSpecialistId] INT           NULL,
    [FromDate]              SMALLDATETIME NULL,
    [ToDate]                SMALLDATETIME NULL,
    CONSTRAINT [PK_PlacementSpecialistHistory] PRIMARY KEY CLUSTERED ([ID] ASC)
);

