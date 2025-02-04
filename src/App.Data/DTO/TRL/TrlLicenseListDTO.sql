SELECT 
    lic.caption,
    lic.id,
	state_enum.name as lic_state_name,
    state_enum.code as lic_state,
	coalesce(lic.license_number, 'б/н') as license_number,
	lic.license_date,
    concat(
		(SELECT count(*)
			from application_branches as apb
			join org_branches as brn on apb.branch_id = brn.id --and brn.record_state <> 4
			where apb.lims_document_id = app.id
			and (apb.record_state <> 4  and brn.record_state <> 4 or (brn.record_state =4 and brn.branch_activity = 'Closed')))
			, '(',
		(SELECT count(*)
			from application_branches as apb
			join org_branches as brn on apb.branch_id = brn.id and brn.record_state <> 4 and brn.branch_activity = 'Active'
			where apb.lims_document_id = app.id
			and apb.record_state <> 4), 
			')') as branches,
	coalesce(org.edrpou, org.inn) as edrpou,
	ori.name as org_name,
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
    COALESCE ((SELECT NAME FROM atu_region AS reg WHERE SUBSTRING ( reg.code, 0, 6 ) = SUBSTRING ( city.code, 0, 6 ) LIMIT 1 ),'' ) AS district_name ,
    COALESCE (CONCAT(region.NAME,', ',city.NAME, ', ',street.NAME,', ',subject_address.building), '') as sql_address,
--ATU END
    app.org_unit_id
	

FROM trl_licenses as lic
    left join enum_record as state_enum on state_enum.enum_type = 'LicenseState' and state_enum.code = lic.lic_state
		left join trl_applications as app on app.id = lic.parent_id
		left join org_organization as org on org.id = app.org_unit_id
		left join org_organization_info as ori on app.organization_info_id = ori.id
		--ATU START
		LEFT JOIN atu_subject_address AS subject_address ON  subject_address.ID = ori.address_id
    LEFT JOIN atu_street AS street ON subject_address.street_id = street.ID
    LEFT JOIN atu_city AS city ON street.city_id = city.ID
    LEFT JOIN atu_region AS region ON city.region_id = region.ID
    --ATU END
		
where (1=1)
    and lic.record_state <> 4
  --  and lic.lic_state = 'Active'
    and lic.is_relevant = true
