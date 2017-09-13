CREATE TABLE [dbo].[SupportService_history] (
    [CLIENT_ID]        VARCHAR (50)    NULL,
    [CASE_ID]          VARCHAR (50)    NULL,
    [PERSON_ID]        VARCHAR (50)    NULL,
    [BUDGET_ID]        VARCHAR (50)    NULL,
    [SERVICE_TYPE_CD]  VARCHAR (50)    NULL,
    [FREQUENCY]        VARCHAR (50)    NULL,
    [SS_START_DATE]    DATETIME        NULL,
    [SS_END_DATE]      DATETIME        NULL,
    [SS_AMOUNT]        DECIMAL (18, 2) NULL,
    [CLIENTFIRST_NAME] VARCHAR (50)    NULL,
    [CLIENTLAST_NAME]  VARCHAR (50)    NULL
);

