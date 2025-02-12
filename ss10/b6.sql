delimiter //
	create procedure GetCountriesWithLargeCities ()
	begin
		select 
			country.name as countryname, 
			sum(city.population) as totalpopulation
		from world.city city
		inner join world.country country on city.countrycode = country.code
		where country.continent = 'asia'
		group by country.name
		having totalpopulation > 10000000
		order by totalpopulation desc;
	end
// delimiter ;

call GetCountriesWithLargeCities ();

drop procedure GetCountriesWithLargeCities ;
