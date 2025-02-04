SELECT
	app.ID,
--Expretise
	coalesce ( app.expertise_result, '')  AS expertise_result_enum,
    coalesce ( app.expertise_comment, '')  AS expertise_comment,
	COALESCE ( app.expertise_date, '1900-01-01' ) AS expertise_date,
	COALESCE ( app.performer_of_expertise, '00000000-0000-0000-0000-000000000000' ) AS performer_of_expertise_id,
	COALESCE ( eres.NAME, '' ) AS expertise_result,
--
	COALESCE ( app.org_unit_id, '00000000-0000-0000-0000-000000000000' ) AS org_unit_id,
    COALESCE(app.caption, '') as caption
FROM
	iml_applications AS app
	LEFT JOIN enum_record AS eres ON eres.enum_type = 'ExpertiseResult' 
	AND eres.code = app.expertise_result