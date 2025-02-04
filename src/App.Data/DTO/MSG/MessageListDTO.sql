SELECT
	mes.ID,
	mes.created_on,
	mes.message_date AS message_date,
	COALESCE ( mes.message_number, '' ) AS message_number,
	COALESCE ( mes.reg_number, '' ) AS reg_number,
	COALESCE ( mes.reg_date, '1900-01-01' ) AS reg_date,
	mes.message_type AS message_type_enum,
	message_type.NAME AS message_type_name,
	COALESCE ( orz.edrpou, '' ) AS edrpou,
	COALESCE ( orz.inn, '' ) AS inn,
	COALESCE ( orz.NAME, '' ) AS org_name,
	is_prl_license,
	is_iml_license,
	is_trl_license,
	COALESCE (concat(
		CASE WHEN is_prl_license THEN 'Виробництва' ELSE''  END,',',
		CASE WHEN is_iml_license THEN 'Імпорту' ELSE'' END,',',
		CASE WHEN is_trl_license THEN 'Торгівлі' ELSE'' END  )) AS license_types,
	COALESCE (concat(
		CASE WHEN is_prl_license THEN 'PRL' ELSE'' END,',',
		CASE WHEN is_iml_license THEN 'IML' ELSE'' END,',',
		CASE WHEN is_trl_license THEN 'TRL' ELSE'' END )) AS license_activity,
	CASE WHEN is_prl_license THEN (SELECT message_state FROM messages as ms WHERE mes.id = ms.message_parent_id and ms.is_prl_license = true) ELSE '' END as state_prl_enum,
	CASE WHEN is_iml_license THEN (SELECT message_state FROM messages as ms WHERE mes.id = ms.message_parent_id and ms.is_iml_license = true) ELSE '' END as state_iml_enum,
	CASE WHEN is_trl_license THEN (SELECT message_state FROM messages as ms WHERE mes.id = ms.message_parent_id and ms.is_trl_license = true) ELSE '' END as state_trl_enum,
	COALESCE ( mes.message_hierarchy_type, '' ) AS message_hierarchy_type_enum,
	( person.last_name || ' ' || person.NAME || ' ' || person.middle_name ) AS sender_name,
	state_enum.NAME AS message_state,
	mes.message_state AS message_state_enum,
	COALESCE ( mes.org_unit_id, '00000000-0000-0000-0000-000000000000' ) AS org_unit_id,
	mes.is_created_on_portal AS is_created_on_portal,
	COALESCE ( mes.caption, '' ) AS caption 
FROM
	messages AS mes
	INNER JOIN person ON mes.created_by = person.ID AND person.record_state <> 4
	LEFT JOIN enum_record AS message_type ON message_type.enum_type = 'MessageType' AND message_type.code = mes.message_type
	LEFT JOIN enum_record AS state_enum ON state_enum.enum_type = 'MessageState' AND state_enum.code = mes.message_state
	LEFT JOIN org_organization AS orz ON orz.ID = mes.org_unit_id 
WHERE
	mes.record_state <> 4