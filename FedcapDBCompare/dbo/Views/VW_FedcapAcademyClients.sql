






CREATE View [dbo].[VW_FedcapAcademyClients]
as
SELECT      CaseFirstName AS [FirstName],
            CaseSurname AS [LastName],
            ClientUserName as Email,
            client.City,
            client.[State],
            client.ZipCode,
            137 AS Department,
            staff.FirstName+' '+staff.LastName AS [Case Manager],
            92 AS ProgramIDs,
		  client.CompanyId,
            ClientId,
            ClientUserName AS Username,
            '' AS [Password],
            2032 AS CertificationID,
            '' AS PathwayID,
		  acad.[StartDate] as EnrollmentStartDate,
		  acad.[EnrollmentEndDate]
     FROM dbo.FedcapAcademy acad WITH (NOLOCK)
          INNER JOIN dbo.VW_HRACases client WITH (NOLOCK) ON acad.ClientId = client.HRACaseID AND acad.CompanyId = client.CompanyId
          LEFT OUTER JOIN dbo.[User] staff WITH (nolock) ON client.[AssignedStaffMemberId] = staff.UserID
     WHERE ISNULL(acad.IsDeleted, 0) = 0
           AND ISNULL(acad.IsSentToFedcapAcademy, 0) = 0
           --AND ((DATEADD(day, 0, DATEDIFF(day, 0, acad.StartDate)) <= DATEADD(day, 0, DATEDIFF(day, 0, GETDATE())))
           --     AND (DATEADD(day, 0, DATEDIFF(day, 0, acad.EndDate)) >= DATEADD(day, 0, DATEDIFF(day, 0, GETDATE()))))
			 --AND
			 --not exists (select clientid from FedcapAcademy where ClientId = acad.ClientId AND CompanyId = acad.CompanyId AND EnrollmentEndDate IS null)
