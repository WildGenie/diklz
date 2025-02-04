SELECT
	qry.id,
	qry.app_id,
	qry.expertise_result_enum,
	qry.decision_type,
	qry.message_number,
	qry.date_of_message,
	qry.signed_job_position,
	qry.signed_full_name,
	qry.performer as performer_id,
	qry."state",
	qry.attached_file,
	qry.caption
FROM
(
	select
		app_license_messages.id as id,
		app_license_messages.app_id,
		COALESCE(prl.expertise_result, '') AS expertise_result_enum,
		COALESCE(decision.decision_type, '') AS decision_type,
		message_number,
		date_of_message,
		signed_job_position,
		signed_full_name,
		performer,
		"state",
		attached_file,
		COALESCE ( app_license_messages.caption, '' ) AS caption,
		app_license_messages.record_state
	from
		app_license_messages 
		LEFT JOIN prl_applications AS prl ON prl.ID = app_license_messages.app_id
		LEFT JOIN app_decisions as decision ON decision.id = prl.app_decision_id
		
	union
	
	select
		app_license_messages.id as id,
		app_license_messages.app_id,
		COALESCE(iml.expertise_result, '') AS expertise_result_enum,
		COALESCE(decision.decision_type, '') AS decision_type,
		message_number,
		date_of_message,
		signed_job_position,
		signed_full_name,
		performer,
		"state",
		attached_file,
		COALESCE ( app_license_messages.caption, '' ) AS caption,
		app_license_messages.record_state
	from
		app_license_messages 
		LEFT JOIN iml_applications AS iml ON iml.ID = app_license_messages.app_id
		LEFT JOIN app_decisions as decision ON decision.id = iml.app_decision_id
		
	union
	
	select
		app_license_messages.id as id,
		app_license_messages.app_id,
		COALESCE(trl.expertise_result, '') AS expertise_result_enum,
		COALESCE(decision.decision_type, '') AS decision_type,
		message_number,
		date_of_message,
		signed_job_position,
		signed_full_name,
		performer,
		"state",
		attached_file,
		COALESCE ( app_license_messages.caption, '' ) AS caption,
		app_license_messages.record_state
	from
		app_license_messages 
		LEFT JOIN trl_applications AS trl ON trl.ID = app_license_messages.app_id
		LEFT JOIN app_decisions as decision ON decision.id = trl.app_decision_id
) qry
WHERE
	qry.record_state <> 4 and qry.expertise_result_enum is not null and qry.expertise_result_enum <> ''