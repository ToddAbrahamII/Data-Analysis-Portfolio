BEGIN --USERS DATA CLEANING

--Check To Make Sure CSV Has Been Imported
SELECT * FROM PrecisionPlanting.dbo.Users;

--User_id is PK and cannot be null
--Check table for duplicate values in User_id row
SELECT User_ID, COUNT(*) as ID_Counter 
FROM PrecisionPlanting.dbo.Users 
GROUP BY User_id HAVING COUNT(*) > 1;

--Check table for duplicate values in Name row
SELECT Name, COUNT(*) as ID_Counter
FROM PrecisionPlanting.dbo.Users
GROUP BY Name HAVING COUNT(*) > 1;

--Select Rows that have multiple values
SELECT * 
FROM PrecisionPlanting.dbo.Users
WHERE Name = 'Claudia O''Connell V'
OR Name = 'Evan Corwin'
OR Name = 'Matilda Marvin'
OR Name = 'Mrs. Shannon Bogisich'
OR Name = 'Ofelia Shields'
ORDER BY NAME;

--Remove Rows where there are multiple values in Name
DELETE FROM PrecisionPlanting.dbo.Users
WHERE User_ID = 137
OR User_ID = 286
OR User_ID = 703
OR User_ID = 916
OR User_ID = 524;

--Find Nulls in Country Section
SELECT * 
FROM PrecisionPlanting.dbo.Users
WHERE Country is null;

--Remove nulls - No way to confirm what country they are from so they become irrelevant/incomplete data
DELETE FROM PrecisionPlanting.dbo.Users
WHERE Country is Null;

--NOTE: Users IDs that are removed: 137.286,524,703,899,900, 901, 902, 903, 904, 905, 916 **Important to view data that is linked to diagnostics

--Select Countries that say USA to United States so we have matching values
SELECT Country FROM PrecisionPlanting.dbo.Users WHERE Country != 'United States';

--Update Country to United States Section
UPDATE PrecisionPlanting.dbo.Users
SET Country = 'United States'
WHERE Country = 'USA';

--Select names that have titles in them
SELECT NAME
FROM PrecisionPlanting.dbo.Users
WHERE NAME LIKE 'Mr.%'		--Mr. Title
OR NAME LIKE 'Miss %'		--Miss Title
OR NAME LIKE 'Ms.%'			--Ms. Title
OR NAME LIKE 'Mrs.%'		--Mrs. Title
OR NAME LIKE 'Dr.%'			--Dr. Title
OR NAME LIKE '%DVM'			--DVM Degree
OR NAME LIKE '%DDS'			--DDS Degree
OR NAME LIKE '%MD'			--MS Degree
OR NAME LIKE '%PhD'			--PhD Degree
OR NAME LIKE '%ª%'			--Non English Character
OR NAME LIKE '% I'			--Redundant the first numeral
OR NAME LIKE ' %'			--Leading Space
OR NAME LIKE '% ';			--Trailing Space


--Removed Titles and Degree Names from the Name Column
-- Remove 'Mr.' title
UPDATE PrecisionPlanting.dbo.Users
SET NAME = REPLACE(NAME, 'Mr.', '')
WHERE NAME LIKE 'Mr.%';

--Remove 'Miss' title
Update PrecisionPlanting.dbo.Users
SET NAME = REPLACE(NAME, 'Miss ', '')
WHERE NAME LIKE 'Miss %';

-- Remove 'Ms.' title
UPDATE PrecisionPlanting.dbo.Users
SET NAME = REPLACE(NAME, 'Ms.', '')
WHERE NAME LIKE 'Ms.%';

-- Remove 'Mrs.' title
UPDATE PrecisionPlanting.dbo.Users
SET NAME = REPLACE(NAME, 'Mrs.', '')
WHERE NAME LIKE 'Mrs.%';

-- Remove 'Dr.' title
UPDATE PrecisionPlanting.dbo.Users
SET NAME = REPLACE(NAME, 'Dr.', '')
WHERE NAME LIKE 'Dr.%';

-- Remove 'DVM' degree
UPDATE PrecisionPlanting.dbo.Users
SET NAME = REPLACE(NAME, 'DVM', '')
WHERE NAME LIKE '%DVM';

-- Remove 'DDS' degree
UPDATE PrecisionPlanting.dbo.Users
SET NAME = REPLACE(NAME, 'DDS', '')
WHERE NAME LIKE '%DDS';

-- Remove 'MD' degree
UPDATE PrecisionPlanting.dbo.Users
SET NAME = REPLACE(NAME, 'MD', '')
WHERE NAME LIKE '%MD';

-- Remove 'PhD' degree
UPDATE PrecisionPlanting.dbo.Users
SET NAME = REPLACE(NAME, 'PhD', '')
WHERE NAME LIKE '%PhD';

-- Remove 'ª' character
UPDATE PrecisionPlanting.dbo.Users
SET NAME = REPLACE(NAME, 'ª', '')
WHERE NAME LIKE '%ª%';

-- Remove 'I' character
UPDATE PrecisionPlanting.dbo.Users
SET NAME = REPLACE(NAME, ' I', '')
WHERE NAME LIKE '% I';

-- Remove leading and trailing spaces
UPDATE PrecisionPlanting.dbo.Users
SET NAME = LTRIM(RTRIM(NAME));

END;

BEGIN --DIAGNOSTICS DATA CLEANING
--Check all data has been loaded
SELECT * FROM PrecisionPlanting.dbo.Diagnostic;

--Check for duplicate Diagnostic_IDs
SELECT Diagnostic_ID, COUNT(*) 
FROM PrecisionPlanting.dbo.Diagnostic
GROUP BY Diagnostic_ID
HAVING COUNT(*) > 1;

--Remove Hydraulic_Test where result is Unknown
SELECT *
FROM PrecisionPlanting.dbo.Diagnostic
WHERE Hydraulic_Test = 'Unknown';

--Remove NULLS in Columns Air_Temp_F, Moisture_Pct, Fuel_Level, and Unknowns in Hydraulic_Test
DELETE FROM PrecisionPlanting.dbo.Diagnostic
WHERE Hydraulic_Test = 'Unknown';

--Views all type of Issues
SELECT Issue
FROM PrecisionPlanting.dbo.Diagnostic
GROUP BY Issue;

--Issue Type Unknown Can stay because it provides numeric data for Pass
SELECT * 
FROM PrecisionPlanting.dbo.Diagnostic
WHERE Issue = 'Unknown'

--Check numerical data for air temperature
SELECT Air_Temp_F
FROM PrecisionPlanting.dbo.Diagnostic
GROUP BY Air_Temp_F;

--Investigate cases where Air temp = 999
SELECT *
FROM PrecisionPlanting.dbo.Diagnostic
WHERE Air_Temp_F = 999;

--Remove outliers in Air Temp 999
DELETE FROM PrecisionPlanting.dbo.Diagnostic
WHERE Diagnostic_Id = 36
OR Diagnostic_Id = 37
OR Diagnostic_ID = 38
OR Diagnostic_ID = 48
OR Diagnostic_ID = 49;

--Check numerical data for Moisture_Pct
SELECT Moisture_Pct
FROM PrecisionPlanting.dbo.Diagnostic
GROUP BY Moisture_Pct;

--Investigate 999 in Moisture Percentage
SELECT *
FROM PrecisionPlanting.dbo.Diagnostic
WHERE Moisture_Pct = 999;

--Remove 999 outliers
DELETE FROM PrecisionPlanting.dbo.Diagnostic
WHERE Diagnostic_ID = 10 OR Diagnostic_ID = 15;

--Investigate Fuel Level Numeric Values, Checks out all data looks good
SELECT Fuel_Level
FROM PrecisionPlanting.dbo.Diagnostic
GROUP BY Fuel_Level;

--Investigate Data in Hydraulic_Test, Checks out all data looks good
SELECT Hydraulic_Test
FROM PrecisionPlanting.dbo.Diagnostic
GROUP BY Hydraulic_Test;

END


BEGIN --DATA ANALYSIS OF TABLES

--Joins both tables together for viewing
SELECT *
FROM PrecisionPlanting.dbo.Diagnostic d
JOIN PrecisionPlanting.dbo.Users u ON u.User_id = d.User_id;

--Find AVGS for Test Passes
SELECT AVG(Air_Temp_F) as AVG_Air_Temp, AVG(Moisture_Pct) as AVG_Moist_Pct, AVG(Fuel_Level) as AVG_Fuel_Level, Hydraulic_Test
FROM PrecisionPlanting.dbo.Diagnostic d
JOIN PrecisionPlanting.dbo.Users u ON u.User_id = d. User_id
WHERE Hydraulic_Test = 'PASS'
GROUP BY  Hydraulic_Test;

--Finds AVGs for Test Fails
SELECT AVG(Air_Temp_F) as AVG_Air_Temp, AVG(Moisture_Pct) as AVG_Moist_Pct, AVG(Fuel_Level) as AVG_Fuel_Level, Hydraulic_Test
FROM PrecisionPlanting.dbo.Diagnostic d
JOIN PrecisionPlanting.dbo.Users u ON u.User_id = d. User_id
WHERE Hydraulic_Test = 'FAIL'
GROUP BY  Hydraulic_Test;

--Finds AVGs for Each Season
--Winter Pass (AVG)
SELECT AVG(Air_Temp_F) as AVG_Air_Temp, AVG(Moisture_Pct) as AVG_Moist_Pct, AVG(Fuel_Level) as AVG_Fuel_Level, Hydraulic_Test
FROM PrecisionPlanting.dbo.Diagnostic d
JOIN PrecisionPlanting.dbo.Users u ON u.User_id = d. User_id
WHERE Hydraulic_Test = 'PASS'
AND( Date LIKE '%-12-%'
OR Date LIKE '%-01-%'
OR Date LIKE '%-02-%')
GROUP BY  Hydraulic_Test;

--Winter Fail (AVG)
SELECT AVG(Air_Temp_F) as AVG_Air_Temp, AVG(Moisture_Pct) as AVG_Moist_Pct, AVG(Fuel_Level) as AVG_Fuel_Level, Hydraulic_Test
FROM PrecisionPlanting.dbo.Diagnostic d
JOIN PrecisionPlanting.dbo.Users u ON u.User_id = d. User_id
WHERE Hydraulic_Test = 'FAIL'
AND( Date LIKE '%-12-%'
OR Date LIKE '%-01-%'
OR Date LIKE '%-02-%')
GROUP BY  Hydraulic_Test;

--Spring Pass (AVG)
SELECT AVG(Air_Temp_F) as AVG_Air_Temp, AVG(Moisture_Pct) as AVG_Moist_Pct, AVG(Fuel_Level) as AVG_Fuel_Level, Hydraulic_Test
FROM PrecisionPlanting.dbo.Diagnostic d
JOIN PrecisionPlanting.dbo.Users u ON u.User_id = d. User_id
WHERE Hydraulic_Test = 'PASS'
AND( Date LIKE '%-03-%'
OR Date LIKE '%-04-%'
OR Date LIKE '%-05-%')
GROUP BY  Hydraulic_Test;

--Sprint Fail (AVG)
SELECT AVG(Air_Temp_F) as AVG_Air_Temp, AVG(Moisture_Pct) as AVG_Moist_Pct, AVG(Fuel_Level) as AVG_Fuel_Level, Hydraulic_Test
FROM PrecisionPlanting.dbo.Diagnostic d
JOIN PrecisionPlanting.dbo.Users u ON u.User_id = d. User_id
WHERE Hydraulic_Test = 'FAIL'
AND( Date LIKE '%-03-%'
OR Date LIKE '%-04-%'
OR Date LIKE '%-05-%')
GROUP BY  Hydraulic_Test;

--Summer Pass (AVG)
SELECT AVG(Air_Temp_F) as AVG_Air_Temp, AVG(Moisture_Pct) as AVG_Moist_Pct, AVG(Fuel_Level) as AVG_Fuel_Level, Hydraulic_Test
FROM PrecisionPlanting.dbo.Diagnostic d
JOIN PrecisionPlanting.dbo.Users u ON u.User_id = d. User_id
WHERE Hydraulic_Test = 'PASS'
AND( Date LIKE '%-06-%'
OR Date LIKE '%-07-%'
OR Date LIKE '%-08-%')
GROUP BY  Hydraulic_Test;

--Summer Fail (AVG)
SELECT AVG(Air_Temp_F) as AVG_Air_Temp, AVG(Moisture_Pct) as AVG_Moist_Pct, AVG(Fuel_Level) as AVG_Fuel_Level, Hydraulic_Test
FROM PrecisionPlanting.dbo.Diagnostic d
JOIN PrecisionPlanting.dbo.Users u ON u.User_id = d. User_id
WHERE Hydraulic_Test = 'FAIL'
AND( Date LIKE '%-06-%'
OR Date LIKE '%-07-%'
OR Date LIKE '%-08-%')
GROUP BY  Hydraulic_Test;

--Fall Pass (AVG)
SELECT AVG(Air_Temp_F) as AVG_Air_Temp, AVG(Moisture_Pct) as AVG_Moist_Pct, AVG(Fuel_Level) as AVG_Fuel_Level, Hydraulic_Test
FROM PrecisionPlanting.dbo.Diagnostic d
JOIN PrecisionPlanting.dbo.Users u ON u.User_id = d. User_id
WHERE Hydraulic_Test = 'PASS'
AND( Date LIKE '%-09-%'
OR Date LIKE '%-10-%'
OR Date LIKE '%-11-%')
GROUP BY  Hydraulic_Test;

--Fall Fail (AVG)
SELECT AVG(Air_Temp_F) as AVG_Air_Temp, AVG(Moisture_Pct) as AVG_Moist_Pct, AVG(Fuel_Level) as AVG_Fuel_Level, Hydraulic_Test
FROM PrecisionPlanting.dbo.Diagnostic d
JOIN PrecisionPlanting.dbo.Users u ON u.User_id = d. User_id
WHERE Hydraulic_Test = 'FAIL'
AND( Date LIKE '%-09-%'
OR Date LIKE '%-10-%'
OR Date LIKE '%-11-%')
GROUP BY  Hydraulic_Test;

--Count Passes and Fails in Each Season to calculate percents
SELECT COUNT(*)
FROM PrecisionPlanting.dbo.Diagnostic; --981

--Winter Pass Count
SELECT COUNT(*)
FROM PrecisionPlanting.dbo.Diagnostic d
JOIN PrecisionPlanting.dbo.Users u ON u.User_id = d. User_id
WHERE Hydraulic_Test = 'PASS'
AND( Date LIKE '%-12-%'
OR Date LIKE '%-01-%'
OR Date LIKE '%-02-%');

--Winter Fail Count
SELECT COUNT(*)
FROM PrecisionPlanting.dbo.Diagnostic d
JOIN PrecisionPlanting.dbo.Users u ON u.User_id = d. User_id
WHERE Hydraulic_Test = 'Fail'
AND( Date LIKE '%-12-%'
OR Date LIKE '%-01-%'
OR Date LIKE '%-02-%');

--Spring Pass Count
SELECT COUNT(*)
FROM PrecisionPlanting.dbo.Diagnostic d
JOIN PrecisionPlanting.dbo.Users u ON u.User_id = d. User_id
WHERE Hydraulic_Test = 'PASS'
AND( Date LIKE '%-03-%'
OR Date LIKE '%-04-%'
OR Date LIKE '%-05-%');

--Spring Fail Count
SELECT COUNT(*)
FROM PrecisionPlanting.dbo.Diagnostic d
JOIN PrecisionPlanting.dbo.Users u ON u.User_id = d. User_id
WHERE Hydraulic_Test = 'FAIL'
AND( Date LIKE '%-03-%'
OR Date LIKE '%-04-%'
OR Date LIKE '%-05-%');

--Summer Pass Count
SELECT COUNT(*)
FROM PrecisionPlanting.dbo.Diagnostic d
JOIN PrecisionPlanting.dbo.Users u ON u.User_id = d. User_id
WHERE Hydraulic_Test = 'PASS'
AND( Date LIKE '%-06-%'
OR Date LIKE '%-07-%'
OR Date LIKE '%-08-%');

--Summer Fail Count
SELECT COUNT(*)
FROM PrecisionPlanting.dbo.Diagnostic d
JOIN PrecisionPlanting.dbo.Users u ON u.User_id = d. User_id
WHERE Hydraulic_Test = 'FAIL'
AND( Date LIKE '%-06-%'
OR Date LIKE '%-07-%'
OR Date LIKE '%-08-%');

--Fall Pass Count
SELECT COUNT(*)
FROM PrecisionPlanting.dbo.Diagnostic d
JOIN PrecisionPlanting.dbo.Users u ON u.User_id = d. User_id
WHERE Hydraulic_Test = 'Pass'
AND( Date LIKE '%-09-%'
OR Date LIKE '%-10-%'
OR Date LIKE '%-11-%');

--Fall Fail Count
SELECT COUNT(*)
FROM PrecisionPlanting.dbo.Diagnostic d
JOIN PrecisionPlanting.dbo.Users u ON u.User_id = d. User_id
WHERE Hydraulic_Test = 'FAIL'
AND( Date LIKE '%-09-%'
OR Date LIKE '%-10-%'
OR Date LIKE '%-11-%');

--Break Down Issue into AVGs and Seasons import to excel
SELECT *
FROM PrecisionPlanting.dbo.Diagnostic d
JOIN PrecisionPlanting.dbo.Users u ON u.User_id = d. User_Id
WHERE Hydraulic_Test = 'FAIL'
GROUP BY User_id;

--Precision Planting
SELECT Name, COUNT(*)
FROM PrecisionPlanting.dbo.Diagnostic d
JOIN PrecisionPlanting.dbo.Users u ON u.User_id = d. User_Id
GROUP BY Name;

--Find Standard Deviation for Pass
SELECT STDEV(Air_Temp_F) as STDEV_Air_Temp, STDEV(Moisture_Pct) as STDEV_Moist_Pct, STDEV(Fuel_Level) as STDEV_Fuel_Level, Hydraulic_Test
FROM PrecisionPlanting.dbo.Diagnostic d
JOIN PrecisionPlanting.dbo.Users u ON u.User_id = d. User_id
WHERE Hydraulic_Test = 'PASS'
GROUP BY  Hydraulic_Test;

--Find Standard Deviation for Fail
SELECT STDEV(Air_Temp_F) as STDEV_Air_Temp, STDEV(Moisture_Pct) as STDEV_Moist_Pct, STDEV(Fuel_Level) as STDEV_Fuel_Level, Hydraulic_Test
FROM PrecisionPlanting.dbo.Diagnostic d
JOIN PrecisionPlanting.dbo.Users u ON u.User_id = d. User_id
WHERE Hydraulic_Test = 'FAIL'
GROUP BY  Hydraulic_Test;

--RESULTS: Larger Disbursment in Air Temp Fail, more variablity in the Fail Tests
--RESULTS: Larger Disbursment in Moist Pct Fail, more variability in the pass tests
--RESULTS: Lower Standard Deviation in the Fuel Level Meaning the fuel level is usually lower

--
SELECT *, (Air_Temp_F - Moisture_Pct) as Air_Difference
FROM PrecisionPlanting.dbo.Diagnostic d
JOIN PrecisionPlanting.dbo.Users u ON u.User_id = d. User_id
WHERE Hydraulic_Test = 'PASS'
ORDER BY Issue, Diagnostic_Id;

SELECT *, (Air_Temp_F - Moisture_Pct) as Air_Difference
FROM PrecisionPlanting.dbo.Diagnostic d
JOIN PrecisionPlanting.dbo.Users u ON u.User_id = d. User_id
WHERE Hydraulic_Test = 'FAIL'
ORDER BY Issue, Diagnostic_Id;

--Calculates Average Differenc in Temperature and Moisture
SELECT Issue, AVG(Air_Temp_F - Moisture_Pct) as AVG_Air_Difference, AVG(Air_Temp_F + Moisture_Pct + Fuel_Level) as AVG_Total_Value , AVG(Air_Temp_F - Fuel_Level) as AVG_Air_fuel_Dif, AVG(Moisture_Pct - Fuel_Level) as AVG_Moist_Fuel
FROM PrecisionPlanting.dbo.Diagnostic d
JOIN PrecisionPlanting.dbo.Users u ON u.User_id = d. User_id
WHERE Hydraulic_Test = 'PASS' 
GROUP BY Issue;

--Calculates Average Difference in Temperature and Moisture
SELECT Issue, AVG(Air_Temp_F - Moisture_Pct), AVG(Air_Temp_F + Moisture_Pct + Fuel_Level) as AVG_Total_Value, AVG(Air_Temp_F - Fuel_Level) as AVG_Air_fuel_Dif, AVG(Moisture_Pct - Fuel_Level) as AVG_Moist_Fuel
FROM PrecisionPlanting.dbo.Diagnostic d
JOIN PrecisionPlanting.dbo.Users u ON u.User_id = d. User_id
WHERE Hydraulic_Test = 'FAIL'
GROUP BY Issue;



END
