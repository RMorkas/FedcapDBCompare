












 CREATE PROCEDURE [dbo].[Crs_timekeeping_run_tk_process]
AS
  BEGIN
      DECLARE @CycleStartDate DATETIME;
      DECLARE @CycleEndDate DATETIME;
      DECLARE @RunDate DATETIME;
      DECLARE @RunId INT;

	  --SET @RunDate = (select MAX(importdate) from Historical_B2WReferral)
      SET @RunDate = (select MAX(importdate) from Historical_B2WReferral where importdate != cast (getdate() as date))

      -- Create and set RunId
      INSERT INTO [dbo].[crs_timekeeping_history]
                  (cyclestartdate,
                   cycleenddate,
                   rundate,
                   runstarttimestamp,
                   runendtimestamp)
      VALUES      (NULL,
                   NULL,
                   @RunDate,
                   Getdate(),
                   NULL)

      SET @RunId = (SELECT Max(runid)
                    FROM   [dbo].[crs_timekeeping_history])

      -- Run Import Procedure
      EXEC [dbo].[Crs_timekeeping_populate_import]
        @RunDate = @RunDate,
        @RunId = @RunId

      --Setting CycleStartDate, CycleEndDate
      IF Datepart(dw, GETDATE()) = 2
        BEGIN
            SET @CycleStartDate = Dateadd(d, -7, GETDATE())
        END
      ELSE
        BEGIN
            SET @CycleStartDate = Dateadd(dd, 2 - Datepart(dw, GETDATE()),
                                 GETDATE())
        END

      SET @CycleEndDate = Dateadd(dd, 6 - Datepart(weekday, ( @CycleStartDate ))
                          ,
                          @CycleStartDate)

      IF Datediff(d, GETDATE(), @CycleEndDate) >= 0
        BEGIN
            SET @CycleEndDate = GETDATE()
			--Dateadd(d, -1, '2017-07-02 20:00:00.490')
        END

	  -- Populate start and end date to [dbo].[CrS_Timekeeping_History] table
	  Update [dbo].[CrS_Timekeeping_History]
	  set [CycleStartDate] = @CycleStartDate
	  , [CycleEndDate] = @CycleEndDate
	  where RunId = @RunId

      -- Process Import table and Populate export table
      EXEC [dbo].[Crs_scheduling_findattendancereport]
        @CycleStartDate = @CycleStartDate,
		@CycleEndDate = @CycleEndDate,
        @RunId = @RunId


	  --Populate endtimestamp in [dbo].[CrS_Timekeeping_History] table
	  Update [dbo].[CrS_Timekeeping_History]
	  SET [RunEndTimeStamp] = GETDATE()
	  WHERE RunId = @RunId

  END











