Select *
From PotfolioProjects..CovidDeaths
Where continent is not null 
Order by 3,4

--Select *
--From PotfolioProjects..CovidVaccinations
--Order by 3,4

Select Location, date, total_cases, new_cases, total_deaths, population
From PotfolioProjects..CovidDeaths
order by 1,2


--Total Cases Vs TotalDeaths
Select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From PotfolioProjects..CovidDeaths
Where location like '%states%'
order by 1,2

--Percentage of people who got Covid
Select Location, date, population, total_cases, (total_cases/population)*100 as DeathPercentage
From PotfolioProjects..CovidDeaths
Where location like '%states%'
order by 1,2


Select Location, date, population, total_cases, (total_cases/population)*100 as DeathPercentage
From PotfolioProjects..CovidDeaths
--Where location like '%states%'
order by 1,2


--Countries with Highest Infection Rate compared to Population
Select Location, population, MAX(total_cases) as HighestInfectionCount, MAX(total_cases/population)*100 as PercentPopulationInfected
From PotfolioProjects..CovidDeaths
--Where location like '%states%'
Where continent is not null 
Group by Location,Population
order by PercentPopulationInfected desc




--Continents with the highest death count per population
Select continent, MAX(cast(Total_deaths as int)) as TotalDeathCount
From PotfolioProjects..CovidDeaths
--Where location like '%states%'
Where continent is not null 
Group by continent
order by TotalDeathCount desc


--Global Numbers
Select date,SUM(new_cases), SUM(cast(new_deaths as int)) --total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From PotfolioProjects..CovidDeaths
--Where location like '%states%'
where continent is not null
Group by date
order by 1,2




Select date, SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100  as DeathPercentage
From PotfolioProjects..CovidDeaths
--Where location like '%states%'
where continent is not null
Group by date
order by 1,2


Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100  as DeathPercentage
From PotfolioProjects..CovidDeaths
--Where location like '%states%'
where continent is not null
--Group by date
order by 1,2


--Total population Vs Vaccinations
Select *
From PotfolioProjects..CovidDeaths dea
Join PotfolioProjects..CovidVaccinations vac
	On dea.location=vac.location
	and dea.date=vac.date



Select dea.continent, dea.location,dea.date, dea.population, vac.new_vaccinations
From PotfolioProjects..CovidDeaths dea
Join PotfolioProjects..CovidVaccinations vac
	On dea.location=vac.location
	and dea.date=vac.date
	Where dea.continent is not null
	order by 2,3

	Select dea.continent, dea.location,dea.date, dea.population, vac.new_vaccinations
	,SUM(cast(vac.new_vaccinations as int)) OVER (Partition by dea.location Order by dea.Location, dea.date)
From PotfolioProjects..CovidDeaths dea
Join PotfolioProjects..CovidVaccinations vac
	On dea.location=vac.location
	and dea.date=vac.date
	Where dea.continent is not null
	order by 2,3

	--USE CTE
	With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
	as
	(
	 Select dea.continent, dea.location,dea.date, dea.population, vac.new_vaccinations
	,SUM(cast(vac.new_vaccinations as int)) OVER (Partition by dea.location Order by dea.Location, 
	dea.date) as  RollingPeopleVaccinated
	--,(RollingPeopleVaccinated/population)*100
From PotfolioProjects..CovidDeaths dea
Join PotfolioProjects..CovidVaccinations vac
	On dea.location=vac.location
	and dea.date=vac.date
	Where dea.continent is not null
	--order by 2,3
	)
	Select*, (RollingPeopleVaccinated/Population)*100
	From PopvsVac


	--TEMP TABLE
	
	DROP Table if exists  #PercentPopulationVaccinated
	Create Table #PercentPopulationVaccinated
	(
	Continent nvarchar(255),
	Location nvarchar(255),
	Date datetime,
	Population numeric,
	New_vaccinations numeric,
	RollingPeopleVaccinated numeric
	)

	Insert into  #PercentPopulationVaccinated
	 Select dea.continent, dea.location,dea.date, dea.population, vac.new_vaccinations
	,SUM(cast(vac.new_vaccinations as int)) OVER (Partition by dea.location Order by dea.Location, 
	dea.date) as  RollingPeopleVaccinated
	--,(RollingPeopleVaccinated/population)*100
From PotfolioProjects..CovidDeaths dea
Join PotfolioProjects..CovidVaccinations vac
	On dea.location=vac.location
	and dea.date=vac.date
	-- Where dea.continent is not null
	--order by 2,3

	Select*, (RollingPeopleVaccinated/Population)*100
	From #PercentPopulationVaccinated


	--Creating view to store data for later visualization
	Create view PercentPopulationVaccinated as
	Select dea.continent, dea.location,dea.date, dea.population, vac.new_vaccinations
	,SUM(cast(vac.new_vaccinations as int)) OVER (Partition by dea.location Order by dea.Location, 
	dea.date) as  RollingPeopleVaccinated
	--,(RollingPeopleVaccinated/population)*100
From PotfolioProjects..CovidDeaths dea
Join PotfolioProjects..CovidVaccinations vac
	On dea.location=vac.location
	and dea.date=vac.date
	Where dea.continent is not null
	--order by 2,3


	Select *
	From PercentPopulationVaccinated 