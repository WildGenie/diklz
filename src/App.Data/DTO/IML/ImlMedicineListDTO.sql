SELECT
	med."id",
	med.caption,
	med.medicine_name,
	med.producer_name,
	med.supplier_name,
	med.register_number,
	med.medicine_name_eng,
    med.application_id,
    imla.org_unit_id,
    med.is_from_license
FROM
	iml_medicines AS med
left join iml_applications as imla on imla.id = med.application_id