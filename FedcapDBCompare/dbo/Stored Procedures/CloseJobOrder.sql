
CREATE Proc [dbo].[CloseJobOrder]
@CompanyId int
AS
Declare @Id int, @trNo int, @openDate smalldateTime, @closeDate smalldatetime,@leadId int, @leadEmail NVARCHAR(MAX), @xml NVARCHAR(MAX), @body NVARCHAR(MAX),
@LeadName NVARCHAR(MAX)
Set @xml = NULL


DECLARE db_cursor CURSOR 
Local FAST_FORWARD
FOR

SELECT JobLeadUserId FROM CV_JobOrder job with(nolock) 
WHERE
job.CompanyId = @CompanyId
AND
(dateadd(day,0,datediff(day,0, job.JobClosingDate)) = dateadd(day,0,datediff(day,0, GETDATE()))) 
AND
job.IsActive = 1
GROUP BY JobLeadUserId


OPEN db_cursor   
FETCH NEXT FROM db_cursor INTO @leadId

WHILE @@FETCH_STATUS = 0   
BEGIN   

Update dbo.CV_JobOrder SET IsActive = 0 WHERE 
CompanyId = @CompanyId
AND
JobLeadUserId = @leadId
AND
(dateadd(day,0,datediff(day,0, JobClosingDate)) = dateadd(day,0,datediff(day,0, GETDATE()))) 
AND
IsActive = 1

SET @xml = CAST(( SELECT job.JobOrderTrNo AS 'td','', emp.FirstName AS 'td','',job.JobTitle AS 'td','',
			CONVERT(varchar(max),job.JobOpeningDate,101) AS 'td','',CONVERT(varchar(max),job.JobClosingDate,101) AS 'td',''
FROM  CV_JobOrder job inner join EmployerLocation loc on job.EmployerLocationId = loc.EmpLocationId
inner join Employer emp on loc.EmployerId = emp.EmployerId
WHERE
job.CompanyId = @CompanyId
AND
(dateadd(day,0,datediff(day,0, job.JobClosingDate)) = dateadd(day,0,datediff(day,0, GETDATE())))
AND
job.JobLeadUserId = @leadId
ORDER BY JobOrderTrNo 
FOR XML PATH('tr'), ELEMENTS ) AS NVARCHAR(MAX))

Select @leadEmail = EMail, @LeadName = (FirstName + ' ' + LastName)  From dbo.[User] WHERE UserID = @leadId

IF(@xml IS NOT NULL)
BEGIN
	SET @body ='<html><body><H4>Job orders closed today led by ' + @LeadName + ' </H4>
	<table border = 1> 
	<tr>
	<th> JobOrder N# </th> <th> Employer </th> <th> Job Title </th> <th> Opened Date </th> <th> Closed Date </th></tr>' 

	SET @body = @body + @xml +'</table><br/> 
	Kind regards<br/>
	FedCap System 
	<br/>
	<br/>
	</body></html>'

	exec msdb.dbo.sp_send_dbmail @profile_name='MyTestMail',
	@recipients=@leadEmail,
	@subject='Job orders closed today',
	@body=@body,
	@body_format = 'HTML'
END
    FETCH NEXT FROM db_cursor INTO @leadId 
END   
CLOSE db_cursor   
DEALLOCATE db_cursor
