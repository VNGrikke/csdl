delimiter //
	create procedure get_ct_cl_popular(in language_popular char(30))
	begin
		select cl.CountryCode, cl.Language, cl.Percentage  
        from world.countrylanguage cl
		where cl.Percentage >= 50;
	end;
// delimiter ;

call get_ct_cl_popular('English');

drop procedure get_ct_cl_popular;

