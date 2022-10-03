--USE projects
-- selecting top 10 & bottom 10 sold commodites
--SELECT b.Commodity AS commodities, cnt

--FROM

--(SELECT TOP 10 Commodity, COUNT(Commodity) AS cnt
--FROM [dbo].[CRIME_REVIEW_FOR_THE_MONTH_OF_J$]
--GROUP BY Commodity
--ORDER BY cnt) AS b

--UNION

--SELECT t.Commodity AS top10, cnt

--FROM

--(SELECT TOP 10 Commodity, COUNT(Commodity) AS cnt
--FROM [dbo].[CRIME_REVIEW_FOR_THE_MONTH_OF_J$]
--GROUP BY Commodity
--ORDER BY cnt DESC) AS t

--ORDER BY cnt DESC

---- viewing the states where the prices of commidities are the highest 
--SELECT state,Commodity, ranky

--FROM

--(SELECT state, commodity, RANK() OVER(PARTITION BY commodity ORDER BY [max price]) AS ranky
--FROM [dbo].[CRIME_REVIEW_FOR_THE_MONTH_OF_J$]) AS new

--WHERE ranky = 1

---- viewing which commodity is sold most by each state
--SELECT *,RANK() OVER(PARTITION BY state ORDER BY cnt DESC) AS ranky

--FROM

--(SELECT state,Commodity, COUNT(Commodity) AS cnt
--FROM [dbo].[CRIME_REVIEW_FOR_THE_MONTH_OF_J$]
--GROUP BY Commodity,state) AS test 

--ORDER BY state, commodity,ranky DESC  

---- finding the average pice of commodities
--SELECT Commodity, ROUND(AVG([max Price]),2) AS [average price]
--FROM [dbo].[CRIME_REVIEW_FOR_THE_MONTH_OF_J$]
--GROUP BY commodity
--ORDER BY [average price] DESC

---- adding a new category column to livestocks and edible stuffs
--SELECT TOP 10 *, CASE WHEN commodity IN ('ox','hen','bull','cow','calf','fish','duck','goat','he buffalo','pigs','she buffalo') THEN 'livestock' ELSE 'Edible' END AS category
--FROM [dbo].[CRIME_REVIEW_FOR_THE_MONTH_OF_J$]

---- viewing the percentage change of every commodity by two methods
----1. by self join
--SELECT state,District,Market,real.commodity,[Max Price],avg_price,CONCAT(ROUND((([Max Price]-avg_price)/avg_price) *100,2),'%') AS p_change


--FROM 

--(SELECT commodity,ROUND(avg([max price]),2) AS avg_price
--FROM [dbo].[CRIME_REVIEW_FOR_THE_MONTH_OF_J$]
--GROUP BY commodity) AS test, [dbo].[CRIME_REVIEW_FOR_THE_MONTH_OF_J$] AS real

--WHERE real.Commodity = test.Commodity

----2. by window function row_numbers were also added
--SELECT *,CONCAT(ROUND((([Max Price]-avg_price)/avg_price) *100,2),'%') AS p_change,CASE WHEN ROUND((([Max Price]-avg_price)/avg_price) *100,2) >0 
--THEN 'greater_than_avg' ELSE 'lesser_than_avg' END AS category
--FROM
--(SELECT state,District,Market,commodity,[max price],ROUND(avg([max price]) OVER(PARTITION BY commodity),2) as avg_price
--FROM [dbo].[CRIME_REVIEW_FOR_THE_MONTH_OF_J$]) AS test

---- the higest selling market of every state
--SELECT *
--FROM

--(SELECT *,rank() OVER(PARTITION BY state ORDER BY avg_modal DESC) AS ranky

--FROM

--(SELECT state,market,SUM([modal price]) AS avg_modal
--FROM [dbo].[CRIME_REVIEW_FOR_THE_MONTH_OF_J$]
--GROUP BY market,state) AS test) AS test2

--WHERE ranky =1 