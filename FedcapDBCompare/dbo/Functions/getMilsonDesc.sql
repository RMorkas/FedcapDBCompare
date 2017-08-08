


CREATE FUNCTION [dbo].[getMilsonDesc]
(
	@retentionStatus int, @vailabilityDate smalldatetime , @endDate smalldatetime, @periodId int,@billingType nvarchar(max)
)
RETURNS nvarchar(max)
AS
BEGIN
	-- Declare the return variable here
	DECLARE @result nvarchar(max)
	SET @result = ''
	
	Declare @milestone Int, @companyId int
	--SET @milestone = (SELECT Cast(Item as INT) FROM Enumes WHERE Enumes.EnumId = @periodId)
	SELECT @milestone = Cast(Item as INT), @companyId = CompanyId FROM Enumes WHERE Enumes.EnumId = @periodId

	IF(@retentionStatus = 1) --Available
	BEGIN
			IF (@milestone = 30 AND @vailabilityDate <= @endDate) --AND @endDate <= DateAdd(day,75,@vailabilityDate)) 
				SET @result = 'Available for 30 days'
			ELSE IF (@milestone = 90 AND @vailabilityDate <= @endDate)-- AND @endDate <= DateAdd(day,75,@vailabilityDate)) 
				SET @result = 'Available for 90 days'
			ELSE IF (@milestone = 180 AND @vailabilityDate <= @endDate)-- AND @endDate <= DateAdd(day,75,@vailabilityDate)) 
				SET @result = 'Available for 180 days'
			ELSE
				SET	@result = NULL
	END
	ELSE IF(@retentionStatus = 2) --Submit to Billing
	BEGIN
			IF (@milestone = 30) 
				SET @result = 'Submit to Billing for 30 days'
			ELSE IF (@milestone = 90 ) 
				SET @result = 'Submit to Billing for 90 days'
			ELSE IF (@milestone = 180 ) 
				SET @result = 'Submit to Billing for 180 days'
			ELSE
				SET	@result = NULL
	END
	ELSE IF(@retentionStatus = 3) --Billed
	BEGIN
			IF (@milestone = 30) 
			BEGIN
				IF(@companyId = 8)
					SET @result = '30 days Verified'
				ELSE
				    SET @result = '30 days Billed'
		     END
			ELSE IF (@milestone = 90)
			BEGIN
				IF(@companyId = 8)
					SET @result = '90 days Verified'
				ELSE
					SET @result = '90 days Billed'
			END
			ELSE IF (@milestone = 180) 
			BEGIN
				IF(@companyId = 8)
					SET @result = '180 days Verified'
				ELSE
				    SET @result = '180 days Billed'
		     END
			ELSE
				SET	@result = NULL
	END
	ELSE IF(@retentionStatus = 4) --Resubmit to Billing
	BEGIN
			IF (@milestone = 30) 
				SET @result = 'Resubmit to Billing for 30 days'
			ELSE IF (@milestone = 90) 
				SET @result = 'Resubmit to Billing for 90 days'
			ELSE IF (@milestone = 180) 
				SET @result = 'Resubmit to Billing for 180 days'
			ELSE
				SET	@result = NULL
	END
	ELSE IF(@retentionStatus = 5) --Expired
	BEGIN
			IF(@billingType like '%offline%')
				BEGIN

					IF (@milestone = 30 AND (@vailabilityDate < @endDate AND @endDate > DateAdd(day,75 + 30,@vailabilityDate))) 
						SET @result = 'Expired 30 days'
					ELSE IF (@milestone = 90 AND @vailabilityDate < @endDate AND @endDate > DateAdd(day,75 + 30,@vailabilityDate)) 
						SET @result = 'Expired 90 days'
					ELSE IF (@milestone = 180 AND @vailabilityDate < @endDate AND @endDate > DateAdd(day,75 + 30,@vailabilityDate)) 
						SET @result = 'Expired 180 days'
					ELSE
						SET @result = NULL
				END
			ELSE
				BEGIN

					IF (@milestone = 30 AND (@vailabilityDate < @endDate AND @endDate > DateAdd(day,75,@vailabilityDate))) 
						SET @result = 'Expired 30 days'
					ELSE IF (@milestone = 90 AND @vailabilityDate < @endDate AND @endDate > DateAdd(day,75,@vailabilityDate)) 
						SET @result = 'Expired 90 days'
					ELSE IF (@milestone = 180 AND @vailabilityDate < @endDate AND @endDate > DateAdd(day,75,@vailabilityDate)) 
						SET @result = 'Expired 180 days'
					ELSE
						SET @result = NULL
				END

	END
	ELSE IF(@retentionStatus = 6) --Lost job
	BEGIN
			IF (DateAdd(day,30,@vailabilityDate) > @endDate)
				SET @result = 'Lost job prior 30 days'
			ELSE IF (DateAdd(day,90,@vailabilityDate) > @endDate)
				SET @result = 'Lost job prior 90 days'
			ELSE IF(DateAdd(day,180,@vailabilityDate) > @endDate)
				SET @result = 'Lost job prior 180 days'
			ELSE
				SET @result = NULL
	END
	--ELSE IF(@retentionStatus = 4) --Billed
	--BEGIN
	--		IF (@DocType = 8716)
	--			SET @result = '30 Days Billed'
	--		ELSE IF (@DocType = 8717)
	--			SET @result = '90 Days Billed'
	--		ELSE IF (@DocType = 8718)
	--			SET @result = '180 Days Billed'
	--		ELSE 
	--			SET @result = NULL
	--END
	ELSE
		SET @result = ''

	-- Return the result of the function
	RETURN @result

END