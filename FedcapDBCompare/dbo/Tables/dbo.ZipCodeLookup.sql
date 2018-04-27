CREATE TABLE [dbo].[ZipCodeLookup] (
    [ZipCodeLookupId] INT          IDENTITY (1, 1) NOT NULL,
    [ZipCode]         CHAR (5)     NOT NULL,
    [City]            VARCHAR (50) NOT NULL,
    [State]           VARCHAR (10) NOT NULL,
    [IsPrimary]       BIT          CONSTRAINT [DF_ZipCodeLookup2_IsPrimary] DEFAULT ((0)) NOT NULL,
    [IsDev]           BIT          NULL,
    [IsUAT]           BIT          NULL,
    [IsStaging]       BIT          NULL,
    [IsProd]          BIT          NULL,
    CONSTRAINT [PK_ZipCodeLookup] PRIMARY KEY CLUSTERED ([ZipCodeLookupId] ASC)
);

