SELECT distinct
        cnt.id,
        cnt.name,
        cnt.contractor_type,
        cnt.address,
        cnt.license_delete_check,
        cnt.caption,
        cnt.is_from_license,
        brn.organization_id as org_unit_id,
        cnt.record_state
    FROM prl_contractors as cnt
    join prl_branch_contractors  as brcnt on brcnt.contractor_id = cnt.id and brcnt.record_state <> 4
    JOIN org_branches as brn on brn.id = brcnt.branch_id and brn.record_state <> 4
    JOIN application_branches as apb on apb.branch_id = brn.id and apb.record_state <> 4
    WHERE apb.lims_document_id in ({0})