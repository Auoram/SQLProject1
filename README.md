# Disaster Analysis Project
This project focuses on analyzing disaster-related data from emdat (Emergency Events Database) using SQL Server. It explores the frequency, human impact, and economic damage of disasters around the world, with a spotlight on Morocco.

## Dataset Preparation
The original dataset was too large and included many columns (https://www.kaggle.com/datasets/brsdincer/all-natural-disasters-19002021-eosdis)
So to simplify the workflow and optimize loading into SQL Server, I **manually split the dataset into two separate CSV files**:

### CSV Files:
1. **DisasterGeneral.csv**  
   Contained general information about each disaster:
   -  Dis No (common)
   -  Year (common)
   -  Seq
   -  Glide
   -  Disaster_Group
   -  Disaster_Subgroup
   -  Disaster_Type (common)
   -  Disaste_Subtype
   -  Disaster_Subsubtype
   -  Event_Name
   -  Country (common)
   -  ISO
   -  Region
   -  Continent
   -  Location
   -  Origin
   -  Associated_Dis
   -  Associated_Dis2
   -  OFDA_Response
   -  Appeal_Declaration
   -  Aid_Contribution
   -  Dis_Mag
   -  Value_Dis
   -  Mag_Scale
   -  Latitude
   -  Longitude
   -  Local_Time
   -  River_Basin
   -  Start_Year
   -  Start_Month
   -  Start_Day
   -  End_Year
   -  End_Month
   -  End_Day

2. **DisasterImpact.csv**  
   Contained data related to human and economic impacts:
   - Dis_No (common)
   - Year (common)
   - Country (common)
   - Disaster_Type (common)
   - Total_Deaths
   - No_Injured
   - No_Affected
   - No_Homeless
   - Total_Affected
   - Reconstruction_Costs_000_US
   - Insured_Damages_000_US
   - Total_Damages_000_US
   - CPI
   - Adm_Level
   - Admin1_Code
   - Admin2_Code
   - Geo_Locations

### Import to SQL Server
- The two CSV files were **imported into SQL Server Management Studio (SSMS)** using the **Import Wizard**.
- Each file was mapped to its own table:
  - `DisasterInfo`
  - `DisasterImpact`
This separation allowed for **modular querying** and easier management of the data, as analysis could focus independently on general disaster information or specific impacts.

---

## Tools & Technologies
- SQL Server Management Studio (SSMS)
- SQL for querying and analysis
- CSV for data exchange and preparation

---

## Author
 - Maroua Boumchich
