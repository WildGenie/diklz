(select
    null as caption,
    imllic.id as id,
    imllic.is_relevant as is_relevant,
    imllic.lic_state as lic_state,
    imllic.org_unit_id as org_unit_id,
    imllic.lic_type as lic_type,
    imllic.parent_id as license_parent_id,
    imla.application_id as application_id
    
from iml_licenses as imllic 
	left join (select 
				imla.org_unit_id, 
				imla.id as application_id
		        from iml_applications as imla
		        where imla.record_state <> 4 ) imla on imllic.org_unit_id = imla.org_unit_id
    
where imllic.record_state <> 4
    
    
union

select  
    null as caption,
    prllic.id as id,
    prllic.is_relevant as is_relevant,
    prllic.lic_state as lic_state,
    prllic.org_unit_id as org_unit_id,
    prllic.lic_type as lic_type,
    prllic.parent_id as license_parent_id,
    prla.application_id as application_id
    
    from prl_licenses as prllic
	left join (select        
		    	prla.org_unit_id,
		    	prla.id as application_id
			    from prl_applications as prla
			    where prla.record_state <> 4) prla on prllic.org_unit_id = prla.org_unit_id

where prllic.record_state <> 4


union

select                
    null as caption,
    trllic.id as id,
    trllic.is_relevant as is_relevant,
    trllic.lic_state as lic_state,
    trllic.org_unit_id as org_unit_id,
    trllic.lic_type as lic_type,
    trllic.parent_id as license_parent_id,
    trla.application_id as application_id
    
from trl_licenses as trllic
left join (select           
	        trla.org_unit_id,
	        trla.id as application_id
		    from trl_applications as trla
		    where trla.record_state <> 4) trla on trllic.org_unit_id = trla.org_unit_id
		    
where trllic.record_state <> 4  
) 

