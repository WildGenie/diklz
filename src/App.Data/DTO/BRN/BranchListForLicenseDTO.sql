SELECT--coalesce(, '') as ,
brn.ID,
    coalesce(brn.name, '') as name,
    coalesce(brn.phone_number, '') as phone_number,
    coalesce(brn.branch_type, '') as branch_type,
    coalesce(brn.caption, '') as caption,
    coalesce(brn.license_delete_check, false) as license_delete_check,
    coalesce(brn.is_from_license, false) as is_from_license,
    COALESCE ((select 
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
        coalesce ((select             
                imla.app_type
            from iml_applications as imla
            where imla.record_state <> 4 and imla.id = apb.lims_document_id

            union

            select              
                prla.app_type
            from prl_applications as prla
            where prla.record_state <> 4 and prla.id = apb.lims_document_id

            union

            select                
                trla.app_type
            from trl_applications as trla
            where trla.record_state <> 4 and trla.id = apb.lims_document_id
            ) , '') as app_type,
        COALESCE ( apb.lims_document_id, '00000000-0000-0000-0000-000000000000' ) as application_id,
	brn.branch_activity,
	--msg.id as message_id,
	(select string_agg(msg.reg_number,'||') as t from messages msg where mpd_selected_id = brn.ID and msg.message_type in 
		('MPDActivityRestoration', 'MPDActivitySuspension', 'MPDClosingForSomeActivity', 'MPDRestorationAfterSomeActivity') and msg.message_state='Accepted') as message_number,
	(select string_agg(msg.reg_date::TEXT,'||') as textt2 from messages msg where mpd_selected_id = brn.ID  and msg.message_type in 
		('MPDActivityRestoration', 'MPDActivitySuspension', 'MPDClosingForSomeActivity', 'MPDRestorationAfterSomeActivity') and msg.message_state='Accepted') as message_date,
    (select string_agg(msg.modified_on::TEXT,'||') as textt2 from messages msg where mpd_selected_id = brn.ID  and msg.message_type in 
		('MPDActivityRestoration', 'MPDActivitySuspension', 'MPDClosingForSomeActivity', 'MPDRestorationAfterSomeActivity') and msg.message_state='Accepted') as message_modified_on,
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
    COALESCE ((SELECT NAME FROM atu_region AS reg WHERE SUBSTRING ( reg.code, 0, 6 ) = SUBSTRING ( city.code, 0, 6 ) LIMIT 1 ),'' ) AS district_name,
    coalesce(case when brn.record_state =4 then 'Видаленно' else 'Активна' end) as status,
    coalesce(brn.record_state) as record_state,
    brn.create_dls,
    brn.create_tds,
    en_rec.code as enum_code
--ATU END
FROM
	org_branches AS brn
	JOIN application_branches AS apb ON apb.branch_id = brn.ID 
--ATU START
	LEFT JOIN atu_subject_address AS subject_address ON brn.address_id = subject_address.ID
	LEFT JOIN atu_street AS street ON subject_address.street_id = street.ID
	LEFT JOIN atu_city AS city ON street.city_id = city.ID
	LEFT JOIN atu_region AS region ON city.region_id = region.ID
    LEFT JOIN entity_enum_recordses as en_enum_rec on en_enum_rec.entity_id = brn.id and en_enum_rec.enum_record_code = 'Pharmacy'
	LEFT JOIN enum_record as en_rec on en_rec.code = en_enum_rec.enum_record_code 
	--ATU END
WHERE 
   brn.record_state <> 4  or ( brn.record_state = 4 and brn.branch_activity='Closed')
