CREATE PROC [dbo].[Rpt_LoadAccountPayable]
@companies varchar(max) =null,
@vendorNames varchar(max) =null,
@accounts varchar(max) =null,
@lineofBusiness varchar(max) =null,
@departments varchar(max) =null,
@locations varchar(max) =null,
@division varchar(max) =null,
@projects varchar(max) =null,
@frmInvDate smalldatetime =null,
@toInvDate smalldatetime =null,
@frmChkDate smalldatetime =null,
@toChkDate smalldatetime =null,
@loadVoidCheck bit =null,
@frmGLDate smalldatetime =null,
@toGLDate smalldatetime =null,
@invoiceNo varchar(30) =null
AS
SELECT * FROM [dbo].[VW_APDetailedReport] 
WHERE
(@companies IS NULL OR [CompanyId] in (SELECT value FROM  dbo.SplitStr(@companies,',')))
AND
(@vendorNames IS NULL OR VendorName in (SELECT value FROM  dbo.SplitStr(@vendorNames,';')))
AND
(@accounts IS NULL OR [AccountId] in (SELECT value FROM  dbo.SplitStr(@accounts,',')))
AND
(@lineofBusiness IS NULL OR [LineOfBusinessId] in (SELECT value FROM  dbo.SplitStr(@lineofBusiness,',')))
AND
(@departments IS NULL OR [DepartmentId] in (SELECT value FROM  dbo.SplitStr(@departments,',')))
AND
(@locations IS NULL OR [LocationId] in (SELECT value FROM  dbo.SplitStr(@locations,',')))
AND
(@division IS NULL OR [DivisionId] in (SELECT value FROM  dbo.SplitStr(@division,',')))
AND
(@projects IS NULL OR [ProjectId] in (SELECT value FROM  dbo.SplitStr(@projects , ',')))
AND
(@invoiceNo IS NULL OR InvoiceNumber LIKE '%' + @invoiceNo + '%')
AND
(
(@frmInvDate IS NULL OR dateadd(day,0,datediff(day,0,InvoiceDate)) >= dateadd(day,0,datediff(day,0, @frmInvDate)))
AND
(@toInvDate IS NULL OR dateadd(day,0,datediff(day,0,InvoiceDate)) <= dateadd(day,0,datediff(day,0, @toInvDate)))
)
AND
(
(@frmChkDate IS NULL OR dateadd(day,0,datediff(day,0,CheckDate)) >= dateadd(day,0,datediff(day,0, @frmChkDate)))
AND
(@toChkDate IS NULL OR dateadd(day,0,datediff(day,0,CheckDate)) <= dateadd(day,0,datediff(day,0, @toChkDate)))
)
AND
(
(@frmGLDate IS NULL OR dateadd(day,0,datediff(day,0,GLDate)) >= dateadd(day,0,datediff(day,0, @frmGLDate)))
AND
(@toGLDate IS NULL OR dateadd(day,0,datediff(day,0,GLDate)) <= dateadd(day,0,datediff(day,0, @toGLDate)))
)
AND
(
(@loadVoidCheck IS NULL)
OR
(@loadVoidCheck = 1 AND [VoidDate] IS NOT NULL)
OR
(@loadVoidCheck = 0 AND [VoidDate] IS NULL)
)


