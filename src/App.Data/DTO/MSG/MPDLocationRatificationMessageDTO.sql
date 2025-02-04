select 
                                                                      --MESSAGE BASE DETAIL DTO START
    mes.id,
    mes.message_date                                                    as message_date,
    coalesce(mes.org_unit_id, '00000000-0000-0000-0000-000000000000')      as org_unit_id,
    mes.message_number                                                as message_number,
    mes.message_type                                                  as message_type,
    mes.message_text                                                  as message_text,
    mes.is_iml_license                                                  as is_iml_license,
    mes.is_prl_license                                                  as is_prl_license,
    mes.is_trl_license                                                  as is_trl_license,
    mes.is_created_on_portal											as is_created_on_portal,
    coalesce(mes.caption, '')                                         as caption,
                                                                      --MESSAGE BASE DETAIL DTO END
--ATU START
    coalesce(mes.address_business_activity_id, '00000000-0000-0000-0000-000000000000') as address_business_activity_id,
    coalesce(street.ID, '00000000-0000-0000-0000-000000000000') AS street_id,
	coalesce(street.NAME, '') AS street_name,
	coalesce(city.ID, '00000000-0000-0000-0000-000000000000') AS city_id,
	coalesce(city.NAME, '') AS city_name,
    coalesce(city.type_enum, '') AS city_enum,
	coalesce(region.ID, '00000000-0000-0000-0000-000000000000') AS region_id,
	coalesce(region.NAME, '') AS region_name,
	coalesce(subject_address.post_index, '') AS post_index,
	coalesce(subject_address.building, '') AS building,
    coalesce(subject_address.address_type, '') AS address_type,
    coalesce((select name from atu_region as reg where substring(reg.code,0,6) = substring(city.code,0,6) limit 1), '') as district_name,
--ATU END
    mes.mpd_selected_id											       as mpd_selected_id
from messages as mes
--ATU START
    LEFT JOIN atu_subject_address AS subject_address ON mes.new_location_id = subject_address.id
	LEFT JOIN atu_street AS street ON subject_address.street_id = street.ID
    LEFT JOIN atu_city AS city ON street.city_id = city.ID
    LEFT JOIN atu_region AS region ON city.region_id = region.ID 
--ATU END
where mes.record_state <> 4