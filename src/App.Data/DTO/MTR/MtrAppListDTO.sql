SELECT 
    qry.id,
    qry.caption,
    qry.modified_on,
    qry.org_unit_id,
    qry.app_type,
    qry.app_sort,
    qry.app_state,
    qry.app_type_enum,
    qry.app_sort_enum,
    qry.app_state_enum,
    qry.record_state,
	qry.decision_enum,
    qry.decision,
	qry.decision_reason,
	qry.reg_date,
	qry.decision_notes,
    (select edocument_status from edocuments where created_on = (select max(created_on) from edocuments where entity_id = qry.id and edocument_type = 'PaymentDocument') and entity_id = qry.id and edocument_type = 'PaymentDocument' ) as edocument_status,
	--qry.reg_number,
    case when qry.reg_number is null and qry.return_check = true then 'Повернуто з коментарем' else  qry.reg_number end as reg_number,
    qry.decision_description,
    qry.protocol_status_name,
    qry.return_comment,
    qry.return_check
FROM
    (
    select
        imla.id,
        imla.caption,
        COALESCE(imla.modified_on, imla.created_on) as modified_on,
        imla.org_unit_id,
        imla.app_type as app_type_enum,
        imla.app_sort as app_sort_enum,
        imla.app_state as app_state_enum,
        type_enum.name as app_type,
        sort_enum.name as app_sort,
        state_enum.name as app_state,
        imla.record_state,
		imla.reg_date,
		imla.reg_number,
		COALESCE(decision_enum.code, '') as decision_enum,
        COALESCE(decision_enum.name, '') as decision,
		STRING_AGG (reason.reason_type, ',') as decision_reason,
		COALESCE(app_dec.notes, '') as decision_notes,
        coalesce(app_dec.decision_description, '') as decision_description,
        prot.status_name as protocol_status_name,
        imla.return_check,
        imla.return_comment
    from iml_applications as imla
    left join enum_record as type_enum on type_enum.enum_type = 'ActivityType' and type_enum.code = imla.app_type
    left join enum_record as sort_enum on sort_enum.enum_type = 'ApplicationSort' and sort_enum.code = imla.app_sort
    left join enum_record as state_enum on state_enum.enum_type = 'ApplicationState' and state_enum.code = imla.app_state
    left join app_decisions as app_dec on imla.app_decision_id = app_dec.id and app_dec.record_state <> 4
		left join app_decision_reasons as reason on app_dec.id = reason.app_decision_id and app_dec.record_state <> 4
		left join enum_record as decision_enum on decision_enum.enum_type = 'DecisionType' and decision_enum.code = app_dec.decision_type
        left join app_protocols as prot on app_dec.protocol_id = prot.id
		GROUP BY    
		imla.id,
        imla.caption,
        COALESCE(imla.modified_on, imla.created_on) ,
        imla.org_unit_id,
        imla.app_type ,
        imla.app_sort ,
        imla.app_state,
        type_enum.name ,
        sort_enum.name ,
        state_enum.name ,
        imla.record_state,
		imla.reg_date,
		imla.reg_number,
		COALESCE(decision_enum.code, '') ,
        COALESCE(decision_enum.name, ''),
		COALESCE(app_dec.notes, '') ,
        coalesce(app_dec.decision_description, '') ,
        prot.status_name ,
        imla.return_check,
        imla.return_comment
		
    UNION

    select
        prla.id,
        prla.caption,
        COALESCE(prla.modified_on, prla.created_on) as modified_on,
        prla.org_unit_id,
        prla.app_type as app_type_enum,
        prla.app_sort as app_sort_enum,
        prla.app_state as app_state_enum,
        type_enum.name as app_type,
        sort_enum.name as app_sort,
        state_enum.name as app_state,
        prla.record_state,
		prla.reg_date,
		prla.reg_number,
		COALESCE(decision_enum.code, '') as decision_enum,
        COALESCE(decision_enum.name, '') as decision,
		STRING_AGG (reason.reason_type, ',') as decision_reason,
        COALESCE(app_dec.notes, '') as decision_notes,
        coalesce(app_dec.decision_description, '') as decision_description,
        prot.status_name as protocol_status_name,
        prla.return_check,
        prla.return_comment
    from prl_applications as prla
    left join enum_record as type_enum on type_enum.enum_type = 'ActivityType' and type_enum.code = prla.app_type
    left join enum_record as sort_enum on sort_enum.enum_type = 'ApplicationSort' and sort_enum.code = prla.app_sort
    left join enum_record as state_enum on state_enum.enum_type = 'ApplicationState' and state_enum.code = prla.app_state
    left join app_decisions as app_dec on prla.app_decision_id = app_dec.id and app_dec.record_state <> 4   	
		left join app_decision_reasons as reason on app_dec.id = reason.app_decision_id and app_dec.record_state <> 4
		left join enum_record as decision_enum on decision_enum.enum_type = 'DecisionType' and decision_enum.code = app_dec.decision_type
        left join app_protocols as prot on app_dec.protocol_id = prot.id
		GROUP BY 
		prla.id,
        prla.caption,
        COALESCE(prla.modified_on, prla.created_on) ,
        prla.org_unit_id,
        prla.app_type ,
        prla.app_sort ,
        prla.app_state ,
        type_enum.name ,
        sort_enum.name ,
        state_enum.name,
        prla.record_state,
		prla.reg_date,
		prla.reg_number,
		COALESCE(decision_enum.code, ''),
        COALESCE(decision_enum.name, '') ,
        COALESCE(app_dec.notes, '') ,
        coalesce(app_dec.decision_description, '') ,
        prot.status_name,
        prla.return_check,
        prla.return_comment
		
    UNION

    select
        trla.id,
        trla.caption,
        COALESCE(trla.modified_on, trla.created_on) as modified_on,
        trla.org_unit_id,
        trla.app_type as app_type_enum,
        trla.app_sort as app_sort_enum,
        trla.app_state as app_state_enum,
        type_enum.name as app_type,
        sort_enum.name as app_sort,
        state_enum.name as app_state,
        trla.record_state,
		trla.reg_date,
		trla.reg_number,
		COALESCE(decision_enum.code, '') as decision_enum,
        COALESCE(decision_enum.name, '') as decision,
		STRING_AGG (reason.reason_type, ',') as decision_reason,
		COALESCE(app_dec.notes, '') as decision_notes,
        coalesce(app_dec.decision_description, '') as decision_description,
        prot.status_name as protocol_status_name,
        trla.return_check,
        trla.return_comment
    from trl_applications as trla
    left join enum_record as type_enum on type_enum.enum_type = 'ActivityType' and type_enum.code = trla.app_type
    left join enum_record as sort_enum on sort_enum.enum_type = 'ApplicationSort' and sort_enum.code = trla.app_sort
    left join enum_record as state_enum on state_enum.enum_type = 'ApplicationState' and state_enum.code = trla.app_state
    left join app_decisions as app_dec on trla.app_decision_id = app_dec.id and app_dec.record_state <> 4   		
		left join app_decision_reasons as reason on app_dec.id = reason.app_decision_id and app_dec.record_state <> 4
		left join enum_record as decision_enum on decision_enum.enum_type = 'DecisionType' and decision_enum.code = app_dec.decision_type
        left join app_protocols as prot on app_dec.protocol_id = prot.id
		GROUP BY 
		trla.id,
        trla.caption,
        COALESCE(trla.modified_on, trla.created_on),
        trla.org_unit_id,
        trla.app_type ,
        trla.app_sort ,
        trla.app_state ,
        type_enum.name ,
        sort_enum.name ,
        state_enum.name ,
        trla.record_state,
		trla.reg_date,
		trla.reg_number,
		COALESCE(decision_enum.code, '') ,
        COALESCE(decision_enum.name, '') ,
		COALESCE(app_dec.notes, '') ,
        coalesce(app_dec.decision_description, ''),
        prot.status_name ,
        trla.return_check,
        trla.return_comment

    ) qry

  where (true)
  AND qry.record_state <> 4
  and qry.app_state_enum is not NULL
  AND qry.app_state_enum IS DISTINCT FROM 'Project'