SELECT                      --coalesce(, '') as ,
    brn.id,
    brn.name,
    coalesce(brn.phone_number, '') as phone_number,
    coalesce(brn.caption, '') as caption,
    brn.organization_id,
    apb.lims_document_id as application_id,
    apb.id as application_branch_id,
    coalesce(brn.fax_number, '') as fax_number,
    coalesce(brn.email, '') as email,
    coalesce(brn.adress_eng, '') as adress_eng,
    brn.prl_is_availiable_prod_sites as prlis_availiable_prod_sites,
    brn.prl_is_availiable_quality_zone as prlis_availiable_quality_zone,
    brn.prl_is_availiable_storage_zone as prlis_availiable_storage_zone,
    brn.prl_is_availiable_pickup_zone as prlis_availiable_pickup_zone,
    coalesce(brn.operation_list_form, '') as operation_list_form,
    brn.iml_is_availiable_storage_zone as imlis_availiable_storage_zone,
    brn.iml_is_availiable_permit_issue_zone as imlis_availiable_permit_issue_zone,
    brn.iml_is_availiable_quality as imlis_availiable_quality,
    brn.trl_is_manufacture as trlis_manufacture,
    brn.trl_is_wholesale as trlis_wholesale,
    brn.trl_is_retail as trlis_retail,
    brn.operation_list_form_changing,
--ATU START
    COALESCE ( brn.address_id, '00000000-0000-0000-0000-000000000000' ) AS address_id,
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
    COALESCE ((SELECT NAME FROM atu_region AS reg WHERE SUBSTRING ( reg.code, 0, 6 ) = SUBSTRING ( city.code, 0, 6 ) LIMIT 1 ),'' ) AS district_name 
--ATU END
    FROM
    org_branches as brn
    join application_branches as apb on apb.branch_id = brn.id and apb.record_state <> 4
    left join
    (select 
            imla.id,
            imla.org_unit_id,
            imla.record_state,
            imla.app_type
        from iml_applications as imla

        union

        select 
            prla.id,
            prla.org_unit_id,
            prla.record_state,
            prla.app_type
        from prl_applications as prla

        union

        select 
            trla.id,
            trla.org_unit_id,
            trla.record_state,
            trla.app_type
        from trl_applications as trla
        ) app on app.id = apb.lims_document_id and app.record_state <> 4
--ATU START
	LEFT JOIN atu_subject_address AS subject_address ON brn.address_id = subject_address.ID
    LEFT JOIN atu_street AS street ON subject_address.street_id = street.ID
    LEFT JOIN atu_city AS city ON street.city_id = city.ID
    LEFT JOIN atu_region AS region ON city.region_id = region.ID 
--ATU END
where brn.record_state <> 4
