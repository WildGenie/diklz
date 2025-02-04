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
    msg.org_unit_id as org_unit_id
    FROM edocuments as doc
    join messages as msg on msg.id = ({0}) and msg.record_state <> 4