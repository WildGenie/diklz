select
    a.caption,
	a.id,
	a.caption as name,
	a.code,
	a.parent_id,
	par.caption as parent_name,
	a.country_id as atu_country_id,
	c.caption as atu_country_name
from atu_region as a left join atu_country as c on a.country_id=c.id and c.record_state<>4
						left join atu_region as par on a.parent_id=par.id and par.record_state<>4
where a.record_state <> 4