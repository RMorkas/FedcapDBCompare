CREATE TABLE [dbo].[OFI_ClientSubInfo] (
    [ClientSubInfoId]         INT          IDENTITY (1, 1) NOT NULL,
    [ClientId]                INT          NULL,
    [OrientationDate]         DATETIME     NULL,
    [TeletypeTelephoneNumber] VARCHAR (10) NULL,
    [MessageTelephoneNumber]  VARCHAR (10) NULL,
    [MessageExtension]        VARCHAR (10) NULL,
    [PregnancyDueDate]        DATETIME     NULL,
    [PenobscotInd]            VARCHAR (1)  NULL,
    [LivingOnTribalLand]      VARCHAR (1)  NULL,
    [DanaPointPassamaquoddy]  VARCHAR (1)  NULL,
    [AroostookMicmac]         VARCHAR (1)  NULL,
    [HoultonMaliseet]         VARCHAR (1)  NULL,
    [IncomeEmploymentFlag]    VARCHAR (1)  NULL,
    [PassedBackgroundCheck]   VARCHAR (1)  NULL,
    [InvestigationDate]       DATETIME     NULL,
    [PleasantPtPassqdyInd]    VARCHAR (1)  NULL,
    PRIMARY KEY CLUSTERED ([ClientSubInfoId] ASC),
    CONSTRAINT [FK_OFI_ClientSubInfo_Client] FOREIGN KEY ([ClientId]) REFERENCES [dbo].[Client] ([ClientId])
);

