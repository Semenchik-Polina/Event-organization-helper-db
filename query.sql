-- все оценки и отзывы события
select rating_value, comment 
from rating, participant 
where participant.userratingid_part_event = 15 and participant.id_rating = rating.id_rating;

-- все события, на которых был 1-ый пользователь
select name, type, role 
from participant 
join part_event 
using (id_part_event) 
where id_user = 1;

-- все призы, которые выдавала компания Hero park
select name, place_numb, type, number 
from organization 
join prize 
using (id_organization) 
where name = 'Hero park';

-- информация о всех призах игры 
select place_numb, type, number 
from part_event_has_prize 
join prize using (id_prize)
where id_part_event = 9; 

-- расписание мероприятия 
select name, type, space, time as beginning, 
	date_add(time, interval (minute(duration) + hour(duration)*60) minute) as ending 
from part_event 
join scedule_info 
using (id_part_event) 
where part_event.id_event = 2;
 
-- все спикеры, когда-либо выступавшие их должности и места работы
select first_name, last_name, position, name
from participant
join user USING (id_user)
join organization on user.id_company = organization.id_organization
where role = 'Спикер';


-- промежуточные данные перед следующим запросом
-- город пользователя
select city from user where id_user = 6 into @userCity;

-- предложения мероприятий для пользователя:
-- все мероприятия 1) в его городе на месяц и по интересным ему темам 2) в его городе на неделю вперёд

-- в городе по интересным темам на месяц 
select name, subject_area, description, beginning_date, ending_date
    from event
	join (
	 -- подзапрос для поиска интересных пользователю тем (по уже посещённым мероприятиям)
		select subject_area  
		from event  
		join part_event
		using (id_event)
		join participant
		using (id_part_event) 
		where id_user = 6
	) userSubjects
    using (subject_area)
    join adress
    using (id_adress)
    where  city = (@userCity) and datediff(beginning_date, now())>7 and datediff(beginning_date, now())<31
    union 
    -- все в городе на неделю
	select name, subject_area, description, beginning_date, ending_date
	from event
	join adress
	using (id_adress)
	where city = (@userCity) and datediff(beginning_date, now())>-1 and datediff(beginning_date, now())<8;



