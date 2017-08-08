
CREATE View [dbo].[VW_FedcapAcademyClients]
as
SELECT      CaseFirstName AS [FirstName],
            CaseSurname AS [LastName],
            client.Email,
            client.City,
            client.[State],
            client.ZipCode,
            137 AS Department,
            staff.FirstName+' '+staff.LastName AS [Case Manager],
            92 AS ProgramIDs,
            ClientId,
            ClientUserName AS Username,
            'fedcap' AS [Password],
            2032 AS CertificationID,
            204 AS PathwayID
     FROM dbo.FedcapAcademy acad WITH (NOLOCK)
          INNER JOIN dbo.VW_HRACases client WITH (NOLOCK) ON acad.ClientId = client.HRACaseID AND acad.CompanyId = client.CompanyId
          LEFT OUTER JOIN dbo.[User] staff WITH (nolock) ON client.[AssignedStaffMemberId] = staff.UserID
     WHERE ISNULL(acad.IsDeleted, 0) = 0
           AND ISNULL(acad.IsSentToFedcapAcademy, 0) = 0
           AND ((DATEADD(day, 0, DATEDIFF(day, 0, acad.StartDate)) <= DATEADD(day, 0, DATEDIFF(day, 0, GETDATE())))
                AND (DATEADD(day, 0, DATEDIFF(day, 0, acad.EndDate)) >= DATEADD(day, 0, DATEDIFF(day, 0, GETDATE()))));
