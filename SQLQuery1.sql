--Select * From PortfolioProject..CovidDeaths$
--order by 3,4 

Select Location, date, total_cases , new_cases , total_deaths,population
From PortfolioProject..CovidDeaths$
order by 1,2 

-- Looking at total cases vs total deaths 
Select Location, date, total_cases , total_deaths,population , (total_deaths/total_cases)*100 as deathPercentage
From PortfolioProject..CovidDeaths$
Where location like '%India%'
order by 1,2

-- Looking at total cases vs Population

Select Location, date, total_cases , total_deaths,population ,(total_cases/population)*100 as casePercentage
From PortfolioProject..CovidDeaths$
Where location like '%India%'
order by 1,2

--Looking at countries with highest infection rate compared to population
Select Location ,population,Max(total_deaths) as maxdeath, Max(total_cases) as HighiestInfection ,Max((total_cases/population)*100) as MaxcasePercentageInfected
From PortfolioProject..CovidDeaths$
--Where location like '%India%'
Group by Location, population
order by MaxcasePercentageInfected desc


-- Looking for continent 
Select location ,Max(cast(total_deaths as int)) as maxdeath
From PortfolioProject..CovidDeaths$
--Where location like '%India%'
where continent is null
Group by location
order by maxdeath desc

-- looking at countries with highest death count 
Select Location ,Max(cast(total_deaths as int)) as maxdeath
From PortfolioProject..CovidDeaths$
--Where location like '%India%'
where continent is not null
Group by Location, population
order by maxdeath desc



-- GLOBAL NUMBERS
Select date , SUM(new_cases) as totalcases, SUM(cast(new_deaths as int)) as totataldeaths, SUM(cast(new_deaths as int))/SUM(new_cases) *100 as DeathPer
From PortfolioProject..CovidDeaths$
--Where location like '%India%'
where continent is not null
Group by date
order by 1,2

--Looking at total Population vs Vaccination
 
  
  select dea.continent,dea.location,dea.date,vac.new_vaccinations,dea.population
, SUM(CONVERT(int, vac.new_vaccinations)) OVER(Partition by dea.Location Order by dea.location,dea.Date) as
 RollingPeopleVaccinated
 --, (RollingPeopleVaccinated/population)*100
  From PortfolioProject..CovidVaccinations$ vac
  join PortfolioProject..CovidDeaths$ dea
  on vac.date=dea.date
  AND vac.location=dea.location
  where dea.continent is not null
  order by 2,3

  --USE CTE

  With PopvsVac (Continent,location,date,population,new_vaccination,RollingPeopleVaccinated) as (
   select dea.continent,dea.location,dea.date,vac.new_vaccinations,dea.population
, SUM(CONVERT(int, vac.new_vaccinations)) OVER(Partition by dea.Location Order by dea.location,dea.Date) as
 RollingPeopleVaccinated
 --, (RollingPeopleVaccinated/population)*100
  From PortfolioProject..CovidVaccinations$ vac
  join PortfolioProject..CovidDeaths$ dea
  on vac.date=dea.date
  AND vac.location=dea.location
  where dea.continent is not null
  --order by 2,3
  )
  Select *, (RollingPeopleVaccinated/Population)*100
  From PopvsVac

