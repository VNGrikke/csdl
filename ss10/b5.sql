delimiter //
	create procedure GetLargeCitiesByCountry (in country_code varchar(3))
	begin
		select c.ID, c.name, c.Population  
        from world.city c
		where c.CountryCode = country_code and c.Population > 1000000;
	end;
// delimiter ;


call GetLargeCitiesByCountry('AFG');


drop procedure GetLargeCitiesByCountry;