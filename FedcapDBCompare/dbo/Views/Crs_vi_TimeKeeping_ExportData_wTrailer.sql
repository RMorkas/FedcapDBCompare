CREATE VIEW [dbo].[Crs_vi_TimeKeeping_ExportData_wTrailer]
AS
select top 100000 * from [dbo].[Crs_vi_TimeKeeping_ExportData] with(nolock)
Union all
SELECT 'END                                      ' + 
 convert(char(11),right('0000000000' + convert(varchar(10),COUNT(1)),10),11) + 
 convert(char(11),convert(varchar(10),getdate(),101),11) + 
 convert(char(5),convert(varchar(5),getdate(),108),5)
+ space(223) 
FROM [dbo].[Crs_vi_TimeKeeping_ExportData]   with(nolock)