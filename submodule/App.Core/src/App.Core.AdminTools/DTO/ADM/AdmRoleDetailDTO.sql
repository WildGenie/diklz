select 
    x.caption,
	x.id,
	x.name,
	x.code,
	x.is_active,    
    array_to_string(array(
        select ro.name
        FROM adm_role_adm_rights AS rr
            join adm_rights as ro on rr.adm_right_id=ro.id
        WHERE (rr.record_state <> 4) and (x.id = rr.adm_role_id)
        ), ', ') as rights_info,
	array_to_string(array(
		select rr.adm_right_id
		FROM adm_role_adm_rights AS rr
		WHERE (rr.record_state <> 4) and (x.id = rr.adm_role_id)
	), '|') AS rights_string
from adm_roles x
where x.record_state <> 4