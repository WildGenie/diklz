SELECT 
    doc.id,
    doc.record_state,
    doc.caption,
    doc.card_number,
    doc.date_from,
    doc.date_to,
    doc.version,
    doc.edocument_status,
    doc.comment,
    doc.edocument_type,
    doc.is_from_license,
    doc.entity_id,
    doc.entity_name,
    app.org_unit_id as org_unit_id
    FROM edocuments as doc
        join lims_docs as app on app.id = ({0}) and app.record_state <> 4
    where doc.record_state <> 4