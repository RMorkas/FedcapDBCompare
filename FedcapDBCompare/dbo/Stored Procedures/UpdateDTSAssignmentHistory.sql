

CREATE proc [dbo].[UpdateDTSAssignmentHistory]
@startDate datetime,
@endDate datetime=null
as
IF @endDate IS NULL
    SET @endDate=@startDate

WHILE DATEDIFF(dd , @startDate , @endDate) >= 0
    BEGIN
        --Update Existing Assignments
        IF OBJECT_ID('tempdb.dbo.#ReferralUpdate' , 'U') IS NOT NULL
		  DROP TABLE #ReferralUpdate

	   SELECT Referral.ClientId,Referral.WorkSiteCode,Referral.ProgramStartDate,Referral.TerminationDate,Referral.DTSAssignmentId INTO #ReferralUpdate 
	   FROM
			 (SELECT 
			 ROW_NUMBER() over (PARTITION BY DTSAssignmentId order by CycleStartDate desc)rn,
			 c.ClientId , WorkSiteCode , 
			 (case when ISDATE(ProgramStartDate) = 1  then ProgramStartDate else NULL end) AS ProgramStartDate, 
			 (case when ISDATE(TerminationDate) = 1  then TerminationDate else NULL end) AS TerminationDate, DTSAssignmentId 
			 FROM Historical_B2WReferral AS h INNER JOIN Client AS c ON h.DTSClientId = c.ClientNo
			 WHERE DATEDIFF(dd , ImportDate , @startDate) = 0
			 ) Referral
	   WHERE EXISTS (SELECT 1 FROM DTSAssignmentHistory AS d
					   WHERE d.ClientId = Referral.ClientId AND d.DTSAssignmentId = Referral.DTSAssignmentId 
					   AND DATEDIFF(DD,ISNULL(d.TerminationDate,''), ISNULL(Referral.TerminationDate,''))!=0
					   )
	   AND rn=1 -- Get the Assignment with the most recent CycleStartDate

	   UPDATE DTSAssignmentHistory
               SET DTSAssignmentHistory.TerminationDate =  CONVERT(VARCHAR(20),r.TerminationDate,101) , DTSAssignmentHistory.ProgramStartDate = CONVERT(VARCHAR(20),r.ProgramStartDate,101)
			FROM DTSAssignmentHistory a INNER JOIN #ReferralUpdate r ON a.ClientId = r.ClientId
               AND a.WorkSiteCode = r.WorkSiteCode AND a.DTSAssignmentId = r.DTSAssignmentId

        --Insert new Assignments
        INSERT INTO DTSAssignmentHistory
        SELECT DISTINCT c.ClientId , WorkSiteCode,
			(case when ISDATE(ProgramStartDate) = 1  then ProgramStartDate else NULL end) AS ProgramStartDate, 
			(case when ISDATE(TerminationDate) = 1  then TerminationDate else NULL end) AS TerminationDate,
			DTSAssignmentId
               FROM Historical_B2WReferral AS h INNER JOIN Client AS c ON h.DTSClientId = c.ClientNo
               WHERE DATEDIFF(dd , ImportDate , @startDate) = 0
               AND NOT EXISTS ( SELECT 1 FROM DTSAssignmentHistory AS d WHERE d.ClientId = c.ClientId AND d.DTSAssignmentId = h.DTSAssignmentId)
        
	   SET @startDate = DATEADD(day , 1 , @startDate)
    END

return 1


