SELECT distinct
        doc.id,
        doc.version,
        doc.caption,
        brn.organization_id as org_unit_id,
        doc.is_from_license,
        (select string_agg(description, ',') as description from file_store where entity_name = 'EDocument' and  entity_id=doc.id )
    FROM edocuments as doc
    JOIN branch_edocuments as brcnt on brcnt.edocument_id = doc.id and brcnt.record_state <> 4
    JOIN org_branches as brn on brn.id = brcnt.branch_id and brn.record_state <> 4
    JOIN application_branches as apb on apb.branch_id = brn.id and apb.record_state <> 4
    WHERE apb.lims_document_id in ({0}) and doc.record_state <> 4