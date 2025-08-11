-- =============================================
-- Countries Import SQL Batch Process
-- Creates table and imports data from countries.csv
-- =============================================

USE [master] -- Change to your target database name
GO

-- Drop table if it exists
IF OBJECT_ID('dbo.countries', 'U') IS NOT NULL
BEGIN
    DROP TABLE dbo.countries
    PRINT 'Existing countries table dropped.'
END
GO

-- Create the countries table
CREATE TABLE dbo.countries (
    country_id INT IDENTITY(1,1) PRIMARY KEY,
    country_name NVARCHAR(100) NOT NULL,
    iso_code NCHAR(2) NOT NULL,
    dialing_code NVARCHAR(10) NOT NULL,
    region NVARCHAR(50) NOT NULL,
    capital NVARCHAR(100) NOT NULL,
    population BIGINT NOT NULL,
    created_date DATETIME2 DEFAULT GETDATE(),
    
    -- Add unique constraint on ISO code
    CONSTRAINT UK_countries_iso_code UNIQUE (iso_code)
)
GO

PRINT 'Countries table created successfully.'
GO

-- Create index on region for better query performance
CREATE NONCLUSTERED INDEX IX_countries_region 
ON dbo.countries (region)
GO

-- Create index on population for sorting/filtering
CREATE NONCLUSTERED INDEX IX_countries_population 
ON dbo.countries (population DESC)
GO

PRINT 'Indexes created successfully.'
GO

-- Import data from CSV file using BULK INSERT
-- Note: Update the file path to match your local file location
BULK INSERT dbo.countries
FROM '/Users/dominichoward/Documents/AI Prompts/countries.csv'
WITH (
    FIELDTERMINATOR = ',',      -- CSV field delimiter
    ROWTERMINATOR = '\n',       -- Row delimiter
    FIRSTROW = 2,               -- Skip header row
    CODEPAGE = '65001',         -- UTF-8 encoding
    TABLOCK,                    -- Table lock for better performance
    FORMAT = 'CSV',             -- Specify CSV format
    FIELDQUOTE = '"'            -- Handle quoted fields
)
GO

-- Verify the import
DECLARE @RecordCount INT
SELECT @RecordCount = COUNT(*) FROM dbo.countries

PRINT 'Data import completed.'
PRINT 'Total records imported: ' + CAST(@RecordCount AS VARCHAR(10))
GO

-- Display sample data to verify import
PRINT 'Sample data verification:'
SELECT TOP 10 
    country_name,
    iso_code,
    dialing_code,
    region,
    capital,
    FORMAT(population, 'N0') AS formatted_population
FROM dbo.countries
ORDER BY population DESC
GO

-- Display summary statistics
PRINT 'Summary statistics:'
SELECT 
    region,
    COUNT(*) AS country_count,
    FORMAT(SUM(CAST(population AS BIGINT)), 'N0') AS total_population,
    FORMAT(AVG(CAST(population AS BIGINT)), 'N0') AS avg_population
FROM dbo.countries
GROUP BY region
ORDER BY total_population DESC
GO

-- Create a view for easy querying
CREATE VIEW dbo.vw_countries_summary AS
SELECT 
    country_name,
    iso_code,
    dialing_code,
    region,
    capital,
    population,
    CASE 
        WHEN population > 100000000 THEN 'Very Large'
        WHEN population > 50000000 THEN 'Large'
        WHEN population > 10000000 THEN 'Medium'
        WHEN population > 1000000 THEN 'Small'
        ELSE 'Very Small'
    END AS population_category,
    created_date
FROM dbo.countries
GO

PRINT 'View vw_countries_summary created successfully.'
GO

-- Grant permissions (adjust as needed for your environment)
-- GRANT SELECT ON dbo.countries TO [your_role_or_user]
-- GRANT SELECT ON dbo.vw_countries_summary TO [your_role_or_user]

PRINT 'Countries import batch process completed successfully!'
PRINT 'Table: dbo.countries'
PRINT 'View: dbo.vw_countries_summary'
PRINT 'Use SELECT * FROM dbo.countries to view all data'
GO
