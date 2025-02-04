select
x.caption,
x.id,
x.person_id,
person.last_name || ' ' || person.name|| ' ' ||   person.middle_name  as person_fio,

person.last_name as person_last_name,
person.name as person_name,
person.middle_name as person_middle_name,

coalesce(person.ipn, '') as person_ipn,
person.phone as person_phone,
person.email as person_email,

coalesce(unitpos.position_name, '') as org_unit_position,
coalesce(unitpos.org_unit_position_id, uuid_in('00000000-0000-0000-0000-000000000000')) as org_unit_position_id,
        coalesce(r.name, '') as region,
        coalesce(r.id, uuid_in('00000000-0000-0000-0000-000000000000')) as region_id,
        coalesce(x.organization_id, uuid_in('00000000-0000-0000-0000-000000000000')) as organization_id,
        coalesce(org.name, '') as organization_name


from org_employee as x
inner join person as person on x.person_id = person.id and person.record_state<>4
    left join sec_user_default_value as edfr on (edfr.user_id = x.id and edfr.entity_name = 'Region' and edfr.record_state <>4)
    left join atu_region as r on r.id = edfr.value_id and r.record_state <>4
    left join org_organization as org on org.id = x.organization_id and org.record_state <>4
left join ( select
              upe.employee_id,
              p.name as position_name,
			  up.id as position_id,
			  unit.name as unit_name,
			  unit.id as unit_id,
              upe.org_unit_position_id
            from org_unit_position_employee as upe
            inner join org_unit_position as up on upe.org_unit_position_id = up.id and up.record_state<>4
            inner join cdn_position as p on up.position_id = p.id and p.record_state <> 4
		        inner join org_unit as unit on up.org_unit_id = unit.id and unit.record_state<>4
          )
     			 as unitpos on unitpos.employee_id = x.id

where ( x.record_state <> 4 )
