CREATE TABLE [dbo].[ACC_LineOfBusiness] (
    [LineOfBusinessId]   INT           NOT NULL,
    [LineOfBusinessDesc] VARCHAR (200) NULL,
    CONSTRAINT [PK_ACC_LineOfBusiness] PRIMARY KEY CLUSTERED ([LineOfBusinessId] ASC)
);

