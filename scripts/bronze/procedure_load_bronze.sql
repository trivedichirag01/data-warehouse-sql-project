/*
PostgreSQL
================================================================================
Stored Procedure: Load Bronze Layer (Source -> Bronze)
================================================================================
Script Purpose:

    This stored procedure loads data into the 'bronze' schema from external CSV files.
    It performs the following actions:

    - Truncates the bronze tables before loading data.
    - Uses the `BULK INSERT` command to load data from csv files to bronze tables.

Parameters:

    None.

    This stored procedure does not accept any parameters or return any values.

Usage Example:

    CALL bronze.load_bronze;
================================================================================
*/



CREATE OR REPLACE PROCEDURE bronze.load_bronze()
LANGUAGE plpgsql
AS $$
DECLARE 
	v_error_message TEXT;
	v_error_code    TEXT;
    v_error_detail  TEXT;
    v_error_hint    TEXT;
	v_start_time    TIMESTAMPTZ;
	v_rows_loaded   BIGINT;
	v_elapsed_time  INTERVAL;
	v_elapsed_seconds NUMERIC;
	v_batch_start_time    TIMESTAMPTZ;
	

BEGIN
    RAISE NOTICE E'\n=======================\nLOADING BRONZE LAYER\n=======================\n';
    
	BEGIN 
	v_batch_start_time := clock_timestamp();
	
	RAISE NOTICE E'\n-----------------------\nLOADING CRM TABLES\n-----------------------\n';
        RAISE NOTICE E' >> Truncating Table: bronze.crm_cust_info';
		TRUNCATE TABLE bronze.crm_cust_info;
        RAISE NOTICE E' >> Inserting Data Into: bronze.crm_cust_info';
		v_start_time := clock_timestamp();
		COPY bronze.crm_cust_info
		FROM 'D:/ETL/datasets/source_crm/cust_info.csv'
		WITH(
			FORMAT CSV,
			HEADER true,
			DELIMITER ','
		);
		GET DIAGNOSTICS v_rows_loaded = ROW_COUNT;
		v_elapsed_time = clock_timestamp() -  v_start_time;
		v_elapsed_seconds = ROUND(EXTRACT(EPOCH FROM v_elapsed_time)::NUMERIC, 2);
		RAISE NOTICE E' TABLE: % | Rows loaded: % | Duration: % seconds\n', 'bronze.crm_cust_info', v_rows_loaded, v_elapsed_seconds; 

		RAISE NOTICE E' >> Truncating Table: bronze.crm_prd_info';
		TRUNCATE TABLE bronze.crm_prd_info;
		RAISE NOTICE E' >> Inserting Data Into: bronze.crm_prd_info';
		v_start_time := clock_timestamp();
		COPY bronze.crm_prd_info
		FROM 'D:/ETL/datasets/source_crm/prd_info.csv'
		WITH(
			FORMAT CSV,
			HEADER true,
			DELIMITER ','
		);
		GET DIAGNOSTICS v_rows_loaded = ROW_COUNT;
		v_elapsed_time = clock_timestamp() -  v_start_time;
		v_elapsed_seconds = ROUND(EXTRACT(EPOCH FROM v_elapsed_time)::NUMERIC, 2);
		RAISE NOTICE E' TABLE: % | Rows loaded: % | Duration: % seconds\n', 'bronze.crm_prd_info', v_rows_loaded, v_elapsed_seconds;

		RAISE NOTICE E' >> Truncating Table: bronze.crm_sales_details';
		TRUNCATE TABLE bronze.crm_sales_details;
		RAISE NOTICE E' >> Inserting Data Into: bronze.crm_sales_details';
		v_start_time := clock_timestamp();
		COPY bronze.crm_sales_details
		FROM 'D:/ETL/datasets/source_crm/sales_details.csv'
		WITH(
			FORMAT CSV,
			HEADER TRUE,
			DELIMITER ','
		);
		GET DIAGNOSTICS v_rows_loaded = ROW_COUNT;
		v_elapsed_time = clock_timestamp() -  v_start_time;
		v_elapsed_seconds = ROUND(EXTRACT(EPOCH FROM v_elapsed_time)::NUMERIC, 2);
		RAISE NOTICE E' TABLE: % | Rows loaded: % | Duration: % seconds\n', 'bronze.crm_sales_details', v_rows_loaded, v_elapsed_seconds;
		

		
	RAISE NOTICE E'\n-----------------------\nLOADING ERP TABLES\n-----------------------\n';
	
		RAISE NOTICE E' >> Truncating Table: bronze.erp_cust_az12';
		TRUNCATE TABLE bronze.erp_cust_az12;
		RAISE NOTICE E' >> Inserting Data Into: bronze.erp_cust_az12';
		v_start_time := clock_timestamp();
		COPY bronze.erp_cust_az12
		FROM 'D:/ETL/datasets/source_erp/CUST_AZ12.csv'
		WITH(
			FORMAT CSV,
			HEADER TRUE,
			DELIMITER ','
		);
		GET DIAGNOSTICS v_rows_loaded = ROW_COUNT;
		v_elapsed_time = clock_timestamp() -  v_start_time;
		v_elapsed_seconds = ROUND(EXTRACT(EPOCH FROM v_elapsed_time)::NUMERIC, 2);
		RAISE NOTICE E' TABLE: % | Rows loaded: % | Duration: % seconds\n', 'bronze.erp_cust_az12', v_rows_loaded, v_elapsed_seconds;


		RAISE NOTICE E' >> Truncating Table: bronze.erp_loc_a101';
		TRUNCATE TABLE bronze.erp_loc_a101;
		RAISE NOTICE E' >> Inserting Data Into: bronze.erp_loc_a101';
		v_start_time := clock_timestamp();
		COPY bronze.erp_loc_a101
		FROM 'D:/ETL/datasets/source_erp/LOC_A101.csv'
		WITH(
			FORMAT CSV,
			HEADER TRUE,
			DELIMITER ','
		);
		GET DIAGNOSTICS v_rows_loaded = ROW_COUNT;
		v_elapsed_time = clock_timestamp() -  v_start_time;
		v_elapsed_seconds = ROUND(EXTRACT(EPOCH FROM v_elapsed_time)::NUMERIC, 2);
		RAISE NOTICE E' TABLE: % | Rows loaded: % | Duration: % seconds\n', 'bronze.erp_loc_a101', v_rows_loaded, v_elapsed_seconds;

		RAISE NOTICE E' >> Truncating Table: bronze.erp_px_cat_g1v2';
		TRUNCATE TABLE bronze.erp_px_cat_g1v2;
		RAISE NOTICE E' >> Inserting Data Into: bronze.erp_px_cat_g1v2';
		v_start_time := clock_timestamp();
		COPY bronze.erp_px_cat_g1v2
		FROM 'D:/ETL/datasets/source_erp/PX_CAT_G1V2.csv'
		WITH(
			FORMAT CSV,
			HEADER TRUE,
			DELIMITER ','
		);
		GET DIAGNOSTICS v_rows_loaded = ROW_COUNT;
		v_elapsed_time = clock_timestamp() -  v_start_time;
		v_elapsed_seconds = ROUND(EXTRACT(EPOCH FROM v_elapsed_time)::NUMERIC, 2);
		RAISE NOTICE E' TABLE: % | Rows loaded: % | Duration: % seconds\n', 'bronze.erp_px_cat_g1v2\n', v_rows_loaded, v_elapsed_seconds;

		v_elapsed_time = clock_timestamp() - v_batch_start_time;
		v_elapsed_seconds = ROUND(EXTRACT(EPOCH FROM v_elapsed_time)::NUMERIC, 2);
		RAISE NOTICE E'\n========================================================================================\nLoading bronze layer is complated | Batch loading duration: % seconds\n========================================================================================', v_elapsed_seconds;
	EXCEPTION WHEN OTHERS THEN 
		GET STACKED DIAGNOSTICS 
			v_error_message = MESSAGE_TEXT,
			v_error_code = RETURNED_SQLSTATE,
			v_error_detail = PG_EXCEPTION_DETAIL,
			v_error_hint = PG_EXCEPTION_HINT;
	
		RAISE NOTICE 'Error Message: %', v_error_message;
		RAISE NOTICE 'Error Code: %', v_error_code;
		RAISE NOTICE 'Error Details: %', v_error_details;
		RAISE NOTICE 'Error Hint: %', v_error_hint;
		RAISE;
	
	END;

END;
$$;
