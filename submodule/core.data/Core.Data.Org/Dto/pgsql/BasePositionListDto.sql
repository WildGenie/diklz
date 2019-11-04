select 
	p.id,
	p.name,
    p.caption,
	up.org_unit_id as organization_id
from cdn_position as p
join org_unit_position as up on up.position_id=p.id and up.record_state<>4
where p.record_state<>4