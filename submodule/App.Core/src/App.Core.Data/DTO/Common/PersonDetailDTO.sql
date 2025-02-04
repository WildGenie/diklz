Select 
        pers.caption,
		pers.id,
		pers.last_name || ' ' || pers.name || ' ' || pers.middle_name as fio,
		pers.last_name,
		pers.name,
		pers.middle_name,
		pers.birthday,
		pers.phone,
		pers.email,
		pers.ipn,
        pers.gender_enum,
        engend.name as gender_name,        
        pers.no_ipn,
        pers.identity_document_type_enum,
        docum.name as identity_document_type_name,        
        pers.doc_prefix,
        pers.personal_document_number,
        pers.personal_document_authority,
        pers.document_issue_date,
        pers.expiration_date
from person pers
left join enum_record engend on engend.code = pers.gender_enum
left join enum_record docum on docum.code = pers.identity_document_type_enum
where pers.record_state<>4