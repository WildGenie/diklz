SELECT                      --coalesce(, '') as ,
	lic.id as Id,
	coalesce(lic.license_number, 'б/н') as license_number,
	lic.license_date,
	lic.order_date,
	lic.order_number,
	lic.lic_sort,
	lic.lic_state,
    lic.end_reason_text,
    lic.end_order_number,
    lic.end_order_date,
    lic.end_order_text,
    lic.is_relevant,
    sort_first.name as first_app_sort_name,
    coalesce(state_enum.name, '') as lic_state_name,
    coalesce(state_type.name, '') as lic_type_name,
    lic.lic_type,
    app.id as base_application_id,
    coalesce(app.app_type, '') as app_type,
    coalesce(app.caption, '') as caption,
    coalesce(app.app_state, '') as app_state,
    coalesce(app.app_sort, '') as app_sort,
    coalesce(app_sort_enum.name, '') as app_sort_enum,
    coalesce(orz.name, '') as org_name,
    coalesce(ori.name, '') as name,
    coalesce(orz.edrpou, '') as edrpou,
    coalesce(orz.inn, '') as inn,
    COALESCE(ori.passport_date, '1900-01-01') as passport_date,
    coalesce(ori.passport_issue_unit, '') as passport_issue_unit,
    coalesce(ori.passport_number, '') as passport_number,
    coalesce(ori.passport_serial, '') as passport_serial,
    coalesce(ori.legal_form_type, '') as legal_form_type,
    col.name as legal_form_name,
    coalesce(ori.ownership_type, '') as ownership_type,
    own.name as ownership_type_name,
    coalesce(ori.org_director, '') as org_director,
    coalesce(ori.phone_number, '') as phone_number,
    coalesce(ori.fax_number, '') as fax_number,
    coalesce(ori.email, '') as email,
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
    app.is_electric_form_results,
    coalesce(app.comment, '') as comment,
    coalesce(app.org_unit_id, '00000000-0000-0000-0000-000000000000') as org_unit_id,
    app.organization_info_id,
--ATU START
    COALESCE ( ori.address_id, '00000000-0000-0000-0000-000000000000' ) AS address_id,
    COALESCE ( street.ID, '00000000-0000-0000-0000-000000000000' ) AS street_id,
    COALESCE ( street.NAME, '' ) AS street_name,
    COALESCE ( city.ID, '00000000-0000-0000-0000-000000000000' ) AS city_id,
    COALESCE ( city.NAME, '' ) AS city_name,
    COALESCE ( city.type_enum, '' ) AS city_enum,
    COALESCE ( region.ID, '00000000-0000-0000-0000-000000000000' ) AS region_id,
    COALESCE ( region.NAME, '' ) AS region_name,
    COALESCE ( subject_address.post_index, '' ) AS post_index,
    COALESCE ( subject_address.building, '' ) AS building,
    COALESCE ( subject_address.address_type, '' ) AS address_type,
    COALESCE ((SELECT NAME FROM atu_region AS reg WHERE SUBSTRING ( reg.code, 0, 6 ) = SUBSTRING ( city.code, 0, 6 ) LIMIT 1 ),'' ) AS district_name 
--ATU END
from
	prl_licenses as lic
    left join prl_applications as app on app.id = lic.parent_id
    left join org_organization as orz on app.org_unit_id = orz.id and orz.record_state <> 4
    left join org_organization_info as ori on app.organization_info_id = ori.id and ori.record_state <> 4
    left join enum_record as own on own.enum_type = 'OwnershipForm' and own.code = ori.ownership_type
    left join enum_record as col on col.enum_type = 'CodeOrganizationalLegalForm' and col.code = ori.legal_form_type
    left join enum_record as state_enum on state_enum.enum_type = 'LicenseState' and state_enum.code = lic.lic_state
    left join enum_record as state_type on state_type.enum_type = 'ActivityType' and state_type.code = lic.lic_type
    left join enum_record as app_sort_enum on app_sort_enum.enum_type = 'ApplicationSort' and app_sort_enum.code = app.app_sort
    left join enum_record as sort_first on sort_first.enum_type = 'ApplicationSort' and sort_first.code = 'GetLicenseApplication'
--ATU START
	LEFT JOIN atu_subject_address AS subject_address ON  subject_address.ID = ori.address_id
    LEFT JOIN atu_street AS street ON subject_address.street_id = street.ID
    LEFT JOIN atu_city AS city ON street.city_id = city.ID
    LEFT JOIN atu_region AS region ON city.region_id = region.ID 
--ATU END
