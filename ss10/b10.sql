create view OfficialLanguageView as
select 
    ct.Code as CountryCode,
    ct.Name as CountryName,
    ctlg.Language as OfficialLanguage
from world.country ct
join world.countrylanguage ctlg on ctlg.CountryCode = ct.Code
where ctlg.IsOfficial = 'T';

select * from OfficialLanguageView;

create index idx_city_name on world.city(Name);


delimiter //
	create procedure GetSpecialCountriesAndCities (in language_name char(30))
	begin
		select 
			ct.Name as CountryName,
			c.Name as CityName,
			c.Population as CityPopulation,
			sum(c.Population) over (partition by ct.Code) as TotalPopulation
		from world.country ct
		join world.city c on c.CountryCode = ct.Code
		join world.countrylanguage ctlg on ctlg.CountryCode = ct.Code
		where ctlg.Language = language_name and ctlg.IsOfficial = 'T' and c.Name like 'New%'
		group by ct.Code, ct.Name, c.Name, c.Population
		having sum(c.Population) over (partition by ct.Code) > 5000000
		order by TotalPopulation desc
		limit 10;
end;
// delimiter ;

call GetSpecialCountriesAndCities('English');


