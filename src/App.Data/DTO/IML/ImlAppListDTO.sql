select
    imla.id,
    imla.caption,
    COALESCE(imla.modified_on, imla.created_on) as modified_on,
    imla.org_unit_id,
    type_enum.name as app_type,
    imla.app_type as app_type_enum,
    sort_enum.name as app_sort,
    imla.app_sort as app_sort_enum,
    sort_enum_full.name as app_sort_full,
    state_enum.name as app_state,
    imla.app_state as app_state_enum,
    imla.record_state,
    imla.back_office_app_state as back_office_app_state_enum,
    back_state_enum.name as back_office_app_state,
    coalesce(decision.name, '') as decision_type,
    coalesce(app_dec.decision_type, '') as decision_type_enum,
    coalesce(expertise.name, '') as expertise_result,
    imla.expertise_result as expertise_result_enum,
    imla.is_created_on_portal,
    --imla.reg_number,
    case when imla.reg_number is null and imla.return_check = true then 'Повернуто з коментарем' else  imla.reg_number end as reg_number,
    imla.reg_date,
    coalesce(orz.edrpou, orz.inn) as ipn,
    coalesce(ori.name, '') as name_org,
    COALESCE ( city.NAME, '' ) AS city_name,
    concat(per.last_name, ' ', per."name", ' ', per.middle_name) as performer_name,
	liccheck.result_of_check,
    liccheck.id as result_of_check_id,
	proto.order_date as order_date,
	proto.order_number as order_number,
    coalesce(proto.id, '00000000-0000-0000-0000-000000000000') as protocol_id,
    		(CASE WHEN imla.app_sort <> 'GetLicenseApplication' and imla.app_sort <> 'IncreaseToImlApplication' THEN 'DontNeed' 
			ELSE
    coalesce((select edocument_status from edocuments where created_on = (select max(created_on) from edocuments where entity_id = imla.id and edocument_type = 'PaymentDocument') and entity_id = imla.id and edocument_type = 'PaymentDocument' ),'RequiresPayment') END) as edocument_status,
    city.code as koatuu,
    imla.return_check

from iml_applications as imla
    left join enum_record as type_enum on type_enum.enum_type = 'ActivityType' and type_enum.code = imla.app_type
    left join enum_record as sort_enum on sort_enum.enum_type = 'ApplicationSortShort' and sort_enum.code = imla.app_sort
    left join enum_record as sort_enum_full on sort_enum_full.enum_type = 'ApplicationSort' and sort_enum_full.code = imla.app_sort
    left join enum_record as state_enum on state_enum.enum_type = 'ApplicationState' and state_enum.code = imla.app_state
    left join enum_record as back_state_enum on back_state_enum.enum_type = 'BackOfficeAppState' and back_state_enum.code = imla.back_office_app_state
    left join app_decisions as app_dec on imla.app_decision_id = app_dec.id and app_dec.record_state <> 4   		
    left join enum_record as decision on decision.enum_type = 'DecisionType' and decision.code = app_dec.decision_type
    left join enum_record as expertise on expertise.enum_type = 'ExpertiseResult' and expertise.code = imla.expertise_result
    left join org_organization as orz on imla.org_unit_id = orz.id and orz.record_state <> 4
    left join org_organization_info as ori on imla.organization_info_id = ori.id and ori.record_state <> 4   
    LEFT JOIN atu_subject_address AS subject_address ON  subject_address.ID = ori.address_id
    LEFT JOIN atu_street AS street ON subject_address.street_id = street.ID
    LEFT JOIN atu_city AS city ON street.city_id = city.ID
    left join org_employee as emp on imla.performer_id = emp.id and emp.record_state <> 4
    left join person as per on emp.person_id = per.id and per.record_state <> 4
	left join app_pre_license_checks as liccheck on liccheck.id = imla.app_pre_license_check_id and liccheck.record_state <> 4
	left join app_protocols as proto on app_dec.protocol_id = proto.id and proto.record_state <> 4
		

    where (1=1) 
    AND imla.back_office_app_state notnull
    AND imla.app_type = 'IML'
    AND imla.record_state <> 4