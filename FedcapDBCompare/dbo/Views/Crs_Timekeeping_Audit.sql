Create VIEW [dbo].[Crs_Timekeeping_Audit]
AS
SELECT        Id, ClientID, DTSClientID, DTSAssignmentID, ActivityDate, Status, runId, notes, datetimestamp, Scheduleid
FROM     dbo.CrS_Timekeeping_Export_Audit with (Nolock) 
