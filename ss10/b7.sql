delimiter //
	create procedure GetEnglishSpeakingCountriesWithCities (in main_language char(30))
	begin
		select ct.Name as CountryName, sum(c.Population) as TotalPopulation
		from world.country ct
		join world.city c on c.CountryCode = ct.Code
		join world.countrylanguage ctlg on ctlg.CountryCode = ct.Code
		where ctlg.Language = main_language and ctlg.IsOfficial = 'T'
		group by ct.Name
		having sum(c.Population) > 5000000
		order by TotalPopulation desc
		limit 10;
	end;
// delimiter ;

call GetEnglishSpeakingCountriesWithCities('English');

drop procedure GetEnglishSpeakingCountriesWithCities;
