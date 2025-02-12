use world;	

SELECT * FROM world.city;

delimiter //
	create procedure get_info_city(in country_code varchar(10))
	begin
		select c.ID, c.name, c.Population  
        from world.city c
		where c.CountryCode = country_code;
	end;
// delimiter ;


call get_info_city('AFG');


drop procedure get_info_city;