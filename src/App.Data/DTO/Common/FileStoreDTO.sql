select
  filestore.caption,
  filestore.id,
  filestore.file_type,
  filestore.entity_name,
  filestore.entity_id,
  filestore.file_path,
  filestore.file_name,
  filestore.content_type,
  filestore.orig_file_name,
  filestore.file_size,
  filestore.ock,
  filestore.document_type,
  filestore.description,
  COALESCE(edoc.edocument_status, '') as edocument_status,
  COALESCE(edoc.edocument_type, '') as edocument_type,
  COALESCE(edoc.created_on, '1900-01-01') as edocument_created_on
from file_store filestore
left join edocuments as edoc on edoc.id = filestore.entity_id and edoc.record_state <> 4
where filestore.record_state <> 4