SELECT distinct
    ass.id, 
    ass.caption, 
    ass."name", 
    ass.middle_name, 
    ass.last_name, 
    ass.ipn, 
    ass.birthday, 
    ass.org_position_type, 
    ass.education_institution, 
    ass.year_of_graduation, 
    ass.number_of_diploma, 
    ass.date_of_graduation, 
    ass.speciality, 
    ass.work_experience, 
    ass.number_of_contract, 
    ass.order_number, 
    ass.date_of_contract, 
    ass.date_of_appointment, 
    ass.name_of_position, 
    ass.contact_information, 
    ass."comment", 
    ass.license_assignee_id, 
    ass.license_delete_check,
    ass.is_from_license,
    brn.organization_id as org_unit_id,
    type.name as assigne_type_name
FROM (select  * from app_assignees where record_state !=4) as ass
    JOIN app_assignee_branches as assb on assb.assignee_id = ass.id and assb.record_state <> 4
    JOIN org_branches as brn on brn.id = assb.branch_id and brn.record_state <> 4
    LEFT JOIN enum_record as type on type.code = ass.org_position_type