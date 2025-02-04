SELECT                      --coalesce(, '') as ,
	lic.id as Id,
	lic.license_date,
	lic.order_date,
	lic.order_number,
    coalesce(state_enum.name, '') as lic_state,
    coalesce(app.caption, '') as caption,
    coalesce(orz.name, '') as org_name,
    coalesce(orz.edrpou, orz.inn) as edrpou,
    coalesce(ori.org_director, '') as org_director,
    coalesce(ori.phone_number, '') as phone_number,
    coalesce(ori.fax_number, '') as fax_number,
    coalesce(ori.email, '') as email,
    lic.parent_id as base_application_id,
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
    COALESCE ((SELECT NAME FROM atu_region AS reg WHERE SUBSTRING ( reg.code, 0, 6 ) = SUBSTRING ( city.code, 0, 6 ) LIMIT 1 ),'' ) AS district_name,
    COALESCE (CONCAT(region.NAME,', ',city.NAME, ', ',street.NAME,', ',subject_address.building), '') as sql_address
--ATU END
from
	iml_licenses as lic
    left join iml_applications as app on app.id = lic.parent_id
    left join org_organization as orz on app.org_unit_id = orz.id and orz.record_state <> 4
    left join org_organization_info as ori on app.organization_info_id = ori.id and ori.record_state <> 4
    left join enum_record as state_enum on state_enum.enum_type = 'LicenseState' and state_enum.code = lic.lic_state
--ATU START
	LEFT JOIN atu_subject_address AS subject_address ON  subject_address.ID = ori.address_id
    LEFT JOIN atu_street AS street ON subject_address.street_id = street.ID
    LEFT JOIN atu_city AS city ON street.city_id = city.ID
    LEFT JOIN atu_region AS region ON city.region_id = region.ID 
--ATU END
where lic.is_relevant = true
