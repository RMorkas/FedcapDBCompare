


CREATE proc [dbo].[Rpt_LINC_HRAClientInfo]
@companyId int,
@firstName varchar(50) =null, 
@lastName varchar(50) =null,
@SSN varchar(9) =null,
@caseNumber varchar(10) =null,
@caseManagerId int =null,
@AccManagerId int =null, 
@NoFilterByDate bit =null,
@referralFrmDate smalldatetime =null,
@referralToDate smalldatetime =null,
@CompleteServiceNA int =null,
@CompleteServiceNO int =null,
@CompleteServiceYES int =null,
@LandLordNA int =null,
@LandLordNo int =null,
@LandLordYes int =null,
@SpanishNA int =null,
@SpanishNo int =null,
@SpanishYes int =null,
@lincId	varchar(20) =null

AS
SELECT        dbo.Client.ClientId, dbo.Client.ClientNo + '-' + dbo.Client.Suffix + '-' + dbo.Client.LineNumber AS CaseNumber, 
                         dbo.Client.CaseLastName + ', ' + dbo.Client.CaseFirstName AS ClientName, dbo.Client.PhoneNumber, dbo.Client.CellPhone, dbo.Client.Email, 
                         dbo.Client.LeaseSigningDate, dbo.Client.LeaseStartDate, dbo.Client.HHSize, dbo.Client.LINCID, 
                         dbo.Client.StreetAddress + ', ' + dbo.Client.City + ', ' + dbo.Client.State + ' ' + dbo.Client.ZipCode AS Address, dbo.Client.SSN, dbo.Client.ReferralDate, 
                         dbo.LINC_LandLord.FirstName + ' ' + dbo.LINC_LandLord.LastName AS LandlordName, dbo.LINC_LandLord.CellPhone AS LandCellPhone, 
                         dbo.[User].FirstName + ' ' + dbo.[User].LastName AS CMName, '' AS AMName, Enumes_2.Item AS RentType, dbo.LINC_ClientSubInfo.ShelterName, 
                         dbo.LINC_ClientSubInfo.AcutalRent, dbo.LINC_ClientSubInfo.Contribution, dbo.LINC_ClientSubInfo.Subsidy, dbo.LINC_ClientSubInfo.MasterNote, 
                         ISNULL(CAST(dbo.LINC_ClientSubInfo.CompleteServicePlan AS INT), 2) AS CompleteServicePlan, 
                         ISNULL(CAST(dbo.LINC_ClientSubInfo.MadeContactWithLandlord AS INT), 2) AS MadeContactWithLandlord, 
                         ISNULL(CAST(dbo.LINC_ClientSubInfo.SpanishSpeaker AS INT), 2) AS SpanishSpeaker, dbo.Client.ReferralDate AS Expr1, dbo.LINC_Employment.VendorName, 
                         Enumes_1.Item AS Employed, dbo.Enumes.Item AS Frequency, dbo.LINC_Employment.EmploymentType, Enumes_3.Item AS LINCProgram, 
                         dbo.LINC_Employment.Salary, dbo.LINC_Employment.JobStartDate, dbo.LINC_Employment.EmployerName
FROM            dbo.Enumes AS Enumes_2 RIGHT OUTER JOIN
                         dbo.[User] RIGHT OUTER JOIN
                         dbo.LINC_ClientSubInfo with(nolock) ON dbo.[User].UserID = dbo.LINC_ClientSubInfo.CaseManagerID ON 
                         Enumes_2.EnumId = dbo.LINC_ClientSubInfo.RentTypeId RIGHT OUTER JOIN
                         dbo.Enumes AS Enumes_1 RIGHT OUTER JOIN
                         dbo.Enumes AS Enumes_3 RIGHT OUTER JOIN
                         dbo.LINC_Employment with(nolock) ON Enumes_3.EnumId = dbo.LINC_Employment.LINCProgramId LEFT OUTER JOIN
                         dbo.Enumes ON dbo.LINC_Employment.FrequencyId = dbo.Enumes.EnumId ON Enumes_1.EnumId = dbo.LINC_Employment.EmployedTypeId RIGHT OUTER JOIN
                         dbo.Client with(nolock) ON dbo.LINC_Employment.ClientId = dbo.Client.ClientId ON dbo.LINC_ClientSubInfo.ClientId = dbo.Client.ClientId LEFT OUTER JOIN
                         dbo.LINC_LandLord with(nolock) ON dbo.Client.LandLordId = dbo.LINC_LandLord.LandLordId
WHERE        
(dbo.Client.CompanyId = @companyId)
AND
(Isnull(dbo.Client.IsDeleted,0) = 0)
AND
(Isnull(dbo.Client.IsActive,0) = 1)
AND
(ISNULL(dbo.LINC_Employment.IsJobImported,0) = 1)
AND
(ISNull(dbo.LINC_ClientSubInfo.LastUpdate,0) = 1)
AND
(@lincId IS NULL OR dbo.Client.LINCID Like '%' + @lincId + '%')
AND
(@firstName IS NULL OR dbo.Client.CaseFirstName Like '%' + @firstName + '%')
AND
(@lastName IS NULL OR dbo.Client.CaseLastName Like '%' + @lastName + '%')
AND
(@SSN IS NULL OR dbo.Client.SSN Like '%' + @SSN + '%')
AND
(@caseNumber IS NULL OR dbo.Client.ClientNo Like '%' + @caseNumber + '%')
AND
(@caseManagerId IS NULL OR dbo.LINC_ClientSubInfo.CaseManagerID = @caseManagerId)
--AND
--(@AccManagerId IS NULL OR dbo.LINC_ClientSubInfo.AccountManagerID = @AccManagerId)
AND
(@NoFilterByDate IS NULL OR
(
(dateadd(day,0,datediff(day,0,dbo.Client.ReferralDate))>= dateadd(day,0,datediff(day,0, @referralFrmDate))) 
AND 
(dateadd(day,0,datediff(day,0,dbo.Client.ReferralDate))<= dateadd(day,0,datediff(day,0,@referralToDate)))
))
AND
(
(@CompleteServiceNA IS NULL AND @CompleteServiceNO IS NULL AND @CompleteServiceYES IS null)  OR
	(@CompleteServiceNA = 1 AND dbo.LINC_ClientSubInfo.CompleteServicePlan is NULL)
	OR
	(@CompleteServiceYES = 1 AND dbo.LINC_ClientSubInfo.CompleteServicePlan = 1)
	OR
	(@CompleteServiceNO = 1 AND dbo.LINC_ClientSubInfo.CompleteServicePlan = 0)
)
AND
(
(@LandLordNA IS NULL AND @LandLordNo IS NULL AND @LandLordYes IS null)  OR
(@LandLordNA = 1 AND dbo.LINC_ClientSubInfo.MadeContactWithLandlord is NULL)
OR
(@LandLordNo = 1 AND dbo.LINC_ClientSubInfo.MadeContactWithLandlord = 0)
OR
(@LandLordYes = 1 AND dbo.LINC_ClientSubInfo.MadeContactWithLandlord = 1)
)
AND
(
(@SpanishNA IS NULL AND @SpanishNo IS NULL AND @SpanishYes IS null)  OR
(@SpanishNA = 1 AND dbo.LINC_ClientSubInfo.SpanishSpeaker is NULL)
OR
(@SpanishNo = 1 AND dbo.LINC_ClientSubInfo.SpanishSpeaker = 0)
OR
(@SpanishYes = 1 AND dbo.LINC_ClientSubInfo.SpanishSpeaker = 1)
)
Order BY dbo.Client.LINCID

--Select * from dbo.LINC_ClientSubInfo where dbo.LINC_ClientSubInfo.CompleteServicePlan = 0 OR dbo.LINC_ClientSubInfo.CompleteServicePlan = 1