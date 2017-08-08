

CREATE proc [dbo].[Rpt_LINC_AccManagerReferral]
@companyId int,
@firstName varchar(50) =null, 
@lastName varchar(50) =null,
@SSN varchar(9) =null,
@caseNumber varchar(10) =null,
@DiscardDate bit =null,
@frmDate smalldatetime =null,
@toDate smalldatetime =null,
@DateType int= null,
@AccManagerId int =null,
@caseManagerId int =null
AS
SELECT        dbo.Client.ClientId, dbo.Client.ClientNo + '-' + dbo.Client.Suffix + '-' + dbo.Client.LineNumber AS CaseNumber, 
                         dbo.Client.CaseLastName + ', ' + dbo.Client.CaseFirstName AS ClientName, dbo.Client.PhoneNumber, dbo.Client.CellPhone, dbo.Client.LINCID, 
                         dbo.Client.StreetAddress + ', ' + dbo.Client.City + ', ' + dbo.Client.State + ' ' + dbo.Client.ZipCode AS Address, 
						 dbo.Client.SSN, Enumes_1.Item AS JobReady, 
                         dbo.Enumes.Item AS ActionTaken, Enumes_2.Item AS Result, dbo.Client.ReferralDate, dbo.LINC_AccManagerReferral.Note, 
                         dbo.LINC_AccManagerReferral.CreatedBy, dbo.LINC_AccManagerReferral.CreatedAt, 
                         CASE 
							WHEN dbo.LINC_AccManagerReferral.IsAttendedMeeting = 1 THEN 'YES' 
							WHEN dbo.LINC_AccManagerReferral.IsAttendedMeeting = 0 THEN 'NO' 
							ELSE '' 
						 END AS IsAttendedMeeting, dbo.LINC_AccManagerReferral.MeetingDate, dbo.LINC_AccManagerReferral.ReferralDateAM, 
						 User_1.FirstName + ' ' + User_1.LastName AS AMName, dbo.[User].FirstName + ' ' + dbo.[User].LastName AS CaseManager,
						 --CASE
							--WHEN dbo.LINC_ClientSubInfo.IsEmployed = 1 THEN 'YES'
							--WHEN dbo.LINC_ClientSubInfo.IsEmployed = 0 THEN 'NO'
							--ELSE ''
						 --END 
						 '' AS IsEmployed
FROM            dbo.Client with(nolock) INNER JOIN
                         dbo.LINC_AccManagerReferral with(nolock) ON dbo.Client.ClientId = dbo.LINC_AccManagerReferral.ClientId INNER JOIN
                         dbo.LINC_ClientSubInfo with(nolock) ON dbo.Client.ClientId = dbo.LINC_ClientSubInfo.ClientId LEFT OUTER JOIN
                         dbo.[User] ON dbo.LINC_ClientSubInfo.CaseManagerID = dbo.[User].UserID LEFT OUTER JOIN
                         dbo.Enumes ON dbo.LINC_AccManagerReferral.ActionTakenId = dbo.Enumes.EnumId LEFT OUTER JOIN
                         dbo.Enumes AS Enumes_1 ON dbo.LINC_AccManagerReferral.JobReadyId = Enumes_1.EnumId LEFT OUTER JOIN
                         dbo.Enumes AS Enumes_2 ON dbo.LINC_AccManagerReferral.ResultId = Enumes_2.EnumId LEFT OUTER JOIN
                         dbo.[User] AS User_1 ON dbo.LINC_AccManagerReferral.AccountManagerID = User_1.UserID
WHERE        
(dbo.Client.CompanyId = @companyId)
AND
(Isnull(dbo.Client.IsDeleted,0) = 0)
AND
(Isnull(dbo.Client.IsActive,0) = 1)
AND
(Isnull(dbo.LINC_ClientSubInfo.LastUpdate,0) = 1)
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
(@AccManagerId IS NULL OR dbo.LINC_AccManagerReferral.AccountManagerID = @AccManagerId)
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
(dateadd(day,0,datediff(day,0, dbo.LINC_AccManagerReferral.CreatedAt))>= dateadd(day,0,datediff(day,0, @frmDate))) 
AND 
(dateadd(day,0,datediff(day,0, dbo.LINC_AccManagerReferral.CreatedAt))<= dateadd(day,0,datediff(day,0,@toDate)))
)))
Order BY dbo.Client.LINCID