SELECT
	med."id",
	med.caption,
	med.medicine_name,
	med.producer_name,
	med.supplier_name,
	med.register_number,
	med.medicine_name_eng,
    med.application_id,
    (case 
		when imla.org_unit_id is not null then imla.org_unit_id
		when msg.org_unit_id is not null then msg.org_unit_id 
	end) as org_unit_id,
    msg.message_state,
    med.is_from_license,
    med.parent_id
FROM
	iml_medicines AS med
left join iml_applications as imla on imla.id = med.application_id
left join messages as msg on msg.id = med.application_id