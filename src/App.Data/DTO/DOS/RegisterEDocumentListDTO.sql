SELECT distinct
        doc.id,
        doc.version,
        doc.caption,
        doc.card_number,
        doc.date_from,
        doc.date_to,
        doc.edocument_status,
        doc.edocument_type,
        brn.organization_id as org_unit_id,
        doc.is_from_license,
		app.id as app_id
				
    FROM edocuments as doc
    JOIN branch_edocuments as brcnt on brcnt.edocument_id = doc.id and brcnt.record_state <> 4
    JOIN org_branches as brn on brn.id = brcnt.branch_id and brn.record_state <> 4
    JOIN application_branches as apb on apb.branch_id = brn.id and apb.record_state <> 4
    join (select 
            subq.id,
            subq.org_unit_id,
            subq.back_office_app_state,
						subq.app_sort
            from
                (select 
                    imla.id,
                    imla.org_unit_id,
                    imla.back_office_app_state,
										imla.app_sort
                from iml_applications as imla
                where imla.record_state <> 4

                union

                select 
                    prla.id,
                    prla.org_unit_id,
                    prla.back_office_app_state,
										prla.app_sort
                from prl_applications as prla
                where prla.record_state <> 4

                union

                select 
                    trla.id,
                    trla.org_unit_id,
                    trla.back_office_app_state,
										trla.app_sort
                from trl_applications as trla
                where trla.record_state <> 4) as subq) as app on app.id = apb.lims_document_id
	join app_decisions as decs on decs.app_id = app.id and decs.record_state <> 4
		
	
		
	where case when app.app_sort = 'GetLicenseApplication' or app.app_sort = 'AdditionalInfoToLicense'
		then doc.record_state <> 4 
		and app.back_office_app_state = 'Reviewed'
		and decs.decision_type = 'Accepted'
	when app.app_sort = 'AddBranchApplication' 
	or app.app_sort = 'AddBranchInfoApplication'
		then doc.record_state <> 4 
		and app.back_office_app_state = 'Reviewed'
		and decs.decision_type = 'Accepted'
		and (doc.is_from_license = false 
		or doc.is_from_license isnull)
	end