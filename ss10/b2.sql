delimiter //
	create procedure CalculatePopulation(in country_code varchar(10), out total_population int)
	begin
		select 
			sum( c.Population) into total_population
        from world.city c
		where c.CountryCode = country_code;
	end;
// delimiter ;

call CalculatePopulation('AFG', @total_population);
select @total_population;

drop procedure CalculatePopulation;