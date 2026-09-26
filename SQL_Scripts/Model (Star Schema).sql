-- 1. Dim_Customer
IF OBJECT_ID('dbo.dim_customer', 'U') IS NOT NULL DROP TABLE dbo.dim_customer;

CREATE TABLE dbo.dim_customer (
    CustomerKey INT PRIMARY KEY,
    CustomerID INT,
    Gender NVARCHAR(100),
    Age INT,
    NumDependents INT,
    EstimatedSalary INT,
    RegistrationDate DATE
);

INSERT INTO dbo.dim_customer
SELECT 
    ROW_NUMBER() OVER (ORDER BY customer_id) AS CustomerKey,
    customer_id AS CustomerID,
    gender AS Gender,
    age AS Age,
    num_dependents AS NumDependents,
    estimated_salary AS EstimatedSalary,
    date_of_registration AS RegistrationDate
FROM dbo.silver_telecom_churn;


-- 2. Dim_Location
IF OBJECT_ID('dbo.dim_location', 'U') IS NOT NULL DROP TABLE dbo.dim_location;

CREATE TABLE dbo.dim_location (
    LocationKey INT PRIMARY KEY,
    State NVARCHAR(100),
    City NVARCHAR(100),
    Pincode INT
);

INSERT INTO dbo.dim_location
SELECT 
    ROW_NUMBER() OVER (ORDER BY state, city, pincode) AS LocationKey,
    state AS State,
    city AS City,
    pincode AS Pincode
FROM (
    SELECT DISTINCT state, city, pincode 
    FROM dbo.silver_telecom_churn
) AS unique_locs;


-- 3. Dim_Partner
IF OBJECT_ID('dbo.dim_partner', 'U') IS NOT NULL DROP TABLE dbo.dim_partner;

CREATE TABLE dbo.dim_partner (
    PartnerKey INT PRIMARY KEY,
    TelecomPartner NVARCHAR(100)
);

INSERT INTO dbo.dim_partner
SELECT 
    ROW_NUMBER() OVER (ORDER BY telecom_partner) AS PartnerKey,
    telecom_partner AS TelecomPartner
FROM (
    SELECT DISTINCT telecom_partner 
    FROM dbo.silver_telecom_churn
) AS unique_partners;


-- 4. Dim_Date (Tarih Boyutu Tablosu)
IF OBJECT_ID('dbo.dim_date', 'U') IS NOT NULL DROP TABLE dbo.dim_date;

CREATE TABLE dbo.dim_date (
    DateKey INT PRIMARY KEY,
    FullDate DATE,
    Year INT,
    Month INT,
    MonthName NVARCHAR(20),
    Quarter INT,
    Day INT,
    DayOfWeek NVARCHAR(20)
);

WITH DateSequence AS (
    SELECT CAST('2020-01-01' AS DATE) AS DateValue
    UNION ALL
    SELECT DATEADD(DAY, 1, DateValue)
    FROM DateSequence
    WHERE DateValue < '2025-12-31'
)
INSERT INTO dbo.dim_date
SELECT 
    CAST(CONVERT(VARCHAR(8), DateValue, 112) AS INT) AS DateKey,
    DateValue AS FullDate,
    YEAR(DateValue) AS Year,
    MONTH(DateValue) AS Month,
    DATENAME(MONTH, DateValue) AS MonthName,
    DATEPART(QUARTER, DateValue) AS Quarter,
    DAY(DateValue) AS Day,
    DATENAME(WEEKDAY, DateValue) AS DayOfWeek
FROM DateSequence
OPTION (MAXRECURSION 0);


-- 5. Fact_Churn (Olgu Tablosu)
IF OBJECT_ID('dbo.fact_churn', 'U') IS NOT NULL DROP TABLE dbo.fact_churn;

CREATE TABLE dbo.fact_churn (
    ChurnKey INT PRIMARY KEY,
    CustomerKey INT,
    LocationKey INT,
    PartnerKey INT,
    DateKey INT,
    CallsMade INT,
    SmsSent INT,
    DataUsed INT,
    IsChurn BIT
);

INSERT INTO dbo.fact_churn
SELECT 
    ROW_NUMBER() OVER (ORDER BY s.customer_id) AS ChurnKey,
    c.CustomerKey,
    l.LocationKey,
    p.PartnerKey,
    CAST(CONVERT(VARCHAR(8), s.date_of_registration, 112) AS INT) AS DateKey,
    s.calls_made AS CallsMade,
    s.sms_sent AS SmsSent,
    s.data_used AS DataUsed,
    s.churn AS IsChurn
FROM dbo.silver_telecom_churn s
LEFT JOIN dbo.dim_customer c ON s.customer_id = c.CustomerID
LEFT JOIN dbo.dim_location l ON s.state = l.State AND s.city = l.City AND s.pincode = l.Pincode
LEFT JOIN dbo.dim_partner p ON s.telecom_partner = p.TelecomPartner;