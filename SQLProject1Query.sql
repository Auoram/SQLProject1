Select * from DisasterInfos order by 2,7;

Select * from DisasterImpact order by 2,4;

--Display the deadliest disasters

SELECT Year, Dis_No, Total_Deaths
FROM DisasterImpact
WHERE Total_Deaths IS NOT NULL
ORDER BY Total_Deaths DESC;

--Total Damages per Country in Millions

SELECT Country,SUM(TRY_CAST(Total_Damages_000_US AS Int)) / 1000.0 AS TotalDamages_MillionUSD
FROM DisasterImpact
WHERE Total_Damages_000_US IS NOT NULL
GROUP BY Country
ORDER BY TotalDamages_MillionUSD DESC;

--Percentage of severely injured people out of the total affected population for each disaster event.

select Dis_No,Year,Disaster_Type,No_Injured,Total_Affected,(CAST(No_Injured AS FLOAT) / NULLIF(CAST(Total_Affected AS FLOAT), 0)) * 100 AS InjuredPercentage
from DisasterImpact
order by InjuredPercentage Desc;

--Total number of people affected, injured, or killed by disasters per country

select Country,(Sum(NULLIF(CAST(Total_Affected AS FLOAT), 0)) + Sum(NULLIF(CAST(Total_Deaths AS FLOAT), 0))) as Impact_on_human
from DisasterImpact
group by Country
order by Impact_on_human desc;

--The distribution (Counting) of disasters by type

SELECT Disaster_Type, COUNT(*) AS Disaster_Count
FROM DisasterImpact
GROUP BY Disaster_Type
ORDER BY Disaster_Count DESC;

--How many disasters occurred in Morocco

SELECT COUNT(*) AS Disaster_Count_Morocco
FROM DisasterImpact
WHERE Country like '%rocco%';

--Frequency of diasasters in morocco per decade

SELECT (Year / 10) * 10 AS Decade, COUNT(*) AS Disaster_Count
FROM DisasterImpact
WHERE Country = 'Morocco'
GROUP BY (Year / 10) * 10
ORDER BY Decade;

--Frequency of diasasters in each country per decade

SELECT Country,(Year / 10) * 10 AS Decade, COUNT(*) AS Disaster_Count
FROM DisasterImpact
GROUP BY Country ,(Year / 10) * 10
ORDER BY Country ,Decade;

--Total Deaths per Continent

SELECT di.Continent,SUM(imp.Total_Deaths) AS Total_Deaths
FROM DisasterInfos di
JOIN DisasterImpact imp ON di.Dis_No = imp.Dis_No
GROUP BY di.Continent
ORDER BY Total_Deaths DESC;

--The total deaths and average damage for each region and continent 

SELECT ifo.Region, ifo.Continent, 
SUM(imp.Total_Deaths) AS Total_Deaths_Per_Region,
AVG(TRY_CAST(imp.Total_Damages_000_US AS FLOAT)) AS Avg_Damage_Per_Region,
SUM(SUM(imp.Total_Deaths)) OVER (PARTITION BY ifo.Continent) AS Total_Deaths_Per_Continent,
AVG(AVG(TRY_CAST(imp.Total_Damages_000_US AS FLOAT))) OVER (PARTITION BY ifo.Continent) AS Avg_Damage_Per_Continent
FROM DisasterInfos ifo JOIN DisasterImpact imp ON ifo.Dis_No = imp.Dis_No
WHERE imp.Total_Deaths IS NOT NULL AND TRY_CAST(imp.Total_Damages_000_US AS FLOAT) IS NOT NULL
GROUP BY ifo.Region, ifo.Continent;

--The number of affected (not Total_Affected) people per disaster nature (subgroup)

WITH AffectedPerNature AS (
    SELECT inf.Disaster_Subgroup, SUM(CAST(imp.Total_Affected AS float)) AS Total_Affected
    FROM DisasterInfos inf JOIN DisasterImpact imp ON inf.Dis_No = imp.Dis_No
    WHERE imp.Total_Affected IS NOT NULL
    GROUP BY inf.Disaster_Subgroup
)
SELECT Disaster_Subgroup, Total_Affected
FROM AffectedPerNature
ORDER BY Total_Affected DESC;

--Using a Temporary table to get the number of disasters per subtype

CREATE TABLE #DisasterCountBySubtype (
    Disaster_Subtype NVARCHAR(100),
    Disaster_Count INT
);

INSERT INTO #DisasterCountBySubtype (Disaster_Subtype, Disaster_Count)
SELECT inf.Disaster_Subtype, COUNT(*) AS Disaster_Count
FROM DisasterInfos inf
GROUP BY inf.Disaster_Subtype
Order By Disaster_Count Desc;

select * from #DisasterCountBySubtype;

drop table #DisasterCountBySubtype;

--Creating views to store data for later visualisation

CREATE VIEW DisastersView AS
SELECT inf.Dis_No, inf.Continent, inf.Region, inf.Country, inf.Location, inf.Disaster_Type, inf.Associated_Dis AS Disaster_Subtype,
inf.Origin, TRY_CAST(imp.Total_Deaths AS INT) AS Total_Deaths,TRY_CAST(imp.Total_Affected AS INT) AS Total_Affected,
TRY_CAST(imp.Total_Damages_000_US AS FLOAT) AS Total_Damages_Million_USD, inf.Latitude, inf.Longitude
FROM DisasterInfos inf JOIN DisasterImpact imp ON inf.Dis_No = imp.Dis_No
WHERE imp.Total_Deaths IS NOT NULL OR imp.Total_Affected IS NOT NULL OR TRY_CAST(imp.Total_Damages_000_US AS FLOAT) IS NOT NULL;

