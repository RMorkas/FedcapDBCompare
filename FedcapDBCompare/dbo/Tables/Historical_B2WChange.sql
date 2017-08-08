CREATE TABLE [dbo].[Historical_B2WChange] (
    [Id]            INT          IDENTITY (1, 1) NOT NULL,
    [ImportDate]    DATETIME     NULL,
    [EffectiveDate] DATETIME     NULL,
    [OldCaseNo]     VARCHAR (20) NULL,
    [OldLineNumber] VARCHAR (2)  NULL,
    [OldSuffix]     VARCHAR (2)  NULL,
    [OldCIN]        VARCHAR (9)  NULL,
    [OldSSN]        VARCHAR (9)  NULL,
    [NewCaseNo]     VARCHAR (20) NULL,
    [NewLineNumber] VARCHAR (2)  NULL,
    [NewSuffix]     VARCHAR (2)  NULL,
    [NewCIN]        VARCHAR (9)  NULL,
    [NewSSN]        VARCHAR (9)  NULL,
    [AgencyCode]    VARCHAR (5)  NULL,
    CONSTRAINT [PK_Historical_B2WChange] PRIMARY KEY CLUSTERED ([Id] ASC)
);

