select 
coalesce(u.caption, '') as caption,
u.id,
coalesce(u.name, '') as name,
p.full_name || ' ' || p.name || ' ' || p.middle_name as person_name
from adm_users as u 
	left join person as p on u.person_id=p.id
where u.record_state <> 4