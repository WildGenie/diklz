select
    prla.id,
    prla.caption,
    COALESCE(prla.modified_on, prla.created_on) as modified_on,
    prla.org_unit_id,
    type_enum.name as app_type,
    prla.app_type as app_type_enum,
    sort_enum.name as app_sort,
    prla.app_sort as app_sort_enum,
    sort_enum_full.name as app_sort_full,
    state_enum.name as app_state,
    prla.app_state as app_state_enum,
    prla.record_state,
    prla.back_office_app_state as back_office_app_state_enum,
    back_state_enum.name as back_office_app_state,
    coalesce(decision.name, '') as decision_type,
    coalesce(app_dec.decision_type, '') as decision_type_enum,
    coalesce(expertise.name, '') as expertise_result,
    prla.expertise_result as expertise_result_enum,
    prla.is_created_on_portal,
    --prla.reg_number,
    case when prla.reg_number is null and prla.return_check = true then 'Повернуто з коментарем' else  prla.reg_number end as reg_number,
    prla.reg_date,
    coalesce(orz.edrpou, orz.inn) as ipn,
    coalesce(ori.name, '') as name_org,
    COALESCE ( city.NAME, '' ) AS city_name,
    concat(per.last_name, ' ', per."name", ' ', per.middle_name) as performer_name,
	liccheck.result_of_check,
    liccheck.id as result_of_check_id,
	proto.order_date as order_date,
	proto.order_number as order_number,
    coalesce(proto.id, '00000000-0000-0000-0000-000000000000') as protocol_id,
    		(CASE WHEN prla.app_sort <> 'GetLicenseApplication' and prla.app_sort <> 'IncreaseToPRLApplication' THEN 'DontNeed' 
			ELSE
    coalesce((select edocument_status from edocuments where created_on = (select max(created_on) from edocuments where entity_id = prla.id and edocument_type = 'PaymentDocument') and entity_id = prla.id and edocument_type = 'PaymentDocument' ),'RequiresPayment') END) as edocument_status,
    city.code as koatuu,
    prla.return_check

from prl_applications as prla
    left join enum_record as type_enum on type_enum.enum_type = 'ActivityType' and type_enum.code = prla.app_type
    left join enum_record as sort_enum on sort_enum.enum_type = 'ApplicationSortShort' and sort_enum.code = prla.app_sort
    left join enum_record as sort_enum_full on sort_enum_full.enum_type = 'ApplicationSort' and sort_enum_full.code = prla.app_sort
    left join enum_record as state_enum on state_enum.enum_type = 'ApplicationState' and state_enum.code = prla.app_state
    left join enum_record as back_state_enum on back_state_enum.enum_type = 'BackOfficeAppState' and back_state_enum.code = prla.back_office_app_state
    left join app_decisions as app_dec on prla.app_decision_id = app_dec.id and app_dec.record_state <> 4   		
    left join enum_record as decision on decision.enum_type = 'DecisionType' and decision.code = app_dec.decision_type
    left join enum_record as expertise on expertise.enum_type = 'ExpertiseResult' and expertise.code = prla.expertise_result
    left join org_organization as orz on prla.org_unit_id = orz.id and orz.record_state <> 4
    left join org_organization_info as ori on prla.organization_info_id = ori.id and ori.record_state <> 4   
    LEFT JOIN atu_subject_address AS subject_address ON  subject_address.ID = ori.address_id
    LEFT JOIN atu_street AS street ON subject_address.street_id = street.ID
    LEFT JOIN atu_city AS city ON street.city_id = city.ID
    left join org_employee as emp on prla.performer_id = emp.id and emp.record_state <> 4
    left join person as per on emp.person_id = per.id and per.record_state <> 4
	left join app_pre_license_checks as liccheck on liccheck.app_id = prla.id and liccheck.record_state <> 4
	left join app_protocols as proto on app_dec.protocol_id = proto.id and proto.record_state <> 4
		

    where (1=1) 
    AND prla.back_office_app_state notnull
    AND prla.app_type = 'PRL'
    AND prla.record_state <> 4