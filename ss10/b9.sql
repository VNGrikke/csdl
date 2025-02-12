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
