select * from Covid_Deaths cd order by 3,4;
select * from Covid_Vaccination cv order by 3,4;

SELECT location , date ,total_cases ,new_cases ,total_deaths ,population from Covid_Deaths cd order by 1,2;

--Total Cases vs Total Deaths
--Perccentage of people dying if they are affected by covid 
SELECT location , date ,total_cases ,total_deaths ,(cast (total_deaths as real) /total_cases)*100 as DeathPercent
from Covid_Deaths cd 
where location = 'United States'
where continent  != ''
order by 1,2;

--Total Cases vs Population
--Percentage of population got covid
SELECT location , date ,population ,total_cases ,(cast (total_cases as float) /population)*100 as PercentPopulationInfected
from Covid_Deaths cd 
where location = 'United States'
where continent  != ''
order by 1,2;

--Countries with high infection rate
SELECT location ,population ,MAX(cast (total_cases as int)) as HighInfection ,Max(cast (total_cases as float) /population)*100 as HighPercentPopulationInfected
from Covid_Deaths cd 
--where location = 'United States'
where continent  != ''
GROUP by location,population 
order by HighPercentPopulationInfected desc;

--Countries with high death rate
SELECT date ,total_cases ,total_deaths ,cast (total_deaths as float)/total_cases as DeathPercent
from Covid_Deaths cd 
--where location = 'United States'
where location  ='World' 
order by 1;
--Total death percent all over the world per day
SELECT date ,sum(new_cases) as total_cases ,sum (new_deaths) as total_deaths ,cast (sum (new_deaths) as float)/sum(new_cases) as DeathPercent
from Covid_Deaths cd 
where continent  != ''
GROUP by date 
order by 1;

SELECT sum(new_cases) as total_cases ,sum (new_deaths) as total_deaths ,sum (cast(new_deaths) as float)/sum(new_cases) as DeathPercent
from Covid_Deaths cd 
where continent  != '' 
order by 1;

--Total Population vs Vaccination in a Temp table
Drop table if exists VaccinatedPeopleSoFar;
Create temp Table VaccinatedPeopleSoFar
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_Vaccination numeric,
VaccinatedPeople numeric
);
Insert into VaccinatedPeopleSoFar
select cd.continent ,cd.location ,cd.date ,cd.population ,cv.new_vaccinations ,
sum(cast(cv.new_vaccinations as float)) over (PARTITION by cd.location ORDER by cd.location ,cd.date) as VaccinatedPeople
from Covid_Deaths cd 
join Covid_Vaccination cv 
on cd.location =cv.location 
and cd.date = cv.date
and cd.continent != '';

select *,(Cast(VaccinatedPeople as Real)/Population)*100 as VaccinatedPeoplePercent from VaccinatedPeopleSoFar;

Drop view if exists V_VaccinatedPeopleSoFar;
Create view V_VaccinatedPeopleSoFar
as
select cd.continent ,cd.location ,cd.date ,cd.population ,cv.new_vaccinations ,
sum(cast(cv.new_vaccinations as float)) over (PARTITION by cd.location ORDER by cd.location ,cd.date) as VaccinatedPeople
from Covid_Deaths cd 
join Covid_Vaccination cv 
on cd.location =cv.location 
and cd.date = cv.date
and cd.continent != '';

SELECT * from V_VaccinatedPeopleSoFar ;




