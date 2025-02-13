delimiter //
	create procedure GetCountriesWithLargeCities ()
	begin
		select 
			ct.name as countryname, 
			sum(c.population) as totalpopulation
		from world.city c
		inner join world.country ct on c.countrycode = ct.code
		where ct.continent = 'asia'
		group by ct.name
		having totalpopulation > 10000000
		order by totalpopulation desc;
	end
// delimiter ;

call GetCountriesWithLargeCities ();

drop procedure GetCountriesWithLargeCities ;

