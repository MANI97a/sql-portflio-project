select* 
from [portflio project]..[covid death]
order by 3,4

--select* 
--from [portflio project]..[covid vaccination]
--order by 3,4

select location,date, total_cases,new_cases,total_deaths, (total_deaths/total_cases)*100 as Deathpercentage
from [portflio project]..[covid death]
where location like '%india%'
order by 1,2

select location, date, population,  total_cases,(total_cases/population)*100 as infection_percentage
from [portflio project]..[covid death]
--where location like '%india%'
order by 1,2

select location, population, MAX(total_cases) as HighestinfectionCount, MAX(total_cases/population)*100 as percentagepopulation
from [portflio project]..[covid death]
group by location,population
order by percentagepopulation desc

select location , MAX(cast(total_deaths as int)) as totaldeathcount 
from [portflio project]..[covid death]
where continent is not null
group by location
order by totaldeathcount desc 

select continent , MAX(cast(total_deaths as int)) as totaldeathcount 
from [portflio project]..[covid death]
group by continent
order by totaldeathcount desc

select location,date, total_cases,new_cases,total_deaths, (total_deaths/total_cases)*100 as Deathpercentage
from [portflio project]..[covid death]
--where location like '%india%'
order by 1,2

select date , SUM(new_cases) as total_cases ,SUM(cast (new_deaths as int)) as total_death ,SUM(cast (new_deaths as int )) /SUM(new_cases)*100 as death_percentage
from [portflio project]..[covid death]
where continent is not null 
group by date
order by 1,2


select  SUM(new_cases) as total_cases ,SUM(cast (new_deaths as int)) as total_death ,SUM(cast (new_deaths as int )) /SUM(new_cases)*100 as death_percentage
from [portflio project]..[covid death]
where continent is not null 
--group by date
order by 1,2

select *
from [portflio project]..[covid death] dea
join [portflio project]..[covid vaccination] vac
on dea.location = vac.location
and dea.date =vac.date

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(convert(int,vac.new_vaccinations)) over (partition by dea.location, dea.date) as Rolliing_vaccination 
--, (Rolling_vaccination/population)*100
from [portflio project]..[covid death] dea
join [portflio project]..[covid vaccination] vac
on dea.location = vac.location
and dea.date =vac.date
where dea.continent is not null
order by 2,3

with popvsvac (continent,location,date,population,new_vaccinations,Rolling_vaccination)
as
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(convert(int,vac.new_vaccinations)) over (partition by dea.location, dea.date) as Rolling_vaccination 
--, (Rolling_vaccination/population)*100
from [portflio project]..[covid death] dea
join [portflio project]..[covid vaccination] vac
on dea.location = vac.location
and dea.date =vac.date
where dea.continent is not null
--order by 2,3
)
select*  ,(Rolling_vaccination/population)*100
from popvsvac


drop table if exists #percentpopulationvaccinated
create table #percentpopulationvaccinated
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccination numeric,
Rolling_vaccination numeric
)

insert into #percentpopulationvaccinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(convert(int,vac.new_vaccinations)) over (partition by dea.location, dea.date) as Rolling_vaccination 
--, (Rolling_vaccination/population)*100
from [portflio project]..[covid death] dea
join [portflio project]..[covid vaccination] vac
on dea.location = vac.location
and dea.date =vac.date
where dea.continent is not null
--order by 2,3
select *  ,(Rolling_vaccination/population)*100 as rollingpercentage
from #percentpopulationvaccinated

create view percentpopulationvaccinated as
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(convert(int,vac.new_vaccinations)) over (partition by dea.location, dea.date) as Rolling_vaccination 
--, (Rolling_vaccination/population)*100
from [portflio project]..[covid death] dea
join [portflio project]..[covid vaccination] vac
on dea.location = vac.location
and dea.date =vac.date
where dea.continent is not null
--order by 2,3


select *
from percentpopulationvaccinated






