CREATE TABLE [dbo].[LINC_LandLord] (
    [LandLordId] INT           IDENTITY (1, 1) NOT NULL,
    [FirstName]  VARCHAR (50)  NULL,
    [MiddleName] VARCHAR (50)  NULL,
    [LastName]   VARCHAR (50)  NULL,
    [HomePhone]  VARCHAR (50)  NULL,
    [CellPhone]  VARCHAR (50)  NULL,
    [Email]      VARCHAR (80)  NULL,
    [Address]    VARCHAR (100) NULL,
    [City]       VARCHAR (50)  NULL,
    [State]      VARCHAR (25)  NULL,
    [ZipCode]    INT           NULL,
    [CreatedBy]  VARCHAR (80)  NULL,
    [CreatedAt]  DATETIME      NULL,
    [UpdatedBy]  VARCHAR (80)  NULL,
    [UpdatedAt]  DATETIME      NULL,
    CONSTRAINT [PK_LINC_LandLord] PRIMARY KEY CLUSTERED ([LandLordId] ASC)
);

