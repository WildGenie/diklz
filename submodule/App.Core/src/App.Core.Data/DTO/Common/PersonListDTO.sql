Select 
        caption,
		id,
		last_name || ' ' || name || ' ' || middle_name as name
from person
where record_state<>4