Select 
        pers.caption,
		pers.id,
		pers.last_name || ' ' || pers.name || ' ' || pers.middle_name as full_name,
		pers.last_name,
		pers.name,
		pers.middle_name,
		pers.birthday,
		pers.phone,
		pers.email,
		pers.ipn,
        pers.gender_enum,
        engend.caption as gender_name,        
        pers.no_ipn,
        pers.identity_document_type_enum,
        docum.caption as identity_document_type_name,        
        pers.doc_prefix,
        pers.personal_document_number,
        pers.personal_document_authority,
        pers.document_issue_date,
        pers.expiration_date,
        coalesce(patcard.id, uuid_in('00000000-0000-0000-0000-000000000000')) as patient_card_id
from person pers
left join enum_record engend on engend.code = pers.gender_enum
left join enum_record docum on docum.code = pers.identity_document_type_enum
left join mis_patient_card patcard on patcard.person_id = pers.id
where pers.record_state<>4