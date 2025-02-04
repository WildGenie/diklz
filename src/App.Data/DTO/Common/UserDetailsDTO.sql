select 
    per.name,
    per.middle_name,
    per.last_name,
    unit.name as org_unit_name,
    emp.position,
    emp.user_email as email,
    emp.id,
    emp.old_lims_id,
    emp.caption,
    org.edrpou
from org_employee as emp
join person as per on emp.person_id = per.id and per.record_state <> 4
left join org_unit as unit on  emp.organization_id = unit.id and unit.record_state <> 4
left join org_organization as org on org.id = emp.organization_id and org.record_state <> 4