delimiter //
create procedure UpdateCityPopulation (inout city_id int, in new_population int)
begin
    declare tmp_city_id int default city_id;
    declare tmp_new_population int default new_population;
    
    update world.city c
    set c.Population = tmp_new_population
    where c.ID = tmp_city_id;
end;
// delimiter ;

set @city_id = 34;

call UpdateCityPopulation(@city_id, 15112005);

drop procedure UpdateCityPopulation;