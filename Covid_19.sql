SELECT * FROM project.covid_deaths1;


select continent, location, date, population, total_cases, new_cases, total_deaths, new_deaths
from project.covid_deaths1
where continent is not null
order by 2;


select location, date, population, total_cases,total_deaths, (total_deaths/total_cases) *100 as DeathPercentage
from project.covid_deaths1
where continent is not null and location like 'Afghanistan'
order by 1;


select location, population, total_cases,total_deaths, (total_cases/population) *100 as CasePercentage
from project.covid_deaths1
where continent is not null -- and location like 'Afghanistan'
order by 1;


select location, population, max(total_deaths) as Total_death, max((total_cases/population)*100) as Max_Infection_rate
from project.covid_deaths1
where continent is not null
group by location, population
order by Total_death desc;


select location, population,max(total_deaths) as Total_death, max((total_cases/population)*100) as Max_Infection_rate
from project.covid_deaths1
where continent is null
group by continent
order by Total_death desc;


select date, sum(population) as TotalPopulation ,sum(new_cases) as total_cases, sum(new_deaths) as Total_deaths,
(sum(new_deaths)/sum(new_cases))*100 as Death_Percentage
from project.covid_deaths1
where continent is not null
group by date 
order by 3; 


SELECT * FROM project.covid_vaccination1;


select dea.continent,dea.location,dea.date, dea.population,vac.new_vaccinations,vac.people_vaccinated,sum(new_vaccinations) over (partition by dea.location Order by dea.location) as Rolling_People_vaccinated
from project.covid_deaths1 dea join project.covid_vaccination1 vac
on dea.location= vac.location and dea.date= vac.date
where dea.continent is not null and vac.people_vaccinated is not null
order by dea.location;

-- CTE
With Popsvsvac (continent, location, dates, Populations, New_vaccinations, People_vaccinated, Rolling_people_vaccinated) as
(
select dea.continent,dea.location,dea.date, dea.population,vac.new_vaccinations,vac.people_vaccinated,sum(new_vaccinations) over (partition by dea.location Order by dea.location) as Rolling_People_vaccinated
from project.covid_deaths1 dea join project.covid_vaccination1 vac
on dea.location= vac.location and dea.date= vac.date
where dea.continent is not null and vac.people_vaccinated is not null
order by dea.location
)
select * from Popsvsvac;


-- Temp table
Drop table if exists Percentpopulationvaccinated ;
Create table Percentpopulationvaccinated 
(
continent varchar(250),
location varchar(250),
dates date,
Population int,
new_vaccinations int,
People_vaccinated int,
Rolling_people_vaccinated int
);
Insert into Percentpopulationvaccinated
(
select dea.continent,dea.location,dea.date, dea.population,vac.new_vaccinations,vac.people_vaccinated,sum(new_vaccinations) over (partition by dea.location Order by dea.location) as Rolling_People_vaccinated
from project.covid_deaths1 dea join project.covid_vaccination1 vac
on dea.location= vac.location and dea.date= vac.date
where dea.continent is not null and vac.people_vaccinated is not null
order by dea.location
);
Select *,(Rolling_People_vaccinated/Population) as Percentage_vaccination from Percentpopulationvaccinated;


-- VIew creation
Create view Percent_pops_vac 
as select dea.continent,dea.location,dea.date, dea.population,vac.new_vaccinations,vac.people_vaccinated,sum(new_vaccinations) over (partition by dea.location Order by dea.location) as Rolling_People_vaccinated
from project.covid_deaths1 dea join project.covid_vaccination1 vac
on dea.location= vac.location and dea.date= vac.date
where dea.continent is not null
order by dea.location;