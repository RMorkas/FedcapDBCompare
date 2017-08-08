CREATE proc ACC_UpdateHistory
@frmDate smalldatetime,
@toDate smalldatetime
AS
BEGIN TRAN
Declare @count int
Select @count = Count(*) FROm [dbo].[APDetailedReport_History]

IF(@count = 0)
	BEGIN
		INSERT INTO [dbo].[APDetailedReport_History] (RecordID, GLDate, BatchName, BatchCreationDate, BatchCreator, VendorName, ChartsOfAccounts, BatchEntrySeg,		
		SegmentValue, InvoiceNumber, InvoiceDate, InvoiceDescription, InvoiceAmount, Response, CheckNumber, CheckDate, CheckAmount, VoidDate, DistributionAmt, 
		InvoiceStatus, PaymentStatusFlag, ImportDate, ImportedBy) SELECT  * FROM [dbo].[APDetailedReport]
	END
ELSE
	BEGIN
		Update [dbo].[APDetailedReport_History] SET [DeleteDate] = GETDATE()
		WHERE
		(@frmDate IS NULL OR dateadd(day,0,datediff(day,0,GLDate)) >= dateadd(day,0,datediff(day,0, @frmDate)))
		AND
		(@toDate IS NULL OR dateadd(day,0,datediff(day,0,GLDate)) <= dateadd(day,0,datediff(day,0, @toDate)))
		
		INSERT INTO [dbo].[APDetailedReport_History] (RecordID, GLDate, BatchName, BatchCreationDate, BatchCreator, VendorName, ChartsOfAccounts, BatchEntrySeg,		
		SegmentValue, InvoiceNumber, InvoiceDate, InvoiceDescription, InvoiceAmount, Response, CheckNumber, CheckDate, CheckAmount, VoidDate, DistributionAmt, 
		InvoiceStatus, PaymentStatusFlag, ImportDate, ImportedBy)
		SELECT  * FROM [dbo].[APDetailedReport]
		WHERE
		(@frmDate IS NULL OR dateadd(day,0,datediff(day,0,GLDate)) >= dateadd(day,0,datediff(day,0, @frmDate)))
		AND
		(@toDate IS NULL OR dateadd(day,0,datediff(day,0,GLDate)) <= dateadd(day,0,datediff(day,0, @toDate)))
	END
IF @@ERROR = 0
	COMMIT TRAN
ELSE
	Rollback TRAN