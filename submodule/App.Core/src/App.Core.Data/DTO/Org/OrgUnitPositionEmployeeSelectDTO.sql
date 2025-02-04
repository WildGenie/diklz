select
upe.id,
pers.last_name || ' ' || pers.name|| ' ' || pers.middle_name as caption,
unit.id as org_unit_id
from org_unit_position_employee as upe
inner join org_employee as oe on oe.id = upe.employee_id and oe.record_state<>4
inner join person as pers on pers.id = oe.person_id and pers.record_state<>4
inner join org_unit_position as oup on oup.id = upe.org_unit_position_id and oup.record_state<>4
inner join org_unit as unit on unit.id = oup.org_unit_id and unit.record_state<>4
