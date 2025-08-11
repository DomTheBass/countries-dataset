# Countries Dataset

A comprehensive dataset containing information about all 195 recognized sovereign countries in the world.

## Overview

This dataset provides essential information about countries including geographic, demographic, and telecommunications data. It's designed for use in applications requiring country reference data, geographic analysis, or demographic studies.

## Dataset Description

### File: `countries.csv`

The CSV file contains the following columns:

| Column | Data Type | Description |
|--------|-----------|-------------|
| **Country Name** | String | Official common name of the country |
| **ISO Code** | String (2 chars) | Two-letter ISO 3166-1 alpha-2 country code |
| **Dialing Code** | String | International dialing code (including + prefix) |
| **Region** | String | Continent/region where the country is located |
| **Capital** | String | Capital city of the country |
| **Population** | Integer | Current population estimate (2024/2025 data) |

### Data Coverage

- **Total Countries**: 195 sovereign nations
- **Regions Covered**: 
  - Africa (54 countries)
  - Asia (48 countries) 
  - Europe (44 countries)
  - North America (23 countries)
  - South America (12 countries)
  - Oceania (14 countries)

### Data Sources

Population figures are based on the most recent estimates from:
- World Bank data
- UN Population Division
- National statistical offices
- CIA World Factbook

## Database Import

### File: `countries_import.sql`

A complete SQL Server batch script for creating and populating a countries table in your database.

#### Prerequisites

- Microsoft SQL Server (2016 or later recommended)
- Appropriate database permissions for:
  - Creating tables
  - Creating indexes
  - Creating views
  - Bulk insert operations

#### Usage Instructions

1. **Prepare Your Environment**
   ```sql
   -- Ensure you have the necessary permissions
   -- Update the database name in the script if needed
   ```

2. **Update File Path**
   - Open `countries_import.sql`
   - Locate the `BULK INSERT` section
   - Update the file path to match your local CSV file location:
   ```sql
   FROM '/your/path/to/countries.csv'
   ```

3. **Execute the Script**
   - Open SQL Server Management Studio (SSMS)
   - Connect to your target SQL Server instance
   - Open the `countries_import.sql` file
   - Execute the entire script (F5)

#### What the Script Does

1. **Table Creation**
   - Creates `dbo.countries` table with optimized data types
   - Adds primary key with auto-increment
   - Creates unique constraint on ISO code
   - Adds timestamp field for audit purposes

2. **Performance Optimization**
   - Creates index on `region` column for geographic queries
   - Creates index on `population` column for demographic analysis
   - Uses table locking during import for optimal performance

3. **Data Import**
   - Uses `BULK INSERT` for efficient CSV import
   - Handles UTF-8 encoding and CSV formatting
   - Skips header row automatically
   - Provides detailed progress feedback

4. **Verification**
   - Displays import statistics
   - Shows sample data for verification
   - Provides regional summary statistics

5. **Additional Features**
   - Creates `vw_countries_summary` view with population categories
   - Includes proper error handling
   - Provides template for permission grants

#### Table Schema

```sql
CREATE TABLE dbo.countries (
    country_id INT IDENTITY(1,1) PRIMARY KEY,
    country_name NVARCHAR(100) NOT NULL,
    iso_code NCHAR(2) NOT NULL,
    dialing_code NVARCHAR(10) NOT NULL,
    region NVARCHAR(50) NOT NULL,
    capital NVARCHAR(100) NOT NULL,
    population BIGINT NOT NULL,
    created_date DATETIME2 DEFAULT GETDATE(),
    
    CONSTRAINT UK_countries_iso_code UNIQUE (iso_code)
)
```

#### Sample Queries

After import, you can use these queries to explore the data:

```sql
-- Top 10 most populous countries
SELECT TOP 10 
    country_name, 
    FORMAT(population, 'N0') AS formatted_population
FROM dbo.countries 
ORDER BY population DESC;

-- Countries by region
SELECT 
    region,
    COUNT(*) AS country_count,
    FORMAT(SUM(population), 'N0') AS total_population
FROM dbo.countries 
GROUP BY region 
ORDER BY total_population DESC;

-- Find countries by dialing code
SELECT country_name, dialing_code 
FROM dbo.countries 
WHERE dialing_code LIKE '+1%';

-- Population categories using the view
SELECT 
    population_category,
    COUNT(*) AS country_count
FROM dbo.vw_countries_summary 
GROUP BY population_category 
ORDER BY country_count DESC;
```

## Data Quality Notes

- All population figures are estimates and may vary depending on source
- Some countries have multiple dialing codes; this dataset includes the primary code
- Capital cities reflect the official/constitutional capital (may differ from largest city)
- Region classifications follow standard geographic conventions

## Use Cases

- **Demographic Analysis**: Population studies and comparisons
- **Geographic Applications**: Mapping and location services
- **Telecommunications**: International dialing and routing
- **Data Validation**: Country code validation in applications
- **Reference Data**: Lookup tables for business applications
- **Educational**: Geographic and demographic education tools

## File Organization

```
countries/
├── README.md           # This documentation file
├── countries.csv       # Main dataset
└── countries_import.sql # SQL Server import script
```

## Version Information

- **Dataset Version**: 2025.1
- **Last Updated**: August 2025
- **Next Update**: Planned for 2026

## Citation

If you use this dataset in academic research, please cite it as follows:

### BibTeX
```bibtex
@dataset{howard2025countries,
  author = {Howard, Dominic},
  title = {Countries Dataset: Comprehensive Global Reference Data},
  year = {2025},
  version = {2025.1},
  publisher = {GitHub},
  url = {https://github.com/DomTheBass/countries-dataset},
  note = {Dataset includes 195 countries with demographic, geographic, and telecommunications data}
}
```

### APA Style
Howard, D. (2025). *Countries Dataset: Comprehensive Global Reference Data* (Version 2025.1) [Data set]. GitHub. https://github.com/DomTheBass/countries-dataset

### MLA Style
Howard, Dominic. "Countries Dataset: Comprehensive Global Reference Data." *GitHub*, 2025, github.com/DomTheBass/countries-dataset.

### Chicago Style
Howard, Dominic. "Countries Dataset: Comprehensive Global Reference Data." GitHub, 2025. https://github.com/DomTheBass/countries-dataset.

### Plain Text
Howard, D. (2025). Countries Dataset: Comprehensive Global Reference Data (Version 2025.1). Retrieved from https://github.com/DomTheBass/countries-dataset

### DOI
*A DOI will be assigned when this dataset is published to Zenodo or figshare for permanent archival.*

## Academic Usage Guidelines

When using this dataset for research:

1. **Data Verification**: Always cross-reference population figures with official sources for critical analysis
2. **Version Control**: Specify the exact version (2025.1) used in your research for reproducibility
3. **Limitations**: Acknowledge that population data are estimates and may vary between sources
4. **Updates**: Check for newer versions before publication, as demographic data changes annually
5. **Scope**: Clearly state that this covers 195 UN-recognized sovereign states plus Vatican City

## License

This dataset is provided for educational and commercial use. Please verify population figures with official sources for critical applications.

## Support

For questions or issues with this dataset:
1. Check the sample queries in this README
2. Verify file paths and permissions
3. Ensure SQL Server version compatibility
4. Review error messages in SQL Server logs

---

*This dataset provides a comprehensive foundation for country-based applications and analysis.*
