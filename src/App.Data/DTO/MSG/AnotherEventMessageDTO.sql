select 
                                                                      --MESSAGE BASE DETAIL DTO START
    mes.id,
    coalesce(mes.message_date,'1900-01-01')                             as message_date,
    coalesce(mes.org_unit_id, '00000000-0000-0000-0000-000000000000')   as org_unit_id,
    coalesce(mes.message_number,'')                                     as message_number,
    coalesce(mes.message_type,'')                                       as message_type,
    coalesce(mes.message_text,'')                                       as message_text,
    mes.is_iml_license                                                  as is_iml_license,
    mes.is_prl_license                                                  as is_prl_license,
    mes.is_trl_license                                                  as is_trl_license,
    mes.is_created_on_portal											as is_created_on_portal,
    coalesce(mes.caption, '')                                           as caption
                                                                      --MESSAGE BASE DETAIL DTO END
from messages as mes
where mes.record_state <> 4