Create proc InserErrorLog
@ErrorTime datetime,
@CompanyId int,
@UserName varchar(Max) =null,
@ClassName varchar(Max) =null,
@ProcedureName varchar(Max) =null,
@IsSqlException bit =null,
@ExceptionType varchar(Max) =null,
@ErrorNumber int =null,
@ErrorState int =null,
@ErrorLine int =null, 
@ErrorMessage varchar(Max) =null,
@InnerException varchar(Max) =null,
@IsHandledError bit =null
As
Insert into ErrorLog (ErrorTime, CompanyId, UserName, ClassName, ProcedureName, IsSqlException, ExceptionType, ErrorNumber, ErrorState, ErrorLine, ErrorMessage, InnerException, IsHandledError)
Values(@ErrorTime, @CompanyId, @UserName, @ClassName, @ProcedureName, @IsSqlException, @ExceptionType , @ErrorNumber, @ErrorState,  @ErrorLine, @ErrorMessage,  @InnerException, @IsHandledError)