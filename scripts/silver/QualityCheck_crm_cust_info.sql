/*
QUALITY CHECK

-- 1) Check for NULL or Duplicates in Primary Key
-- >> A Primary Key must be unique and no null
-- >> Expectation: No Result
=========================================
*/
SELECT 
	cst_id,
	COUNT(*) As duplicate_id
FROM bronze.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) >1 OR cst_id IS NULL

-- If Result has duplicate or NULL on Primary Key, The next step we need to verify data by what is newest row.
-- Then we range value base on latest date by using ROW_NUMER() OVER(PARTITION BY cst_id ORDER BY cst_create_date DESC)
SELECT
*,
ROW_NUMBER() OVER(PARTITION BY cst_id ORDER BY cst_create_date DESC) AS flag_last
FROM bronze.crm_cust_info


-- After we rank ready. We need to filter only 1 as Primary Key No duplicate and Primary Key is not null
-- *** FINAL RESULT
SELECT *
FROM(
	SELECT
	*,
	ROW_NUMBER() OVER(PARTITION BY cst_id ORDER BY cst_create_date DESC) AS flag_last
	FROM bronze.crm_cust_info
) t
WHERE flag_last = 1 AND cst_id IS NOT NULL

/*
QUALITY CHECK

-- 2) Check for unwanted spaces in String Values
	>> Expectation: No Results
=========================================
*/
SELECT 
	cst_firstname
FROM bronze.crm_cust_info
-- If the original value is not equal to the same value after trimming, it means there are sapces!
WHERE cst_firstname != TRIM(cst_firstname) 


-- IF we saw values in each String field contain unwanted spaces value than we use TRIM() function in each column.
-- FINAL RESULT
SELECT 
	cst_id,
	cst_key,
	TRIM(cst_firstname) AS cst_firstname,
	TRIM(cst_lastname) AS cst_lastname,
	cst_marital_status,
	cst_gndr,
	cst_create_date
FROM bronze.crm_cust_info


/*
QUALITY CHECK

-- 3) Check the consistency of values in low candinality columns

=========================================
*/
-- In our data warehouse, we aim to store clear and meaningful values rather than using abbreviation terms
-- Example here Gender has value M and F, Then convert it to Male and Female
SELECT
DISTINCT 
CASE
	WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Male'
	WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'Female'
	ELSE 'n/a'
END cst_gndr
FROM bronze.crm_cust_info

-- For Married Status We also use this step as well.
SELECT
DISTINCT 
CASE
	WHEN UPPER(TRIM(cst_marital_status)) = 'S' THEN 'Single'
	WHEN UPPER(TRIM(cst_marital_status)) = 'M' THEN 'Married'
	ELSE 'n/a'
END cst_marital_status
FROM bronze.crm_cust_info
