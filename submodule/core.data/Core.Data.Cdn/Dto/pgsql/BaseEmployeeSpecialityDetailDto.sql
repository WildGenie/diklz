select
  x.id,
  x.caption,  
  coalesce( x.employee_id, uuid_in('00000000-0000-0000-0000-000000000000')) as employee_id,
  coalesce( x.speciality_id, uuid_in('00000000-0000-0000-0000-000000000000')) as  speciality_id, 
  x.is_main_speciality,
  coalesce( person.last_name, '') || ' ' || coalesce( person.name, '') || ' ' || coalesce( person.middle_name, '') as employee_name,
  coalesce( parent.caption, '') as parent_caption
from cdn_employee_speciality x
  left join cdn_speciality as spec on spec.id = x.speciality_id and spec.record_state <> 4
  left join org_employee as emp on emp.id = x.employee_id and emp.record_state <> 4
  left join person as person on person.id = emp.person_id and person.record_state <> 4
  left join cdn_speciality as parent on parent.id = spec.parent_id and parent.record_state <> 4
where x.record_state <> 4   