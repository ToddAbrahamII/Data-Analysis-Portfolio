/* Video Game Data Analysis */

/*Data Cleaning*/
SELECT * FROM VideoGames.dbo.game_sales_data;

--Finds nulls from each column
SELECT * 
FROM VideoGames.dbo.game_sales_data
WHERE 
Rank is null OR
Name is null OR
Platform is null OR
Publisher is null OR
Developer is null OR
Critic_Score is null OR
User_Score is null OR
Total_Shipped is null OR
Year is null;

--All Possible Platforms
SELECT DISTINCT Platform
FROM VideoGames.dbo.game_sales_data;

/*Best Selling Video Games*/
--All Platforms
SELECT TOP 10 Name, Platform, Total_Shipped, Year
FROM VideoGames.dbo.game_sales_data
ORDER BY Total_Shipped DESC;

--Xbox Best Selling Games
SELECT TOP 10 Name, Platform, Total_Shipped, Year
FROM VideoGames.dbo.game_sales_data
WHERE Platform = 'XB'
ORDER BY Total_Shipped DESC;

--PS4 Best Selling Games
SELECT TOP 10 Name, Platform, Total_Shipped, Year
FROM VideoGames.dbo.game_sales_data
WHERE Platform = 'PS4'
ORDER BY Total_Shipped DESC;

--Wii
SELECT TOP 10 Name, Platform, Total_Shipped, Year
FROM VideoGames.dbo.game_sales_data
WHERE Platform = 'Wii'
ORDER BY Total_Shipped DESC;

/*Best Reviewed Video Games*/
--Best Critic Score
SELECT TOP 10 Name, Platform, Publisher, Critic_Score, Year
FROM VideoGames.dbo.game_sales_data
ORDER BY Critic_Score DESC;

--Best User Score
SELECT TOP 10 Name, Platform, Publisher, User_Score, Year
FROM VideoGames.dbo.game_sales_data
ORDER BY User_Score DESC;

--Average score between critic and user scores
SELECT TOP 10 Name, Platform, Publisher, (Critic_Score + User_Score) /2 AS Total_Score, Year
FROM VideoGames.dbo.game_sales_data
ORDER BY ((Critic_Score + User_Score) /2) DESC;

/*Average Review Score of Video Games by Year*/
SELECT Year, AVG((Critic_Score + User_Score)/2) AS Average_Score
FROM VideoGames.dbo.game_sales_data
WHERE (Critic_Score + User_Score)/2 is not null
GROUP BY Year
ORDER BY Year;

/*Games to have been on the most platforms*/
SELECT TOP 10 Name, COUNT(Name) as Amount_Of_Platforms
FROM VideoGames.dbo.game_sales_data
GROUP BY NAME
ORDER BY COUNT(NAME) DESC;

