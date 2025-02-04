select 
    app.id,
    app.caption,
    app.created_on,
    COALESCE(app.modified_on, app.created_on) as modified_on,
    coalesce(app.doc_num, '') as doc_num,
    coalesce(app.app_reg_date, '01-01-1900') as reg_date,
    COALESCE (ter1.name, '') as teritorial_service_enum_name,
    COALESCE (app.org_unit_id, '00000000-0000-0000-0000-000000000000') as org_unit_id,
    app.app_conclusion_status,
    app.record_state,
    app.teritorial_service,
    null as assigne

from app_conclusions app 
left join (select * from enum_record where code = 'StatusConclusion') ter1 on app.teritorial_service = ter1.code
