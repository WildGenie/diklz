select
 x.caption,
 x.id,
 x.name,
 x.state as state,
 x.category as category,
 o2.name as parent,
 o2.id as parent_id,
 x.description
from
 org_department as x
left join org_organization as o2 on o2.id=x.parent_id and o2.record_state<>4
where ( x.record_state <> 4 )