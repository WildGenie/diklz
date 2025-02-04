SELECT                      --coalesce(, '') as ,
    brn.id,
    brn.name,
    brn.phone_number,
    coalesce(brn.caption, '') as caption,
    brn.license_delete_check,
    brn.is_from_license,
    coalesce(brn.operation_list_form_changing,  '') as operation_list_form_changing,
    coalesce((select
        subq.org_unit_id
    from
        (select
            imla.id,
            imla.org_unit_id
        from iml_applications as imla
        where imla.record_state <> 4 and imla.id = apb.lims_document_id

        union

        select
            prla.id,
            prla.org_unit_id
        from prl_applications as prla
        where prla.record_state <> 4 and prla.id = apb.lims_document_id

        union

        select
            trla.id,
            trla.org_unit_id
        from trl_applications as trla
        where trla.record_state <> 4 and trla.id = apb.lims_document_id
        ) subq
        ), '00000000-0000-0000-0000-000000000000' ) as org_unit_id,
        apb.lims_document_id as application_id,
        COALESCE ( city.code, '' ) as koatuu_code
FROM
    org_branches as brn
    join application_branches as apb on apb.branch_id = brn.id
    --ATU START
	LEFT JOIN atu_subject_address AS subject_address ON brn.address_id = subject_address.ID
	LEFT JOIN atu_street AS street ON subject_address.street_id = street.ID
	LEFT JOIN atu_city AS city ON street.city_id = city.ID
    --ATU END
where brn.record_state <> 4
