select
	a.id,
	a.name as caption,
	a.region_id
from
	atu_city as a
where a.record_state <> 4