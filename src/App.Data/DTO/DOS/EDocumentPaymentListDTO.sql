SELECT DISTINCT
	qwe.ID,
  qwe.created_on,
	qwe.caption,
	qwe.comment,
	( SELECT string_agg ( description, ',' ) AS description FROM file_store WHERE entity_name = 'EDocument' AND entity_id = qwe.ID ),
	qwe.edocument_type,
	qwe.edocument_status,
  qwe.entity_id,
  qwe.entity_name
FROM
(
    SELECT DISTINCT
	    doc.ID,
      doc.created_on,
	    COALESCE(doc.caption, '') as caption,
	    COALESCE(doc.COMMENT, '') as comment,
	    ( SELECT string_agg ( description, ',' ) AS description FROM file_store WHERE entity_name = 'EDocument' AND entity_id = doc.ID ),
	    doc.edocument_type,
	    doc.edocument_status,
      COALESCE(doc."entity_id", '00000000-0000-0000-0000-000000000000' ) as entity_id,
      COALESCE(doc."entity_name", '') as entity_name,
			doc.record_state
    FROM
      edocuments AS doc
	    LEFT JOIN prl_applications AS prl ON prl.ID = doc.entity_id
			
		UNION
		
		SELECT DISTINCT
	    doc.ID,
      doc.created_on,
	    COALESCE(doc.caption, '') as caption,
	    COALESCE(doc.COMMENT, '') as comment,
	    ( SELECT string_agg ( description, ',' ) AS description FROM file_store WHERE entity_name = 'EDocument' AND entity_id = doc.ID ),
	    doc.edocument_type,
	    doc.edocument_status,
      COALESCE(doc."entity_id", '00000000-0000-0000-0000-000000000000' ) as entity_id,
      COALESCE(doc."entity_name", '') as entity_name,
			doc.record_state
    FROM
      edocuments AS doc
	    LEFT JOIN iml_applications AS iml ON iml.ID = doc.entity_id
					
		UNION
		
		SELECT DISTINCT
	    doc.ID,
      doc.created_on,
	    COALESCE(doc.caption, '') as caption,
	    COALESCE(doc.COMMENT, '') as comment,
	    ( SELECT string_agg ( description, ',' ) AS description FROM file_store WHERE entity_name = 'EDocument' AND entity_id = doc.ID ),
	    doc.edocument_type,
	    doc.edocument_status,
      COALESCE(doc."entity_id", '00000000-0000-0000-0000-000000000000' ) as entity_id,
      COALESCE(doc."entity_name", '') as entity_name,
			doc.record_state
    FROM
      edocuments AS doc
	    LEFT JOIN trl_applications AS trl ON trl.ID = doc.entity_id
) as qwe
WHERE 
		qwe."entity_id" IN ( {0} )  and
		qwe.record_state <> 4