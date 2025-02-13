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
create procedure getspecialcountriesandcities (in language_name varchar(50))
begin
    select 
        ct.name as countryname, 
        c.name as cityname, 
        c.population as citypopulation
    from world.country ct
    join world.city c on c.countrycode = ct.code
    join world.countrylanguage ctlg on ctlg.countrycode = ct.code
    where ctlg.language = language_name
        and c.name like 'new%'
        and ct.Population > 5000000
    order by citypopulation desc
    limit 10;
end;
// delimiter ;


call GetSpecialCountriesAndCities('English');

drop procedure GetSpecialCountriesAndCities;