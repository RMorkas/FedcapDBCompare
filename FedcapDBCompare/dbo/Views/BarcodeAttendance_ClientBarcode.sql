Create view BarcodeAttendance_ClientBarcode
AS
SELECT        ID, HRACaseID, Barcode, Status, StartDate, EndDate, timestamp, EnteredBy, Notes, 'R1' AS RegionCode, 
                         1 AS CompanyId
FROM            ALLSECTOR.Arborfedcap_rpt_r1.dbo.BarcodeAttendance_ClientBarcode
UNION ALL
SELECT        ID, HRACaseID, Barcode, Status, StartDate, EndDate, timestamp, EnteredBy, Notes, 'R2' AS RegionCode, 
                         2 AS CompanyId
FROM            ALLSECTOR.Arborfedcap_rpt.dbo.BarcodeAttendance_ClientBarcode