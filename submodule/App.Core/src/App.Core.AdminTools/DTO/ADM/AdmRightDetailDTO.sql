select 
caption,
id,
	name,
	is_active,
	entity,
	properties_as_json,
	code
from adm_rights
where record_state <> 4