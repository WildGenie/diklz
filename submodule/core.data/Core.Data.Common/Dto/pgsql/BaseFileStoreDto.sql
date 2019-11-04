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
  filestore.description
from file_store filestore
where record_state <> 4