SELECT
  qry.app_decision_closed as is_closed,
	qry.app_decision_id as id,
	qry.org_unit_id,
  qry.expertise_result_enum,
	qry.decision_reasons,
	qry.app_id,
	qry.decision_type,
	qry.date_of_start,
	qry.protocol_id,
	qry.protocol_number,
	qry.date_of_protocol,
	qry.decision_description,
	qry.paid_money,
	qry.notes,
	qry.caption 
FROM
	(
		--prl
		select
			app_decisions.is_closed as app_decision_closed,
			app_decisions.ID as app_decision_id,
			lims.org_unit_id AS org_unit_id,
			prl.expertise_result AS expertise_result_enum,
			STRING_AGG ( reason.reason_type, ',' ) AS decision_reasons,
			app_id,
			decision_type,
			date_of_start,
			COALESCE ( protocol_id, '00000000-0000-0000-0000-000000000000' ) AS protocol_id,
			COALESCE ( protocol.protocol_number, '' ) AS protocol_number,
			COALESCE ( protocol.protocol_date, '1900-01-01' ) AS date_of_protocol,
			decision_description,
			paid_money,
			notes,
			COALESCE ( app_decisions.caption, '' ) AS caption,
			app_decisions.record_state
		from
			app_decisions
			LEFT JOIN lims_docs AS lims ON lims.ID = app_decisions.app_id
			LEFT JOIN app_decision_reasons AS reason ON reason.app_decision_id = app_decisions.ID
			LEFT JOIN app_protocols AS protocol ON protocol.ID = protocol_id 
			LEFT JOIN prl_applications AS prl ON prl.ID = app_decisions.app_id
	GROUP BY
	app_decisions.is_closed ,
			app_decisions.ID ,
			lims.org_unit_id ,
			prl.expertise_result ,
			--STRING_AGG ( reason.reason_type, ',' ) AS decision_reasons,
			app_id,
			decision_type,
			date_of_start,
			COALESCE ( protocol_id, '00000000-0000-0000-0000-000000000000' ) ,
			COALESCE ( protocol.protocol_number, '' ) ,
			COALESCE ( protocol.protocol_date, '1900-01-01' ) ,
			decision_description,
			paid_money,
			notes,
			COALESCE ( app_decisions.caption, '' ) ,
			app_decisions.record_state
		
		union
		--iml
		select
			app_decisions.is_closed as app_decision_closed,
			app_decisions.ID as app_decision_id,
			lims.org_unit_id AS org_unit_id,
			iml.expertise_result AS expertise_result_enum,
			STRING_AGG ( reason.reason_type, ',' ) AS decision_reasons,
			app_id,
			decision_type,
			date_of_start,
			COALESCE ( protocol_id, '00000000-0000-0000-0000-000000000000' ) AS protocol_id,
			COALESCE ( protocol.protocol_number, '' ) AS protocol_number,
			COALESCE ( protocol.protocol_date, '1900-01-01' ) AS date_of_protocol,
			decision_description,
			paid_money,
			notes,
			COALESCE ( app_decisions.caption, '' ) AS caption,
			app_decisions.record_state
		from
			app_decisions
			LEFT JOIN lims_docs AS lims ON lims.ID = app_decisions.app_id
			LEFT JOIN app_decision_reasons AS reason ON reason.app_decision_id = app_decisions.ID
			LEFT JOIN app_protocols AS protocol ON protocol.ID = protocol_id 
			LEFT JOIN iml_applications AS iml ON iml.ID = app_decisions.app_id
	GROUP BY
	app_decisions.is_closed ,
			app_decisions.ID ,
			lims.org_unit_id ,
			iml.expertise_result ,
			--STRING_AGG ( reason.reason_type, ',' ) AS decision_reasons,
			app_id,
			decision_type,
			date_of_start,
			COALESCE ( protocol_id, '00000000-0000-0000-0000-000000000000' ) ,
			COALESCE ( protocol.protocol_number, '' ) ,
			COALESCE ( protocol.protocol_date, '1900-01-01' ) ,
			decision_description,
			paid_money,
			notes,
			COALESCE ( app_decisions.caption, '' ) ,
			app_decisions.record_state
			
		union
		--trl
		select
			app_decisions.is_closed as app_decision_closed,
			app_decisions.ID as app_decision_id,
			lims.org_unit_id AS org_unit_id,
			trl.expertise_result AS expertise_result_enum,
			STRING_AGG ( reason.reason_type, ',' ) AS decision_reasons,
			app_id,
			decision_type,
			date_of_start,
			COALESCE ( protocol_id, '00000000-0000-0000-0000-000000000000' ) AS protocol_id,
			COALESCE ( protocol.protocol_number, '' ) AS protocol_number,
			COALESCE ( protocol.protocol_date, '1900-01-01' ) AS date_of_protocol,
			decision_description,
			paid_money,
			notes,
			COALESCE ( app_decisions.caption, '' ) AS caption,
			app_decisions.record_state
		from
			app_decisions
			LEFT JOIN lims_docs AS lims ON lims.ID = app_decisions.app_id
			LEFT JOIN app_decision_reasons AS reason ON reason.app_decision_id = app_decisions.ID
			LEFT JOIN app_protocols AS protocol ON protocol.ID = protocol_id 
			LEFT JOIN trl_applications AS trl ON trl.ID = app_decisions.app_id
	GROUP BY
	app_decisions.is_closed ,
			app_decisions.ID ,
			lims.org_unit_id ,
			trl.expertise_result ,
			--STRING_AGG ( reason.reason_type, ',' ) AS decision_reasons,
			app_id,
			decision_type,
			date_of_start,
			COALESCE ( protocol_id, '00000000-0000-0000-0000-000000000000' ) ,
			COALESCE ( protocol.protocol_number, '' ) ,
			COALESCE ( protocol.protocol_date, '1900-01-01' ) ,
			decision_description,
			paid_money,
			notes,
			COALESCE ( app_decisions.caption, '' ) ,
			app_decisions.record_state		
	) qry
WHERE
	qry.record_state <> 4 and qry.expertise_result_enum is not null