CREATE VIEW gold.dim_customer AS
SELECT
	ROW_NUMBER() OVER(ORDER BY ci.cst_id) AS customer_key,
	ci.cst_id AS customer_id,
	ci.cst_key As customer_number,
	ci.cst_firstname AS first_name,
	ci.cst_lastname AS last_name,
	lo.cntry AS country,
	ci.cst_marital_status As marital_status,
	CASE
		WHEN ci.cst_gndr IN ('n/a', NULL) THEN COALESCE(ce.gen,'n/a')
		ELSE cst_gndr
	END gender,	  
	ce.bdate AS birthday,		
	ci.cst_create_date AS create_date
FROM silver.crm_cust_info ci
LEFT JOIN silver.erp_cust_az12 ce
ON ci.cst_key = ce.cid
LEFT JOIN silver.erp_loc_a101 lo
ON ci.cst_key = lo.cid



