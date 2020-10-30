ALTER VIEW vwCostAnalysisExportUsageDetails AS
SELECT
	r.filename()  as filename1,
	r.filepath(1) as foldername1,
    r.* 
FROM
    OPENROWSET(
        BULK 'https://azurebillingadls01.dfs.core.windows.net/costanalysisexport/day1/dailyusage/*/*.csv',
        FORMAT = 'CSV',
        PARSER_VERSION='2.0',
        FIRSTROW=2
    ) 
    WITH 
    (
		SubscriptionGuid	VARCHAR(100),
		ResourceGroup		VARCHAR(100),
		ResourceLocation	VARCHAR(100),
		UsageDateTime		VARCHAR(20),
		MeterCategory		VARCHAR(100),
		MeterSubcategory	VARCHAR(100),
		MeterId				VARCHAR(100),
		MeterName			VARCHAR(100),
		MeterRegion			VARCHAR(100),
		UsageQuantity		FLOAT,
		ResourceRate		FLOAT,
		PreTaxCost			FLOAT,
		ConsumedService		VARCHAR(100),
		ResourceType		VARCHAR(100),
		InstanceId			VARCHAR(600),
		Tags				VARCHAR(8000),
		OfferId				VARCHAR(100),
		AdditionalInfo		VARCHAR(8000),
		ServiceInfo1		VARCHAR(100),
		ServiceInfo2		VARCHAR(100),
		ServiceName			VARCHAR(100),
		ServiceTier			VARCHAR(100),
		Currency			VARCHAR(100),
		UnitOfMeasure		VARCHAR(100)
    )
    AS r


	------
	SELECT 
foldername1,MAX(UsageDateTime) as MaxUsageDateTime FROM 
(
	SELECT
		foldername1,filename1,COUNT(DISTINCT UsageDateTime) as UsageDateTime 
	FROM 
		vwCostAnalysisExportUsageDetails
	GROUP BY 
		foldername1,filename1
) x
GROUP BY x.foldername1

