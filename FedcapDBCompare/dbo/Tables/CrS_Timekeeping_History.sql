CREATE TABLE [dbo].[CrS_Timekeeping_History] (
    [RunId]             INT      IDENTITY (1, 1) NOT NULL,
    [CycleStartDate]    DATETIME NULL,
    [CycleEndDate]      DATETIME NULL,
    [Rundate]           DATETIME NULL,
    [RunStartTimeStamp] DATETIME NULL,
    [RunEndTimeStamp]   DATETIME NULL
);

