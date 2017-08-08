



CREATE proc [dbo].[Rpt_LINC_Training]
@companyId int,
@firstName varchar(50) =null, 
@lastName varchar(50) =null,
@SSN varchar(9) =null,
@caseNumber varchar(10) =null,
@DiscardDate bit =null,
@frmDate smalldatetime =null,
@toDate smalldatetime =null,
@DateType int= null,
@caseManagerId int =null
AS
SELECT        dbo.Client.ClientId, dbo.Client.ClientNo + '-' + dbo.Client.Suffix + '-' + dbo.Client.LineNumber AS CaseNumber, 
                         dbo.Client.CaseLastName + ', ' + dbo.Client.CaseFirstName AS ClientName, dbo.Client.PhoneNumber, dbo.Client.CellPhone, dbo.Client.LINCID, 
                         dbo.Client.StreetAddress + ', ' + dbo.Client.City + ', ' + dbo.Client.State + ' ' + dbo.Client.ZipCode AS Address, dbo.Client.SSN, dbo.Enumes.Item AS TrainingType, 
                         dbo.LINC_ReferredTraining.TrainingStartDate, dbo.LINC_ReferredTraining.TrainingEndDate, dbo.LINC_ReferredTraining.Note, dbo.Client.ReferralDate, 
                         dbo.LINC_ReferredTraining.CreatedAt, DATEADD(wk, DATEDIFF(wk, 0, dbo.Client.ReferralDate), 4) AS WeekEndOfReferral, DATEADD(wk, DATEDIFF(wk, 0, 
                         dbo.LINC_ReferredTraining.CreatedAt), 4) AS WeekEndOfCreateAt, dbo.LINC_ReferredTraining.CreatedBy, Enumes_1.Item AS TrainingFor, 
                         Enumes_2.Item AS TrainingMember, dbo.LINC_ReferredTraining.InfoSessionDate, 
						 CASE
							WHEN dbo.LINC_ReferredTraining.IsAttendedInfoSession = 0 Then 'NO'
							WHEN dbo.LINC_ReferredTraining.IsAttendedInfoSession = 1 Then 'YES'
							ELSE ''
						 END AS AttendedInfoSession,
                         CASE
							WHEN dbo.LINC_ReferredTraining.IsCompletedTraining = 0 Then 'NO'
							WHEN dbo.LINC_ReferredTraining.IsCompletedTraining = 1 Then 'YES'
							ELSE ''
						 END AS CompletedTraining,
						 dbo.[User].FirstName + ' ' + dbo.[User].LastName AS CaseManager
FROM            dbo.Client with(nolock) INNER JOIN
                         dbo.LINC_ReferredTraining with(nolock) ON dbo.Client.ClientId = dbo.LINC_ReferredTraining.ClientId INNER JOIN
                         dbo.Enumes ON dbo.LINC_ReferredTraining.TrainingTypeId = dbo.Enumes.EnumId INNER JOIN
                         dbo.LINC_ClientSubInfo with(nolock) ON dbo.Client.ClientId = dbo.LINC_ClientSubInfo.ClientId LEFT OUTER JOIN
                         dbo.[User] ON dbo.LINC_ClientSubInfo.CaseManagerID = dbo.[User].UserID LEFT OUTER JOIN
                         dbo.Enumes AS Enumes_2 ON dbo.LINC_ReferredTraining.TrainingMemberId = Enumes_2.EnumId LEFT OUTER JOIN
                         dbo.Enumes AS Enumes_1 ON dbo.LINC_ReferredTraining.TrainingForId = Enumes_1.EnumId
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
(dateadd(day,0,datediff(day,0, dbo.LINC_ReferredTraining.CreatedAt))>= dateadd(day,0,datediff(day,0, @frmDate))) 
AND 
(dateadd(day,0,datediff(day,0, dbo.LINC_ReferredTraining.CreatedAt))<= dateadd(day,0,datediff(day,0,@toDate)))
)))
Order By dbo.Client.LINCID