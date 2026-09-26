--Bronz Katmanı:

SELECT COUNT(*) AS TotalData FROM telecom_churn

--Tekil Kayıt Kontrolü:
SELECT customer_id,COUNT(*) AS DuplicateCount FROM telecom_churn
GROUP BY customer_id
HAVING COUNT(*) > 1

SELECT COUNT(DISTINCT customer_id ) AS DistinctCount , COUNT(*) AS TotalRows FROM telecom_churn

-- Boş Değer Kontrolü:

SELECT 
	SUM(CASE WHEN customer_id IS NULL THEN 1 ELSE 0 END) AS null_customer_id,
	SUM(CASE WHEN telecom_partner IS NULL THEN 1 ELSE 0 END) AS null_telecom_partner,
	SUM(CASE WHEN gender IS NULL THEN 1 ELSE 0 END) AS null_gender,
    SUM(CASE WHEN age IS NULL THEN 1 ELSE 0 END) AS null_age,
    SUM(CASE WHEN state IS NULL THEN 1 ELSE 0 END) AS null_state,
    SUM(CASE WHEN city IS NULL THEN 1 ELSE 0 END) AS null_city,
    SUM(CASE WHEN pincode IS NULL THEN 1 ELSE 0 END) AS null_pincode,
    SUM(CASE WHEN date_of_registration IS NULL THEN 1 ELSE 0 END) AS null_date_of_registration,
    SUM(CASE WHEN num_dependents IS NULL THEN 1 ELSE 0 END) AS null_num_dependents,
    SUM(CASE WHEN estimated_salary IS NULL THEN 1 ELSE 0 END) AS null_estimated_salary,
    SUM(CASE WHEN calls_made IS NULL THEN 1 ELSE 0 END) AS null_calls_made,
    SUM(CASE WHEN sms_sent IS NULL THEN 1 ELSE 0 END) AS null_sms_sent,
    SUM(CASE WHEN data_used IS NULL THEN 1 ELSE 0 END) AS null_data_used,
    SUM(CASE WHEN churn IS NULL THEN 1 ELSE 0 END) AS null_churn
FROM telecom_churn 


-- Aykırı Değer (Outlier) & Veri Tipi

SELECT 
    MIN(age) AS min_age, MAX(age) AS max_age,
    MIN(estimated_salary) AS min_salary, MAX(estimated_salary) AS max_salary,
    MIN(calls_made) AS min_calls, MAX(calls_made) AS max_calls,
    MIN(sms_sent) AS min_sms, MAX(sms_sent) AS max_sms,
    MIN(data_used) AS min_data, MAX(data_used) AS max_data,
    MIN(date_of_registration) AS min_reg_date, MAX(date_of_registration) AS max_reg_date
FROM telecom_churn;

-------------calls_made,sms_sent,data_used verilerinde negatif değerler bulunuyor.

-- Silver Katman (calls_made,sms_sent,data_used düzeltme)
IF OBJECT_ID('silver_telecom_churn', 'U') IS NOT NULL 
    DROP TABLE silver_telecom_churn;

SELECT 
    customer_id,
    telecom_partner,
    gender,
    age,
    state,
    city,
    pincode,
    date_of_registration,
    num_dependents,
    estimated_salary,
    ABS(calls_made) AS calls_made,   -- Negatif aramaları pozitife çevirdik
    ABS(sms_sent) AS sms_sent,       -- Negatif SMS'leri pozitife çevirdik
    ABS(data_used) AS data_used,     -- Negatif verileri pozitife çevirdik
    churn
INTO silver_telecom_churn
FROM telecom_churn;

------ Değer kontolü

SELECT 
    MIN(calls_made) AS min_calls, 
    MIN(sms_sent) AS min_sms, 
    MIN(data_used) AS min_data
FROM silver_telecom_churn;


--Gold Katmanı (Star Schema Modelleme)