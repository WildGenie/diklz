SELECT                      
    app.id,
	string_agg(coalesce(activity_type."name", ''),',') as activity_type_name,
    coalesce(app.app_type, '') as app_type,
    coalesce(app.caption, '') as caption,
    coalesce(app.app_state, '') as app_state,
    coalesce(app.app_sort, '') as app_sort,
    coalesce(app.back_office_app_state, '') as back_office_app_state,
    coalesce(back_state.name, '') as back_office_app_state_string,
    coalesce(ori.name, '') as org_name,
    coalesce(orz.edrpou, '') as edrpou,
    coalesce(orz.inn, '') as inn,
    coalesce(ori.passport_date, '1900-01-01') as passport_date,
    coalesce(ori.passport_issue_unit, '') as passport_issue_unit,
    coalesce(ori.passport_number, '') as passport_number,
    coalesce(ori.passport_serial, '') as passport_serial,
    coalesce(ori.legal_form_type, '') as legal_form_type,
    col.name as legal_form_name,
    coalesce(ori.ownership_type, '') as ownership_type,
    own.name as ownership_type_name,
    coalesce(ori.economic_classification_type, '') as economic_classification_type,
    econClas.name as economic_classification_type_name,
    coalesce(ori.org_director, '') as org_director,
    coalesce(ori.phone_number, '') as phone_number,
    coalesce(ori.fax_number, '') as fax_number,
    coalesce(orz.email, '') as email,
    coalesce(ori.national_account, '') as national_account,
    coalesce(ori.national_bank_requisites, '') as national_bank_requisites,
    coalesce(ori.international_account, '') as international_account,
    coalesce(ori.international_bank_requisites, '') as international_bank_requisites,
    coalesce(app.duns, '') as duns,
    coalesce(app.is_check_mpd, false) as is_check_mpd,
    coalesce(app.is_paper_license, false) as is_paper_license,
    coalesce(app.is_courier_delivery, false) as is_courier_delivery,
    app.is_post_delivery,
    app.is_agree_license_terms,
    app.is_agree_processing_data,
    app.is_courier_results,
    app.is_post_results,
    app.is_protection_from_aggressors,
    app.is_electric_form_results,
    app.is_created_on_portal,
		coalesce(app.performer_id, '00000000-0000-0000-0000-000000000000') as performer_id,
--Expretise
    app.expertise_result as expertise_result_enum,
    COALESCE(app.expertise_date, '1900-01-01') as expertise_date,
    coalesce(app.performer_of_expertise, '00000000-0000-0000-0000-000000000000') as performer_of_expertise,
    case when app.performer_of_expertise is not null then app.performer_of_expertise::text else '' end AS performer_of_expertise_string,
	coalesce(eres.name, '') as expertise_result,    
--
    coalesce(app.comment, '') as comment,
    coalesce(app.org_unit_id, '00000000-0000-0000-0000-000000000000') as org_unit_id,
    app.organization_info_id,
	coalesce(decision.code, '') as decision_type,
    coalesce(app.reg_number,'') as reg_number,
    app.reg_date,
    app.error_processing_license,
--ATU START
    COALESCE ( ori.address_id, '00000000-0000-0000-0000-000000000000' ) AS address_id,
    COALESCE ( street.ID, '00000000-0000-0000-0000-000000000000' ) AS street_id,
    COALESCE ( street.NAME, '' ) AS street_name,
    COALESCE ( city.ID, '00000000-0000-0000-0000-000000000000' ) AS city_id,
    COALESCE ( city.NAME, '' ) AS city_name,
    COALESCE ( city.type_enum, '' ) AS city_enum,
	COALESCE ( city.code, '' ) as koatuu_code,
    COALESCE ( region.ID, '00000000-0000-0000-0000-000000000000' ) AS region_id,
    COALESCE ( region.NAME, '' ) AS region_name,
    COALESCE ( subject_address.post_index, '' ) AS post_index,
    COALESCE ( subject_address.building, '' ) AS building,
    COALESCE ( subject_address.address_type, '' ) AS address_type,
    COALESCE ((SELECT NAME FROM atu_region AS reg WHERE SUBSTRING ( reg.code, 0, 6 ) = SUBSTRING ( city.code, 0, 6 ) LIMIT 1 ),'' ) AS district_name,
    app.prl_in_pharmacies,
	app.retail_of_medicines,
	app.wholesale_of_medicines,
    false AS imlis_importing_finished,
    false AS imlis_importing_in_bulk,
    '' AS imlanother_activity,
    false AS is_conditions_for_control,
    false AS is_good_manufacturing_practice,
    COALESCE ( app.return_comment, '' ) as return_comment,
    app.return_check
--ATU END
FROM
    trl_applications as app
    left join org_organization as orz on app.org_unit_id = orz.id and orz.record_state <> 4
    left join org_organization_info as ori on app.organization_info_id = ori.id and ori.record_state <> 4
	left join app_decisions as app_dec on app.app_decision_id = app_dec.id
    left join enum_record as own on own.enum_type = 'OwnershipForm' and own.code = ori.ownership_type
    left join enum_record as col on col.enum_type = 'CodeOrganizationalLegalForm' and col.code = ori.legal_form_type
	left join enum_record as decision on decision.enum_type = 'DecisionType' and decision.code = app_dec.decision_type
    left join enum_record as eres on eres.enum_type = 'ExpertiseResult' and eres.code = app.expertise_result
    left join enum_record as back_state on back_state.enum_type = 'BackOfficeAppState' and back_state.code = app.back_office_app_state
    left join enum_record as econClas on econClas.enum_type = 'EconomicClassificationCode' and econClas.code = ori.economic_classification_type
		
	left join entity_enum_recordses as entity_en_rec on entity_en_rec.entity_id = app.id 
    left join enum_record as activity_type on activity_type.enum_type = 'TrlActivityType' and activity_type.code = entity_en_rec.enum_record_code
    
    --ATU START
	LEFT JOIN atu_subject_address AS subject_address ON  subject_address.ID = ori.address_id
    LEFT JOIN atu_street AS street ON subject_address.street_id = street.ID
    LEFT JOIN atu_city AS city ON street.city_id = city.ID
    LEFT JOIN atu_region AS region ON city.region_id = region.ID
    --ATU END
		GROUP BY
		app.id,
		--string_agg(activity_type."name",',') ,
    coalesce(app.app_type, '') ,
    coalesce(app.caption, '') ,
    coalesce(app.app_state, '') ,
    coalesce(app.app_sort, '') ,
    coalesce(app.back_office_app_state, '') ,
    coalesce(back_state.name, '') ,
    coalesce(ori.name, '') ,
    coalesce(orz.edrpou, '') ,
    coalesce(orz.inn, '') ,
    coalesce(ori.passport_date, '1900-01-01') ,
    coalesce(ori.passport_issue_unit, '') ,
    coalesce(ori.passport_number, '') ,
    coalesce(ori.passport_serial, '') ,
    coalesce(ori.legal_form_type, '') ,
    col.name ,
    coalesce(ori.ownership_type, '') ,
    own.name ,
    coalesce(ori.economic_classification_type, '') ,
    econClas.name ,
    coalesce(ori.org_director, '') ,
    coalesce(ori.phone_number, '') ,
    coalesce(ori.fax_number, '') ,
    coalesce(orz.email, '') ,
    coalesce(ori.national_account, '') ,
    coalesce(ori.national_bank_requisites, '') ,
    coalesce(ori.international_account, '') ,
    coalesce(ori.international_bank_requisites, '') ,
    coalesce(app.duns, '') ,
    coalesce(app.is_check_mpd, false) ,
    coalesce(app.is_paper_license, false) ,
    coalesce(app.is_courier_delivery, false) ,
    app.is_post_delivery,
    app.is_agree_license_terms,
    app.is_agree_processing_data,
    app.is_courier_results,
    app.is_post_results,
    app.is_protection_from_aggressors,
    app.is_electric_form_results,
    app.is_created_on_portal,
		coalesce(app.performer_id, '00000000-0000-0000-0000-000000000000') ,
--Expretise
    app.expertise_result ,
    COALESCE(app.expertise_date, '1900-01-01') ,
    coalesce(app.performer_of_expertise, '00000000-0000-0000-0000-000000000000') ,
    case when app.performer_of_expertise is not null then app.performer_of_expertise::text else '' end,
	coalesce(eres.name, '') ,    
--
    coalesce(app.comment, '') ,
    coalesce(app.org_unit_id, '00000000-0000-0000-0000-000000000000') ,
    app.organization_info_id,
	coalesce(decision.code, '') ,
    coalesce(app.reg_number,'') ,
    app.reg_date,
    app.error_processing_license,
--ATU START
    COALESCE ( ori.address_id, '00000000-0000-0000-0000-000000000000' ) ,
    COALESCE ( street.ID, '00000000-0000-0000-0000-000000000000' ) ,
    COALESCE ( street.NAME, '' ) ,
    COALESCE ( city.ID, '00000000-0000-0000-0000-000000000000' ) ,
    COALESCE ( city.NAME, '' ) ,
    COALESCE ( city.type_enum, '' ) ,
	COALESCE ( city.code, '' ) ,
    COALESCE ( region.ID, '00000000-0000-0000-0000-000000000000' ) ,
    COALESCE ( region.NAME, '' ) ,
    COALESCE ( subject_address.post_index, '' ) ,
    COALESCE ( subject_address.building, '' ) ,
    COALESCE ( subject_address.address_type, '' ) ,
    COALESCE ((SELECT NAME FROM atu_region AS reg WHERE SUBSTRING ( reg.code, 0, 6 ) = SUBSTRING ( city.code, 0, 6 ) LIMIT 1 ),'' ) ,
    app.prl_in_pharmacies,
	app.retail_of_medicines,
	app.wholesale_of_medicines,
    COALESCE ( app.return_comment, '' ),
    app.return_check



