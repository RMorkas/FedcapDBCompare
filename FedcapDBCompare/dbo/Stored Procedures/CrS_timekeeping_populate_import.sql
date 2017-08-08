




CREATE PROCEDURE [dbo].[CrS_timekeeping_populate_import] @RunDate AS DATETIME, @RunId as int
AS
  BEGIN
  
  

	  ---- Get The RunId
	  --	  set @RunId = (SELECT MAX(Runid) as MaxRunID from [dbo].[CrS_Timekeeping_History])
      
	  -- Clear the Import table.
      TRUNCATE TABLE [CrS_Timekeeping_Import]

      -- Import the latest data from the B2WHistoricalReferral table.
      SET IDENTITY_INSERT [CrS_Timekeeping_Import] ON

      INSERT INTO [dbo].[crs_timekeeping_import]
                  (id,
                   datetimestamp,
                   processed,
                   scheduled,
                   hracasenumber,
                   suffix,
                   linenumber,
                   cin,
                   lastname,
                   firstname,
                   middleinitial,
                   applicantregdate,
                   gender,
                   ssn,
                   dob,
                   localofficecode,
                   hraindividualstatus,
                   dtsclientid,
                   clientdemochangedate,
                   agencycode,
                   worksitecode,
                   programstartdate,
                   assignedhours,
                   requiredhours,
                   ebtstartdate,
                   orientationstartdate,
                   terminationdate,
                   dtsassignmentid,
                   cyclestartdate,
                   hracaseid,
                   mon,
                   tue,
                   wed,
                   thu,
                   fri,
                   sat,
                   sun)
      SELECT id,
             importdate,
             processed,
             scheduled,
             hracasenumber,
             suffix,
             linenumber,
             cin,
             lastname,
             firstname,
             middleinitial,
             applicantregdate,
             gender,
             ssn,
             dob,
             localofficecode,
             hraindividualstatus,
             dtsclientid,
             clientdemochangedate,
             agencycode,
             worksitecode,
             programstartdate,
             assignedhours,
             requiredhours,
             ebtstartdate,
             orientationstartdate,
             terminationdate,
             dtsassignmentid,
             cyclestartdate,
             hracaseid,
             mon,
             tue,
             wed,
             thu,
             fri,
             sat,
             sun
      FROM   [dbo].[historical_b2wreferral]
      WHERE  historical_b2wreferral.importdate = cast (@RunDate as date)

      SET IDENTITY_INSERT [CrS_Timekeeping_Import] OFF

      -- Fill in ClientId based on DTSclientId in the Client table.
      UPDATE cti
      SET    cti.clientid = cl.clientid
      FROM   [dbo].[crs_timekeeping_import] cti
             INNER JOIN [dbo].[client] cl
                     ON cti.dtsclientid = cl.clientno
      WHERE  cti.datetimestamp = cast (@RunDate as date)
             AND cl.companyid = 9

	  -- Fill in RunId
	  Update [dbo].[crs_timekeeping_import]
	  SET RunId = @RunId
  END  




