

CREATE Proc [dbo].[getWellnessClients]
@companyId int,
@dateAsOf smalldatetime =null,
@wellnessType varchar(20) =null,
@list StringList  READONLY 
as
Declare @count int
Set @count = (select COUNT(Item) from @list)



IF(@companyId = 1)
Begin

	IF OBJECT_ID('tempdb.dbo.#tempWellnessR1', 'U') IS NOT NULL
		DROP TABLE #tempWellnessR1;

	SELECT * INTO #tempWellnessR1 from NYCWAY_RegionI.fed.WellnessStatus well
	where
	(well.CompletionDate IS NULL)
	AND
	(
		(dateadd(day,0,datediff(day,0, well.InitiationDate))>= dateadd(day,0,datediff(day,0, DATEADD(Year,-1, @dateAsOf))))
		AND
		(dateadd(day,0,datediff(day,0, well.InitiationDate))<= dateadd(day,0,datediff(day,0, @dateAsOf)))
	)
	AND 
	(@wellnessType IS NULL OR WellnessType = @wellnessType)
	AND
	(@count = 0 or well.Site in (select item From @list))

	select cases.HRACaseID, ID, Client, well.SSN, well.CIN, CaseNumber, Site, CaseManager, InitiationCode, InitiationDate, InitiationCodePostedBy, CompletionCode, CompletionDate, FADDate, 
	InitiationExtensionFormSavedBy, InitiationExtensionSaveDate, InitiationExtensionImaging, CompletionFormSavedBy, CompletionFormSaveDate, TPWPRExpirationDate, TPWPRStatus, PhysicianReviewReady, PreviousMedical, 
	MedicalCompletedBy, CompletionImaging, Outcome, OpenWellnessFADStatus, WellnessType, CSPStatus, cases.FEGSCaseManager,loginTable.Name as CaseManagerName 
	FROM #tempWellnessR1 well join FedCapCM.dbo.VW_HRACases 
	cases on cases.SSN = well.SSN 
	--Left outer join ALLSECTOR_PROD_R1.FEDCAPWCR1.dbo.logintable as loginTable ON
	--cases.FEGSCaseManager = loginTable.UserID
	Outer Apply
	(
		select * from OPENQUERY ([ALLSECTOR_PROD_R1] ,'Select UserID, loginTable.FirstName + '' '' + loginTable.LastName AS Name From 
											[fedcapWCR1].dbo.logintable as loginTable') loginTable
		WHere
		cases.FEGSCaseManager = loginTable.UserID
		
	 ) loginTable
	Where 
	cases.CompanyId = @companyId
END
ELSE
Begin

	IF OBJECT_ID('tempdb.dbo.#tempWellnessR2', 'U') IS NOT NULL
		DROP TABLE #tempWellnessR2;

	SELECT * INTO #tempWellnessR2 from NYCWAY_History.fed.WellnessStatus well
	where
	(well.CompletionDate IS NULL)
	AND
	(
		(dateadd(day,0,datediff(day,0, well.InitiationDate))>= dateadd(day,0,datediff(day,0, DATEADD(Year,-1, @dateAsOf))))
		AND
		(dateadd(day,0,datediff(day,0, well.InitiationDate))<= dateadd(day,0,datediff(day,0, @dateAsOf)))
	)
	AND 
	(@wellnessType IS NULL OR WellnessType = @wellnessType)
	AND
	(@count = 0 or well.Site in (select item From @list))

	select cases.HRACaseID, ID, Client, well.SSN, well.CIN, CaseNumber, Site, CaseManager, InitiationCode, InitiationDate, InitiationCodePostedBy, CompletionCode, CompletionDate, FADDate, 
	InitiationExtensionFormSavedBy, InitiationExtensionSaveDate, InitiationExtensionImaging, CompletionFormSavedBy, CompletionFormSaveDate, TPWPRExpirationDate, TPWPRStatus, PhysicianReviewReady, PreviousMedical, 
	MedicalCompletedBy, CompletionImaging, Outcome, OpenWellnessFADStatus, WellnessType, CSPStatus, cases.FEGSCaseManager, loginTable.Name 
	FROM #tempWellnessR2 well join FedCapCM.dbo.VW_HRACases cases on
	cases.SSN = well.SSN 
	--Left outer join ALLSECTOR_PROD_R2.ARBORFEDCAP.dbo.logintable as loginTable ON
	--cases.FEGSCaseManager = loginTable.UserID
	Outer Apply
	(
		select * from OPENQUERY ([ALLSECTOR_PROD_R2] ,'Select UserID, loginTable.FirstName + '' '' + loginTable.LastName AS Name From 
											[Arborfedcap].dbo.logintable as loginTable') loginTable
		WHere
		cases.FEGSCaseManager = loginTable.UserID
		
	 ) loginTable
	Where 
	cases.CompanyId = @companyId
END
