select 
    caption,
	id,
	name,
	is_active,
	entity,
	code
from adm_rights
where record_state <> 4