/*
=============================================================================================================================================================================
DDL Scripts: Create Bronze Tables
=============================================================================================================================================================================
Script Purpose: 
  This script creates tables in the bronze schema, dropping existing tables if they already exist.
  Run this script to redefine the DDL structure of 'bronze' Tables.
=============================================================================================================================================================================
*/
CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
	DECLARE @start_time DATETIME, @end_time DATETIME; -- This helps us check how long it takes for each table to be loaded -- SET start, SET end and PRINT the outcome --
	SET @start_time = GETDATE();
	TRUNCATE TABLE bronze.crm_cust_info;

	BULK INSERT bronze.crm_cust_info FROM 'C:\Users\yaqeenbkk\Divers\Coding\SQL\SQL Course (30 hours)\SQL Projects\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
	WITH (
		FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		TABLOCK
	);
	SET @end_time = GETDATE();
	PRINT '>> Load duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';


	SET @start_time = GETDATE();
	TRUNCATE TABLE bronze.crm_prd_info;

	BULK INSERT bronze.crm_prd_info FROM 'C:\Users\yaqeenbkk\Divers\Coding\SQL\SQL Course (30 hours)\SQL Projects\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
	WITH (
		FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		TABLOCK
	);
	SET @end_time = GETDATE();
	PRINT '>> Load duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';


	SET @start_time = GETDATE();
	TRUNCATE TABLE bronze.crm_sales_details;

	BULK INSERT bronze.crm_sales_details FROM 'C:\Users\yaqeenbkk\Divers\Coding\SQL\SQL Course (30 hours)\SQL Projects\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
	WITH (
		FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		TABLOCK
	);
	SET @end_time = GETDATE();
	PRINT '>> Load duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';


	SET @start_time = GETDATE();
	TRUNCATE TABLE bronze.erp_cust_az12;

	BULK INSERT bronze.erp_cust_az12 FROM 'C:\Users\yaqeenbkk\Divers\Coding\SQL\SQL Course (30 hours)\SQL Projects\sql-data-warehouse-project\datasets\source_erp\CUST_AZ12.csv'
	WITH (
		FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		TABLOCK
	);
	SET @end_time = GETDATE();
	PRINT '>> Load duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';


	SET @start_time = GETDATE();
	TRUNCATE TABLE bronze.erp_loc_a101;

	BULK INSERT bronze.erp_loc_a101 FROM 'C:\Users\yaqeenbkk\Divers\Coding\SQL\SQL Course (30 hours)\SQL Projects\sql-data-warehouse-project\datasets\source_erp\LOC_A101.csv'
	WITH (
		FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		TABLOCK
	);
	SET @end_time = GETDATE();
	PRINT '>> Load duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';


	SET @start_time = GETDATE();
	TRUNCATE TABLE bronze.erp_px_cat_g1v2;

	BULK INSERT bronze.erp_px_cat_g1v2 FROM 'C:\Users\yaqeenbkk\Divers\Coding\SQL\SQL Course (30 hours)\SQL Projects\sql-data-warehouse-project\datasets\source_erp\PX_CAT_G1V2.csv'
	WITH (
		FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		TABLOCK
	);
	SET @end_time = GETDATE();
	PRINT '>> Load duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
END
