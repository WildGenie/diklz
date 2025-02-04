select
    a.caption,
	a.id,
	a.name,	
    coalesce(a.type_enum, '') as type_enum,	
    x1.name as type,	
	a.code,
	a.region_id,
	r.name as region_name
from
	atu_city as a
	inner join atu_region as r on a.region_id = r.id and r.record_state<>4
    left join enum_record as x1 on lower(x1.code) = lower(a.type_enum) and x1.enum_type = 'CityType'::text
where a.record_state <> 4