CREATE Proc UpdateClientCaseManager
@companyId int,
@caseManagerId varchar(50) =null,
@list StringList  READONLY 
as

Declare @count int
Set @count = (select COUNT(Item) from @list)

IF(@companyId = 1)
Begin
	Update ALLSECTOR.Arborfedcap_rpt_r1.dbo.HRACases SET FEGSCaseManager = @caseManagerId
	WHERE  HRACaseID In (select item From @list)

END
ELSE
Begin
	Update ALLSECTOR.Arborfedcap_rpt.dbo.HRACases SET FEGSCaseManager = @caseManagerId
	WHERE  HRACaseID In (select item From @list)
END

