CREATE TABLE [dbo].[ClientDetail] (
    [ClientDetailId]             INT             IDENTITY (1, 1) NOT NULL,
    [ClientId]                   INT             NULL,
    [CompanyId]                  INT             NULL,
    [BackgroundId]               INT             NULL,
    [TabeReading]                NUMERIC (18, 1) NULL,
    [TabeMath]                   NUMERIC (18, 1) NULL,
    [ComputerLevelId]            INT             NULL,
    [CanPassDrug]                BIT             NULL,
    [LiftMax]                    NUMERIC (18, 2) NULL,
    [CanStandLongPeriod]         BIT             NULL,
    [CanSitLongPeriod]           BIT             NULL,
    [IsServedInArmy]             BIT             NULL,
    [FirstPreferSectorId]        INT             NULL,
    [SecondPreferSectorId]       INT             NULL,
    [ThirdPreferSectorId]        INT             NULL,
    [HasPersonalDriverLicense]   BIT             NULL,
    [HasCommercialDriverLicense] BIT             NULL,
    [HasStateIdentification]     BIT             NULL,
    [HasBenefitsCard]            BIT             NULL,
    [HasUSPassport]              BIT             NULL,
    [HasSocialSecurityCard]      BIT             NULL,
    [ActiveBarcode]              INT             NULL,
    [Photo]                      VARBINARY (MAX) NULL,
    [CreatedBy]                  VARCHAR (80)    NULL,
    [CreatedAt]                  DATETIME        NULL,
    [UpdatedBy]                  VARCHAR (80)    NULL,
    [UpdatedAt]                  DATETIME        NULL,
    CONSTRAINT [PK_ClientStatus] PRIMARY KEY CLUSTERED ([ClientDetailId] ASC),
    CONSTRAINT [FK_ClientStatus_Enumes] FOREIGN KEY ([BackgroundId]) REFERENCES [dbo].[Enumes] ([EnumId]),
    CONSTRAINT [FK_ClientStatus_Enumes1] FOREIGN KEY ([ComputerLevelId]) REFERENCES [dbo].[Enumes] ([EnumId])
);


GO
CREATE TRIGGER [dbo].[historyOfBarcode] ON [dbo].[ClientDetail] 
After INSERT, UPDATE
AS
Declare @oldBarCode int, @newBraCode int, @lastHistoryId int

select @newBraCode = ActiveBarcode From inserted
select @oldBarCode = ActiveBarcode From deleted
if(@newBraCode = @oldBarCode OR @newBraCode IS NULL) --nothing change.
return;

Select @lastHistoryId = BarcodeHistoryId From [dbo].[ClientBarcodeHistory] as history JOIN
inserted on history.CompanyId = inserted.CompanyId AND history.ClientId = inserted.ClientId
WHERE
--history.CompanyId = inserted.CompanyId
--AND
--history.ClientId = inserted.ClientId
--AND
history.EndDate IS NULL

if(@lastHistoryId IS NOT null AND @lastHistoryId <> 0)
	BEGIN
		Update dbo.[ClientBarcodeHistory] Set EndDate = GETDATE()
		WHere
		BarcodeHistoryId = @lastHistoryId
	END

Insert INTO [dbo].[ClientBarcodeHistory] (CompanyId, SiteId, ClientId, Barcode, StartDate, EndDate, CreatedBy, CreatedAt)
Select inserted.CompanyId, null, inserted.ClientId, @newBraCode, GETDATE(), null, ISNULL(inserted.UpdatedBy,CreatedBy), ISNULL(inserted.UpdatedAt,CreatedAt) from inserted




