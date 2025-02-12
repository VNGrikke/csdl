delimiter //
	create procedure GetCountriesByCityNames ()
	begin
		select 
			ct.Name as CountryName, 
			ctlg.Language as OfficialLanguage, 
			sum(c.Population) as TotalPopulation
		from world.country ct
		join world.city c on c.CountryCode = ct.Code
		join world.countrylanguage ctlg on ctlg.CountryCode = ct.Code
		where ctlg.IsOfficial = 'T'
		and c.Name like 'A%'
		group by ct.Name, ctlg.Language
		having sum(c.Population) > 2000000
		order by ct.Name asc;
	end;
// delimiter ;

call GetCountriesByCityNames();

drop procedure GetCountriesByCityNames;
