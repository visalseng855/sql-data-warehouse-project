-- Check For NULL or Duplicate in Primary Key
-- Expectation: No Result

-- >> Check on Primary key
SELECT
	prd_id,
	COUNT(*)
FROM bronze.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) >1 OR prd_id IS NULL

-- >> Check on product key have dupplicate or note.

SELECT
	prd_key,
	COUNT(*)
FROM bronze.crm_prd_info
GROUP BY prd_key
HAVING COUNT(*) >1 OR prd_key IS NULL

-- >> Verify Start Date and End Date. Why End Date record less than Start Date.
SELECT *
FROM bronze.crm_prd_info
WHERE prd_end_dt < prd_start_dt

-->> Check Unwanted Space
SELECT 
	prd_nm
FROM bronze.crm_prd_info
WHERE prd_nm != TRIM(prd_nm)

-->> Check Cost negative or NULL
SELECT 
	prd_cost
FROM bronze.crm_prd_info
WHERE prd_cost <0 OR prd_cost IS NULL

-->> Meaningful name of product line
SELECT 
	CASE prd_line
		WHEN 'M' THEN 'Mountain'
		WHEN 'R' THEN 'Road'
		WHEN 'S' THEN 'Other Sales'
		WHEN 'T' THEN 'Touring'
		ELSE 'n/a'
	END prd_line
FROM bronze.crm_prd_info
GROUP BY prd_line

-->> Check Start Date and End Date
SELECT 
*
FROM bronze.crm_prd_info
WHERE prd_end_dt < prd_start_dt

