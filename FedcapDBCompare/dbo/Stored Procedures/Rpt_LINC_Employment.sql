

CREATE proc [dbo].[Rpt_LINC_Employment]
@companyId int,
@firstName varchar(50) =null, 
@lastName varchar(50) =null,
@SSN varchar(9) =null,
@caseNumber varchar(10) =null,
@DiscardDate bit =null,
@frmDate smalldatetime =null,
@toDate smalldatetime =null,
@DispalyAllData bit =null,
@DateType int= null,
@caseManagerId int =null
AS
SELECT        dbo.Client.ClientId, dbo.Client.ClientNo + '-' + dbo.Client.Suffix + '-' + dbo.Client.LineNumber AS CaseNumber, 
                         dbo.Client.CaseLastName + ', ' + dbo.Client.CaseFirstName AS ClientName, dbo.Client.PhoneNumber, dbo.Client.CellPhone, dbo.Client.LINCID, 
                         dbo.Client.StreetAddress + ', ' + dbo.Client.City + ', ' + dbo.Client.State + ' ' + dbo.Client.ZipCode AS Address, dbo.Client.SSN, dbo.LINC_Employment.VendorName, 
                         dbo.LINC_Employment.EmployerName, dbo.LINC_Employment.JobStartDate, Enumes_3.Item AS EmployedType, dbo.LINC_Employment.Salary, 
                         dbo.LINC_Employment.SalaryPerHour, Enumes_1.Item AS SalaryRate, dbo.LINC_Employment.EmploymentType, Enumes_2.Item AS LINCProgram, 
                         dbo.LINC_Employment.JobTitle, dbo.LINC_Employment.EmployerAddress, dbo.LINC_Employment.EmployerPhone, dbo.LINC_Employment.JobEndDate, 
                         dbo.LINC_Employment.Note, CASE WHEN ISNULL(dbo.LINC_Employment.IsJobImported, 0) = 1 THEN 'HRA' ELSE 'FEDCAP' END AS JobFoundBy, 
                         dbo.Client.ReferralDate, dbo.LINC_Employment.CreatedBy, dbo.LINC_Employment.CreatedAt, Enumes_4.Item AS EmploymentFor, 
                         Enumes_5.Item AS HouseholdMember, dbo.Enumes.Item AS PlacementType, User_1.FirstName + ' ' + User_1.LastName AS AMName,
						 dbo.[User].FirstName + ' ' + dbo.[User].LastName AS CaseManager
FROM            dbo.Client with(nolock) INNER JOIN
                         dbo.LINC_Employment with(nolock) ON dbo.Client.ClientId = dbo.LINC_Employment.ClientId INNER JOIN
                         dbo.LINC_ClientSubInfo with(nolock) ON dbo.Client.ClientId = dbo.LINC_ClientSubInfo.ClientId LEFT OUTER JOIN
                         dbo.[User] ON dbo.LINC_ClientSubInfo.CaseManagerID = dbo.[User].UserID LEFT OUTER JOIN
                         dbo.[User] AS User_1 ON dbo.LINC_Employment.AccountManagerId = User_1.UserID LEFT OUTER JOIN
                         dbo.Enumes ON dbo.LINC_Employment.PlacementTypeId = dbo.Enumes.EnumId LEFT OUTER JOIN
                         dbo.Enumes AS Enumes_5 ON dbo.LINC_Employment.HouseholdMemberId = Enumes_5.EnumId LEFT OUTER JOIN
                         dbo.Enumes AS Enumes_4 ON dbo.LINC_Employment.EmploymentForId = Enumes_4.EnumId LEFT OUTER JOIN
                         dbo.Enumes AS Enumes_1 ON dbo.LINC_Employment.FrequencyId = Enumes_1.EnumId LEFT OUTER JOIN
                         dbo.Enumes AS Enumes_2 ON dbo.LINC_Employment.LINCProgramId = Enumes_2.EnumId LEFT OUTER JOIN
                         dbo.Enumes AS Enumes_3 ON dbo.LINC_Employment.EmployedTypeId = Enumes_3.EnumId
WHERE        
(dbo.Client.CompanyId = @companyId)
AND
(Isnull(dbo.Client.IsDeleted,0) = 0)
AND
(Isnull(dbo.Client.IsActive,0) = 1)
AND
(ISNULL(LINC_ClientSubInfo.LastUpdate,0) = 1)
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
AND
(@DiscardDate IS NULL OR
(@DateType = 1 OR
(
(dateadd(day,0,datediff(day,0, dbo.Client.ReferralDate))>= dateadd(day,0,datediff(day,0, @frmDate))) 
AND 
(dateadd(day,0,datediff(day,0, dbo.Client.ReferralDate))<= dateadd(day,0,datediff(day,0,@toDate)))
)))
AND
(@DiscardDate IS NULL OR
(@DateType = 0 OR
(
(dateadd(day,0,datediff(day,0, dbo.LINC_Employment.CreatedAt))>= dateadd(day,0,datediff(day,0, @frmDate))) 
AND 
(dateadd(day,0,datediff(day,0, dbo.LINC_Employment.CreatedAt))<= dateadd(day,0,datediff(day,0,@toDate)))
)))
AND
(@DispalyAllData IS NULL OR ISNULL(dbo.LINC_Employment.IsJobImported,0) = @DispalyAllData)