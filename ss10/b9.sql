create view CountryLanguageView as
select 
    ct.Code as CountryCode,
    ct.Name as CountryName,
    ctlg.Language,
    ctlg.IsOfficial
from world.country ct
join world.countrylanguage ctlg on ctlg.CountryCode = ct.Code
where ctlg.IsOfficial = 'T';

select * from CountryLanguageView;

delimiter //
create procedure getlargecitieswithenglish()
begin
    select 
        c.name as cityname,
        ct.name as countryname,
        c.population
    from city c
    join country ct on c.countrycode = ct.code
    join countrylanguage cl on c.countrycode = cl.countrycode
    where c.population > 1000000  
        and cl.language = 'english' 
        and cl.isofficial = 't'
    order by c.population desc
    limit 20;  
end;
// delimiter ;

call getlargecitieswithenglish();
drop procedure if exists GetLargeCitiesWithEnglish;