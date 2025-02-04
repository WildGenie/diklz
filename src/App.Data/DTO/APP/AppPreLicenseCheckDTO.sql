SELECT
	qry.ID,
	qry.app_id,
	qry.expertise_result_enum,
	qry.scheduled_start_date,
	qry.scheduled_end_date,
	qry.check_created_id,
	qry.creation_date_of_check,
	qry.end_date_of_check,
	qry.result_of_check,
	qry.caption 
FROM
(
	select
		pre.ID,
		pre.app_id,
		prl.expertise_result AS expertise_result_enum,
		pre.scheduled_start_date,
		pre.scheduled_end_date,
		pre.check_created_id,
		pre.creation_date_of_check,
		pre.end_date_of_check,
		pre.result_of_check,
		COALESCE ( pre.caption, '' ) AS caption,
		pre.record_state
	from
		app_pre_license_checks AS pre
		LEFT JOIN prl_applications AS prl ON prl.ID = pre.app_id 
	
	union
	
	select
		pre.ID,
		pre.app_id,
		iml.expertise_result AS expertise_result_enum,
		pre.scheduled_start_date,
		pre.scheduled_end_date,
		pre.check_created_id,
		pre.creation_date_of_check,
		pre.end_date_of_check,
		pre.result_of_check,
		COALESCE ( pre.caption, '' ) AS caption,
		pre.record_state
	from
		app_pre_license_checks AS pre
		LEFT JOIN prl_applications AS iml ON iml.ID = pre.app_id 
		
	union
	
	select
		pre.ID,
		pre.app_id,
		trl.expertise_result AS expertise_result_enum,
		pre.scheduled_start_date,
		pre.scheduled_end_date,
		pre.check_created_id,
		pre.creation_date_of_check,
		pre.end_date_of_check,
		pre.result_of_check,
		COALESCE ( pre.caption, '' ) AS caption,
		pre.record_state
	from
		app_pre_license_checks AS pre
		LEFT JOIN prl_applications AS trl ON trl.ID = pre.app_id
) qry
WHERE
	qry.record_state <> 4