select
    x.caption,
	x.id,
	x.name,
	x.code,
	x.parent_id,
	p.name as parent,
	x.description,
    x.subject_address_id :: text as atu_address_guids
from
	org_unit as x
	left join ( select id, name
			from org_unit as u
			where u.record_state <> 4 ) as p on x.parent_id = p.id
where ( x.record_state <> 4 )