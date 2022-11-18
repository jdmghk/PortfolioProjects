Select *
From PortfolioProject..CovidDeaths
Where Continent is not null
order by 3,4


--Select *
--From PortfolioProject..CovidVaccinations
--order by 3,4

Select Location, date, total_cases, new_cases, total_deaths, population_density
From PortfolioProject..CovidDeaths
Where Continent is not null
order by 1,2

--Looking at Total Cases vs Total Deaths
-- Shows likelihood of dying of contracting covid in Nigeria
Select Location, date, total_cases, total_deaths, (total_deaths/total_cases) * 100 as DeathPercentage
From PortfolioProject..CovidDeaths
Where location = 'Nigeria' 
and Continent is not null
order by 1,2


-- Looking at Total Cases vs Population 
-- Shows what percentage of population got Covid 
Select Location, date, population,total_cases, (total_cases/population)*100 as PercentPopulationInfected
FROM PortfolioProject..CovidDeaths
WHERE location = 'Nigeria'
and Continent is not null
order by 1,2;

--Looking at Countries with Highest Infection Rate compared to Population
Select Location, population, MAX(total_cases) as HighestInfectionCount, Max((total_cases/population))*100 as PercentPopulationInfected
FROM PortfolioProject..CovidDeaths
--WHERE location = 'Nigeria'
Where Continent is not null
Group by location, population
order by PercentPopulationInfected desc;


--Showing Countries with Highest Death Count per Population
Select Location,  MAX(cast(total_deaths as int)) as TotalDeathCount
FROM PortfolioProject..CovidDeaths
--WHERE location = 'Nigeria'
Where Continent is not null
Group by location 
order by TotalDeathCount desc;


--Showing Continent with Highest Death Count per Population
Select Continent,  MAX(cast(total_deaths as int)) as TotalDeathCount
FROM PortfolioProject..CovidDeaths
--WHERE location = 'Nigeria'
Where Continent is null
Group by location 
order by TotalDeathCount desc;



--GLOBAL NUMBERS
Select date, SUM(new_cases) as total_cases, SUM(CAST(new_deaths as int)) as total_deaths, SUM(CAST(new_deaths as int))/SUM(New_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
--Where location = 'Nigeria' 
where Continent is not null
Group by date
order by 1,2

Select SUM(new_cases) as total_cases, SUM(CAST(new_deaths as int)) as total_deaths, SUM(CAST(new_deaths as int))/SUM(New_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
--Where location = 'Nigeria' 
where Continent is not null
--Group by date
order by 1,2



--Looking at Total Population as Vaccinations

--USE CTE
With PopvsVac (continent, location, date, population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CAST(vac.new_vaccinations as int))  OVER (Partition by dea.location order by dea.location,
   dea.date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
     On dea.location = vac.location
	 and dea.date = vac.date
where dea.continent is not null  
--order by 2,3
)
Select *, (RollingPeopleVaccinated/Population)*100 as percentvaccinated
From PopvsVac




-- TEMP TABLE

CREATE Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
);

 Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CAST(vac.new_vaccinations as int))  OVER (Partition by dea.location order by dea.location,
   dea.date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
     On dea.location = vac.location
	 and dea.date = vac.date
--where dea.continent is not null  
--order by 2,3

Select *, (RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated



--Creating View to store data for later visualizations

Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CAST(vac.new_vaccinations as int))  OVER (Partition by dea.location order by dea.location,
   dea.date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
     On dea.location = vac.location
	 and dea.date = vac.date
where dea.continent is not null  
--order by 2,3
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          
Select *
From PercentPopulationVaccinated