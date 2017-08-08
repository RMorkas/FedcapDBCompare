CREATE TABLE [dbo].[ClientSupportService] (
    [ClientSupportServiceId]  INT             IDENTITY (1, 1) NOT NULL,
    [ClientId]                INT             NOT NULL,
    [SupportServiceId]        INT             NOT NULL,
    [StartDate]               DATETIME        NULL,
    [EndDate]                 DATETIME        NULL,
    [AmountRequested]         DECIMAL (18, 2) NULL,
    [FrequencyId]             INT             NULL,
    [IsEstimate]              BIT             NULL,
    [ServiceDescription]      VARCHAR (2000)  NULL,
    [PaymentToVendorFlag]     BIT             NULL,
    [ServiceBeneficiaryId]    INT             NULL,
    [VendorName]              VARCHAR (100)   NULL,
    [VendorTaxId]             VARCHAR (20)    NULL,
    [VendorStreet1]           VARCHAR (50)    NULL,
    [VendorStreet2]           VARCHAR (50)    NULL,
    [VendorCity]              VARCHAR (50)    NULL,
    [VendorState]             VARCHAR (25)    NULL,
    [VendorZipCode]           VARCHAR (20)    NULL,
    [ProviderTypeId]          INT             NULL,
    [CreatedBy]               VARCHAR (80)    NULL,
    [CreatedAt]               DATETIME        NULL,
    [UpdatedBy]               VARCHAR (80)    NULL,
    [UpdatedAt]               DATETIME        NULL,
    [FormVersionId]           INT             NULL,
    [ChildName]               VARCHAR (100)   NULL,
    [ChildCareProviderTypeId] INT             NULL,
    [IsLocked]                BIT             CONSTRAINT [DF_ClientSupportService_IsLocked] DEFAULT ((0)) NOT NULL,
    [WorkSite]                VARCHAR (200)   NULL,
    [IsDeleted]               BIT             CONSTRAINT [DF_ClientSupportService_IsDeleted] DEFAULT ((0)) NOT NULL,
    [RequestStatus]           INT             CONSTRAINT [DF_ClientSupportService_IsApproved] DEFAULT ((0)) NOT NULL,
    [Approved]                BIT             CONSTRAINT [DF_ClientSupportService_Approved] DEFAULT ((0)) NOT NULL,
    [SupervisorId]            INT             NULL,
    [VendorPhone]             VARCHAR (20)    NULL,
    [HoursPerWeek]            NUMERIC (18, 2) NULL,
    CONSTRAINT [PK_ClientSupportService] PRIMARY KEY CLUSTERED ([ClientSupportServiceId] ASC),
    CONSTRAINT [FK_ClientSupportService_ChildCareProviderType] FOREIGN KEY ([ChildCareProviderTypeId]) REFERENCES [dbo].[ChildCareProviderType] ([ChildCareProviderTypeId]),
    CONSTRAINT [FK_ClientSupportService_Client] FOREIGN KEY ([ClientId]) REFERENCES [dbo].[Client] ([ClientId]),
    CONSTRAINT [FK_ClientSupportService_FormVersion] FOREIGN KEY ([FormVersionId]) REFERENCES [dbo].[FormVersion] ([FormVersionId]),
    CONSTRAINT [FK_ClientSupportService_SupportService] FOREIGN KEY ([SupportServiceId]) REFERENCES [dbo].[SupportService] ([SupportServiceId]),
    CONSTRAINT [FK_ClientSupportService_User] FOREIGN KEY ([SupervisorId]) REFERENCES [dbo].[User] ([UserID])
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'0: To be Sent to OFI
1: OFI Decision Pending
2: Request Approved
3: Request Denied', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ClientSupportService', @level2type = N'COLUMN', @level2name = N'RequestStatus';

